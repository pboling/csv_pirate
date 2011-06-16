# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
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
             "install.rb",
             "uninstall.rb",
             "lib/csv_pirate.rb",
             "lib/csv_pirate/pirate_ship.rb",
             "lib/csv_pirate/the_capn.rb",
             "lib/csv_pirate/version.rb",
             "spec/csv_pirate_spec.rb",
             "spec/pirate_ship_spec.rb",
             "spec/the_capn_spec.rb",
             "spec/spec.opts",
             "spec/spec_helper.rb",
             "spec/spec_helpers/glowing_gas_ball.rb",
             "spec/spec_helpers/star.rb",
             "Rakefile",
             "Gemfile",
             "init.rb",
             "LICENSE.txt",
             "CHANGELOG.txt",
             "VERSION.yml"]
  end
  Jeweler::RubygemsDotOrgTasks.new
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install jeweler"
end

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "csv_pirate2 #{version}"
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
