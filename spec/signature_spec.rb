require "spec_helper"

describe Signature do
  it "should raise an exception if less arguments than needed are given" do
    lambda{
      class TestClass
        signature "method2100", [] => Java::void
      end
    }.should raise_error(ArgumentError)
  end

  it "should raise an exception if more parameters than needed are given" do
    lambda{
      class TestClass
        signature "method0000", [java.lang.String] => Java::void
      end
    }.should raise_error(ArgumentError)
  end
end
