require 'English'

module Daemonz
  # Complex procedure for killing a process or a bunch of process replicas
  # kill_command is the script that's supposed to kill the process / processes (tried first)
  # pid_patters are globs identifying PID files (a file can match any of the patterns)
  # process_patterns are strings that should show on a command line (a process must match all)  
  # options:
  #   :verbose - log what gets killed
  #   :script_delay - the amount of seconds to sleep after launching the kill script
  #   :force_script - the kill script is executed even if there are no PID files
  def self.kill_process_set(kill_script, pid_patterns, process_patterns, options = {})
    # Phase 1: kill order (only if there's a PID file)
    pid_patterns = [pid_patterns] unless pid_patterns.kind_of? Enumerable
    unless options[:force_script]
      pid_files = pid_patterns.map { |pattern| Dir.glob(pattern) }.flatten
    end
    if options[:force_script] or !(pid_files.empty? or kill_script.nil?)
      logger.info "Issuing kill order: #{kill_script}\n" if options[:verbose]
      success = Kernel.system kill_script unless kill_script.nil?
      if !success and options[:verbose]
        logger.warn "Kill order failed with exit code #{$CHILD_STATUS.exitstatus}"
      end

      deadline_time = Time.now + (options[:script_delay] || 0.5)
      while Time.now < deadline_time
        pid_files = pid_patterns.map { |pattern| Dir.glob(pattern) }.flatten
        break if pid_files.empty?
        sleep 0.05
      end
    end
    
    # Phase 2: look through PID files and issue kill orders
    pinfo = process_info()
    pid_files = pid_patterns.map { |pattern| Dir.glob(pattern) }.flatten
    pid_files.each do |fname|
      begin
        pid = File.open(fname, 'r') { |f| f.read.strip! }
        process_cmdline = pinfo[pid][:cmdline]
        # avoid killing innocent victims
        if pinfo[pid].nil? or process_patterns.all? { |pattern| process_cmdline.index pattern } 
          logger.warn "Killing #{pid}: #{process_cmdline}" if options[:verbose]
          Process.kill 'TERM', pid.to_i
        end
      rescue
        # just in case the file gets wiped before we see it
      end
      begin
        logger.warn "Deleting #{fname}" if options[:verbose]
        File.delete fname if File.exists? fname
      rescue
        # prevents crashing if the file is wiped after we call exists?
      end
    end
    
    # Phase 3: look through the process table and kill anything that looks good
    pinfo = process_info()
    pinfo.each do |pid, info|
      next unless process_patterns.all? { |pattern| info[:cmdline].index pattern }
      logger.warn "Killing #{pid}: #{pinfo[pid][:cmdline]}" if options[:verbose]
      Process.kill 'TERM', pid.to_i
    end
  end
end
