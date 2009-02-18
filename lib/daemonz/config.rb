require 'erb'
require 'yaml'

module Daemonz
  class << self
    attr_reader :config
    
    # Set by the rake tasks.
    attr_accessor :keep_daemons_at_exit
  end

  # compute whether daemonz should be enabled or not
  def self.disabled?
    return true if config[:disabled]
    config[:disabled_for].each do |suffix|
      if suffix == $0[-suffix.length, suffix.length]
        config[:disabled] = true # cache the expensive computation
        return true
      end
    end
    config[:disabled_for] = [] # cache the expensive computation
    return false
  end
  
  # figure out the plugin's configuration 
  def self.configure(config_file, options = {})
    load_configuration config_file
    
    config[:root_path] ||= RAILS_ROOT
    if options[:force_enabled]
      config[:disabled] = false
      config[:disabled_for] = []
    else
      config[:disabled] ||= false
      config[:disabled_for] ||= ['rake', 'script/generate']
    end
    config[:disabled] = false if config[:disabled] == 'false'
    config[:master_file] ||= File.join RAILS_ROOT, "tmp", "pids", "daemonz.master.pid"
    
    config[:logger] &&= options[:override_logger]
    self.configure_logger

    if self.disabled?
      config[:is_master] = false
    else
      config[:is_master] = Daemonz.claim_master
    end
  end
    
  # load and parse the config file
  def self.load_configuration(config_file)
    if File.exist? config_file
      file_contents = File.read config_file
      erb_result = ERB.new(file_contents).result
      @config = YAML.load erb_result
    else
      logger.warn "Daemonz configuration not found - #{config_file}"
      @config = {}
    end
  end
  
  class << self
    attr_reader :daemons
  end
  
  # process the daemon configuration
  def self.configure_daemons    
    @daemons = []
    config[:daemons].each do |name, daemon_config|
      next if config[:disabled]
      daemon = { :name => name }
            
      # compute the daemon startup / stop commands 
      ['start', 'stop'].each do |command|
        daemon_binary = daemon_config[:binary] || daemon_config["#{command}_binary".to_sym]
        if daemon_config[:absolute_binary]
          daemon_path = `which #{daemon_binary}`.strip
          unless daemon_config[:kill_patterns]
            logger.error "Daemonz ignoring #{name}; using an absolute binary path but no custom process kill patterns"
            break
          end
        else
          daemon_path = File.join config[:root_path], daemon_binary || ''
        end
        unless daemon_binary and File.exists? daemon_path
          logger.error "Daemonz ignoring #{name}; the #{command} file is missing"
          break
        end
        
        unless daemon_config[:absolute_binary]
          begin
            binary_perms = File.stat(daemon_path).mode
            if binary_perms != (binary_perms | 0111)
              File.chmod(binary_perms | 0111, daemon_path)
            end
          rescue Exception => e
            # chmod might fail due to lack of permissions
            logger.error "Daemonz failed to make #{name} binary executable - #{e.class.name}: #{e}\n"
            logger.info e.backtrace.join("\n") + "\n"
          end
        end
        
        daemon_args = daemon_config[:args] || daemon_config["#{command}_args".to_sym]
        daemon_cmdline = "#{daemon_path} #{daemon_args}"
        daemon[command.to_sym] = {:path => daemon_path, :cmdline => daemon_cmdline}
      end
      next unless daemon[:stop]
      
      # kill patterns
      daemon[:kill_patterns] = daemon_config[:kill_patterns] || [daemon[:start][:path]]
      
      # pass-through params
      daemon[:pids] = daemon_config[:pids]
      unless daemon[:pids]
        logger.error "Daemonz ignoring #{name}; no pid file pattern specified"
        next
      end
      daemon[:delay_before_kill] = daemon_config[:delay_before_kill] || 0.2
      daemon[:start_order] = daemon_config[:start_order]
      
      @daemons << daemon
    end
    
    # sort by start_order, then by name
    @daemons.sort! do |a, b|
      if a[:start_order]
        if b[:start_order]
          if a[:start_order] != b[:start_order]
            next a[:start_order] <=> b[:start_order]
          else
            next a[:name] <=> b[:name]
          end
        else
          next 1
        end
      else
        next a[:name] <=> b[:name]
      end
    end
  end
end
