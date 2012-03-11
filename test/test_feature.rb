require 'directory_test'

class FeatureTest < DirectoryTest  
  TEST_DIR = File.join(File.dirname(__FILE__), 'feature')

  class Runner < MiniTest::Unit
    attr_reader :result
    def initialize
      super
    end

    def noob(file, name)
      @skips += 1
      @report << "Skipped:\n#{file}: #{name}\n" if @verbose
      'S'
    end

    def win(file, name)
      '.'
    end

    def fail(file, name, reason)
      @failures += 1
      @report << "Failure:\n#{file}: #{name}\n#{reason}"
      'F'
    end
  end

  MiniTest::Unit.runner = Runner.new

  def run(runner)
    @result = ''
    @runner = runner
    result = super
    @runner = nil
    result = @result if result == '.'
    result
  end

  def check_output(name, output)
    # Kind of a hack, but we use the assertion count to represent the number of tests
    # inside each Lolcode test.
    # Probably the /real/ right solution is to generate /suites/ for each Lolcode test.
    self._assertions = 0

    error_message = nil
    test = ''
    output.each_line do |line|
      if line.chomp.empty?
        if error_message
          @result << @runner.fail(name, test, error_message)
          error_message = nil
        end
        next
      end
      if error_message
        error_message << line
        next
      end
      
      status, test = line.chomp.split("\t", 2)
      self._assertions += 1
      case status
      when 'WIN'
        @result << @runner.win(name, test)
      when 'FAIL'
        error_message = ''
      when 'NOOB'
        @result << @runner.noob(name, test)
      else
        raise "Unknown test status: '#{status}'"
      end
    end
  end
end
