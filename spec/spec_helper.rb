#require 'spec'
require 'rspec/core'
require 'csv_pirate'

$LOAD_PATH.unshift(File.dirname(__FILE__))

RSpec.configure do |config|
  
end

# require all files inside spec_helpers
Dir[File.join(File.dirname(__FILE__), "spec_helpers/*.rb")].each { |file| require file }
