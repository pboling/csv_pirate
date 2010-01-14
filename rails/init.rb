begin
  require 'rubygems'
  gem     'fastercsv'
rescue LoadError
  "Unable to load dependencies: rubygems or fastercsv"
end

require 'faster_csv' unless defined?(FasterCSV)
require 'csv_pirate'
require 'ninth_bit/pirate_ship'

# If you are using this on a vanilla Ruby class (no rails or active record) then extend your class like this:
#  MyClass.send(:extend, NinthBit::PirateShip::ActMethods) if defined?(MyClass)
# Alternatively you can do this inside your class definition:
#   class MyClass
#     extend NinthBit::PirateShip::ActMethods
#   end
# If you are using ActiveRecord then it is done for you :)
ActiveRecord::Base.send(:extend, NinthBit::PirateShip::ActMethods) if defined?(ActiveRecord)
