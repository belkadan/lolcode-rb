#!/usr/bin/ruby

# FIXME use proper Gem packaging here
require 'lib/lolcode/compile'
require 'lib/lolcode/runtime'

module Lolcode
  def self.run_interpreter(options = {})
    Runtime::World.new.run_interpreter(options)
  end

  def self.load(filename)
    world = Runtime::World.new
    result = world.load(filename)
    return true if result.is_a?(Runtime::Module)
    world.catch_top_level_result(result, true)
  end

  def self.run_tests(test_dir = '.', interactive = true)
    success = true
    Dir.chdir(test_dir) do
      Dir.entries('.').select {|x| File.extname(x) == '.lol'}.each do |file|
        print file
        if interactive then gets else puts end
        begin
          Runtime::World.new.load(file)
        rescue StandardError => problem
          puts 'ERROR: ' + problem
          success = false
        end
        puts
      end
      success
    end
  end
end

if $0 == __FILE__
  Lolcode::load(ARGV[0]) if ARGV[0]
end

