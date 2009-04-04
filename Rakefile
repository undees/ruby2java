#TODO Remove all unnecessary code.

require 'rake'
require 'rake/testtask'

MANIFEST = FileList["History.txt", "Manifest.txt", "README.txt", 
  "Rakefile", "LICENSE.txt", "src/**/*.rb"]

task :default do
  puts 'We\'re coming!'
end

desc "Clean up any generated file."
task :clean do
  rm_rf 'pkg'
end

task :spec do
  require 'spec/rake/spectask'
  desc "Runs Specs (I hope we'll have some)"
  
  #Spec::Rake::SpecTask.new do |t|
  #  t.spec_opts ||= []
  #  t.spec_files =  if ENV['class'].nil?
  #                    FileList['test/spec/**']
  #                  else
  #                    File.join('test', 'spec', ENV['class']+'_spec.rb')
  #                  end
  #end
end

file "Manifest.txt" => :manifest
task :manifest do
  File.open("Manifest.txt", "w") {|f| MANIFEST.each {|n| f << "#{n}\n"} }
end
Rake::Task['manifest'].invoke # Always regen manifest, so Hoe has up-to-date list of files

require File.dirname(__FILE__) + "/src/version"
begin
  require 'hoe'
  Hoe.new("rmagick4j", RMagick4J::Version::VERSION) do |p|
    p.rubyforge_name =# TODO: Where in rubyforge
    p.url = "http://kenai.com/projects/ruby2java"
    p.author = "Thomas E. Enebo, Charles O. Nutter and Sergio Rodríguez Arbeo" # Ordered by last name.
    p.email = "serabe@gmail.com, tom.enebo@gmail.com" # TODO: Charles, add the address of your choice.
    p.summary = "Compiler for Ruby aiming JVM"
    p.changes = p.paragraphs_of('History.txt', 0..1).join("\n\n")
    p.description = p.paragraphs_of('README.txt', 0...1).join("\n\n")
  end.spec.dependencies.delete_if { |dep| dep.name == "hoe" }
rescue LoadError
  puts "You really need Hoe installed to be able to package this gem"
rescue => e
  puts "ignoring error while loading hoe: #{e.to_s}"
end

