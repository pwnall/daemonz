# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{daemonz}
  s.version = "0.3.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Victor Costan"]
  s.date = %q{2010-04-18}
  s.email = %q{victor@costan.us}
  s.extra_rdoc_files = [
    "README.textile"
  ]
  s.files = [
    "MIT-LICENSE",
     "README.textile",
     "Rakefile",
     "VERSION",
     "config_template.yml",
     "daemonz.gemspec",
     "init.rb",
     "lib/daemonz.rb",
     "lib/daemonz/config.rb",
     "lib/daemonz/generators/config/config_generator.rb",
     "lib/daemonz/generators/config/templates/config.yml",
     "lib/daemonz/generators/config/templates/prepackaged/ferret.yml",
     "lib/daemonz/generators/config/templates/prepackaged/starling.yml",
     "lib/daemonz/generators/daemon/daemon_generator.rb",
     "lib/daemonz/generators/daemon/templates/config.yml",
     "lib/daemonz/generators/daemon/templates/daemon.rb.erb",
     "lib/daemonz/generators/daemon/templates/integration_test.rb.erb",
     "lib/daemonz/killer.rb",
     "lib/daemonz/logging.rb",
     "lib/daemonz/manage.rb",
     "lib/daemonz/master.rb",
     "lib/daemonz/process.rb",
     "lib/daemonz/railtie.rb",
     "lib/daemonz/tasks/daemonz_tasks.rake"
  ]
  s.homepage = %q{http://github.com/costan/daemonz}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.6}
  s.summary = %q{Automatically starts and stops the daemons in a Rails application}
  s.test_files = [
    "test/daemonz_test.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<simple-daemon>, [">= 0"])
      s.add_runtime_dependency(%q<zerg_support>, [">= 0"])
    else
      s.add_dependency(%q<simple-daemon>, [">= 0"])
      s.add_dependency(%q<zerg_support>, [">= 0"])
    end
  else
    s.add_dependency(%q<simple-daemon>, [">= 0"])
    s.add_dependency(%q<zerg_support>, [">= 0"])
  end
end

