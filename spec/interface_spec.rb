require File.join(File.dirname(__FILE__), 'spec_helper')

describe "Class interface support" do
  
  before :each do
    TestClass.empty_interfaces
  end

  it "should be empty by default" do
    TestClass.interfaces.should be_empty
  end

  it "should retain interfaces added previously" do
    TestClass.interface JCloneable
    TestClass.interface JComparable
    TestClass.interfaces.should have(2).interfaces
  end

  it "should not add an already added interface" do
    TestClass.interface JCloneable
    TestClass.interface JCloneable
    TestClass.interfaces.should have(1).interfaces
  end

  it "should raise an exception if no arguments are passed" do
    lambda{
      TestClass.interface
    }.should raise_error(ArgumentError)
  end
end
