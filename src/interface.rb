class Class

  def interface(*list)
    raise ArgumentError, "at least 1 interface needed" if list.empty?
    interfaces.push *list
    interfaces.uniq!
  end

  def interfaces
    @interfaces ||= []
  end
end
