class Class

  def extends_class(klazz)
    @parent_class = klazz if klazz.is_a? Class
  end

  def parent_class
    @parent_class || Java::OrgJruby::RubyObject
  end
end
