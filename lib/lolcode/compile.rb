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
      
      def o_rly(consequent, alternatives, last_alternative)
				lambda {|env|
					if env.get(Runtime::Environment::It).win?
						consequent.call(env) if consequent
					else
						chosen = alternatives.find do |cond, body|
							test = cond.call(env)
							break test if test.is_a?(Runtime::DoNotWant)
							test.win?
						end
						return chosen if chosen.is_a?(Runtime::DoNotWant)

            chosen_body = if chosen then chosen[1] else last_alternative end
            chosen_body.call(env) if chosen_body
					end
				}
      end

      def wtf(choices)
				lambda {|env|
					test_var = env.get(Runtime::Environment::It)
					result = nil
					choices.drop_while do |literal, body|
						literal and test_var != literal
					end.each do |literal, body|
						result = body.call(env) if body
						if result
              # Exceptions, returns, etc. handled normally.
              # Named GTFOs always refer to loops.
              # But nameless GTFOs just end the switch harmlessly.
							result = nil if result.is_a? Runtime::GTFO and result.name.nil?
							break
						end
					end
					result
				}
      end
      
      def plz(action, handlers, cleanup)
				lambda {|env|
					result = action.call(env) if action
					if result and result.is_a? Runtime::DoNotWant
						env.set(Runtime::Environment::It, result.value)
						chosen = handlers.find do |cond, action|
							test = cond.call(env)
							break test if test.is_a?(Runtime::DoNotWant)
							test.win?
						end
						# FIXME nested exceptions...which takes priority?
						# This says the O NOES test's exception wins...
						if chosen.is_a?(Runtime::DoNotWant)
							result = chosen
						elsif chosen and chosen[1]
							result = chosen[1].call(env)
						end
					end
					# ...but this says the cleanup clause's exception loses
					cleanup_result = cleanup.call(env) if cleanup
					result || cleanup_result
				}
      end
      
      def im_in_yr_bukkit(obj, slot, name, body)
				lambda {|env|
					base = obj.call(env)
					return base if base.is_a?(Runtime::DoNotWant)

					iter_function = base.get([slot])
					return iter_function if iter_function.is_a?(Runtime::DoNotWant)
					iter = iter_function.call(base, [])
					return iter if iter_function.is_a?(Runtime::DoNotWant)

					while true
            # :-( For perfect correctness we can't optimize this.
						test = iter.get(['finished'])
						return test if test.is_a?(Runtime::DoNotWant)
						finished = test.call(iter, [])
						return finished if finished.is_a?(Runtime::DoNotWant)
						break if finished.win?

						advance = iter.get(['going'])
						return advance if advance.is_a?(Runtime::DoNotWant)
						item = advance.call(iter, [])
						return item if item.is_a?(Runtime::DoNotWant)
						env.set(Runtime::Environment::It, item)

						# FIXME copypasta from below
						result = body.call(env) if body
						if result
							if result.is_a? Runtime::GTFO
								break if result.name.nil? or result.name == name
								return result
							elsif result.is_a? Runtime::Whatever
								break if result.name and result.name != name
								# otherwise, just jump to the top of the loop, which is right
							else
								return result
							end
						end
					end
					nil
				}
      end
      
      def im_in_yr(name, incr, test, body)
				lambda {|env|
					while true
						if test
							test_val = test.call(env)
							return test_val if test_val.is_a?(Runtime::DoNotWant)
							break unless test_val
						end

						result = body.call(env) if body
						if result
							if result.is_a? Runtime::GTFO
								break if result.name.nil? or result.name == name
								return result
							elsif result.is_a? Runtime::Whatever
								break if result.name and result.name != name
								# otherwise, just jump to the increment, which is right
							else
								return result
							end
						end

						incr_result = incr.call(env) if incr
						return incr_result if incr_result.is_a?(Runtime::DoNotWant)
					end
					nil
				}
      end
      
      def uppin(loop_var, incr)
        raise "incr should be a symbol" unless incr.is_a?(Symbol)
				lambda {|env|
					# It is conceivable that the loop variable could be SRSing itself...
					# Fix the reference before doing any modification.
					curr_var = loop_var.call(env)
					return curr_var if curr_var.is_a?(Runtime::DoNotWant)
					curr_val = env.get(curr_var)
					return curr_val if curr_val.is_a?(Runtime::DoNotWant)
					val = Runtime::Numbr.cast(env.world, curr_val)
					return val if val.is_a?(Runtime::DoNotWant)
					env.set(curr_var, val.send(incr, env.world))
				}
      end
      
      def wile(condition, desired)
				lambda {|env|
					test = condition.call(env)
					return test if test.is_a?(Runtime::DoNotWant)
					test.win? == desired
				}
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
				# FIXME: share code with MAEK?
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

      def itz_a(parent)
        lambda {|env|
					# We can't just test this directly because
					# someone could override their 'liek' slot
					parent_val = parent.call(env)
					return parent_val if parent_val.is_a?(Runtime::DoNotWant)
					problem = env.get(Runtime::Environment::It)
					liek = problem.get(['liek'])
					return liek if liek.is_a?(Runtime::DoNotWant)
					liek.call(problem, [parent_val])
				}
      end
			
			def found_yr(kind, value)
				result_class = case kind
				               when :FoundYr   then Runtime::Result
				               when :DoNotWant then Runtime::DoNotWant
				               else raise 'Unknown function exit kind'
				               end
				lambda {|env|
					val = value.call(env)
					return val if val.is_a?(Runtime::DoNotWant)
					result_class.new(val)
				}
			end

			def gtfo(kind, label)
				result_class = case kind
				               when :GTFO     then Runtime::GTFO
				               when :WHATEVER then Runtime::Whatever
				               else raise 'Unknown lop exit kind'
				               end
				lambda {|env| result_class.new(label) }
			end

      def sequence(first, second)
  			if second
  				lambda {|env| first.call(env) || second.call(env) }
  			else
  				first
  			end
      end
      
      def monadic_op(op_name)
        case op_name
        when :NOT
  				lambda {|a, world| Runtime::Troof.new(world, !a.win?) }
        when :LIEK
          lambda {|a, world| Runtime::Bukkit.new(a) }
        else
          raise 'Unknown monadic operator'
        end
      end
      
      def apply_monadic(op, arg)
				lambda {|env|
					arg_val = arg.call(env)
					return arg_val if arg_val.is_a?(Runtime::DoNotWant)
					op.call(arg_val, env.world)
				}
      end
      
			def numeric_dyadic_op(op_name)
				op = case op_name
				     when :SUM
				     	lambda {|a,b| a + b }
				     when :DIFF
				     	lambda {|a,b| a - b }
				     when :PRODUKT
				     	lambda {|a,b| a * b }
				     when :QUOSHUNT
				     	lambda {|a,b|
				     	 	return Runtime::DoNotWant.new('DIVIDE BY ZERO') if b.zero?
				     	 	a / b
				     	}
				     when :MOD
				     	lambda {|a,b|
				     	 	return Runtime::DoNotWant.new('DIVIDE BY ZERO') if b.zero?
				     	 	a % b
				     	}
				     when :BIGGR
				     	lambda {|a,b| [a, b].max }
				     when :SMALLR
				     	lambda {|a,b| [a, b].min }
				     else
				     	raise 'Unknown numeric dyadic operator'
				     end
				lambda {|a, b, world|
					left = world.to_numeric(a)
					return left if left.is_a?(Runtime::DoNotWant)
					right = world.to_numeric(b)
					return right if right.is_a?(Runtime::DoNotWant)
					result = op.call(left, right)
					return result if result.is_a?(Runtime::DoNotWant)
					world.make_numeric(result)
				}
			end
			
			def boolean_dyadic_op(op_name)
				msg = case op_name
				      when :BOTH   then :&
				      when :EITHER then :|
				      when :WON    then :^
				      else raise 'Unknown boolean dyadic operator'
				      end
				lambda {|a, b, world|
					left = a.win?
					right = b.win?
					Runtime::Troof.new(world, left.send(msg, right))
				}
			end

			def both_saem_op
				lambda {|a, b, world| Runtime::Troof.new(world, a == b) }
			end
			def diffrint_op
				lambda {|a, b, world| Runtime::Troof.new(world, a != b) }
			end

      def apply_dyadic(op, lexpr, rexpr)
				lambda {|env|
					lval = lexpr.call(env)
					return lval if lval.is_a?(Runtime::DoNotWant)
					rval = rexpr.call(env)
					return rval if rval.is_a?(Runtime::DoNotWant)
					op.call(lval, rval, env.world)
				}
      end
			
			def boolean_variadic_op(op_name)
				msg = case op_name
				      when :ALL then :all?
				      when :ANY then :any?
				      else raise 'Unknown boolean variadic operator'
				      end
				lambda {|world, args|
					Runtime::Troof.new(world, args.map(&:win?).send(msg))
				}
			end
			
			def smoosh_op
				lambda {|world, args|
					yarns = args.map do |arg|
						casted = Runtime::Yarn.cast(world, arg)
						break casted if casted.is_a?(Runtime::DoNotWant)
						casted
					end
					return yarns if yarns.is_a?(Runtime::DoNotWant)
					Runtime::Yarn.new(world, yarns.join)
				}
			end
			
			def apply_variadic(op, args)
				lambda {|env|
					arg_vals = args.map do |arg|
						val = arg.call(env)
						break val if val.is_a?(Runtime::DoNotWant)
						val
					end
					return arg_vals if arg_vals.is_a?(Runtime::DoNotWant)
					op.call(env.world, arg_vals)
				}
			end
			
			def maek(val, type)
				lambda {|env|
					type_var = type.call(env)
					return type_var if type_var.is_a?(Runtime::DoNotWant)
					type_val = env.get(type_var)
					return type_val if type_val.is_a?(Runtime::DoNotWant)
					real_val = val.call(env)
					return real_val if real_val.is_a?(Runtime::DoNotWant)
					type_val.cast(env.world, real_val)
				}
			end
			
			def function_call(me, name, arg_exprs)
				lambda {|env|
					obj = me.call(env)
					return obj if obj.is_a?(Runtime::DoNotWant)
					func = obj.get([name])
					return func if func.is_a?(Runtime::DoNotWant)
					arg_vals = arg_exprs.map do |arg|
						val = arg.call(env)
						break val if val.is_a?(Runtime::DoNotWant)
						val
					end
					return arg_vals if arg_vals.is_a?(Runtime::DoNotWant)
					func.call(obj, arg_vals)
				}
			end
			
			def numbar(val)
				lambda {|env| Runtime::Numbar.new(env.world, val) }
			end
			def numbr(val)
				lambda {|env| Runtime::Numbr.new(env.world, val) }
			end
			
			def yarn(pieces)
				lambda {|env|
					strs = pieces.map do |piece|
						if piece.respond_to?(:call)
							piece = piece.call(env)
							break piece if piece.is_a?(Runtime::DoNotWant)
						end
						piece
					end
					return strs if strs.is_a?(Runtime::DoNotWant)
					Runtime::Yarn.new(env.world, strs.join)
				}
			end
			
			def to_yarn(var)
				# FIXME: This is really a composite of other things, huh.
				lambda {|env|
					actual_var = var.call(env)
					return actual_var if actual_var.is_a?(Runtime::DoNotWant)
					val = env.get(actual_var)
					return val if val.is_a?(Runtime::DoNotWant)
					Runtime::Yarn.cast(env.world, val)
				}
			end
    end
  end
end