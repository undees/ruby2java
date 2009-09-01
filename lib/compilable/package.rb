class Class

  def package(package_name)
    # Should we raise an exception?
    # Only first called is considered.

    @package_name ||= package_name
  end

  attr_reader :package_name
end
