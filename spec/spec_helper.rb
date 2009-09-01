require File.join( File.dirname(__FILE__), "..", "lib", "compilable", "signature")
require File.join( File.dirname(__FILE__), "..", "lib", "compilable", "interface")
require File.join( File.dirname(__FILE__), "..", "lib", "compilable", "package")

JCloneable = java.lang.Cloneable
JComparable = java.lang.Comparable

class TestClass

  # Methods name: methodABCD
  # A: number of compulsory arguments.
  # B: number of optional parameters.
  # C: 1 if restargs, 0 otherwise
  # D: 1 if block_given?, 0 otherwise.

  def method0000
    "foo"
  end

  def method2100(a,b,c="bar")
    a + b + c
  end
end

class Class
  
  def empty_interfaces
    @interfaces = []
  end
end
