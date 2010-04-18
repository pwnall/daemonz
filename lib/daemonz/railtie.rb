require 'daemonz'
require 'rails'

# :nodoc: namespace
module Daemonz

# Railtie for the daemonz plugin.
class Railtie < Rails::Railtie
  initializer :control_daemon_processes do
    Daemonz.safe_start
    at_exit { Daemonz.safe_stop unless Daemonz.keep_daemons_at_exit }
  end

  rake_tasks do
    load 'daemonz/tasks/daemonz_tasks.rake'    
  end
  
  generators do
    require 'daemonz/generators/config/config_generator.rb'
    require 'daemonz/generators/daemon/daemon_generator.rb'
  end
end  # class Daemonz::Railtie

end  # namespace Daemonz
