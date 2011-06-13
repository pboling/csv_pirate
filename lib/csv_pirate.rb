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

require 'csv_pirate/version.rb'
require 'csv_pirate/the_capn.rb'
require 'csv_pirate/pirate_ship.rb'

module CsvPirate
  
end
