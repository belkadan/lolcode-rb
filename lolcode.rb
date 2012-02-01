require 'treetop'

module Lolcode
  Treetop.load(File.join(File.dirname(__FILE__), 'lolcode.treetop'))
  @parser = LolcodeParser.new

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
    @@bukkit = nil

    def initialize(parent = @@bukkit)
      @values = {}
      @parent = parent
    end

    @@bukkit = Bukkit.new(nil)

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
      get(var).init(name, val)
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

    def self.lol_type
      @@bukkit
    end

    def cast(val)
      DoNotWant.new('Cannot MAEK ' + Yarn.cast(val) + ' into that.')
    end

    def @@bukkit.cast(val)
      val
    end
  end

  class Proc < Bukkit
    unless self.class_variable_defined?(:@@sheep)
      # FIXME common parent for Primitives and Sheepdas?
      @@sheep = Bukkit.new
    end

    def initialize(env, args, body)
      super(@@sheep)
      @env = env
      @args = args
      @body = body
    end

    def call(me, arg_values)
      # FIXME this is not proper Ruby
      new_env = Environment.new @env
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

    def self.lol_type
      @@sheep
    end
  end

  class Primitive < Bukkit
    unless self.class_variable_defined?(:@@primitive)
      # FIXME common parent for Primitives and Sheepdas?
      @@primitive = Bukkit.new
    end

    def initialize(&body)
      super(@@primitive)
      @body = body
    end

    def call(me, arg_values)
      @body.call(me, arg_values)
    end

    def self.lol_type
      @@primitive
    end
  end

  class Bukkit
    @@bukkit.init('liek', Primitive.new do |me, args|
      Troof.new(me.liek? args.first)
    end)
  end

  @noob = Bukkit.new
  def @noob.cast(val)
    self
  end
  def @noob.to_s
    'NOOB'
  end
  def @noob.win?
    false
  end
  def self.noob
    @noob
  end

  class ImmutableBukkit < Bukkit
    alias_method :set!, :set
    def set(name, val)
      DoNotWant.new('It is not safe to change the properties of non-finite primitives.')
    end
  end

  class Troof < Bukkit
    # FIXME TROOF should inherit from BUKKIT
    # FIXME all of these should be per-environment, since you can mess with the slots!
    unless self.class_variable_defined?(:@@troof)
      @@troof = Bukkit.new
      @@win = Troof.new(@@troof)
      @@fail = Troof.new(@@troof)
    end

    def self.new(truth)
      return super if @@fail.nil?
      if truth then @@win else @@fail end
    end

    def self.cast(val)
      if Lolcode.win?(val) then @@win else @@fail end
    end
    def @@troof.cast(val)
      Troof.cast(val)
    end

    def @@win.to_s
      'WIN'
    end
    def @@win.win?
      true
    end
    def @@fail.to_s
      'FAIL'
    end
    def @@fail.win?
      false
    end

    def self.lol_type
      @@troof
    end
  end

  class Yarn < ImmutableBukkit
    # FIXME the empty string should be per-environment, since you can mess with the YARN prototype!
    @@empty = nil

    def self.new(val, parent = @@empty)
      return @@empty if @@empty and (val == '' or val == @@empty)
      super
    end

    def initialize(val, parent = @@empty)
      super(parent)
      @value = val.to_s
    end

    @@empty = Yarn.new('', Bukkit.lol_type)

    def self.cast(val)
      Yarn.new(val)
    end
    def @@empty.cast(val)
      Yarn.new(val)
    end

    def to_s
      @value
    end

    def to_str
      to_s
    end

    def ==(other)
      other.is_a?(Yarn) and other.to_s == to_s
    end

    def empty?
      self == @@empty
    end

    def win?
      !empty?
    end

    def get(name)
      if name.first == 'LONGNESS'
        longness = Lolcode.make_numeric(@value.length)
        if name.count == 1
          longness
        else
          longness.get(name.drop(1))
        end
      else
        super
      end
    end

    def @@empty.set(name, val)
      set!(name, val)
    end

    def self.lol_type
      @@empty
    end
  end

  class Numbr < ImmutableBukkit
    @@zero = nil
    @@one = nil

    def initialize(val)
      super(@@zero || Bukkit.lol_type)
      @value = val
    end

    def self.new(val)
      return @@zero if @@zero and val.zero?
      return @@one if @@one and val == 1
      super
    end

    @@zero = self.new(0)
    @@one = self.new(1)

    def self.cast(val)
      return @@one if val.is_a? Troof and val.win?
      return @@zero if val.is_a? Troof or val == @noob
      return val if val.is_a? Numbr
      return self.new(val.to_i) if val.is_a? Numbar
      return self.new(val.to_str.to_i) if val.is_a? Yarn

      # FIXME: random bukkits?
      return DoNotWant.new('Cannot make a NUMBR from ' + Yarn.cast(val))
    end
    def @@zero.cast(val)
      Numbr.cast(val)
    end

    def ==(other)
      return other.to_f == to_f if other.is_a?(Numbar)
      return other.to_i == to_i if other.is_a?(Numbr)
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

    def next
      Numbr.new(@value.next)
    end

    def pred
      Numbr.new(@value.pred)
    end

    def win?
      self != @@zero
    end

    def self.lol_type
      @@zero
    end

    def @@zero.set(name, val)
      set!(name, val)
    end
  end

  class Numbar < ImmutableBukkit
    @@zero = nil
    @@one = nil

    def initialize(val)
      super(@@zero || Bukkit.lol_type)
      @value = val
    end

    def self.new(val)
      return @@zero if @@zero and val.zero?
      return @@one if @@one and val == 1.0
      super
    end

    @@zero = self.new(0.0)
    @@one = self.new(1.0)

    def self.cast(val)
      return @@one if val.is_a? Troof and val.win?
      return @@zero if val.is_a? Troof or val == Lolcode::noob
      return val if val.is_a? Numbar
      return self.new(val.to_f) if val.is_a? Numbr
      return self.new(val.to_str.to_f) if val.is_a? Yarn

      # FIXME: random bukkits?
      return DoNotWant.new('Cannot make a NUMBAR from ' + Yarn.cast(val))
    end
    def @@zero.cast(val)
      Numbar.cast(val)
    end

    def ==(other)
      return other.to_f == to_f if other.is_a?(Numbar) or other.is_a?(Numbr)
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

    def win?
      self != @@zero
    end

    def @@zero.set(name, val)
      set!(name, val)
    end

    def self.lol_type
      @@zero
    end
  end

  class World
    def initialize
      Bukkit.register(self)
      Lolcode::noob.register(self)
      Troof.register(self)
      Primitive.register(self)
      Proc.register(self)
      Numbr.register(self)
      Numbar.register(self)
      Yarn.register(self)
    end
  end

  class Environment < Bukkit
    def self.root
      root = Environment.new
      root.init('WIN', Troof.new(true))
      root.init('FAIL', Troof.new(false))
      root.init('NOOB', Lolcode::noob)
      root.init('TROOF', Troof.lol_type)
      root.init('MAGIC', Primitive.lol_type)
      root.init('SHEEP', Proc.lol_type)
      root.init('NUMBR', Numbr.lol_type)
      root.init('NUMBAR', Numbar.lol_type)
      root.init('YARN', Yarn.lol_type)
      root.init('BUKKIT', Bukkit.lol_type)
      # HACK
      root.init('liek', Bukkit.lol_type.get(['liek']))
      root
    end

    def initialize(parent = nil)
      # FIXME: this is WRONG, environments are BUKKITs like anything else...but the top-level environment is the BUKKIT bukkit. How to do this properly...?
      super
      init('IT', Lolcode::noob)
      init('I', self)
    end

    def it
      ['IT']
    end
  end

  def self.win?(val)
    if val.respond_to?(:win?)
      val.win?
    else
      # FIXME: do random bukkits get to choose their conversion?
      true
    end
  end

  def self.to_numeric(val)
    return val.to_i if val.is_a? Numbr
    return val.to_f if val.is_a? Numbar
    return 1 if val.is_a? Troof and val.win?
    return 0 if val.is_a? Troof

    # FIXME: random bukkits?
    return DoNotWant.new('Cannot make a NUMBR or NUMBAR from ' + Yarn.cast(val)) unless val.is_a? Yarn

    val = val.to_str
    return val.to_f if val.include? '.'
    return val.to_i
  end

  def self.make_numeric(val)
    # This translates from Ruby floats and ints to Lolcode NUMBARs and NUMBRs
    return Numbr.new(val) if val.is_a? Integer
    return Numbar.new(val)
  end

  def self.load(filename, env = Environment.root)
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

  def self.catch_top_level_result(result, should_recover)
    return if result.nil?
    # FIXME how to deal with this more properly?
    if result.is_a? DoNotWant
      raise 'DO NOT WANT: ' + Yarn.cast(result.value) unless should_recover
      # FIXME should use stderr
      puts 'DO NOT WANT: ' + Yarn.cast(result.value)
    elsif result.name
      catch_top_level_result(DoNotWant.new('No such loop: ' + result.name), should_recover)
    end
  end

  def self.run_interpreter(env = Environment.root, options = {})
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
          catch_top_level_result(action.call(env), true)
        else
          puts 'BAI FOR NAU'
          should_continue = false
        end
      else
        puts @parser.failure_reason
        should_continue = false
      end
    end

    run_interpreter(env) if should_continue
  end

  def self.run(input, env = Environment.root())
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

  def self.run_tests(interactive = true, test_dir = '.')
    success = true
    Dir.entries(test_dir).select {|x| File.extname(x) == '.lol'}.each do |file|
      print file
      if interactive then gets else puts end
      begin
        self.load(file)
      rescue StandardError => problem
        puts 'ERROR: ' + problem
        success = false
      end
      puts
    end
    success
  end
end
