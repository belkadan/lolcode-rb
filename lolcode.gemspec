require File.expand_path("../lib/lolcode/version", __FILE__)

# Based on https://github.com/wycats/newgem-template/blob/master/newgem.gemspec
Gem::Specification.new do |s|
  s.name        = "lolcode"
  s.version     = Lolcode::VERSION
  s.platform    = Gem::Platform::RUBY
  s.author      = "Jordy Rose"
  s.email       = "jrose@belkadan.com"
  s.homepage    = "https://github.com/belkadan/lolcode-rb"
  s.summary     = "A Lolcode implementation"
  s.description = "An implementation of Lolcode 1.3, with a few extensions. Can execute scripts or run interactively."

  s.required_ruby_version     = '>= 1.8.5'
  s.required_rubygems_version = ">= 1.3.6"

  # lol - required for validation
  s.rubyforge_project         = "nowarning"

  # If you have other dependencies, add them here
  s.add_runtime_dependency "treetop", "~> 1.4"
  s.add_development_dependency "minitest", "~> 2.11"

  # If you need to check in files that aren't .rb files, add them here
  s.files        = Dir["{lib}/**/*.rb", "bin/*", "examples/*", "*.md",
                       "test/*.rb", "test/feature/**", "test/simple/**"]
  s.require_path = 'lib'

  # If you need an executable, add it here
  s.executables = ["lolcode"]
  s.test_files  = Dir["test/test_*.rb"]

  # If you have C extensions, uncomment this line
  # s.extensions = "ext/extconf.rb"
end
