class DaemonGenerator < Rails::Generator::NamedBase
  def manifest
    record do |m|
      m.directory "config/daemonz"
      m.template "config.yml", "config/daemonz/#{file_name}.yml"
      
      m.directory "script/background"
      m.template "daemon.rb.erb", "script/background/#{file_name}.rb"
      
      m.directory "test/integration"
      m.template "integration_test.rb.erb",
                 "test/integration/#{file_name}_test.rb"
    end
  end
end
