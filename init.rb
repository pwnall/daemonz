require 'daemonz'

daemonz_config = File.join(RAILS_ROOT, 'config', 'daemonz.yml')
Daemonz.configure daemonz_config

if Daemonz.config[:is_master]
  Daemonz.configure_daemons
  Daemonz.start_daemons
end

at_exit do
  if Daemonz.config[:is_master]
    Daemonz.stop_daemons
    Daemonz.release_master_lock
  end
end
