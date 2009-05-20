require 'rubygems'
require 'bitescript'
require File.join( File.dirname(__FILE__), 'compilable.rb')
require 'fileutils'

module Ruby2Java
  class JavaCompiler
    RubyObject = org.jruby.RubyObject
    RubyBasicObject = org.jruby.RubyBasicObject
    Ruby = org.jruby.Ruby
    RubyClass = org.jruby.RubyClass
    IRubyObject = org.jruby.runtime.builtin.IRubyObject
    ThreadContext = org.jruby.runtime.ThreadContext
    LoadService = org.jruby.runtime.load.LoadService
    JClass = java.lang.Class
    JavaUtil = org.jruby.javasupport.JavaUtil
    JObject = java.lang.Object

    def initialize(source_name)
      @file_builder = BiteScript::FileBuilder.new(source_name)
    end

    def write_files
      @file_builder.generate do |name, builder|
        FileUtils.mkdir_p File.dirname(name)
        File.open(name, 'w') do |f|
          f.write(builder.generate)
        end
      end
    end

    def process_class(ruby_class_path, ruby_class, java_name, *require_files)
      @file_builder.package = ruby_class.package_name if ruby_class.package_name

      cb = @file_builder.public_class(java_name, RubyObject, *ruby_class.interfaces);

      # field to hold the RubyClass reference
      cb.private_static_field "__ruby_class__", RubyClass

      # If a require file is specified, load it in static initializer
      cb.static_init do
        invokestatic Ruby, "getGlobalRuntime", [Ruby]
        require_files.each do |require_file|
          dup
          ldc File.read(require_file)
          ldc require_file
          invokevirtual Ruby, "executeScript", [IRubyObject, cb.string, cb.string]
          pop
        end
        ldc ruby_class_path
        invokevirtual Ruby, "getClass", [RubyClass, cb.string]
        dup
        putstatic this, "__ruby_class__", RubyClass
        ldc this.name
        invokestatic JClass, "forName", [JClass, string]
        invokevirtual RubyClass, "setClassAllocator", [void, JClass]
        # load the script contents into the class file
        returnvoid
      end

      cb.public_constructor do
        aload 0
        invokestatic Ruby, "getGlobalRuntime", [Ruby]
        getstatic this, "__ruby_class__", RubyClass
        invokespecial RubyObject, "<init>", [cb.void, Ruby, RubyClass]
        returnvoid
      end

      for method_name in ruby_class.public_instance_methods(false) do
        method = ruby_class.instance_method(method_name)
        signatures = if ruby_class.respond_to? :signatures
          ruby_class.signatures[method_name]
        else
          nil
        end
        annotations = if ruby_class.respond_to? :annotations
          ruby_class.annotations[method_name]
        else
          nil
        end

        create_method(cb, method_name, method, signatures, annotations)
      end

      for method_name in ruby_class.public_methods(false) do
        method = ruby_class.method(method_name)
        signatures = if ruby_class.respond_to? :static_signatures
          ruby_class.static_signatures[method_name]
        else
          nil
        end
        annotations = if ruby_class.respond_to? :static_annotations
          ruby_class.static_annotations[method_name]
        else
          nil
        end

        create_method(cb, method_name, method, signatures, annotations, :static => true)
      end
    end

    def create_method(cb, method_name, method, signatures = nil, annotations = nil, options = {})
      java_signature = true

      unless signatures
        signatures = Signature.undefined_for_arity(method.arity)
        java_signature = false
      end

      for s in signatures do
        if options[:static]
          mb = cb.public_static_method method_name, s.retval, *(s.params)
        else
          mb = cb.public_method method_name, s.retval, *(s.params)
        end

        mb.start

        if annotations && annotations.size > 0
          # define annotations
          annotations.each do |anno_cls, anno_data|
            mb.annotate(anno_cls, true) do |anno|
              anno_data.each {|k,v| anno.send(k + "=", v)} if anno_data
            end
          end
        end

        # prepare receiver, context, and method name for callMethod later
        options[:static] ? mb.getstatic(mb.this, "__ruby_class__", RubyClass) : mb.aload(0)
        mb.dup
        mb.invokeinterface IRubyObject, "getRuntime", [Ruby]
        ruby_index = first_local(s.params, !options[:static])
        mb.dup; mb.astore ruby_index
        mb.invokevirtual Ruby, "getCurrentContext", [ThreadContext]
        mb.ldc method_name

        # TODO: arity-specific calling
        if java_signature
          java_args(mb, method, s.params, ruby_index, options)
        else
          ruby_args(mb, method, ruby_index, options)
        end

        # invoke the method dynamically
        # TODO: this could have a simple inline cache
        mb.invokevirtual RubyBasicObject, "callMethod", [IRubyObject, ThreadContext, mb.string, IRubyObject[]]

        # return the result
        if java_signature
          java_return(mb, s.retval)
        else
          ruby_return(mb, s.retval)
        end

        mb.stop
      end
    end

    def first_local(params, instance = true)
      i = instance ? 1 : 0
      params.each do |param|
        if param == Java::long || param == Java::double
          i += 2
        else
          i += 1
        end
      end
      i
    end

    def java_args(mb, method, params, ruby_index, options = {})
      # We have a signature and need to use java integration logic
      mb.ldc params.size
      mb.anewarray IRubyObject
      base = options[:static] ? 0 : 1
      index = base
      0.upto(params.size - 1) do |i|
        mb.dup
        mb.ldc i 
        mb.aload ruby_index
        param_type = params[i - 1]
        if [mb.boolean, mb.byte, mb.short, mb.char, mb.int].include? param_type
          mb.iload index + base
          mb.invokestatic JavaUtil, "convertJavaToRuby", [IRubyObject, Ruby, mb.int]
        elsif mb.long == param_type
          mb.lload index + base
          mb.invokestatic JavaUtil, "convertJavaToRuby", [IRubyObject, Ruby, mb.long]
          index += 1
        elsif mb.float == param_type
          mb.fload index + base
          mb.invokestatic JavaUtil, "convertJavaToRuby", [IRubyObject, Ruby, mb.float]
        elsif mb.double == param_type
          mb.dload index + base
          mb.invokestatic JavaUtil, "convertJavaToRuby", [IRubyObject, Ruby, mb.double]
          index += 1
        else
          mb.aload index + base
          mb.invokestatic JavaUtil, "convertJavaToUsableRubyObject", [IRubyObject, Ruby, mb.object]
        end
        mb.aastore
        index += 1
      end
    end

    def ruby_args(mb, method, ruby_index, options = {})
      if method.arity < 0
        # restarg or optarg, just pass array through
        mb.aload options[:static] ? 0 : 1
      else
        # all normal args, box them up
        mb.ldc method.arity
        mb.anewarray IRubyObject
        i = ruby_index;
        base = options[:static] ? 0 : 1
        0.upto(method.arity - 1) do |i|
          mb.dup
          mb.ldc i
          mb.aload i + base
          mb.aastore
        end
      end
    end

    def ruby_return(mb, retval)
      mb.areturn
    end

    def java_return(mb, retval)
      if mb.boolean == retval
        mb.invokestatic JavaUtil, "convertRubyToJavaBoolean", [mb.boolean, IRubyObject]
        mb.ireturn
      elsif mb.byte == retval
        mb.invokestatic JavaUtil, "convertRubyToJavaByte", [mb.byte, IRubyObject]
        mb.ireturn
      elsif mb.short == retval
        mb.invokestatic JavaUtil, "convertRubyToJavaShort", [mb.short, IRubyObject]
        mb.ireturn
      elsif mb.char == retval
        mb.invokestatic JavaUtil, "convertRubyToJavaChar", [mb.char, IRubyObject]
        mb.ireturn
      elsif mb.int == retval
        mb.invokestatic JavaUtil, "convertRubyToJavaInt", [mb.int, IRubyObject]
        mb.ireturn
      elsif mb.long == retval
        mb.invokestatic JavaUtil, "convertRubyToJavaLong", [mb.long, IRubyObject]
        mb.lreturn
      elsif mb.float == retval
        mb.invokestatic JavaUtil, "convertRubyToJavaFloat", [mb.float, IRubyObject]
        mb.freturn
      elsif mb.double == retval
        mb.invokestatic JavaUtil, "convertRubyToJavaDouble", [mb.double, IRubyObject]
        mb.dreturn
      elsif retval == mb.void || retval == nil
        mb.pop
        mb.returnvoid
      else
        mb.ldc retval
        mb.invokestatic JavaUtil, "convertRubyToJava", [JObject, IRubyObject, JClass]
        mb.areturn
      end
    end
  end
end
