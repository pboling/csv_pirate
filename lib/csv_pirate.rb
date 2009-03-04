# CsvPirate
#Copyright ©2009 Peter H. Boling of 9thBit LLC, released under the MIT license
#Gem / Plugin for Rails / Active Record: Easily make CSVs of anything that can be derived from your models
#Language: Ruby (written by a pirate)
#License:  MIT License
#Labels:   Ruby, Rails, Gem, Plugin
#Version:  1.0
#Project owners:
#    peter.boling (The Cap'n)
require 'fastercsv'

class CsvPirate

  attr_accessor :waggoner         #filename
  attr_accessor :chart            #directory
  attr_accessor :aft              #extension
  attr_accessor :chronometer

  # Must provide swag or grub (not both)
  attr_accessor :swag             # ARrr array of objects
  attr_accessor :grub             # ARrr class
  # spyglasses is only used with grub, not swag
  attr_accessor :spyglasses       # named_scopes
  
  # These are the booty of the CSV
  # Should be methods/columns on the swag
  # also used to create the figurehead (CSV header)
  attr_accessor :booty            # methods
  
  # The array that gets built as we write the CSV... could be useful?
  attr_accessor :buried_treasure  # info array
  
  attr_accessor :rhumb_lines      # the file object to write the CSV lines to
  
  attr_accessor :astrolabe        # when true then read only CsvPirate instance for loading of CSVs
  
  # CsvPirate only works for commissions of swag OR grub!
  # swag:         the ARrr collection of swag to work on (optional)
  # grub:         the ARrr class that the spyglasses will be used on (optional)
  # spyglasses:   named scopes in your model that will refine the rows in the CSV according to conditions of the spyglasses,
  #                 and order them according to the order of the spyglasses (optional)
  # booty:        booty on your model that you want printed in the CSV
  # chart:        name of directory where you want to hide your loot
  # wagonner:     name of document where you will give detailed descriptions of the loot
  # chronometer:  keeps track of when you hunt for treasure
  # See README for examples
  
  def initialize(*args)
    return if args.empty?

    self.chart = args.first[:chart] || 'log/'
    self.aft = args.first[:aft] || '.csv'
    self.chronometer = args.first[:chronometer] || Date.today
    self.waggoner = args.first[:waggoner]

    self.swag = args.first[:swag]
    self.grub = args.first[:grub]

    self.spyglasses = (args.first[:spyglasses] || []) if self.grub

    self.booty = args.first[:booty] || []

    self.astrolabe = args.first[:astrolabe] || false

    self.buried_treasure = []

    # Initialize doesn't write anything to a CSV, 
    #   but does create the traverse_board and opens the waggoner for writing
    Dir.mkdir(self.traverse_board) if !self.astrolabe && Dir.glob(self.traverse_board).empty?
    self.rhumb_lines = File.open(File.expand_path(self.poop_deck),self.astrolabe ? "r" : "a")
  end

  ########################################
  ########### INSTANCE METHODS ###########
  ########################################

  # This is the hardest working method.  Get your shovels!
  def dig_for_treasure(&block)
    return false unless block_given?
  
    if !grub.nil?
      self.swag = grub
      spyglasses.each {|x| self.swag = self.swag.send(x) }
    end
  
    treasure_chest = self.swag.map do |spoils| 
      self.prize(spoils)
    end
  
    treasure_chest.each do |loot|
      yield loot
    end
  end
  
  def prize(spoils)
    gold_doubloons = []
    self.booty.each do |plunder|
      gold_doubloons << spoils.send(plunder.to_sym)
    end
    gold_doubloons
  end
  
  def scrivener(msg)
    self.rhumb_lines.puts msg
  end
  
  # Sail through your db looking for buried treasure! 
  # - restricted to loot that can be seen through spyglasses (if provided)!
  def hoist_mainstay
    # check essential args
    return "Pirate needs a waggoner to write on!" if self.waggoner.blank?
    return "Pirate needs some swag or grub!" if self.swag.blank? && self.grub.blank?
    return "Pirate needs some booty!" if self.booty.blank?

    self.figurehead
  
    self.buried_treasure = self.dig_for_treasure do |treasure|
      self.scrivener(treasure.map {|x| "#{x}"}.to_csv) # |x| marks the spot!
    end

    self.rhumb_lines.close

    self.jolly_roger

    # returns the array that is created before exporting it to CSV
    return self.buried_treasure
  end

  def jolly_roger
    if self.buried_treasure.is_a?(Array)
      puts "Found #{self.buried_treasure.length} deniers buried here: '#{self.poop_deck}'"
      puts "You must weigh_anchor to review your plunder!"
    else
      puts "Failed to locate treasure"
    end
  end

  # write the header of the CSV (column names)
  def figurehead
    self.scrivener(self.booty.to_csv)
  end
  
  def traverse_board
    "#{RAILS_ROOT}/#{self.chart}"
  end
  
  def sand_glass
    "#{self.chronometer.respond_to?(:strftime) ? '_' + self.chronometer.strftime("%Y_%m_%d") : ''}"
  end
  
  #complete file path
  def poop_deck
    "#{self.traverse_board}#{self.waggoner}#{self.sand_glass}" +  self.aft
  end

  # Must be done on order to rummage through the loot found by the pirate ship
  def weigh_anchor
    CsvPirate.swab(self.poop_deck)
  end

  # Sink your own ship! Or run a block of code on each row of the current CSV
  def scuttle(&block)
    return false unless block_given?
    CsvPirate.broadside(self.poop_deck, true) do |careen|
      yield careen
    end
  end

  ########################################
  ############ CLASS METHODS #############
  ########################################

  # Used to read any loot found by any pirate
  def self.swab(quarterdeck)
    File.open(File.expand_path(quarterdeck), "r") do |swabbie|
      swabbie.each_line do |swab|
        puts swab
      end
    end
  end

  # Sink other ships! Or run a block of code on each row of a CSV
  def self.broadside(galley, report_kills = true, &block)
    return false unless block_given?
    count = 1 if report_kills
    FasterCSV.foreach(galley, {:headers => :first_row, :return_headers => false}) do |gun|
      yield gun
      puts "Galleys sunk: #{(count+=1).to_s}" if report_kills
    end
  end

  # During a mutiny things are a little different!
  # Essentially you are using an existing CSV to drive queries to create a second CSV cased on the first
  # The capn hash is:
  #   :grub       => is the class on which to make booty [method] calls
  #   :swag       => column index in CSV (0th, 1st, 2nd, etc. column?)
  #                  (swag OR spyglasses can be specified, but code defers to swag if provided)
  #   :spyglasses => is the column to load ("find_by_#{booty}") the ARrr object for each row on the first CSV
  #                  (swag OR spyglasses can be specified, but code defers to swag if provided)
  #   :waggoner   => where the capn's loot was stashed (filename)
  #   :chart      => directory where capn's waggoner is located
  #   :astrolabe  => true (file is opened at top of file in read only mode when true)
  # The first_mate hash is:
  #   :grub       => is the class on which to make booty [method] calls, or 
  #                    is a method (as a string) we call to get from the object loaded by capn,
  #                    to the object on which we'll make the first_mate booty [method] calls, or nil, if same object
  #   :swag       => is the method to call on first CSV row's object to find second CSV row's object (if grub is a class)
  #   :spyglasses => is the column to load ("find_by_#{booty}") the ARrr object for each row on the second CSV (if grub is a class)
  #   :booty      => is the methods to call on the ARrr object for each row on the second CSV
  #   :waggoner   => where to stash the first mate's loot (filename)
  #   :chart      => directory where first mate's waggoner is located
  #   :astrolabe  => false (false is the default for astrolabe, so we could leave it off the first_mate)
  #
  # Example:
