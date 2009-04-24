class Class

  def package(*package_name)
    raise ArgumentError, 'too few arguments' if package_name.empty?
    # Should we raise an exception?
    # Only first called is considered.
    @package_name = package_name.join('.') unless @package_name
  end

  attr_reader :package_name
end
