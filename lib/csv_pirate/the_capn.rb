module CsvPirate
  class TheCapn

    BOOKIE = [:counter, :timestamp, :none]
    MOP_HEADS = [:clean, :dirty]
    BRIGANTINE_OPTIONS = [:first, :last]
    CSV_CLASS = (defined?(CSV) ? CSV : FasterCSV)

    attr_accessor :waggoner         # First part of filename
    attr_accessor :chart            # directory, default is (['log','csv'])
    attr_accessor :aft              # extension, default is ('.csv')
    attr_accessor :gibbet           # part of the filename after waggoner and date, before swabbie and aft
    attr_accessor :chronometer      # Date object or false

    # Must provide swag or grub (not both)
    attr_accessor :swag             # Array of objects
    attr_accessor :grub             # Class
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
    attr_accessor :blackjack        # Hash: Specify how you want your CSV header
                                    #   {:join => '-'}    joins the method names called to get hte data for that column with '_' underscores.
                                    #   {:humanize => '-'} first joins as above, then humanizes the string
                                    #   {:array => ['col1',col2','col3'] Uses the column names provided in the array.  If the array provided is too short defaults to :humanize =>'_'

    attr_accessor :brigantine       # the complete file path
    attr_accessor :pinnacle         # an array of strings for CSV header based on blackjack
    class << self
       attr_accessor :parlay        # verbosity on a scale of 0 - 3 (0=:none, 1=:error, 2=:info, 3=:debug, 0 being no screen output, 1 is default
     end

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
    # :chronometer    keeps track of when you hunt for treasure, can be false if you don't want to keep track.
    # :gibbet         filename spacer after the date, and before the iterative counter/timestamp.  MuST contain a '.'
    # :swab           can be :counter, :timestamp, or :none
    #   :counter - default, each successive run will create a new file using a counter
    #   :timestamp - each successive run will create a new file using a HHMMSS time stamp
    #   :none - no iterative file naming convention, just use waggoner, aft and gibbet
    # :mop            can be :clean or :dirty (:overwrite or :append) (only has an effect if :swab is :none) since overwriting is irrelevant for a new file
    #   :clean - do not use :counter or :timestamp, and instead overwrite the file
    #   :dirty - do not use :counter, or :timestamp, or :overwrite.  Just keep adding on.
    # :bury_treasure  should we store the csv data as it is collected in an array in Ruby form for later use (true), or just write the CSV (false)?
    # :blackjack      Specify how you want your CSV header
    #   {:join => '-'}    joins the method names called to get hte data for that column with '_' underscores.
    #   {:humanize =>'-'} first joins as above, then humanizes the string
    #   {:array => ['col1',col2','col3'] Uses the column names provided.  If the array provided is too short defaults to :humanize =>'_'
    # See README for examples

    def initialize(*args)
      raise ArgumentError, "must provide required options" if args.nil?

      @swag = args.first[:swag]
      @grub = args.first[:grub]

      # if they provide both
      raise ArgumentError, "must provide either :swag or :grub, not both" if !self.swag.nil? && !self.grub.nil?
      # if they provide neither
      raise ArgumentError, "must provide either :swag or :grub" if self.swag.nil? && self.grub.nil?

      @swab = args.first[:swab] || :counter
      raise ArgumentError, ":swab is #{self.swab.inspect}, but must be one of #{TheCapn::BOOKIE.inspect}" unless TheCapn::BOOKIE.include?(self.swab)

      @mop = args.first[:mop] || :clean
      raise ArgumentError, ":mop is #{self.mop.inspect}, but must be one of #{TheCapn::MOP_HEADS.inspect}" unless TheCapn::MOP_HEADS.include?(self.mop)

      @gibbet = args.first[:gibbet] || '.export'
      raise ArgumentError, ":gibbet is #{self.gibbet.inspect}, and does not contain a '.' character, which is required when using iterative filenames (set :swab => :none to turn off iterative filenames)" if self.swab != :none && (self.gibbet.nil? || !self.gibbet.include?('.'))

      @waggoner = args.first[:waggoner] || "#{self.grub || self.swag}"
      raise ArgumentError, ":waggoner is #{self.waggoner.inspect}, and must be a string at least one character long" if self.waggoner.nil? || self.waggoner.length < 1

      # Not checking if empty here because PirateShip will send [] if the database is unavailable, to allow tasks like rake db:create to run
      @booty = args.first[:booty] || [] # would like to use Class#instance_variables for generic classes
      raise ArgumentError, ":booty is #{self.booty.inspect}, and must be an array of methods to call on a class for CSV data" if self.booty.nil? || !self.booty.is_a?(Array)

      @chart = args.first[:chart] || ['log','csv']
      raise ArgumentError, ":chart is #{self.chart.inspect}, and must be an array of directory names, which will become the filepath for the csv file" if self.chart.nil? || !self.chart.is_a?(Array) || self.chart.empty?

      @aft = args.first[:aft] || '.csv'
      @chronometer = args.first[:chronometer] == false ? false : (args.first[:chronometer] || Date.today)

      @spyglasses = (args.first[:spyglasses] || (self.respond_to?(:all) ? [:all] : nil)) if self.grub

      @shrouds = args.first[:shrouds] || ','  # for tsv, tab-delimited, "\t"
      raise ArgumentError, ":shrouds is #{self.shrouds.inspect}, and must be a string (e.g. ',' or '\t'), which will be used as the delimeter for the csv file" if self.shrouds.nil? || !self.shrouds.is_a?(String)

      @astrolabe = args.first[:astrolabe] || false

      @bury_treasure = args.first[:bury_treasure] || false
      @buried_treasure = []

      #does not rely on rails humanize!
      @blackjack = args.first[:blackjack] || {:humanize => '_'}

      #Make sure the header array is the same length as the booty columns
      if self.blackjack.keys.first == :array && (self.blackjack.values.first.length != self.booty.length)
        @blackjack = {:join => '_'}
        puts "Warning: :blackjack reset to {:join => '_'} because the length of the :booty is different than the length of the array provided to :blackjack" if TheCapn.parlance(2)
      end

      @pinnacle = self.block_and_tackle

      # Initialize doesn't write anything to a CSV,
      #   but does create the traverse_board (file) and opens it for reading / writing
      self.northwest_passage unless self.astrolabe

      # This will contain the text of the csv from this particular execution
      @maroon = ""

      # Once the traverse_board (dir) exists, then check if the rhumb_lines (file) already exists, and set our rhumb_lines counter
      @swabbie = self.insult_swabbie

      @brigantine = self.poop_deck(args.first[:brigantine])

      @nocturnal = File.basename(self.brigantine)

      # Then open the rhumb_lines
      self.rhumb_lines = File.open(File.expand_path(self.brigantine),self.astrolabe ? "r" : "a")
    end

    def self.create(*args)
      csv_pirate = TheCapn.new({
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
        :blackjack => args.first[:blackjack],
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
          gold_doubloons << TheCapn.marlinespike(spoils, plunder)
        # BJM: if array, assume they are args to be sent along with the function
        elsif plunder.is_a?(Array)
          gold_doubloons << spoils.send(plunder[0].to_sym, *plunder[1..-1] )
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
    # Creates the CSV file and returns the text of the CSV
    # - restricted to loot that can be seen through spyglasses (if provided)!
    def hoist_mainstay

      self.swab_poop_deck

      self.dead_mans_chest

      self.rhumb_lines.close

      self.jolly_roger if TheCapn.parlay && TheCapn.parlance(1)

      # returns the text of this CSV export
      return self.maroon
    end

    def dead_mans_chest
      self.maroon = CSV_CLASS.generate(:col_sep => self.shrouds) do |csv|
        self.sounding(csv)
      end
      self.scrivener(self.maroon)
      self.maroon
    end

    def jolly_roger
      if self.bury_treasure
        if self.buried_treasure.is_a?(Array)
          puts "Found #{self.buried_treasure.length} deniers buried here: '#{self.brigantine}'" if TheCapn.parlay && TheCapn.parlance(1)
          puts "You must weigh_anchor to review your plunder!" if TheCapn.parlay && TheCapn.parlance(1)
        else
          puts "Failed to locate treasure" if TheCapn.parlay && TheCapn.parlance(1)
        end
      end
    end

    def sounding(csv)
      csv << self.block_and_tackle
      # create the data for the csv
      self.dig_for_treasure do |treasure|
        moidore = treasure.map {|x| "#{x}"}
        csv << moidore # |x| marks the spot!
        self.buried_treasure << moidore if self.bury_treasure
      end
    end

    #Takes a potentially nested hash element of a booty array and turns it into a string for a column header
    # hash = {:a => {:b => {:c => {:d => {"e" => "fghi"}}}}}
    # run_through(hash, '_')
    # => "a_b_c_d_e_fghi"
    # Ooooh so recursive!
    def run_through(hash, join_value)
      hash.map do |k,v|
        if v.is_a?(Hash)
          [k,run_through(v, join_value)].join(join_value)
        else #works for Symbols and Strings
          [k,v].join(join_value)
        end
      end.first
    end

    #complete file path
    def poop_deck(brig)
      if BRIGANTINE_OPTIONS.include?(brig) && !self.flies.empty?
        self.old_csv_dump(brig)
      elsif brig.is_a?(String)
        "#{self.analemma}#{brig}"
      else
        "#{self.analemma}#{self.swabbie}#{self.aft}"
      end
    end

    # Swabs the poop_deck (of the brigantine) if the mop is clean. (!)
    def swab_poop_deck
      self.rhumb_lines.truncate(0) if self.swab == :none && self.mop == :clean && File.size(self.brigantine) > 0
    end

    # Must be done on order to rummage through the loot found by the pirate ship
    def weigh_anchor
      TheCapn.rinse(self.brigantine)
    end

    # Sink your own ship! Or run a block of code on each row of the current CSV
    def scuttle(&block)
      return false unless block_given?
      TheCapn.broadside(self.brigantine) do |careen|
        yield careen
      end
    end

    #permanence can be any of:
    #   {:new => :new} - only calls the initializer with data hash for each row to instantiate objects (useful with any vanilla Ruby Class)
    #   {:new => :save} - calls the initializer with the data hash for each row and then calls save on each (useful with ActiveRecord)
    #   {:new => :create} - calls a create method with the data hash for each row (useful with ActiveRecord)
    #   {:find_or_new => [column names for find_by]} - see below (returns only the new objects
    #   {:find_or_save => [column names for find_by]} - see below (returns all found or saved objects)
    #   {:find_or_create => [column names for find_by]} - looks for existing objects using find_by_#{columns.join('_and_')}, (returns all found or created objects)
    #       and if not found creates a new object.
    #       The difference between the new, save and create versions are the same as the various :new hashes above.
    #   {:update_or_new => [column names for find_by]} - see below (returns only the new objects)
    #   {:update_or_save => [column names for find_by]} - see below (returns all updated or saved objects)
    #   {:update_or_create => [column names for find_by]} - looks for existing objects using find_by_#{columns.join('_and_')} , (returns all updated or created objects)
    #       and updates them with the data hash form the csv row, otherwise creates a new object.
    #TODO: This is a nasty method.  Just a quick hack to GTD.  Needs to be rethought and refactored. --pboling
    def to_memory(permanence = {:new => :new}, exclude_id = true, exclude_timestamps = true)
      return nil unless self.grub
      buccaneers = []
      self.scuttle do |row|
        data_hash = self.data_hash_from_row(row, exclude_id, exclude_timestamps)
        case permanence
          when {:new => :new} then
            buccaneers << self.grub.new(data_hash)
          when {:new => :save} then
            obj = self.grub.new(data_hash)
            buccaneers << obj.save(false)
          when {:new => :create} then
            buccaneers << self.grub.create(data_hash)
        else
          if permanence[:find_or_new]
            obj = self.send_aye(data_hash, permanence[:find_or_new])
            buccaneers << self.grub.new(data_hash) if obj.nil?
          elsif permanence[:find_or_save]
            obj = self.send_aye(data_hash, permanence[:find_or_save])
            if obj.nil?
              obj = self.grub.new(data_hash)
              obj.save(false) if obj.respond_to?(:save)
            end
            buccaneers << obj
          elsif permanence[:find_or_create]
            obj = self.send_aye(data_hash, permanence[:find_or_create])
            if obj.nil?
              self.grub.create(data_hash)
            end
            buccaneers << obj
          elsif permanence[:update_or_new]
            obj = self.send_aye(data_hash, permanence[:update_or_new])
            if obj.nil?
              obj = self.grub.new(data_hash)
            else
              self.save_object(obj, data_hash)
            end
            buccaneers << obj
          elsif permanence[:update_or_save]
            obj = self.send_aye(data_hash, permanence[:update_or_save])
            if obj.nil?
              obj = self.grub.new(data_hash)
              obj.save(false)
            else
              self.save_object(obj, data_hash)
            end
            buccaneers << obj
          elsif permanence[:update_or_create]
            obj = self.send_aye(data_hash, permanence[:update_or_create])
            if obj.nil?
              obj = self.grub.create(data_hash)
            else
              self.save_object(obj, data_hash)
            end
            buccaneers << obj
          end
        end
      end
      buccaneers
    end

    def save_object(obj, data_hash)
      data_hash.each do |k,v|
        obj.send("#{k}=".to_sym, v)
      end
      unless obj.save(false)
        puts "Save Failed: #{obj.inspect}" if TheCapn.parlance(1)
      end
    end

    def send_aye(data_hash, columns)
      obj = self.grub.send(self.find_aye(columns), self.find_aye_arr(data_hash, columns))
      if obj
        puts "#{self.grub}.#{find_aye(columns)}(#{self.find_aye_arr(data_hash, columns).inspect}): found id = #{obj.id}" if TheCapn.parlance(2)
      end
      obj
    end

    def find_aye(columns)
      "find_by_#{columns.join('_and_')}".to_sym
    end

    def find_aye_arr(data_hash, columns)
      columns.map do |col|
        data_hash[col.to_s]
      end
    end

    def data_hash_from_row(row, exclude_id = true, exclude_timestamps = true)
      plunder = {}
      method_check = self.grub.instance_methods - Object.methods
      method_check = method_check.select {|x| "#{x}" =~ /=$/}
      my_booty = self.booty.reject {|x| x.is_a?(Hash)}
      my_booty = exclude_id ? my_booty.reject {|x| a = x.to_sym; [:id, :ID,:dbid, :DBID, :db_id, :DB_ID].include?(a)} : self.booty
      my_booty = exclude_timestamps ? my_booty.reject {|x| a = x.to_sym; [:created_at, :updated_at, :created_on, :updated_on].include?(a)} : self.booty
      my_booty = my_booty.select {|x| method_check.include?("#{x}=".to_sym)} if method_check
      my_booty.each do |method|
        plunder = plunder.merge({method => row[self.pinnacle[self.booty.index(method)]]})
      end
      plunder
    end

    # Grab an old CSV dump (first or last)
    def old_csv_dump(brig)
      file = self.flies.send(brig)
      "#{self.traverse_board}#{file}"
    end

    def flies
      Dir.entries(self.traverse_board).select {|x| x.match(self.unfurl)}.sort
    end

    # Regex for matching dumped CSVs
    def unfurl
      wibbly = self.waggoner == '' ? '' : Regexp.escape(self.waggoner)
      timey = self.sand_glass == '' ? '' : '\.\d+'
      wimey = self.gibbet == '' ? '' : Regexp.escape(self.gibbet)
      Regexp.new("#{wibbly}#{timey}#{wimey}")
    end

    protected

    # create the header of the CSV (column/method names)
    # returns an array of strings for CSV header based on blackjack
    def block_and_tackle
      self.blackjack.map do |k,v|
        case k
          #Joining is only relevant when the booty contains a nested hash of method calls as at least one of the booty array elements
          #Use the booty (methods) as the column headers
          when :join then self.binnacle(v, false)
          #Use the humanized booty (methods) as the column headers
          when :humanize then self.binnacle(v, true)
          when :array then v
        end
      end.first
    end

    #returns an array of strings for CSV header based on booty
    def binnacle(join_value, humanize = true)
      self.booty.map do |compass|
        string = compass.is_a?(Hash) ?
          self.run_through(compass, join_value) :
          compass.is_a?(String) ?
            compass :
            compass.is_a?(Symbol) ?
              compass.to_s :
              compass.to_s
        humanize ? string.to_s.gsub(/_id$/, "").gsub(/_/, " ").capitalize : string
      end
    end

    # The directory path to the csv
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
      tail.nil? ? 0 : tail[/\d*/].to_i
    end

    # Get all the files in the dir
    def axe
      Dir.glob(self.lantern)
    end

    # File increment for next CSV to dump
    def boatswain
      return self.swabbie unless self.swabbie.nil?
      highval = 0
      self.axe.each do |flotsam|
        counter = self.filibuster(flotsam)
        highval = ((highval <=> counter) == 1) ? highval : counter
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
        # BJM:
        if east.is_a?(Array)
          spoils = spoils.send(east[0].to_sym, *east[1..-1] )
        else
          spoils = spoils.send(east.to_sym)
        end
        unless spoils.nil?
          if west.is_a?(Hash)
            # Recursive madness is here!
            spoils = TheCapn.marlinespike(spoils, west)
          elsif west.is_a?(Array)
            spoils << spoils.send(west[0].to_sym, *west[1..-1] )
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
      CSV_CLASS.foreach(galley, {:headers => :first_row, :return_headers => false}) do |gun|
        yield gun
      end
    end

    # !!!EXPERIMENTAL!!!
    #
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
      carrack = TheCapn.new(capn)
      cutthroat = TheCapn.new(first_mate)

      cutthroat.figurehead

      carrack.scuttle do |cutlass|
        puts "CUTLASS: #{cutlass.inspect}" if TheCapn.parlance(2)
        puts "CARRACK.SWAG: #{carrack.swag.inspect}" if TheCapn.parlance(2)
        backstaff = cutlass[carrack.swag] || cutlass["#{carrack.spyglasses}"]
        puts "BACKSTAFF: #{backstaff}" if TheCapn.parlance(2)
        puts "CARRACK.SPYGLASSES: #{carrack.spyglasses.inspect}" if TheCapn.parlance(2)
        gully = carrack.grub.send("find_by_#{carrack.spyglasses}".to_sym, backstaff)
        puts "GULLY: #{gully.inspect}" if TheCapn.parlance(2)
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
          puts "FLOTSAM: #{flotsam.inspect}" if TheCapn.parlance(2)
          if flotsam
            plunder = cutthroat.prize(flotsam)
            cutthroat.buried_treasure << plunder
            cutthroat.scrivener(plunder.map {|bulkhead| "#{bulkhead}"}.join(','))
          else
            puts "Unable to locate: #{cutthroat.grub} related to #{carrack.grub}.#{carrack.spyglasses} '#{gully.send(carrack.spyglasses)}'" if TheCapn.parlance(1)
          end
        else
          puts "Unable to locate: #{carrack.grub}.#{carrack.spyglasses} '#{gully.send(carrack.spyglasses)}'" if TheCapn.parlance(1)
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
end
