require "spec_helper"

describe Signature do
  it "should raise an exception if fewer arguments than needed are passed" do
    lambda{
      class TestClass
        signature "method2100", [] => Java::void
      end
    }.should raise_error(ArgumentError)
  end
end
