require 'jruby/ext'

IRubyObject = org.jruby.runtime.builtin.IRubyObject

class Class

  def signature(name, signature)
    name = name.to_s
    params = signature.keys.first
    sig = Signature.new(params, signature[params])
    if sig.fit? *(instance_method(name).args)
      signatures[name] = [sig]
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
