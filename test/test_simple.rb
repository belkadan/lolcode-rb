require 'directory_test'

class SimpleTest < DirectoryTest  
  TEST_DIR = File.join(File.dirname(__FILE__), 'simple')
  
  def check_output(name, output)
    expected_path = File.join(TEST_DIR, name.sub(/\.lol$/, '.txt'))
    if File.exist? expected_path
      assert_equal File.read(expected_path), output
    else
      assert_empty output
    end
  end
end
