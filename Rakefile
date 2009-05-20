#TODO Remove all unnecessary code.

require 'rake'
require 'rake/testtask'

MANIFEST = FileList['bin/*', 'History.txt', 'Manifest.txt', 'README.txt', 
  'Rakefile', 'LICENSE.txt', 'lib/**/*.rb', "examples/**/*.{java,rb}"]

task :default do
  puts 'We\'re coming!'
end

task :spec do
  require 'spec/rake/spectask'
  desc 'Runs Specs'
  
  Spec::Rake::SpecTask.new do |t|
    t.spec_opts ||= []
    t.spec_files =  if ENV['class'].nil?
                      FileList['spec/**_spec.rb']
                    else
                      File.join('spec', ENV['class']+'_spec.rb')
                    end
  end
end

file 'Manifest.txt' => :manifest
task :manifest do
  File.open('Manifest.txt', 'w') {|f| MANIFEST.each {|n| f << "#{n}\n"} }
end
Rake::Task['manifest'].invoke # Always regen manifest, so Hoe has up-to-date list of files

require File.dirname(__FILE__) + '/lib/ruby2java'
begin
  require 'hoe'
  Hoe.new('ruby2java', Ruby2Java::VERSION) do |p| # TODO: Final name: compiler2, ruby2java, r2j2?
    p.rubyforge_name =# TODO: Where in rubyforge?
    p.url = 'http://kenai.com/projects/ruby2java'
    p.developer 'Thomas E. Enebo', 'tom.enebo@gmail.com'
    p.developer 'Charles O. Nutter', 'charles.nutter@sun.com'
    p.developer 'Sergio Rodríguez Arbeo', 'serabe@gmail.com'
    p.summary = 'Tool for JRuby to turn Ruby code into Java classes'
    p.changes = p.paragraphs_of('History.txt', 0..1).join('\n\n')
    p.description = p.paragraphs_of('README.txt', 0...1).join('\n\n')
  end.spec.dependencies.delete_if { |dep| dep.name == 'hoe' }
rescue LoadError
  puts 'You really need Hoe installed to be able to package this gem'
rescue => e
  puts "ignoring error while loading hoe: #{e.to_s}"
end
