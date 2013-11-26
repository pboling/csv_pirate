# For code coverage, must be required before all application / gem / library code.
unless ENV['NOCOVER']
  require 'coveralls'
  Coveralls.wear!
end

require 'csv_pirate'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
#Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}
# The above does not require the files in the right order on travis-ci, so:
require 'support/glowing_gas_ball'
require 'support/star'

# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  #config.filter_run :focus

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = 'random'

end