#   capn      = {:grub => User,:spyglasses => [:inactive],:booty => ['id','login','status'],:waggoner => 'orig',:chart => 'log/csv/',:astrolabe => false}
#   make_orig = CsvPirate.new(capn)
#   make_orig.hoist_mainstay
#   make_orig.weigh_anchor
#
#   first_mate = {:grub => 'account',:booty => ["id","number","name","created_at"],:waggoner => 'fake',:chart => 'log/csv/'}
#  OR
#   # for same class, we re-use the object loaded from first CSV and make the booty [method] calls on it
#   first_mate = {:grub => User,:booty => ["id","login","visits_count"],:waggoner => 'fake',:chart => 'log/csv/'}
#  OR
#   first_mate = {:grub => Account,:spyglasses => 'id',:swag=>'user_id',:booty => ["id","name","number"],:waggoner => 'fake',:chart => 'log/csv/'}
#  AND
#   capn       = {:grub => User,:spyglasses => 'login',:swag => 1,:waggoner => 'orig',:chart => 'log/csv/',:astrolabe => true}
#   after_mutiny = CsvPirate.mutiny(capn, first_mate)
#
  def self.mutiny(capn, first_mate)
    carrack = CsvPirate.new(capn)
    cutthroat = CsvPirate.new(first_mate)
    
    cutthroat.figurehead

    carrack.scuttle do |cutlass|
      puts "CUTLASS: #{cutlass.inspect}"
      puts "CARRACK.SWAG: #{carrack.swag.inspect}"
      backstaff = cutlass[carrack.swag] || cutlass["#{carrack.spyglasses}"]
      puts "BACKSTAFF: #{backstaff}"
      puts "CARRACK.SPYGLASSES: #{carrack.spyglasses.inspect}"
      gully = carrack.grub.send("find_by_#{carrack.spyglasses}".to_sym, backstaff)
      puts "GULLY: #{gully.inspect}"
      if gully
        flotsam = cutthroat.grub.is_a?(String) ? 
          gully.send(cutthroat.grub.to_sym) : 
          cutthroat.grub.is_a?(Symbol) ? 
            gully.send(cutthroat.grub) : 
            cutthroat.grub.class == carrack.grub.class ?
              gully :
              cutthroat.grub.class == Class ? 
                cutthroat.grub.send("find_by_#{cutthroat.swag}", gully.send(cutthroat.spyglasses)) : 
                nil
        puts "FLOTSAM: #{flotsam.inspect}"
        if flotsam
          plunder = cutthroat.prize(flotsam)
          cutthroat.buried_treasure << plunder
          cutthroat.scrivener(plunder.map {|bulkhead| "#{bulkhead}"}.join(','))
        else
          puts "Unable to locate: #{cutthroat.grub} related to #{carrack.grub}.#{carrack.spyglasses} '#{gully.send(carrack.spyglasses)}'"
        end
      else
        puts "Unable to locate: #{carrack.grub}.#{carrack.spyglasses} '#{gully.send(carrack.spyglasses)}'"
      end
    end
    
    carrack.rhumb_lines.close
    cutthroat.rhumb_lines.close

    cutthroat.jolly_roger

    # returns the array that is created before exporting it to CSV
    return cutthroat
  end

end
