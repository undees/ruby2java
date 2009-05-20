require 'rbconfig'

class SimpleSignatures
  def helloWorld
    puts "Hello from Ruby"
  end
  def goodbyeWorld(a)
    puts a
  end

  if defined? Ruby2Java
    signature :helloWorld, [] => Java::void
    signature :goodbyeWorld, [java.lang.String] => Java::void
  end
end
