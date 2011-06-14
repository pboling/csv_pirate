source :rubygems

#FasterCSV became the built-in CSV library in Ruby 1.9, so is only required if using Ruby 1.8
if RUBY_VERSION =~ /^1\.8\.\d{1}$/
  gem 'fastercsv', '~> 1.5'
end

group :development do
  gem 'rspec', '~> 2.6'
  gem "shoulda", ">= 0"
  gem "bundler", "~> 1.0.0"
  gem "jeweler", "~> 1.6.2"
  gem "rcov", ">= 0"
end
