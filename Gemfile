source :rubygems

gemspec

#FasterCSV became the built-in CSV library in Ruby 1.9, so is only required if using Ruby 1.8
if RUBY_VERSION =~ /^1\.8\.\d{1}$/
  gem 'fastercsv', '~> 1.5'
end

group :test do
  gem 'rspec', '~> 2.6'
end
