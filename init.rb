#We might have rails (pre version 3)...
puts "init.rb is loading"
if defined?(ActiveRecord) && !defined?(Rake) && !defined?(Rails::Railtie) && defined?(config) && config.respond_to?(:gems)
  puts "init.rb has Rails config!"

  require 'csv_pirate'

  config.to_prepare do
    # If you are using this on a vanilla Ruby class (no rails or active record) then extend your class like this:
    #  MyClass.send(:extend, NinthBit::PirateShip::ActMethods) if defined?(MyClass)
    # Alternatively you can do this inside your class definition:
    #   class MyClass
    #     extend NinthBit::PirateShip::ActMethods
    #   end
    # If you are using ActiveRecord then it is done for you :)
    ActiveRecord::Base.send(:extend, CsvPirate::PirateShip::ActMethods) if defined?(ActiveRecord)
  end

#And we might not... (rake needs to come hear to load the gems properly)
elsif defined?(ActiveRecord) && !defined?(Rails::Railtie)
  puts "init.rb probably in a rake task"

  require 'csv_pirate'
  ActiveRecord::Base.send(:extend, NinthBit::PirateShip::ActMethods) if defined?(ActiveRecord)

end
