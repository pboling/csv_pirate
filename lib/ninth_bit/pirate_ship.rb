module NinthBit
  module PirateShip

    module ActMethods
      #coding tyle is adopted from attachment_fu
      def has_csv_pirate_ship(options = {})
        if options.blank?
          raise ArgumentError, "must provide required options"
        end
        options[:chart]         ||= 'log/'
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
        options[:booty]         ||= self.column_names
        options[:bury_treasure] ||= true
        options[:parlay]        ||= 1

        # if they provide both
        raise ArgumentError, "must provide either specify :swag or :grub" if !options[:swag].blank? && !options[:grub].blank?
        # if they provide neither
        raise ArgumentError, "must provide either specify :swag or :grub, not both" if options[:swag].blank? && options[:grub].blank?
        raise ArgumentError, ":swab is #{options[:swab].inspect}, but must be one of #{CsvPirate::BOOKIE.inspect}" unless CsvPirate::BOOKIE.include?(options[:swab])
        raise ArgumentError, ":mop is #{options[:mop].inspect}, but must be one of #{CsvPirate::MOP_HEADS.inspect}" unless CsvPirate::MOP_HEADS.include?(options[:mop])
        raise ArgumentError, ":gibbet is #{options[:gibbet].inspect}, and does not contain a '.' character, which is required for iterative filenames" if options[:gibbet].nil? || !options[:gibbet].include?('.')
        raise ArgumentError, ":waggoner is #{options[:waggoner].inspect}, and must be a string at least one character long" if options[:waggoner].nil? || options[:waggoner].length < 1
        raise ArgumentError, ":booty is #{options[:booty].inspect}, and must be an array of methods to call on a class for CSV data" if options[:booty].nil? || options[:booty].empty?

        extend ClassMethods unless (class << self; included_modules; end).include?(ClassMethods)

        self.piratey_options = options

      end
    end

    module ClassMethods

      def self.extended(base)
        base.class_inheritable_accessor :piratey_options
      end

      #returns the text of the csv export (not the file - this is important if you are appending)
      def walk_the_plank(args = {})
        CsvPirate.parlay = args[:parlay] || self.piratey_options[:parlay]
        CsvPirate.new({
          :chart => args[:chart] || self.piratey_options[:chart],
          :aft => args[:aft] || self.piratey_options[:aft],
          :gibbet => args[:gibbet] || self.piratey_options[:gibbet],
          :chronometer => args[:chronometer] || Date.today,
          :waggoner => args[:waggoner] || self.piratey_options[:waggoner] || "#{self}",
          :swag => args[:swag] || self.piratey_options[:swag],
          :swab => args[:swab] || self.piratey_options[:swab],
          :mop => args[:mop] || self.piratey_options[:mop],
          :shrouds => args[:swab] || self.piratey_options[:shrouds],
          :grub => args[:grub] || self.piratey_options[:grub],
          :spyglasses => args[:spyglasses] || self.piratey_options[:spyglasses],
          :booty => args[:booty] || self.piratey_options[:booty],
          :bury_treasure => args[:bury_treasure] || self.piratey_options[:bury_treasure]
        })
        csv_pirate.hoist_mainstay()
      end

    end

  end
end
