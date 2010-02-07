require 'daemonz'
require 'rails'

module Daemonz
  class Railtie < Rails::Railtie
    initializer :control_daemon_processes do
      Daemonz.safe_start
      at_exit do
        Daemonz.safe_stop unless Daemonz.keep_daemons_at_exit
      end      
    end
  end
end
