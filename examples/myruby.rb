require 'rbconfig'
require 'java'
require File.join( File.dirname(__FILE__), '..', 'src', 'compilable')

class MyRubyClass
  def helloWorld
    puts "Hello from Ruby"
  end
  def goodbyeWorld(a)
    puts a
  end

  signature :helloWorld, [] => Java::void
  signature :goodbyeWorld, [java.lang.String] => Java::void
end
