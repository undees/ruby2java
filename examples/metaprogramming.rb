require 'rbconfig'
require 'java'

class Metaprogramming
  %w[boolean byte short char int long float double].each do |type|
    java_type = Java.send type
    eval "def #{type}Method(a); a; end"
    signature "#{type}Method", [java_type] => java_type if defined? Ruby2Java
  end
end
