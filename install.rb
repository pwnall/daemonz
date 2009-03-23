require 'fileutils'
daemonz_config_dir = File.join RAILS_ROOT, 'config', 'daemonz'
template_dir = File.join File.dirname(__FILE__), 'templates'

# copy the main config file, daemonz.yml
daemonz_config_main = File.join RAILS_ROOT, 'config', 'daemonz.yml'
unless File.exist? daemonz_config_main
  FileUtils.cp File.join(template_dir, 'config.yml'), daemonz_config_main
end

# copy prepackaged examples
FileUtils.mkpath daemonz_config_dir
prepackaged_dir = File.join(template_dir, 'prepackaged')
Dir.entries(prepackaged_dir).each do |entry|
  next unless /\.yml$/ =~ entry
  destination = File.join(daemonz_config_dir, entry)
  next if File.exist? destination
  FileUtils.cp File.join(prepackaged_dir, entry), destination
end
