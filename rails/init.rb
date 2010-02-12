#We might have rails...
if defined?(Rails) && !defined?(Rake) && defined?(config) && config.respond_to?(:gems)

  config.gem 'fastercsv', :lib => 'faster_csv', :version => '>=1.4.0'

  require 'csv_pirate'
  require 'ninth_bit/pirate_ship'

  config.to_prepare do
    # If you are using this on a vanilla Ruby class (no rails or active record) then extend your class like this:
    #  MyClass.send(:extend, NinthBit::PirateShip::ActMethods) if defined?(MyClass)
    # Alternatively you can do this inside your class definition:
    #   class MyClass
    #     extend NinthBit::PirateShip::ActMethods
    #   end
    # If you are using ActiveRecord then it is done for you :)
    ActiveRecord::Base.send(:extend, NinthBit::PirateShip::ActMethods) if defined?(ActiveRecord)
  end

#And we might not... (rake needs to come hear to load the gems properly)
else

  begin

    require 'rubygems'
    gem 'fastercsv', '>=1.4.0', :lib => 'faster_csv'
    require 'csv_pirate'
    require 'ninth_bit/pirate_ship'
    ActiveRecord::Base.send(:extend, NinthBit::PirateShip::ActMethods) if defined?(ActiveRecord)

  rescue Gem::LoadError
    puts "Install the fastercsv gem to enable CsvPirate"
  end

end

