require 'jruby/ext'

IRubyObject = org.jruby.runtime.builtin.IRubyObject

class Class

  def generate_signatures(name, signature)
    args = instance_method(name).args # Using some stuff headius told me
    offset = args.first.length
    params = signature.keys.first
    ret_val = signature[params]
    if  params.size <= offset
      signature(name,signature)
      return
    end

    sig = []
    cur_params = params[0...(offset)]
    cur_sig = Signature.new(cur_params, ret_val)
    if cur_sig.fit? *args
      sig << cur_sig
    else
      raise ArgumentError, "java signature does not fit ruby signature"
    end

    unless args[1].empty?
      lim = [params.size - offset, args[1].size].min
      (0...lim).each do |x|
        cur_params << params[offset+x]
        cur_sig = Signature.new(cur_params, ret_val)
        if cur_sig.fit? *args
          sig << cur_sig
        else
          raise ArgumentError, "java signature does not fit ruby signature"
        end
      end
    end

    if args[2]
      # TODO: Implement restargs?
    end

    if args[3]
      # TODO: Implement blocks?
    end

    signatures[name.to_s] ||= []
    signatures[name.to_s].push *sig
  end

  def signature(name, signature)
    name = name.to_s
    params = signature.keys.first
    sig = Signature.new(params, signature[params])
    if sig.fit? *(instance_method(name).args)
      signatures[name] ||= [] 
      signatures[name] << sig
    else
      raise ArgumentError, "java signature does not fit ruby signature"
    end
  end

  def signatures
    @signatures ||= {}
  end
end

class Signature
  attr_accessor :params, :retval

  def initialize(params, retval)
    @params, @retval = params.dup, retval
  end

  # Check if a signature fits in the "arity" of a method
  # should be called sig.fit? *args
  # where args come from instance_method(:foo).args
  def fit?(compulsory, optional, rest, block)     # TODO: Check for blocks
    compulsory.size <= params.size && compulsory.size + optional.size >= params.size #|| !rest.nil?
  end

  def self.undefined_for_arity(arity)
    params = (arity < 0) ? [IRubyObject[]] : [IRubyObject] * arity

    [Signature.new(params, IRubyObject)]
  end
end
