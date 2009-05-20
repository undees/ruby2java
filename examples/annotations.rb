class TestSomething
  def test_jruby_rocks
    fail unless "JRuby rocks" == "JRuby" + " " + "rocks"
  end

  def test_jruby_will_never_support_annotations
    fail("JRuby does support annotations!") if "JRuby supports annotations"
  end
end

# Anywhere else in your project, you can turn this into a Java class
if defined? Ruby2Java
  TestSomething.signature 'test_jruby_rocks', [] => nil
  TestSomething.signature 'test_jruby_will_never_support_annotations', [] => nil
  TestSomething.annotation 'test_jruby_rocks', org.junit.Test => nil
  TestSomething.annotation 'test_jruby_will_never_support_annotations', org.junit.Test => nil
end
