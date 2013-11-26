# CsvPirate
# Copyright ©2008-2013 Peter H. Boling of RailsBling.com, released under the MIT license
# Gem / Plugin for Rails / Active Record: Easily make CSVs of anything that can be derived from your models
# Language: Ruby (written by a pirate)
# License:  MIT License
# Labels:   Ruby, Rails, Gem, Plugin
# Project owners:
#    Peter Boling (The Cap'n)
require 'yaml'

if RUBY_VERSION.to_f >= 1.9
  require 'csv'
else
  require 'faster_csv'
end

require 'csv_pirate/version.rb'
require 'csv_pirate/the_capn.rb'
require 'csv_pirate/pirate_ship.rb'

module CsvPirate
  # If you are using this on a vanilla Ruby class (no rails or active record) then extend your class like this:
  #  MyClass.send(:extend, NinthBit::PirateShip::ActMethods) if defined?(MyClass)
  # Alternatively you can do this inside your class definition:
  #   class MyClass
  #     extend NinthBit::PirateShip::ActMethods
  #   end
  # If you are using ActiveRecord then it is done for you :)
  if defined?(Rails) && defined?(ActiveRecord)
    if defined?(Rails::Railtie)
      require 'csv_pirate/railtie'
    else
      ActiveRecord::Base.send(:extend, CsvPirate::PirateShip::ActMethods)
    end
  end

  # Support the old (< v5.0.0) API
  def self.new(*args)
    warn "[DEPRECATION] \"CsvPirate.new\" is deprecated.  Use \"CsvPirate::TheCapn.new\" instead.  Called from: #{caller.first}"
    CsvPirate::TheCapn.new(*args)
  end

  def self.create(*args)
    warn "[DEPRECATION] \"CsvPirate.create\" is deprecated.  Use \"CsvPirate::TheCapn.create\" instead.  Called from: #{caller.first}"
    CsvPirate::TheCapn.create(*args)
  end

end

# Support the old (< v5.0.0) API
module NinthBit
  module PirateShip
    module ActMethods
      include CsvPirate::PirateShip::ActMethods

      has_csv_pirate = ActMethods.instance_method(:has_csv_pirate_ship)

      define_method(:has_csv_pirate_ship) do |args|
        warn "[DEPRECATION] \"NinthBit::PirateShip::ActMethods\" module is deprecated.  Use \"include CsvPirate::PirateShip::ActMethods\" instead.  Called from: #{caller.first}"
        has_csv_pirate.bind(self).call(args)
      end

    end
  end
end
