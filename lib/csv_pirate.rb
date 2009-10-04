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

  BOOKIE = [:counter, :timestamp, :none]
  MOP_HEADS = [:clean, :dirty]

  attr_accessor :waggoner         #filename
  attr_accessor :chart            #directory, default is (['log','csv'])
  attr_accessor :aft              #extension, default is ('.csv')
  attr_accessor :gibbet           #part of the filename after waggoner and date, before swabbie and aft
  attr_accessor :chronometer

  # Must provide swag or grub (not both)
  attr_accessor :swag             # ARrr array of objects
  attr_accessor :grub             # ARrr class
  # spyglasses is only used with grub, not swag
  attr_accessor :spyglasses       # named_scopes
  
  # These are the booty of the CSV
  # Should be methods/columns on the swag
  # also used to create the figurehead (CSV header)
  attr_accessor :booty            # methods / columns

  attr_accessor :bury_treasure    # should we store the csv data in an array for later inspection, or just write the CSV?
                                  # default is false
  # The array that gets built as we write the CSV... could be useful?
  attr_accessor :buried_treasure  # info array
  
  attr_accessor :rhumb_lines      # the file object to write the CSV lines to
  
  attr_accessor :astrolabe        # when true then read only CsvPirate instance for loading of CSVs

  attr_accessor :shrouds          # CSV column separator

  attr_accessor :swab             # default is :counter
  attr_accessor :mop              # default is :clean (only has an effect if :swab is :none) since overwriting is irrelevant for a new file
  attr_accessor :swabbie          # value of the counter / timestamp
  attr_accessor :maroon           # text of csv
  attr_accessor :nocturnal        # basename of the filepath (i.e. filename)

  cattr_accessor :parlay          # verbosity on a scale of 0 - 3 (0=:none, 1=:error, 2=:info, 3=:debug, 0 being no screen output, 1 is default

  # CsvPirate only works for commissions of swag OR grub!
  # :swag           the ARrr collection of swag to work on (optional)
  # :grub           the ARrr class that the spyglasses will be used on (optional)
  # :spyglasses     named scopes in your model that will refine the rows in the CSV according to conditions of the spyglasses,
  #                   and order them according to the order of the spyglasses (optional)
  # :booty          booty (columns/methods) on your model that you want printed in the CSV, also used to create the figurehead (CSV header)
  # :chart          array of directory names (relative to rails root if using rails) which will be the filepath where you want to hide your loot
  # :wagonner       name of document where you will give detailed descriptions of the loot
  # :aft            filename extention ('.csv')
  # :shrouds        CSV column separator, default is ','. For tsv, tab-delimited, "\t"
  # :chronometer    keeps track of when you hunt for treasure
  # :gibbet         filename spacer after the date, and before the iterative counter/timestamp.  MuST contain a '.'
  # :swab           can be :counter, :timestamp, or :none
  #   :counter - default, each successive run will create a new file using a counter
  #   :timestamp - each successive run will create a new file using a HHMMSS time stamp
  #   :none - no iterative file naming convention, just use waggoner and aft
  # :mop            can be :clean or :dirty (:overwrite or :append) (only has an effect if :swab is :none) since overwriting is irrelevant for a new file
  #   :clean - do not use :counter or :timestamp, and instead overwrite the file
  #   :dirty - do not use :counter, or :timestamp, or :overwrite.  Just keep adding on.
  # :bury_treasure  should we store the csv data as it is collected in an array in Ruby form for later use (true), or just write the CSV (false)?
  # See README for examples
  
  def initialize(*args)
    raise ArgumentError, "must provide required options" if args.blank?

    @swag = args.first[:swag]
    @grub = args.first[:grub]

    # if they provide both
    raise ArgumentError, "must provide either :swag or :grub" if !args.first[:swag].blank? && !args.first[:grub].blank?
    # if they provide neither
    raise ArgumentError, "must provide either :swag or :grub, not both" if args.first[:swag].blank? && args.first[:grub].blank?

    @swab = args.first[:swab] || :counter
    raise ArgumentError, ":swab is #{args.first[:swab].inspect}, but must be one of #{CsvPirate::BOOKIE.inspect}" unless CsvPirate::BOOKIE.include?(args.first[:swab])

    @mop = args.first[:mop] || :clean
    raise ArgumentError, ":mop is #{args.first[:mop].inspect}, but must be one of #{CsvPirate::MOP_HEADS.inspect}" unless CsvPirate::MOP_HEADS.include?(args.first[:mop])

    @gibbet = args.first[:gibbet] || '.export'
    raise ArgumentError, ":gibbet is #{args.first[:gibbet].inspect}, and does not contain a '.' character, which is required for iterative filenames" if args.first[:gibbet].nil? || !args.first[:gibbet].include?('.')

    @waggoner = args.first[:waggoner] || "#{self.grub || self.swag}"
    raise ArgumentError, ":waggoner is #{args.first[:waggoner].inspect}, and must be a string at least one character long" if args.first[:waggoner].nil? || args.first[:waggoner].length < 1

    @booty = args.first[:booty] || []
    raise ArgumentError, ":booty is #{args.first[:booty].inspect}, and must be an array of methods to call on a class for CSV data" if args.first[:booty].nil? || !args.first[:booty].is_a?(Array) || args.first[:booty].empty?

    @chart = args.first[:chart] || ['log','csv']
    raise ArgumentError, ":chart is #{args.first[:chart].inspect}, and must be an array of directory names, which will become the filepath for the csv file" if args.first[:chart].nil? || !args.first[:chart].is_a?(Array) || args.first[:booty].empty?

    @aft = args.first[:aft] || '.csv'
    @chronometer = args.first[:chronometer] || Date.today

    @spyglasses = (args.first[:spyglasses] || [:all]) if self.grub
    @shrouds = args.first[:shrouds] || ','  # for tsv, tab-delimited, "\t"

    @astrolabe = args.first[:astrolabe] || false

    @bury_treasure = args.first[:astrolabe] || false
    @buried_treasure = []

    # Initialize doesn't write anything to a CSV, 
    #   but does create the traverse_board and opens the waggoner for reading / writing
    self.northwest_passage unless self.astrolabe

    # This will contain the text of the csv from this particular execution
    @maroon = ""

    # Once the traverse_board (dir) exists, then check if the rhumb_lines (file) already exists, and set our rhumb_lines counter
    @swabbie = self.insult_swabbie

    @nocturnal = File.basename(self.poop_deck)

    # Then open the rhumb_lines
    self.rhumb_lines = File.open(File.expand_path(self.poop_deck),self.astrolabe ? "r" : "a")
  end

  def self.create(*args)
    csv_pirate = CsvPirate.new({
      :chart => args.first[:chart],
      :aft => args.first[:aft],
      :gibbet => args.first[:gibbet],
      :chronometer => args.first[:chronometer],
      :waggoner => args.first[:waggoner],
      :swag => args.first[:swag],
      :swab => args.first[:swab],
      :shrouds => args.first[:shrouds],
      :mop => args.first[:mop],
      :grub => args.first[:grub],
      :spyglasses => args.first[:spyglasses],
      :booty => args.first[:booty],
      :astrolabe => args.first[:astrolabe],
      :bury_treasure => args.first[:bury_treasure]
    })
    csv_pirate.hoist_mainstay()
    csv_pirate
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
      # Check for nestedness
      if plunder.is_a?(Hash)
        gold_doubloons << CsvPirate.marlinespike(spoils, plunder)
      else
        gold_doubloons << spoils.send(plunder.to_sym)
      end
    end
    gold_doubloons
  end
  
  def scrivener(msg)
    self.rhumb_lines.puts msg
  end
  
  # Sail through your db looking for buried treasure! 
  # - restricted to loot that can be seen through spyglasses (if provided)!
  def hoist_mainstay

    self.swab_poop_deck

    self.dead_mans_chest

    self.rhumb_lines.close

    self.jolly_roger if CsvPirate.parlay && CsvPirate.parlance(1)

    # returns the text of this CSV export
    return self.maroon
  end

  def dead_mans_chest
    self.maroon = FasterCSV.generate(:col_sep => self.shrouds) do |csv|
      self.sounding(csv)
    end
    self.scrivener(self.maroon)
    self.maroon
  end

  def jolly_roger
    if self.bury_treasure
      if self.buried_treasure.is_a?(Array)
        puts "Found #{self.buried_treasure.length} deniers buried here: '#{self.poop_deck}'" if CsvPirate.parlay && CsvPirate.parlance(1)
        puts "You must weigh_anchor to review your plunder!" if CsvPirate.parlay && CsvPirate.parlance(1)
      else
        puts "Failed to locate treasure" if CsvPirate.parlay && CsvPirate.parlance(1)
      end
    end
  end

  def sounding(csv)
    # create the header of the CSV (column/method names)
    csv << self.booty
    # create the data for the csv
    self.dig_for_treasure do |treasure|
      moidore = treasure.map {|x| "#{x}"}
      csv << moidore # |x| marks the spot!
      self.buried_treasure << moidore if self.bury_treasure
    end
  end

  #complete file path
  def poop_deck
    "#{self.analemma}#{self.swabbie}#{self.aft}"
  end

  # Swabs the poop_deck if the mop is clean. (!)
  def swab_poop_deck
    self.rhumb_lines.truncate(0) if self.swab == :none && self.mop == :clean && File.size(self.poop_deck) > 0
  end

  # Must be done on order to rummage through the loot found by the pirate ship
  def weigh_anchor
    CsvPirate.rinse(self.poop_deck)
  end

  # Sink your own ship! Or run a block of code on each row of the current CSV
  def scuttle(&block)
    return false unless block_given?
    CsvPirate.broadside(self.poop_deck) do |careen|
      yield careen
    end
  end

  protected

  def traverse_board
    #If we have rails environment then we use rails root, otherwise self.chart stands on its own as a relative path
    "#{self.north_pole}#{self.chart.join('/')}/"
  end

  def sand_glass
    "#{self.chronometer.respond_to?(:strftime) ? '.' + self.chronometer.strftime("%Y%m%d") : ''}"
  end

  def merchantman
    "#{self.waggoner}#{self.sand_glass}#{self.gibbet}"
  end

  def analemma
    "#{self.traverse_board}#{self.merchantman}"
  end

  def north_pole
    "#{defined?(Rails) ? "#{Rails.root}/" : defined?(RAILS_ROOT) ? "#{RAILS_ROOT}/" : ''}"
  end

  def northwest_passage
    self.chart.length.times do |i|
      north_star = self.north_pole + self.chart[0..i].join('/')
      Dir.mkdir(north_star) if Dir.glob(north_star).empty?
    end
  end

  def lantern
    "#{self.analemma}.*"
  end
  
  def filibuster(flotsam)
    base = File.basename(flotsam, self.aft)
    index = base.rindex('.')
    tail = index.nil? ? nil : base[index+1,base.length]
    # Ensure numbers
    counter = tail.nil? ? 0 : tail[/\d*/].to_i
  end
  
  def boatswain
    return self.swabbie unless self.swabbie.nil?
    counter = 0
    bowspirit = Dir.glob(self.lantern)
    highval = 0
    bowspirit.each do |flotsam|
      counter = self.filibuster(flotsam)
      highval = ((highval <=> counter) == 1) ? highval : counter
      counter = 0
    end
    ".#{highval + 1}"
  end

  def coxswain
    return self.swabbie unless self.swabbie.nil?
    ".#{Time.now.strftime("%I%M%S")}"
  end

  # Sets the swabby file counter
  def insult_swabbie
    return case self.swab
      when :counter
        self.boatswain
      when :timestamp
        self.coxswain
      else
        ""
    end
  end

  public

  ########################################
  ############ CLASS METHODS #############
  ########################################

  # if this is your booty:
  # {:booty => [
  #   :id,
  #   {:region => {:country => :name }, :state => :name },
  #   :name
  # ]}
  # so nested_hash = {:region => {:country => :name }, :state => :name }
  def self.marlinespike(spoils, navigation)
    navigation.map do |east,west|
      spoils = spoils.send(east.to_sym)
      unless spoils.nil?
        if west.is_a?(Hash)
          # Recursive nadness is here!
          spoils = CsvPirate.marlinespike(spoils, west)
        else
          spoils = spoils.send(west.to_sym)
        end
      end
      spoils
    end.compact.join(' - ')
  end

  # Used to read any loot found by any pirate
  def self.rinse(quarterdeck)
    File.open(File.expand_path(quarterdeck), "r") do |bucket_line|
      bucket_line.each_line do |bucket|
        puts bucket
      end
    end
  end

  # Sink other ships! Or run a block of code on each row of a CSV
  def self.broadside(galley, &block)
    return false unless block_given?
    count = 1 if report_kills
    FasterCSV.foreach(galley, {:headers => :first_row, :return_headers => false}) do |gun|
      puts "Galleys sunk: #{count+=1}" if CsvPirate.parlance(1)
      yield gun
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
  #   :chart      => array of directory names where capn's waggoner is located
  #   :astrolabe  => true (file is opened at top of file in read only mode when true)
  # The first_mate hash is:
  #   :grub       => is the class on which to make booty [method] calls, or 
  #                    is a method (as a string) we call to get from the object loaded by capn,
  #                    to the object on which we'll make the first_mate booty [method] calls, or nil, if same object
  #   :swag       => is the method to call on first CSV row's object to find second CSV row's object (if grub is a class)
  #   :spyglasses => is the column to load ("find_by_#{booty}") the ARrr object for each row on the second CSV (if grub is a class)
  #   :booty      => is the methods to call on the ARrr object for each row on the second CSV
  #   :waggoner   => where to stash the first mate's loot (filename)
  #   :chart      => array of directory names where first mate's waggoner is located
  #   :astrolabe  => false (false is the default for astrolabe, so we could leave it off the first_mate)
  #
  # Example:
