require "spec_helper"

describe Signature do
  describe "should raise an exception if" do
    it "less arguments than needed are given" do
      lambda{
        class TestClass
          signature "method2100", [] => Java::void
        end
      }.should raise_error(ArgumentError)
    end

    it "more arguments than the method can accept are given" do
      lambda{
        class TestClass
          signature "method0000", [java.lang.String] => Java::void
        end
      }.should raise_error(ArgumentError)
    end
  end
end
