# CsvPirate
#Copyright ©2009 Peter H. Boling of 9thBit LLC, released under the MIT license
#Gem / Plugin for Rails / Active Record: Easily make CSVs of anything that can be derived from your models
#Language: Ruby (written by a pirate)
#License:  MIT License
#Labels:   Ruby, Rails, Gem, Plugin
#Version:  1.0
#Project owners:
#    peter.boling (The Cap'n)
require 'yaml'

if RUBY_VERSION.to_f >= 1.9
  require 'csv'
else
  require 'faster_csv'
end

module CsvPirate
  if defined?(Rails::Railtie)
    # namespace our plugin and inherit from Rails::Railtie
    # to get our plugin into the initialization process
    class Railtie < Rails::Railtie

      # configure our plugin on boot. other extension points such
      # as configuration, rake tasks, etc, are also available
      #initializer "csv_pirate.initialize" do |app|
      #end

      # Add a to_prepare block which is executed once in production
      # and before each request in development
      config.to_prepare do
        # If you are using this on a vanilla Ruby class (no rails or active record) then extend your class like this:
        #  MyClass.send(:extend, CsvPirate::PirateShip::ActMethods) if defined?(MyClass)
        # Alternatively you can do this inside your class definition:
        #   class MyClass
        #     extend CsvPirate::PirateShip::ActMethods
        #   end
        # If you are using ActiveRecord then it is done for you :)
        ActiveRecord::Base.send(:extend, CsvPirate::PirateShip::ActMethods) if defined?(ActiveRecord)
      end
    end
  end
end

require 'csv_pirate/version.rb'
require 'csv_pirate/the_capn.rb'
require 'csv_pirate/pirate_ship.rb'

# Support the old (< v5.0.0) API
module NinthBit
  module PirateShip
    module ActMethods
      include CsvPirate::PirateShip::ActMethods

      has_csv_pirate = ActMethods.instance_method(:has_csv_pirate_ship)

      define_method(:has_csv_pirate_ship) do |args|
        warn "[DEPRECATION] \"NinthBit::PirateShip::ActMethods\" module is deprecated.  Use \"include CsvPirate::PirateShip::ActMethods\" instead.  Called from: #{Kernel.caller.first}"
        has_csv_pirate.bind(self).call(args)
      end

    end
  end
end
