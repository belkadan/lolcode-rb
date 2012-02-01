require 'treetop'

module Lolcode
  Treetop.load(File.join(File.dirname(__FILE__), 'lolcode.treetop'))

  class GTFO
    attr_reader :name
    def initialize(name)
      @name = name
    end
    def value
      noob
    end
  end

  class Whatever
    attr_reader :name
    def initialize(name)
      @name = name
    end
  end

  class Result
    attr_reader :value
    def initialize(value)
      @value = value
    end
    def name
      nil
    end
  end

  class DoNotWant
    attr_reader :value
    def initialize(val)
      @value = val
    end
    def name
      nil
    end
  end

  class Bukkit
    def initialize(parent)
      @values = {}
      @parent = parent
    end

    def exists?(var)
      @values.has_key?(var) or (@parent and @parent.exists?(var))
    end

    def set(var, val)
      last = var.last
      if var.length == 1
        # FIXME: some kind of RuntimeError type
        return DoNotWant.new(last.inspect + ' does not exist') unless exists? last
        @values[last] = val
        nil
      else
        # FIXME refactor
        bukkit = get(var.take(var.length - 1))
        return bukkit if bukkit.is_a?(DoNotWant)
        bukkit.set([last], val)
      end
    end

    def get(var)
      first = var[0]
      # FIXME: some kind of RuntimeError type
      return DoNotWant.new(first.inspect + ' does not exist') unless @parent or @values.has_key?(first)
      base = @values[first]
      if base
        if var.length == 1 then base else base.get(var.drop(1)) end
      else
        @parent.get(var)
      end
    end

    def create(var, name, val)
      base = get(var)
      return base if base.is_a?(DoNotWant)
      base.init(name, val)
    end

    def init(name, val)
      return DoNotWant.new(name.inspect + ' already exists') if @values.has_key? name
      @values[name] = val
      nil
    end

    def root
      if @parent then @parent.root else self end
    end

    def liek?(other)
      # FIXME multiple inheritance?
      (self == other) or (@parent and @parent.liek?(other))
    end

    def win?
      # Allows for things LIEK NOOB or LIEK FAIL
      @parent.nil? or @parent.win?
    end

    def to_s
      if @parent.nil?
        super
      else
        @parent.to_s
      end
    end

    def to_numeric
      if @parent.nil?
        return nil
      else
        @parent.to_numeric
      end
    end

    def to_i
      if @parent.nil?
        return nil
      else
        @parent.to_i
      end
    end

    def to_f
      if @parent.nil?
        return nil
      else
        @parent.to_f
      end
    end

    def cast(world, val)
      DoNotWant.new('Cannot MAEK ' + Yarn.cast(world, val) + ' into that.')
    end
  end

  class Proc < Bukkit
    def self.register(world)
      world.sheep = Bukkit.new(world.root)
    end

    def initialize(world, env, args, body)
      super(world.sheep)
      @env = env
      @args = args
      @body = body
    end

    def call(me, arg_values)
      # FIXME this is not proper Ruby
      new_env = Environment.new(@env.world, @env)
      new_env.init('ME', me)
      @args.zip(arg_values).each do |var, val|
        new_env.init(var, val)
      end
      result = @body.call(new_env)
      return result if result.is_a?(DoNotWant)
      # FIXME some kind of RuntimeError type, not a string?
      return DoNotWant.new('No such loop: ' + result.name) if result.name
      result.value
    end
  end

  class Primitive < Bukkit
    def self.register(world)
      world.magic = Bukkit.new(world.root)
    end

    def initialize(world, &body)
      super(world.magic)
      @body = body
    end

    def call(me, arg_values)
      @body.call(me, arg_values)
    end
  end

  def self.register_noob(world)
    noob = Bukkit.new(world.bukkit)
    def noob.cast(world, val)
      self
    end
    def noob.to_s
      'NOOB'
    end
    def noob.to_numeric
      0
    end
    def noob.to_i
      0
    end
    def noob.to_f
      0.0
    end
    def noob.win?
      false
    end
    world.noob = noob
  end

  class ImmutableBukkit < Bukkit
    alias_method :set!, :set
    def set(name, val)
      DoNotWant.new('It is not safe to change the properties of non-finite primitives.')
    end

    def make_mutable!
      instance_eval do
        def set(name, val)
          set!(name, val)
        end
      end
    end
  end

  class Troof < Bukkit
    def self.new(world, truth)
      return super(truth) if world.troof.nil?
      if truth then world.win else world.fail end
    end

    def self.register(world)
      troof = Bukkit.new(world.bukkit)
      def troof.cast(world, val)
        if val.win? then world.win else world.fail end
      end

      win = Troof.new(world, troof)
      def win.to_s
        'WIN'
      end
      def win.win?
        true
      end
      def win.to_numeric
        1
      end
      def win.to_i
        1
      end
      def win.to_f
        1.0
      end

      fail = Troof.new(world, troof)
      def fail.to_s
        'FAIL'
      end
      def fail.win?
        false
      end
      def fail.to_numeric
        0
      end
      def fail.to_i
        0
      end
      def fail.to_f
        0.0
      end

      world.troof = troof
      world.win = win
      world.fail = fail
    end
  end

  class Yarn < ImmutableBukkit
    def self.register(world)
      empty = self.new(world, '')
      def empty.cast(world, val)
        Yarn.cast(world, val)
      end
      empty.make_mutable!
      world.yarn = empty
    end

    def initialize(world, val)
      super(world.yarn || world.bukkit)
      @value = val.to_s
    end

    def self.cast(world, val)
      return world.yarn if val == ''
      Yarn.new(world, val)
    end

    def to_s
      @value
    end

    def to_str
      to_s
    end

    def to_i
      @value.to_i
    end

    def to_f
      @value.to_f
    end

    def to_numeric
      if @value.include? '.'
        @value.to_f
      else
        @value.to_i
      end
    end

    def ==(other)
      (other.is_a?(String) or other.is_a?(Yarn)) and other.to_s == to_s
    end

    def empty?
      @value.empty?
    end

    def win?
      !empty?
    end

    def get(name)
      if name.first == 'LONGNESS'
        # FIXME: DON'T HACK THE WORLD
        longness = self.root.world.make_numeric(@value.length)
        if name.count == 1
          longness
        else
          longness.get(name.drop(1))
        end
      else
        super
      end
    end
  end

  class Numbr < ImmutableBukkit
    def self.register(world)
      zero = self.new(world, 0)
      def zero.cast(world, val)
        Numbr.cast(world, val)
      end
      zero.make_mutable!
      world.numbr = zero
    end

    def initialize(world, val)
      super(world.numbr || world.bukkit)
      @value = val
    end

    def self.new(world, val)
      return world.numbr if world.numbr and val.zero?
      # FIXME other cached constants?
      # return @@one if @@one and val == 1
      super
    end

    def self.cast(world, val)
      return val if val.is_a?(self)
      intval = val.to_i
      if intval
        self.new(world, intval)
      else
        DoNotWant.new('Cannot make a NUMBR from ' + Yarn.cast(world, val))
      end
    end

    def ==(other)
      # This should NOT account for inheritance!
      return other.to_i == to_i if other.is_a?(Numbr) or other.is_a?(Integer)
      return other.to_f == to_f if other.is_a?(Numbar) or other.is_a?(Numeric)
      return false
    end

    def to_i
      @value
    end
    
    def to_f
      @value.to_f
    end

    def to_s
      @value.to_s
    end

    def to_numeric
      @value
    end

    def next(world)
      Numbr.new(world, @value.next)
    end

    def pred(world)
      Numbr.new(world, @value.pred)
    end

    def win?
      @value.nonzero?
    end
  end

  class Numbar < ImmutableBukkit
    def self.register(world)
      zero = self.new(world, 0.0)
      def zero.cast(world, val)
        Numbar.cast(world, val)
      end
      zero.make_mutable!
      world.numbar = zero
    end

    def initialize(world, val)
      super(world.numbar || world.bukkit)
      @value = val
    end

    def self.new(world, val)
      return world.numbar if world.numbar and val.zero?
      # FIXME other cached constants?
      # return @@one if @@one and val == 1.0
      super
    end

    def self.cast(world, val)
      return val if val.is_a?(self)
      realval = val.to_f
      if realval
        self.new(world, realval)
      else
        DoNotWant.new('Cannot make a NUMBAR from ' + Yarn.cast(world, val))
      end
    end

    def ==(other)
      return other.to_f == to_f if other.is_a?(Numbar) or other.is_a?(Numbr) or other.is_a?(Numeric)
      return false
    end

    def to_i
      @value.to_i
    end
    
    def to_f
      @value
    end

    def to_s
      @value.to_s
    end

    def to_numeric
      @value
    end

    def win?
      @value.nonzero?
    end
  end

  class Bukkit
    def self.register(world)
      # The root bukkit is actually an environment, so it can track the world
      # and function as module scope.
      root = Environment.new(world, nil)
      def root.cast(world, val)
        val
      end
      world.bukkit = root
    end
  end

  class World
    def initialize
      @parser = LolcodeParser.new

      Bukkit.register(self)
      Lolcode::register_noob(self)
      Troof.register(self)
      Primitive.register(self)
      Proc.register(self)
      Numbr.register(self)
      Numbar.register(self)
      Yarn.register(self)

      # This needs to happen AFTER all primitives have been initialized!
      liek = Primitive.new(self) do |me, args|
        Troof.new(self, me.liek?(args.first))
      end
      root.init('liek', liek)
    end

    # Special-case BUKKIT cause it's the root
    def bukkit=(val)
      @bukkit = val
      @bukkit.init('BUKKIT', val)
    end
    attr_reader :bukkit
    alias_method :root, :bukkit

    def self.builtin(*names)
      names.each do |name|
        class_eval %{
          def #{name}=(val)
            raise 'Must register BUKKIT first' if bukkit.nil?
            @#{name} = val
            bukkit.init('#{name.to_s.upcase}', val)
          end

          def #{name}
            @#{name}
          end
        }
      end
    end

    builtin :noob, :troof, :win, :fail, :numbr, :numbar, :yarn, :magic, :sheep
  end

  class Environment < Bukkit
    attr_accessor :world

    def initialize(world, parent)
      super(parent)
      @world = world
      init('IT', world.noob)
      init('I', self)
    end

    def it
      ['IT']
    end
  end

  class World
    def to_numeric(val)
      val.to_numeric || DoNotWant.new('Cannot make a NUMBR or NUMBAR from ' + Yarn.cast(self, val))
    end

    def make_numeric(val)
      # This translates from Ruby floats and ints to Lolcode NUMBARs and NUMBRs
      return Numbr.new(self, val) if val.is_a? Integer
      return Numbar.new(self, val)
    end

    def catch_top_level_result(result, should_recover)
      return if result.nil?
      # FIXME how to deal with this more properly?
      if result.is_a? DoNotWant
        raise 'DO NOT WANT: ' + Yarn.cast(self, result.value) unless should_recover
        # FIXME should use stderr
        puts 'DO NOT WANT: ' + Yarn.cast(self, result.value)
      elsif result.name
        catch_top_level_result(DoNotWant.new('No such loop: ' + result.name), should_recover)
      end
    end

    def load(filename, env = self.root)
      filename = filename.to_str
      filename += '.lol' unless filename.end_with? '.lol'
      # FIXME better error handling
      # Also see the exceptions raised by run()
      begin
        run(File.read(filename), env)
      rescue SystemCallError
        return DoNotWant.new('CANNOT HAS ' + filename.inspect)
      rescue IOError
        return DoNotWant.new('CANNOT HAS ' + filename.inspect)
      end
      nil
    end

    def run_interpreter(options = {})
      print '? '
      input = gets
      while input.end_with? "...\n" or input.end_with? "…\n"
        print '> '
        input << gets
      end

      index = 0
      should_continue = true
      while should_continue and index < input.size
        ast = @parser.parse(input, :root => :program_fragment, :consume_all_input => false, :index => index)
        if ast
          puts ast.inspect if options[:debug]
          action = ast.compile
          index = @parser.index
          if action
            catch_top_level_result(action.call(options[:environment] || self.root), true)
          else
            puts 'BAI FOR NAU'
            should_continue = false
          end
        else
          puts @parser.failure_reason
          should_continue = false
        end
      end

      run_interpreter(options) if should_continue
    end

    def run(input, env = self.root)
      valid = @parser.parse(input, :consume_all_input => false, :root => :hai)
      raise 'Invalid header! (expected "HAI 1.3")' unless valid

      index = @parser.index
      while true
        ast = @parser.parse(input, :root => :program_fragment, :consume_all_input => false, :index => index)
        if ast
          action = ast.compile
          index = @parser.index
          if action
            begin
              catch_top_level_result(action.call(env), false)
            rescue StandardError => problem
              puts ast.text_value
              raise
            end
          else
            break
          end
        else
          raise @parser.failure_reason
        end
      end
    end
  end

  def self.run_interpreter(options = {})
    World.new.run_interpreter(options)
  end

  def self.load(filename)
    World.new.load(filename)
  end

  def self.run_tests(interactive = true, test_dir = '.')
    success = true
    Dir.entries(test_dir).select {|x| File.extname(x) == '.lol'}.each do |file|
      print file
      if interactive then gets else puts end
      begin
        World.new.load(file)
      rescue StandardError => problem
        puts 'ERROR: ' + problem
        success = false
      end
      puts
    end
    success
  end
end
