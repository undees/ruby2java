The Ruby2Java compiler inspects the *runtime* definition of classes
to produce a normal-looking Java class. All metaprogrammed methods
are reflected on the Java class, as are runtime modifications to
those methods.

== Installation

  gem install ruby2java

== How do I use it?

To create a Java class from a Ruby class, use the following command:

  ruby2java RubyClass file1.rb [file2.rb ...]

The compiler will then:

1. Require in all specified files. Watch those load-time side-effects!
2. Retrieve the named Ruby class
3. Inspect the Ruby class object for "signatures" and "annotations"
   methods, from which it gathers Java signature/annotation info
4. Generate a Java .class file for the new same-named Java class

The resulting Java class will have normal constructors and methods
and will be constructible and callable lke any other Java class.

== What do I need?

* JRuby 1.3.0RC2 or higher

== Features

* Public instance methods, static methods, and constructors
* Interface implementation
* Package specification
* Basic method annotation

== Known Issues

* All Java dependencies must be compiled and available on JRuby's
  classpath for the compiler to work (since it must be able to see
  those classes when generating the Java signatures/annotations).
* There is no dependency tracking between compiled Ruby classes.
  If two Ruby2Java-compiled Ruby classes depend on each other for
  their Java signatures, you will need them to use "Object" or some
  common supertype.
* Circular dependencies are not yet supported. (implied by above)
* Extending an existing Java class is not yet supported.
* Annotations have only been cursorily tested, and may not work for
  nontrivial cases.
* Because the .rb files specified are embedded in the .class, it will
  be larger than the sum of all those file sizes. It also does not
  provide much of an obfuscation boundary.
* There are no optimizations in place to speed the dynamic dispatch
  performed by each of the generated Java methods.
