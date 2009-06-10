dir = File.join( File.dirname(__FILE__), 'compilable')
require File.join(dir,'annotation')
require File.join(dir,"extends_class")
require File.join(dir,'interface')
require File.join(dir,'package')
require File.join(dir,'signature')

class Class

  def ruby2java_compilable?
    parent_class.included_modules.include?(Java::OrgJrubyRuntimeBuiltin::IRubyObject)
  end
end
