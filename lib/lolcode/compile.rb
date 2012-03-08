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