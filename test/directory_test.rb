require 'rubygems'
require 'minitest/autorun'

require 'stringio'

$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])
require 'lolcode'

class DirectoryTest < MiniTest::Unit::TestCase
  def self.test_directory
    self.const_get(:TEST_DIR)
  end

  def run_test(name)
    out, err = capture_io do
      Lolcode::load(File.join(self.class.test_directory, name))
    end
    
    assert_empty err
    check_output(name, out)
  end

  def check_output(name, output)
    raise 'This method should be implemented by subclasses.'
  end

  def self.test_methods
    return [] if self == DirectoryTest
    Dir.chdir(self.test_directory) do
      Dir['*.lol']
    end
  end
end
