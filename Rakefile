require 'bundler'
Bundler::GemHelper.install_tasks

require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "csv_pirate"
    gemspec.summary = "Easily create CSVs of any data that can be derived from instance methods on your classes."
    gemspec.description = %q{CsvPirate is the easy way to create a CSV of essentially anything in Ruby, in full pirate regalia.
It works better if you are wearing a tricorne!}
    gemspec.email = "peter.boling@gmail.com"
    gemspec.homepage = "http://github.com/pboling/csv_pirate"
    gemspec.authors = ["Peter Boling"]
    gemspec.files = ["README.rdoc",
             "csv_pirate.gemspec",
             "init.rb",
             "rails/init.rb",
             "install.rb",
             "lib/csv_pirate.rb",
             "lib/ninth_bit/pirate_ship.rb",
             "spec/csv_pirate_spec.rb",
             "spec/pirate_ship_spec.rb",
             "spec/spec.opts",
             "spec/spec_helper.rb",
             "spec/spec_helpers/glowing_gas_ball.rb",
             "spec/spec_helpers/star.rb",
             "Rakefile",
             "LICENSE",
             "CHANGELOG",
             "VERSION.yml"]
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = 'csv_pirate'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

# require 'spec/rake/spectask'
# Spec::Rake::SpecTask.new(:spec) do |t|
#   t.libs << 'lib' << 'spec'
#   t.spec_files = FileList['spec/**/*_spec.rb']
# end
#
# Spec::Rake::SpecTask.new(:rcov) do |t|
#   t.libs << 'lib' << 'spec'
#   t.spec_files = FileList['spec/**/*_spec.rb']
#   t.rcov = true
# end
#
#begin
#  require 'cucumber/rake/task'
#  Cucumber::Rake::Task.new(:features)
#rescue LoadError
#  puts "Cucumber is not available. In order to run features, you must: sudo gem install cucumber"
#end

task :default => :spec
