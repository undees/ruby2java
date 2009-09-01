class Class

  def package(package_name)
    STDERR.puts <<HERE if @package_name
Warning: package already defined as #{package_name};\
 ignoring redefinition
HERE

    @package_name ||= package_name
  end

  attr_reader :package_name
end
