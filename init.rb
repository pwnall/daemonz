require 'daemonz'

Daemonz.safe_start
at_exit do
  Daemonz.safe_stop unless Daemonz.keep_daemons_at_exit
end
