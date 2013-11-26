source "http://rubygems.org"

gemspec :path => '..'

gem 'fastercsv', '>= 1.4.0', :platforms => [:ruby_18]
gem 'mime-types', '< 2.0.0', :platforms => [:ruby_18]
gem "activerecord", "~>3.0.0"
