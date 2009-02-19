require 'English'

module Daemonz
  # Starts daemons, yields, stops daemons. Intended for tests.
  def self.with_daemons(logger = 'rails')
    begin
      safe_start :force_enabled => true, :override_logger => logger
      yield
    ensure
      safe_stop :force_enabled => true
    end
  end
  
  # Complete startup used by rake:start and at Rails plug-in startup.
  def self.safe_start(options = {})
    daemonz_config = File.join(RAILS_ROOT, 'config', 'daemonz.yml')
    Daemonz.configure daemonz_config, options
    
    if Daemonz.config[:is_master]
      Daemonz.configure_daemons
      Daemonz.start_daemons!
    end    
  end
  
  # Complete shutdown used by rake:start and at Rails application exit.
  def self.safe_stop(options = {})
    if options[:configure]
      daemonz_config = File.join(RAILS_ROOT, 'config', 'daemonz.yml')
      Daemonz.configure daemonz_config, options
    end
    if Daemonz.config[:is_master]
      if options[:configure]
        Daemonz.configure_daemons
      end
      Daemonz.stop_daemons!
      Daemonz.release_master_lock
    end
  end
    
  def self.start_daemons!
    @daemons.each { |daemon| start_daemon! daemon }
  end
  
  def self.stop_daemons!
    @daemons.reverse.each { |daemon| stop_daemon! daemon }
  end
  
  def self.start_daemon!(daemon)
    # cleanup before we start
    kill_process_set daemon[:stop][:cmdline], daemon[:pids],
                     daemon[:kill_patterns],
                     :script_delay => daemon[:delay_before_kill],
                     :verbose => true, :force_script => false
      
    logger.info "Daemonz starting #{daemon[:name]}: #{daemon[:start][:cmdline]}"
    success = Kernel.system daemon[:start][:cmdline]
    unless success
      logger.warn "Daemonz start script for #{daemon[:name]} failed " +
                  "with code #{$CHILD_STATUS.exitstatus}"
    end
  end
  
  def self.stop_daemon!(daemon)
    kill_process_set daemon[:stop][:cmdline], daemon[:pids],
                     daemon[:kill_patterns],
                     :script_delay => daemon[:delay_before_kill],
                     :verbose => true, :force_script => true
  end  
end
