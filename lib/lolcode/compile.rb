require 'rubygems'
require 'treetop'

module Lolcode
  Treetop.load(File.join(File.dirname(__FILE__), 'lolcode.treetop'))

  module Compile
    class << self
      def can_has(name)
  			lambda {|env|
  				name_val = name.call(env)
  				return name_val if name_val.is_a?(Runtime::DoNotWant)
  				env.world.load(name_val)
  			}
      end

      def has_a(bukkit, slot, initial)
        raise 'slot should be a simple string' unless slot.respond_to?(:to_str)
  			lambda {|env|
  				bukkit_val = bukkit.call(env)
  				return bukkit_val if bukkit_val.is_a?(Runtime::DoNotWant)
          if initial
            initial_val = initial.call(env)
            return initial_val if initial_val.is_a?(Runtime::DoNotWant)
          else
            initial_val = env.world.noob
          end
  				env.create(bukkit_val, slot, initial_val);
  			}
      end
    
      def o_hai_im(name, parent, body)
  			lambda {|env|
  				if name
  					base = name.call(env)
  					return base if base.is_a?(Runtime::DoNotWant)
  					slot = base.pop
  					base = Runtime::Environment::I if base.empty?
  				end

          if parent
            new_bukkit = parent.call(env)
            return new_bukkit if new_bukkit.is_a?(Runtime::DoNotWant)
          else
            new_bukkit = Runtime::Bukkit.new(env.world.bukkit)
          end

  				if body
  					bukkit_env = Runtime::Environment.new(env.world, env)
  					bukkit_env.set(Runtime::Environment::I, new_bukkit)
  					bukkit_env.init(Runtime::Environment::Me, new_bukkit)
  					problem = body.call(bukkit_env)
  					return problem if problem
  				end

  				if name
  					env.create(base, slot, new_bukkit)
  				else
  					env.set(Runtime::Environment::It, new_bukkit)
  				end
  			}
      end
      
      def how_iz(bukkit, slot, arg_names, rest_name, body)
				lambda {|env|
					bukkit_val = bukkit.call(env)
					return bukkit_val if bukkit_val.is_a?(Runtime::DoNotWant)
					proc = env.closure(arg_names, rest_name, body)
					env.create(bukkit_val, slot, proc);
				}
      end

      def if_u_say_so
				# Falling off the end of a function body >> FOUND IT
        # FIXME: is Ruby smart enough to unique this? In Ruby v1.8, NO.
				lambda {|env| Runtime::Result.new(env.get(Runtime::Environment::It)) }
      end

      def visible(args, has_newline)
				lambda {|env|
					error = args.each do |arg|
						arg_val = arg.call(env)
						break arg_val if arg_val.is_a?(Runtime::DoNotWant)
						arg_yarn = Runtime::Yarn.cast(env.world, arg_val)
						break arg_yarn if arg_yarn.is_a?(Runtime::DoNotWant)
						print arg_yarn
					end
					return error if error.is_a?(Runtime::DoNotWant)
					puts if has_newline
					nil
				}
      end

      def gimmeh(var)
				lambda {|env|
					arg_val = var.call(env)
					return arg_val if arg_val.is_a?(Runtime::DoNotWant)
					input = gets
					if input
						env.set(arg_val, Runtime::Yarn.new(env.world, input.chomp))
					else
						env.set(arg_val, env.world.noob)
					end
				}
      end

      def get(source)
				lambda {|env|
					val = source.call(env)
					return val if val.is_a?(Runtime::DoNotWant)
					env.get(val)
				}
      end

      def assign(sink, source)
				lambda {|env|
					sink_val = sink.call(env)
					return sink_val if sink_val.is_a?(Runtime::DoNotWant)
					source_val = source.call(env)
					return source_val if source_val.is_a?(Runtime::DoNotWant)
					env.set(sink_val, source_val)
				}
      end

      def is_now_a(var, type)
				lambda {|env|
					# It is conceivable that the variable could be SRSing itself...
					# Fix the reference before doing any modification.
					curr_var = var.call(env)
					return curr_var if curr_var.is_a?(Runtime::DoNotWant)
					type_var = type.call(env)
					return type_var if type_var.is_a?(Runtime::DoNotWant)
					type_val = env.get(type_var)
					return type_val if type_val.is_a?(Runtime::DoNotWant)
					curr_val = env.get(curr_var)
					return curr_val if curr_val.is_a?(Runtime::DoNotWant)
					val = type_val.cast(env.world, curr_val)
					return val if val.is_a?(Runtime::DoNotWant)
					env.set(curr_var, val)
				}
      end

      def set_it(expr)
				lambda {|env|
					val = expr.call(env)
					return val if val.is_a?(Runtime::DoNotWant)
					env.set(Runtime::Environment::It, val)
				}
      end

      def sequence(first, second)
  			if second
  				lambda {|env| first.call(env) || second.call(env) }
  			else
  				first
  			end
      end
    end
  end
end