require "rake"
 
begin
  require "jeweler"
  Jeweler::Tasks.new do |gem|
    gem.name = "daemonz"
    gem.summary = "Automatically starts and stops the daemons in a Rails application"
    gem.email = "victor@costan.us"
    gem.homepage = "http://github.com/costan/daemonz"
    gem.authors = ["Victor Costan"]
    gem.files = Dir["*", "{lib}/**/*"]
  end
  
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end