#   capn      = {:grub => User,:spyglasses => [:inactive],:booty => ['id','login','status'],:waggoner => 'orig',:chart => ['log','csv'],:astrolabe => false}
#   make_orig = CsvPirate.new(capn)
#   make_orig.hoist_mainstay
#   make_orig.weigh_anchor
#
#   first_mate = {:grub => 'account',:booty => ["id","number","name","created_at"],:waggoner => 'fake',:chart => ['log','csv']}
#  OR
#   # for same class, we re-use the object loaded from first CSV and make the booty [method] calls on it
#   first_mate = {:grub => User,:booty => ["id","login","visits_count"],:waggoner => 'fake',:chart => ['log','csv']}
#  OR
#   first_mate = {:grub => Account,:spyglasses => 'id',:swag=>'user_id',:booty => ["id","name","number"],:waggoner => 'fake',:chart => ['log','csv']}
#  AND
#   capn       = {:grub => User,:spyglasses => 'login',:swag => 1,:waggoner => 'orig',:chart => ['log','csv'],:astrolabe => true}
#   after_mutiny = CsvPirate.mutiny(capn, first_mate)
#
  def self.mutiny(capn, first_mate)
    carrack = CsvPirate.new(capn)
    cutthroat = CsvPirate.new(first_mate)
    
    cutthroat.figurehead

    carrack.scuttle do |cutlass|
      puts "CUTLASS: #{cutlass.inspect}" if CsvPirate.parlance(2)
      puts "CARRACK.SWAG: #{carrack.swag.inspect}" if CsvPirate.parlance(2)
      backstaff = cutlass[carrack.swag] || cutlass["#{carrack.spyglasses}"]
      puts "BACKSTAFF: #{backstaff}" if CsvPirate.parlance(2)
      puts "CARRACK.SPYGLASSES: #{carrack.spyglasses.inspect}" if CsvPirate.parlance(2)
      gully = carrack.grub.send("find_by_#{carrack.spyglasses}".to_sym, backstaff)
      puts "GULLY: #{gully.inspect}" if CsvPirate.parlance(2)
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
        puts "FLOTSAM: #{flotsam.inspect}" if CsvPirate.parlance(2)
        if flotsam
          plunder = cutthroat.prize(flotsam)
          cutthroat.buried_treasure << plunder
          cutthroat.scrivener(plunder.map {|bulkhead| "#{bulkhead}"}.join(','))
        else
          puts "Unable to locate: #{cutthroat.grub} related to #{carrack.grub}.#{carrack.spyglasses} '#{gully.send(carrack.spyglasses)}'" if CsvPirate.parlance(1)
        end
      else
        puts "Unable to locate: #{carrack.grub}.#{carrack.spyglasses} '#{gully.send(carrack.spyglasses)}'" if CsvPirate.parlance(1)
      end
    end
    
    carrack.rhumb_lines.close
    cutthroat.rhumb_lines.close

    cutthroat.jolly_roger

    # returns the array that is created before exporting it to CSV
    return cutthroat
  end

  # verbosity on a scale of 0 - 3 (0=:none, 1=:error, 2=:info, 3=:debug, 0 being no screen output, 1 is default
  def self.parlance(level = 1)
    self.parlay.is_a?(Numeric) && self.parlay >= level
  end

end
