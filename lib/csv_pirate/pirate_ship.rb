module CsvPirate
  module PirateShip

    module ActMethods
      #coding style is adopted from attachment_fu
      def has_csv_pirate_ship(options = {})
        check_booty = prevent_from_failing_pre_migration

        options[:chart]         ||= ['log','csv']
        options[:aft]           ||= '.csv'
        options[:gibbet]        ||= '.export'
        #Needs to be defined at runtime, doesn't make sense here unless set to false, except to be overridden at runtime
        # Default is nil so that the CsvPirate default will kick-in.
        options[:chronometer]   ||= nil
        options[:waggoner]      ||= "#{self}"
        options[:swag]          ||= nil
        options[:swab]          ||= :counter
        options[:mop]           ||= :clean
        options[:shrouds]       ||= ','
        options[:grub]          ||= self if options[:swag].nil?
        options[:spyglasses]    ||= (self.respond_to?(:all) ? [:all] : nil) if options[:grub]
        # Have to protect against model definitions pre-migration, since column names will fail if
        options[:booty]         ||= check_booty ? self.column_names : []
        options[:bury_treasure] ||= true
        options[:blackjack]     ||= {:humanize => '_'}
        options[:parlay]        ||= 1

        # if they provide both
        raise ArgumentError, "must provide either :swag or :grub, not both" if !options[:swag].nil? && !options[:grub].nil?
        # if they provide neither
        raise ArgumentError, "must provide either :swag or :grub" if options[:swag].nil? && options[:grub].nil?
        raise ArgumentError, ":swab is #{options[:swab].inspect}, but must be one of #{TheCapn::BOOKIE.inspect}" unless TheCapn::BOOKIE.include?(options[:swab])
        raise ArgumentError, ":mop is #{options[:mop].inspect}, but must be one of #{TheCapn::MOP_HEADS.inspect}" unless TheCapn::MOP_HEADS.include?(options[:mop])
        raise ArgumentError, ":gibbet is #{options[:gibbet].inspect}, and does not contain a '.' character, which is required when using iterative filenames (set :swab => :none to turn off iterative filenames)" if options[:swab] != :none && (options[:gibbet].nil? || !options[:gibbet].include?('.'))
        raise ArgumentError, ":waggoner is #{options[:waggoner].inspect}, and must be a string at least one character long" if options[:waggoner].nil? || options[:waggoner].length < 1
        raise ArgumentError, ":booty is #{options[:booty].inspect}, and must be an array of methods to call on a class for CSV data" if check_booty && (options[:booty].nil? || !options[:booty].is_a?(Array) || options[:booty].empty?)
        raise ArgumentError, ":chart is #{options[:chart].inspect}, and must be an array of directory names, which will become the filepath for the csv file" if options[:chart].nil? || !options[:chart].is_a?(Array) || options[:chart].empty?
        raise ArgumentError, ":shrouds is #{options[:shrouds].inspect}, and must be a string (e.g. ',' or '\t'), which will be used as the delimeter for the csv file" if options[:shrouds].nil? || !options[:shrouds].is_a?(String)
        raise ArgumentError, ":blackjack is #{options[:blackjack].inspect}, and must be a hash (e.g. {:humanize => '_'}), which defines how the header of the CSV will be created" if options[:blackjack].nil? || !options[:blackjack].is_a?(Hash)

        extend ClassMethods unless (class << self; included_modules; end).include?(ClassMethods)

        class << self
          attr_accessor :piratey_options
        end

        self.piratey_options = options

      end

      #return true if we can access the tables, return false if we'd better not.
      def prevent_from_failing_pre_migration
        # If you aren't using ActiveRecord (you are outside rails) then you must declare your :booty
        # If you are using ActiveRecord then you only want ot check for booty if the table exists so it won't fail pre-migration
        begin
          defined?(ActiveRecord) && ActiveRecord::Base.connected? ?
                self.respond_to?(:table_name) && ActiveRecord::Base.connection.tables.include?(self.table_name) :
                self.respond_to?(:column_names)
         #The only error that occurs here is when ActiveRecord checks for the table but the database isn't setup yet.
         #It was preventing rake db:create from working.
         rescue
           puts "csv_pirate: failed to connect to database, or table missing"
           return false
         end
       end

    end

    module ClassMethods

      # intended for use with send_data for downloading the text of the csv:
      # send_data Make.say_your_last_words
      # TODO: Fix say_your_last_words so it works! Use send_data args for real
      #def say_your_last_words(charset = 'utf-8', args = {})
      #  csv_pirate = self.blindfold(args)
      #  return [ csv_pirate.maroon,
      #    {:type => "text/csv; charset=#{charset}; header=present"},
      #    {:disposition => "attachment; filename=#{csv_pirate.nocturnal}"} ]
      #end

      # returns the text of the csv export (not the file - this is important if you are appending)
      # warning if using from console: if you are exporting a large csv this will all print in your console.
      # intended for use with send_data for downloading the text of the csv:
      # send_data Make.walk_the_plank,
      #          :type => 'text/csv; charset=iso-8859-1; header=present',
      #          :disposition => "attachment; filename=Data.csv"
      def walk_the_plank(args = {})
        self.land_ho(args).hoist_mainstay()
      end

      # returns the csv_pirate object so you have access to everything
      # warning if using from console: if you are exporting a large csv this will all print in your console.
      # If using in a download action it might look like this:
      # csv_pirate = Make.blindfold
      # send_data csv_pirate.maroon,
      #          :type => 'text/csv; charset=iso-8859-1; header=present',
      #          :disposition => "attachment; filename=#{csv_pirate.nocturnal}"
      def blindfold(args = {})
        TheCapn.create(self.piratey_args(args))
      end

      # returns the csv_pirate object so you have access to everything
      # Does not actually create the csv, so you need to do this in your code:
      #   csv_pirate = Klass.land_ho({:booty => [:id, :name, :dragons, :created_at]})
      # This allows you to modify the csv_pirate object before creating the csv like this:
      #   csv_pirate.booty -= [:id, :name]
      #   csv_pirate.hoist_mainstay()
      def land_ho(args = {})
        TheCapn.new(self.piratey_args(args))
      end

      def weigh_anchor(args = {})
        pargs = self.piratey_args(args)
        pargs.merge!({
                :gibbet => '.dump',
                :chart => pargs[:chart] + ["dumps"],
        })
        TheCapn.create(pargs)
      end

      def raise_anchor(permanence = {:new => :new}, args = {})
        pargs = self.piratey_args(args)
        pargs.merge!({
                :chart => pargs[:chart] + ["dumps"],
                :brigantine => :last
        })
        csv_pirate = TheCapn.new(pargs)

        csv_pirate.to_memory(permanence)
      end

      protected

      def piratey_args(args = {})
        TheCapn.parlay ||= args[:parlay] || self.piratey_options[:parlay]
        return { :chart => args[:chart] || self.piratey_options[:chart],
          :aft => args[:aft] || self.piratey_options[:aft],
          :gibbet => args[:gibbet] || self.piratey_options[:gibbet],
          :chronometer => get_chronometer(args[:chronometer]),
          :waggoner => args[:waggoner] || self.piratey_options[:waggoner] || "#{self}",
          :swag => args[:swag] || self.piratey_options[:swag],
          :swab => args[:swab] || self.piratey_options[:swab],
          :mop => args[:mop] || self.piratey_options[:mop],
          :shrouds => args[:shrouds] || self.piratey_options[:shrouds],
          :grub => args[:grub] || self.piratey_options[:grub],
          :spyglasses => args[:spyglasses] || self.piratey_options[:spyglasses],
          :booty => args[:booty] || self.piratey_options[:booty],
          :blackjack => args[:blackjack] || self.piratey_options[:blackjack],
          :bury_treasure => args[:bury_treasure] || self.piratey_options[:bury_treasure] }
      end

      def get_chronometer(chron)
        chron == false ?
                false :
                (chron || (self.piratey_options[:chronometer] == false ?
                        false :
                        (self.piratey_options[:chronometer] || Date.today)))
      end

    end

  end
end
