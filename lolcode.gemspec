require File.expand_path("../lib/lolcode/version", __FILE__)

# Based on https://github.com/wycats/newgem-template/blob/master/newgem.gemspec
Gem::Specification.new do |s|
  s.name        = "lolcode"
  s.version     = Lolcode::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Jordy Rose"]
  s.email       = ["jrose@belkadan.com"]
  s.homepage    = "https://github.com/belkadan/lolcode-rb"
  s.summary     = "A Lolcode implementation in Ruby"

  s.required_rubygems_version = ">= 1.3.6"

  # If you have other dependencies, add them here
  s.add_dependency "treetop", "~> 1.4"

  # If you need to check in files that aren't .rb files, add them here
  s.files        = Dir["{lib}/**/*.rb", "bin/*", "examples/*", "*.md"]
  s.require_path = 'lib'

  # If you need an executable, add it here
  s.executables = ["lolcode"]

  # If you have C extensions, uncomment this line
  # s.extensions = "ext/extconf.rb"
end
