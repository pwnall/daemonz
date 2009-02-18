require 'daemonz'

Daemonz.safe_start
at_exit do
  Daemonz.safe_stop
end
