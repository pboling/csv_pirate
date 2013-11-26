# -*- encoding: utf-8 -*-
require File.expand_path('../lib/csv_pirate/version', __FILE__)

Gem::Specification.new do |s|
  s.name = %q{csv_pirate}
  s.version = CsvPirate::VERSION

  s.authors = ["Peter Boling"]
  s.description = %q{CsvPirate is the easy way to create a CSV of essentially anything in Ruby, in full pirate regalia.
It works better if you are wearing a tricorne!}
  s.email = %q{peter.boling@gmail.com}
  s.extra_rdoc_files = [
    "LICENSE",
    "README.md"
  ]
  s.files         = `git ls-files`.split($\)
  s.executables   = s.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.homepage = %q{http://github.com/pboling/csv_pirate}
  s.licenses = ["MIT"]
  s.platform = Gem::Platform::RUBY
  s.require_paths = ["lib"]
  s.summary = %q{Easily create CSVs of any data that can be derived from instance methods on your classes.}

  s.add_development_dependency(%q<rspec>, [">= 2.11.0"])
  s.add_development_dependency(%q<shoulda>, [">= 0"])
  s.add_development_dependency(%q<rdoc>, [">= 3.12"])
  s.add_development_dependency(%q<reek>, [">= 1.2.8"])
  s.add_development_dependency(%q<roodi>, [">= 2.1.0"])
  s.add_development_dependency(%q<rake>, [">= 0"])
  s.add_development_dependency "coveralls"

end
