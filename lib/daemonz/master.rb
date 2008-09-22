require 'English'

module Daemonz
  def self.release_master_lock
    if File.exist? config[:master_file]
      File.delete config[:master_file]
    else
      logger.warn "Master lock removed by someone else"
    end
  end
  
  def self.grab_master_lock
    loop do
      File.open(config[:master_file], File::CREAT | File::RDWR) do |f|
        if f.flock File::LOCK_EX
          lock_data = f.read
          lock_data = lock_data[lock_data.index(/\d/), lock_data.length] if lock_data.index /\d/          
          master = lock_data.split("\n", 2)
          
          if master.length == 2
            master_pid = master[0].to_i            
            master_cmdline = master[1]
            if master_pid != 0
              master_pinfo = process_info(master_pid)
              return master_pid if master_pinfo and master_pinfo[:cmdline] == master_cmdline
             
              logger.info "Old master (PID #{master_pid}) died; breaking master lock"            
            end            
          end
          
          f.truncate 0
          f.write "#{$PID}\n#{process_info($PID)[:cmdline]}"
          f.flush
          return nil
        end
      end
    end
  end
  
  # attempts to claim the master lock
  def self.claim_master
    loop do
      begin
        # try to grab that lock
        master_pid = grab_master_lock
        if master_pid
          logger.info "Daemonz in slave mode; PID #{master_pid} has master lock"
          return false
        else
          logger.info "Daemonz grabbed master lock"
          return true
        end        
      #rescue Exception => e
      #  logger.warn "Daemonz mastering failed: #{e.class.name} - #{e}"
      #  logger.info "Retrying daemonz mastering"
      end
    end
  end
end
