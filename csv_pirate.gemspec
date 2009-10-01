# -*- encoding: utf-8 -*-
Gem::Specification.new do |s|
  s.name = 'csv_pirate'
  s.version = '2.0.0'

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ['Peter Boling']
  s.date = '2009-09-29'
  s.summary = %q{Easily create CSVs of any data that can be derived from your models.}
  s.description = %q{CsvPirate is the easy way to create a CSV of essentially anything in Rails, in full pirate regalia.
It works better if you are wearing a tricorne!}
  s.email = 'peter.boling@gmail.com'
  s.homepage = 'http://github.com/pboling/capistrano_mailer'
  s.require_paths = ["lib"]

  s.has_rdoc = true

  s.homepage = %q{http://github.com/pboling/csv_pirate}
  s.rdoc_options = ["--inline-source", "--charset=UTF-8"]
  s.require_paths = ["lib"]

  s.files = ["README.rdoc",
             "csv_pirate.gemspec",
             "init.rb",
             "rails/init.rb",
             "install.rb",
             "about.yml",
             "lib/csv_pirate.rb",
             "lib/ninth_bit/pirate_ship.rb",
             "Rakefile",
             "LICENSE",
             "CHANGELOG",
             "VERSION.yml"]

  s.test_files = []
  
end
