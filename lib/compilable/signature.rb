require 'jruby/ext'

class Class

  def signature(name, signature)
    name = name.to_s
    params = signature.keys.first
    sig = Signature.new(params, signature[params])
    sig_method = instance_method(name) || method(name)
    if sig.fit? *(sig_method.args)
      signatures[name] = [sig]
    else
      raise ArgumentError, "java signature does not fit ruby signature"
    end
  end

  def signatures
    @signatures ||= {}
  end

  def static_signature(name, signature)
    name = name.to_s
    params = signature.keys.first
    sig = Signature.new(params, signature[params])
    sig_method = begin
      instance_method(name)
    rescue NameError
      method(name)
    end
    if sig.fit? *(sig_method.args)
      static_signatures[name] = [sig]
    else
      raise ArgumentError, "java signature does not fit ruby signature"
    end
  end

  def static_signatures
    @static_signatures ||= {}
  end
end

class Signature
  attr_accessor :params, :retval

  def initialize(params, retval)
    throw ArgumentError.new("Return Value must not be nil") unless retval
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
