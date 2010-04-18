# :nodoc: namespace
module Daemonz
# :nodoc: namespace
module Generators
  
class DaemonGenerator < Rails::Generators::NamedBase
  def self.source_root
    @source_root ||= File.expand_path 'templates', File.dirname(__FILE__)
  end
  
  def create_harness
    empty_directory 'config/daemonz'
    template "config.yml", "config/daemonz/#{file_name}.yml"
      
    empty_directory 'script/background'
    template 'daemon.rb.erb', "script/background/#{file_name}.rb"
      
    empty_directory 'test/integration'
    template 'integration_test.rb.erb', "test/integration/#{file_name}_test.rb"
  end
end  # class Daemon::Generators::DaemonGenerator

end  # namespace Daemon::Generators
end  # namespace Daemon
