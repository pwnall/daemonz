module Daemonz
  
end

require 'daemonz/config.rb'
require 'daemonz/killer.rb'
require 'daemonz/logging.rb'
require 'daemonz/manage.rb'
require 'daemonz/master.rb'
require 'daemonz/process.rb'

if defined?(Rails)
  require 'daemonz/railtie'
  require 'daemonz/engine'
end
