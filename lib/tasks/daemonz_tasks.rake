namespace :daemons do
  desc "(testing only) Starts the daemons in config/daemonz.yml"
  task :start => :environment do
    require 'daemonz'
    Daemonz.safe_start :force_enabled => true, :override_logger => 'stdout'
    Daemonz.keep_daemons_at_exit = true 
  end

  desc "(testing only) Stops the daemons in config/daemonz.yml"
  task :stop => :environment do
    require 'daemonz'
    Daemonz.safe_stop :force_enabled => true, :configure => true,
                      :override_logger => 'stdout'
    Daemonz.keep_daemons_at_exit = true                      
  end
end
