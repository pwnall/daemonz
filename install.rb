require 'fileutils'
daemonz_config = File.join(RAILS_ROOT, 'config', 'daemonz.yml')
config_template = File.join(File.dirname(__FILE__) , 'config_template.yml')
FileUtils.cp config_template, daemonz_config unless File.exist?(daemonz_config)
