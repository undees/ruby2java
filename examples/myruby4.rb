require 'rbconfig'
require 'java'
require '../src/signature'

class MyRubyClass
  def helloWorld
    puts "Hello from Ruby"
  end

  def goodbyeWorld(a,b="JRuby")
    puts b+a
  end

	def byeBye(a,b="JRuby")
		puts b+a
	end

  signature :helloWorld, [] => Java::void
  signature :byeBye, [java.lang.String,java.lang.String] => Java::void
	generate_signatures :goodbyeWorld, [java.lang.String,java.lang.String] => Java::void
end
