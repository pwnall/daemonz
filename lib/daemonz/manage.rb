require 'English'

module Daemonz
  def self.start_daemons
    @daemons.each { |daemon| start_daemon daemon }
  end
  
  def self.stop_daemons
    @daemons.reverse.each { |daemon| stop_daemon daemon }
  end
  
  def self.start_daemon(daemon)
    # cleanup before we start
    kill_process_set daemon[:stop][:cmdline], daemon[:pids], daemon[:kill_patterns],
      :script_delay => daemon[:delay_before_kill], :verbose => true, :force_script => false
      
    logger.info "Daemonz starting #{daemon[:name]}: #{daemon[:start][:cmdline]}"
    success = Kernel.system daemon[:start][:cmdline]
    unless success
      logger.warn "Daemonz start script for #{daemon[:name]} failed with code #{$CHILD_STATUS.exitstatus}"
    end
  end
  
  def self.stop_daemon(daemon)
    kill_process_set daemon[:stop][:cmdline], daemon[:pids], daemon[:kill_patterns],
      :script_delay => daemon[:delay_before_kill], :verbose => true, :force_script => true    
  end
end
