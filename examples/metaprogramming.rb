require 'rbconfig'
require 'java'
require File.join( File.dirname(__FILE__), '..', 'lib', 'compilable')

class Metaprogramming
  %w[boolean byte short char int long float double].each do |type|
    java_type = Java.send type
    eval "def #{type}Method(a); a; end"
    signature "#{type}Method", [java_type] => java_type
  end
end