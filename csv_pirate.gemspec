# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{csv_pirate}
  s.version = "0.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["pboling"]
  s.date = %q{2009-03-03}
  s.description = %q{Easily create CSVs of any data that can be derived from your models}
  s.email = %q{peter.boling@gmail.com}
  s.files = ["VERSION.yml", "lib/csv_pirate.rb", "spec/csv_pirate_spec.rb", "spec/spec_helper.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/pboling/csv_pirate}
  s.rdoc_options = ["--inline-source", "--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{How does a Pirate create CSVs?  With the waggoner, charts, spyglasses, chronometers, swag, and grub.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
