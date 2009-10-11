require 'faster_csv' unless defined?(FasterCSV)

module NinthBit
  module PirateShip

    module ActMethods
      #coding tyle is adopted from attachment_fu
      def has_csv_pirate_ship(options = {})
        # If you aren't using ActiveRecord (you are outside rails) then you must declare your :booty
        # If you are using ActiveRecord then you only want ot check for booty if the table exists so it won't fail pre-migration
        check_booty = defined?(ActiveRecord) && self.is_a?(ActiveRecord::Base) ? ActiveRecord::Base.connection.tables.include?(self.table_name) : true

        options[:chart]         ||= ['log','csv']
        options[:aft]           ||= '.csv'
        options[:gibbet]        ||= '.export'
        #Needs to be defined at runtime, doesn't make sense here
        #options[:chronometer]   ||= Date.today
        options[:waggoner]      ||= "#{self}"
        options[:swag]          ||= nil
        options[:swab]          ||= :counter
        options[:mop]           ||= :clean
        options[:shrouds]       ||= ','
        options[:grub]          ||= self if options[:swag].nil?
        options[:spyglasses]    ||= [:all]
        # Have to protect against model definitions pre-migration, since column names will fail if
        options[:booty]         ||= check_booty ? self.column_names : []
        options[:bury_treasure] ||= true
        options[:parlay]        ||= 1

        # if they provide both
        raise ArgumentError, "must provide either :swag or :grub, not both" if !options[:swag].blank? && !options[:grub].blank?
        # if they provide neither
        raise ArgumentError, "must provide either :swag or :grub" if options[:swag].blank? && options[:grub].blank?
        raise ArgumentError, ":swab is #{options[:swab].inspect}, but must be one of #{CsvPirate::BOOKIE.inspect}" unless CsvPirate::BOOKIE.include?(options[:swab])
        raise ArgumentError, ":mop is #{options[:mop].inspect}, but must be one of #{CsvPirate::MOP_HEADS.inspect}" unless CsvPirate::MOP_HEADS.include?(options[:mop])
        raise ArgumentError, ":gibbet is #{options[:gibbet].inspect}, and does not contain a '.' character, which is required when using iterative filenames (set :swab => :none to turn off iterative filenames)" if options[:swab] != :none && (options[:gibbet].nil? || !options[:gibbet].include?('.'))
        raise ArgumentError, ":waggoner is #{options[:waggoner].inspect}, and must be a string at least one character long" if options[:waggoner].nil? || options[:waggoner].length < 1
        raise ArgumentError, ":booty is #{options[:booty].inspect}, and must be an array of methods to call on a class for CSV data" if check_booty && (options[:booty].nil? || !options[:booty].is_a?(Array) || options[:booty].empty?)
        raise ArgumentError, ":chart is #{options[:chart].inspect}, and must be an array of directory names, which will become the filepath for the csv file" if options[:chart].nil? || !options[:chart].is_a?(Array) || options[:chart].empty?
        raise ArgumentError, ":shrouds is #{options[:shrouds].inspect}, and must be a string (e.g. ',' or '\t'), which will be used as the delimeter for the csv file" if options[:shrouds].nil? || !options[:shrouds].is_a?(String)

        extend ClassMethods unless (class << self; included_modules; end).include?(ClassMethods)

        self.piratey_options = options

      end
    end

    module ClassMethods

      def self.extended(base)
        base.class_inheritable_accessor :piratey_options
      end

      # intended for use with send_data for downloading the text of the csv:
      # send_data Make.say_your_last_words
      # TODO: Fix say_yourr_last_words so it works! Use send_data args for real
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
        CsvPirate.create(self.piratey_args(args))
      end

      # returns the csv_pirate object so you have access to everything
      # Does not actually create the csv, so you need to do this in your code:
      #   csv_pirate = Klass.land_ho({:booty => [:id, :name, :dragons, :created_at]})
      # This allows you to modify the csv_pirate object before creating the csv like this:
      #   csv_pirate.booty -= [:id, :name]
      #   csv_pirate.hoist_mainstay()
      def land_ho(args = {})
        CsvPirate.new(self.piratey_args(args))
      end

      protected

      def piratey_args(args = {})
        CsvPirate.parlay = args[:parlay] || self.piratey_options[:parlay]
        return { :chart => args[:chart] || self.piratey_options[:chart],
          :aft => args[:aft] || self.piratey_options[:aft],
          :gibbet => args[:gibbet] || self.piratey_options[:gibbet],
          :chronometer => args[:chronometer] == false ? false : args[:chronometer] || Date.today,
          :waggoner => args[:waggoner] || self.piratey_options[:waggoner] || "#{self}",
          :swag => args[:swag] || self.piratey_options[:swag],
          :swab => args[:swab] || self.piratey_options[:swab],
          :mop => args[:mop] || self.piratey_options[:mop],
          :shrouds => args[:shrouds] || self.piratey_options[:shrouds],
          :grub => args[:grub] || self.piratey_options[:grub],
          :spyglasses => args[:spyglasses] || self.piratey_options[:spyglasses],
          :booty => args[:booty] || self.piratey_options[:booty],
          :bury_treasure => args[:bury_treasure] || self.piratey_options[:bury_treasure] }
      end

    end

  end
end
