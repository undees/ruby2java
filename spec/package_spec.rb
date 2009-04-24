require File.join(File.dirname(__FILE__), 'spec_helper')

describe "Class package support" do
 
  describe "#package" do
    it "should not take into account consecutive calls after the first one" do  
      TestClass.package "org.jruby.ruby2java"
      TestClass.package "org.jruby"
      TestClass.package_name.should == "org.jruby.ruby2java"
    end

    it "should fail when called without arguments" do
      lambda{
	TestClass.package
      }.should raise_error
    end
  end
end
