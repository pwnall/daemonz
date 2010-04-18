# :nodoc: namespace
module Daemonz
# :nodoc: namespace
module Generators
  
class ConfigGenerator < Rails::Generators::Base
  def self.source_root
    @source_root ||= File.expand_path 'templates', File.dirname(__FILE__)
  end
    
  def create_configuration
    copy_file 'config.yml', 'config/daemonz.yml'
    
    empty_directory 'config/daemonz'
    copy_file 'prepackaged/ferret.yml', 'config/daemonz/ferret.yml'
    copy_file 'prepackaged/starling.yml', 'config/daemonz/starling.yml'
  end  
end  # class Daemonz::Generators::ConfigGenerator

end  # namespace Daemonz::Generators
end  # namespace Daemonz
