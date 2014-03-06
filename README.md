# CsvPirate

Easily create CSVs of any data that can be derived from any Ruby object (PORO).

| Project                 |  Sanitize Email   |
|------------------------ | ----------------- |
| gem name                |  csv_pirate       |
| license                 |  MIT              |
| moldiness               |  [![Maintainer Status](http://stillmaintained.com/pboling/csv_pirate.png)](http://stillmaintained.com/pboling/csv_pirate) |
| version                 |  [![Gem Version](https://badge.fury.io/rb/csv_pirate.png)](http://badge.fury.io/rb/csv_pirate) |
| dependencies            |  [![Dependency Status](https://gemnasium.com/pboling/csv_pirate.png)](https://gemnasium.com/pboling/csv_pirate) |
| code quality            |  [![Code Climate](https://codeclimate.com/github/pboling/csv_pirate.png)](https://codeclimate.com/github/pboling/csv_pirate) |
| inline documenation     |  [![Inline docs](http://inch-pages.github.io/github/pboling/csv_pirate.png)](http://inch-pages.github.io/github/pboling/csv_pirate) |
| continuous integration  |  [![Build Status](https://secure.travis-ci.org/pboling/csv_pirate.png?branch=master)](https://travis-ci.org/pboling/csv_pirate) |
| test coverage           |  [![Coverage Status](https://coveralls.io/repos/pboling/csv_pirate/badge.png)](https://coveralls.io/r/pboling/csv_pirate) |
| homepage                |  [https://github.com/pboling/csv_pirate][homepage] |
| documentation           |  [http://rdoc.info/github/pboling/csv_pirate/frames][documentation] |
| author                  |  [Peter Boling](https://coderbits.com/pboling) |
| Spread ~♡ⓛⓞⓥⓔ♡~      |  [![Endorse Me](https://api.coderwall.com/pboling/endorsecount.png)](http://coderwall.com/pboling) |

## Summary

CsvPirate is the easy way to create a CSV of essentially anything in Ruby, in full pirate regalia.
It works better if you are wearing a tricorne!

## Compatibility

* Ruby 1.8.7 (Must also `gem install fastercsv` and `require 'faster_csv'`)
* Ruby 1.9.2, 1.9.3, and 2.0.0
* Rails (ActiveRecord) 2, 3, and 4

## Usage

Pure Ruby!  Doesn't require rails (though it works great with Active Record).

My goal is to have it do EVERYTHING it possibly can for me, since almost every project I do needs CSV exports.

CsvPirate only works for commissions of `swag` OR `grub`!

Initialize method (a.k.a new()) takes a hash of parameters, and creates the blank CSV file, and the instance can be modified prior to writing out to CSV:

    # CsvPirate only works for commissions of swag OR grub!
    # :swag           the ARrr collection of swag to work on (optional)
    # :grub           the ARrr class that the spyglasses will be used on (optional)
    # :spyglasses     named scopes in your model that will refine the rows in the CSV according to conditions of the spyglasses,
    #                   and order them according to the order of the spyglasses (optional)
    # :booty          booty (columns/methods) on your model that you want printed in the CSV, also used to create the figurehead (CSV header)
    # :chart          array of directory names (relative to rails root if using rails) which will be the filepath where you want to hide your loot
    # :waggoner       name of document where you will give detailed descriptions of the loot
    # :aft            filename extention ('.csv')
    # :shrouds        CSV column separator, default is ','. For tsv, tab-delimited, "\t"
    # :chronometer    keeps track of when you hunt for treasure
    # :gibbet         filename spacer after the date, and before the iterative counter/timestamp.  MuST contain a '.'
    # :swab           can be :counter, :timestamp, or :none
    #   :counter - default, each successive run will create a new file using a counter
    #   :timestamp - each successive run will create a new file using a HHMMSS time stamp
    #   :none - no iterative file naming convention, just use waggoner and aft
    # :mop            can be :clean or :dirty (:overwrite or :append) (only has an effect if :swab is :none) since overwriting is irrelevant for a new file
    #   :clean - do not use :swab above (:counter or :timestamp), and instead overwrite the file
    #   :dirty - do not use :swab above (:counter, or :timestamp), and do not overwrite.  Just keep adding on.
    # :bury_treasure  should we store the csv data as it is collected in an array in Ruby form for later use (true), or just write the CSV (false)?
    # :blackjack      Specify how you want your CSV header
    #   {:join => '-'}    joins the method names called to get hte data for that column with '_' underscores.
    #   {:humanize =>'-'} first joins as above, then humanizes the string (this is the default)
    #   {:array => ['col1',col2','col3'] Uses the column names provided.  If the array's length is less than the booty array's length it reverts to :humanize =>'_'

Check the source to see if there anything else hiding in there!  (HINT: There a bunch more undocumented options)

The create method has the same parameters, and actually writes the data to the CSV.

Avast! Here be pirates! Brush up on [pirate coding naming conventions](http://www.privateerdragons.com/pirate_dictionary.html).


## Install

    gem install csv_pirate

If you are still using Ruby < 1.9 then you will need to add `fastercsv` to your project.
FasterCSV became the built-in CSV library in Ruby 1.9, so is *only* required if using an older Ruby.

    gem 'fastercsv', '>= 1.4.0'


## Upgrading

### From version prior to 5.0

NinthBit::PirateShip::ActMethods has been deprecated in favor of CsvPirate::PirateShip::ActMethods.
Old API still works for now.

### From version prior to 4.0

`:chart` was a string which indicated where you wanted to hide the loot (write the csv file)
Now it must be an array of directory names.  So if you want your loot in "log/csv/pirates/model_name", then chart is:

    ['log','csv','pirates','model_name']

CsvPirate ensures that whatever you choose as your chart exists in the filesystem, and creates the directories if need be.


## Usage with ActiveRecord

What's the simplest thing that will work?

    class MyClass < ActiveRecord::Base
      has_csv_pirate_ship   # defaults to csv of all columns of all records
    end

    MyClass.blindfold       # creates the csv, and returns the CsvPirate instance
    MyClass.walk_the_plank  # creates the csv, and returns contents of the exported data (that was written into the csv) (as a string)
    MyClass.land_ho         # Does Not create the csv, sets up the CsvPirate instance.  You can manipulate it and then call .hoist_mainstay on it to create the csv

## Importing to DB or Ruby objects in memory from CSV

Importing abilities are now here!  You can dump data to CSV, copy the CSV to wherever, and then import the data in the CSV.  Works very well with ActiveRecord.

See the weigh_anchor method, added to models with has_csv_pirate_ship defined, for dumping.
See the raise_anchor method, added to models with has_csv_pirate_ship defined, for importing.
See the to_memory method to convert the data in a csv or CsvPirate instance object back into Ruby class instances
with as many attributes as possible set equal to the data from the CSV.

## Usage without ActiveRecord

[ See Spec Tests for more Examples! ]

Since the defaults assume an active record class you need to override some of them:

    class Star
      extend CsvPirate::PirateShip::ActMethods
      has_csv_pirate_ship :booty => [:name, :distance, :spectral_type, {:name => :hash}, {:name => :next}, {:name => :upcase}, :star_vowels],
                          :spyglasses => [:get_stars]

      attr_accessor :name, :distance, :spectral_type

      def initialize(*args)
        @name = args.first[:name]
        @distance = args.first[:distance]
        @spectral_type = args.first[:spectral_type]
      end

      def star_vowels
        self.name.tr('aeiou', '*')
      end

      def self.get_stars
        [
          Star.new(:name => "Proxima Centauri", :distance => "4.2 LY", :spectral_type => "M5.5Vc"),
          Star.new(:name => "Rigil Kentaurus", :distance => "4.3 LY", :spectral_type => "G2V"),
          Star.new(:name => "Barnard's Star", :distance => "5.9 LY", :spectral_type => "M3.8V"),
          Star.new(:name => "Wolf 359", :distance => "7.7 LY", :spectral_type => "M5.8Vc"),
          Star.new(:name => "Lalande 21185", :distance => "8.26 LY", :spectral_type => "M2V"),
          Star.new(:name => "Luyten 726-8A and B", :distance => "8.73 LY", :spectral_type => "M5.5 de & M6 Ve"),
          Star.new(:name => "Sirius A and B", :distance => "8.6 LY", :spectral_type => "A1Vm"),
          Star.new(:name => "Ross 154", :distance => "9.693 LY", :spectral_type => "M3.5"),
          Star.new(:name => "Ross 248", :distance => "10.32 LY", :spectral_type => "M5.5V"),
          Star.new(:name => "Epsilon Eridani", :distance => "10.5 LY", :spectral_type => "K2V")
        ]
      end
    end


    rails development  >a = Star.blindfold
      => #<CsvPirate:0x2209098 @buried_treasure=[], @mop=:clean, @spyglasses=[:get_stars], @swabbie=".3", @booty=[:name, :distance, :spectral_type, {:name=>:hash}, {:name=>:next}, {:name=>:upcase}, :star_vowels], @bury_treasure=false, @swab=:counter, @chronometer=Sun, 04 Oct 2009, @maroon="name,distance,spectral_type,namehash,namenext,nameupcase,star_vowels\nProxima Centauri,4.2 LY,M5.5Vc,971295636,Proxima Centaurj,PROXIMA CENTAURI,Pr*x*m* C*nt**r*\nRigil Kentaurus,4.3 LY,G2V,-231389024,Rigil Kentaurut,RIGIL KENTAURUS,R*g*l K*nt**r*s\nBarnard's Star,5.9 LY,M3.8V,1003964756,Barnard's Stas,BARNARD'S STAR,B*rn*rd's St*r\nWolf 359,7.7 LY,M5.8Vc,429493790,Wolf 360,WOLF 359,W*lf 359\nLalande 21185,8.26 LY,M2V,466625069,Lalande 21186,LALANDE 21185,L*l*nd* 21185\nLuyten 726-8A and B,8.73 LY,M5.5 de & M6 Ve,-886693495,Luyten 726-8A and C,LUYTEN 726-8A AND B,L*yt*n 726-8A *nd B\nSirius A and B,8.6 LY,A1Vm,-969980943,Sirius A and C,SIRIUS A AND B,S*r**s A *nd B\nRoss 154,9.693 LY,M3.5,-26506942,Ross 155,ROSS 154,R*ss 154\nRoss 248,10.32 LY,M5.5V,-18054910,Ross 249,ROSS 248,R*ss 248\nEpsilon Eridani,10.5 LY,K2V,931307088,Epsilon Eridanj,EPSILON ERIDANI,Eps*l*n Er*d*n*\n", @waggoner="Star", @astrolabe=false, @grub=Star, @rhumb_lines=#<File:/Users/pboling/RubymineProjects/empty_csv_pirate_app/log/csv/Star.20091004.export.3.csv (closed)>, @nocturnal="Star.20091004.export.3.csv", @aft=".csv", @gibbet=".export", @shrouds=",", @swag=[#<Star:0x2202db0 @spectral_type="M5.5Vc", @distance="4.2 LY", @name="Proxima Centauri">, #<Star:0x2202d10 @spectral_type="G2V", @distance="4.3 LY", @name="Rigil Kentaurus">, #<Star:0x2202c98 @spectral_type="M3.8V", @distance="5.9 LY", @name="Barnard's Star">, #<Star:0x2202c20 @spectral_type="M5.8Vc", @distance="7.7 LY", @name="Wolf 359">, #<Star:0x2202ba8 @spectral_type="M2V", @distance="8.26 LY", @name="Lalande 21185">, #<Star:0x2202b30 @spectral_type="M5.5 de & M6 Ve", @distance="8.73 LY", @name="Luyten 726-8A and B">, #<Star:0x2202ab8 @spectral_type="A1Vm", @distance="8.6 LY", @name="Sirius A and B">, #<Star:0x2202a40 @spectral_type="M3.5", @distance="9.693 LY", @name="Ross 154">, #<Star:0x22029c8 @spectral_type="M5.5V", @distance="10.32 LY", @name="Ross 248">, #<Star:0x2202950 @spectral_type="K2V", @distance="10.5 LY", @name="Epsilon Eridani">], @chart=["log", "csv"]>
    rails development  >a.weigh_anchor
      name,distance,spectral_type,namehash,namenext,nameupcase,star_vowels
      Proxima Centauri,4.2 LY,M5.5Vc,971295636,Proxima Centaurj,PROXIMA CENTAURI,Pr*x*m* C*nt**r*
      Rigil Kentaurus,4.3 LY,G2V,-231389024,Rigil Kentaurut,RIGIL KENTAURUS,R*g*l K*nt**r*s
      Barnard's Star,5.9 LY,M3.8V,1003964756,Barnard's Stas,BARNARD'S STAR,B*rn*rd's St*r
      Wolf 359,7.7 LY,M5.8Vc,429493790,Wolf 360,WOLF 359,W*lf 359
      Lalande 21185,8.26 LY,M2V,466625069,Lalande 21186,LALANDE 21185,L*l*nd* 21185
      Luyten 726-8A and B,8.73 LY,M5.5 de & M6 Ve,-886693495,Luyten 726-8A and C,LUYTEN 726-8A AND B,L*yt*n 726-8A *nd B
      Sirius A and B,8.6 LY,A1Vm,-969980943,Sirius A and C,SIRIUS A AND B,S*r**s A *nd B
      Ross 154,9.693 LY,M3.5,-26506942,Ross 155,ROSS 154,R*ss 154
      Ross 248,10.32 LY,M5.5V,-18054910,Ross 249,ROSS 248,R*ss 248
      Epsilon Eridani,10.5 LY,K2V,931307088,Epsilon Eridanj,EPSILON ERIDANI,Eps*l*n Er*d*n*
      => #<File:/Users/pboling/RubymineProjects/empty_csv_pirate_app/log/csv/Star.20091004.export.3.csv (closed)>

## Advanced Usage & Examples

Assuming a Make (as in manufacturers of automobiles) model like this:

    # ## Schema Information
    #
    # Table name: makes
    #
    #  id      :integer(4)      not null, primary key
    #  name    :string(255)
    #  factory :string(255)
    #  sales   :integer(4)
    #

    class Make < ActiveRecord::Base
      has_many :vehicle_models
      named_scope :factory_in_germany, :conditions => ["factory = ?", "Germany"]

      # Showing all available options with their default values
      has_csv_pirate_ship :chart          => ['log','csv']        # Array of Strings: directory where csv will be created (Yes, it creates all of them if they do not already exist)
                          :aft            => '.csv'               # String: filename extension, usually this would be '.csv', but can be whatever you want.
                          :gibbet         => '.export'            # String: Middle part of the filename {the '.' is required for iterative filenames, set :swab => :none to turn off iterative filenames}
                                                                  # Comes after waggoner and chronometer, before swabbie and aft
                          :waggoner       => "#{Make}"            # String: First part of filename

                          # Must provide :swag or :grub (not both)
                          :swag           => nil                  # Array of objects: to use to create the CSV (i.e. you've already done the query and have the results you want a CSV of)
                          :grub           => Make                 # Class:  on which to call the method chain in :spyglasses that will return the array of objects to be placed in :swag by CsvPirate (See description of swag above).
                          :spyglasses     => [:all]               # Array of symbols/strings: Methods that will be chained together and called on :grub in order to get the :swag records which will become the rows of the CSV.
                          :booty          => Make.column_names    # Array of symbols/strings or nested hashes of symbols/strings: Methods to call on each object in :swag.  These become the columns of the CSV.  The method names become the CSV column headings.  Methods can be chained to dig deep (e.g. traverse several ActiveRecord associations) to get at a value for the CSV. To call instance methods that include arguments, pass a booty element of an array such as [:method_name, arg1, arg2...].

                          :swab           => :counter             # Symbol: What kind of file counter to use to avoid overwriting the CSV file, :counter is Integer, :timestamp is HHMMSS, :none is no file counter, increasing the likelihood of duplicate filenames on successive csv exports.
                          :mop            => :clean               # Symbol: If we DO end up writing to a preexisting file (by design or accident) should we overwrite (:clean) or append (:dirty)?
                          :shrouds        => ','                  # String: Delimiter for CSV.  '\t' will create a tab delimited file (tsv), '|' will create a pipe delimited file.
                          :bury_treasure  => true                 # Boolean: Should the array of objects in :swag be stored in the CsvPirate object for later inspection?
                          :blackjack      => {:humanize => '-'}   # Hash: Specify how you want your CSV header
                                                                  #   {:join => '-'}    joins the method names called to get hte data for that column with '_' underscores.
                                                                  #   {:humanize => '-'} first joins as above, then humanizes the string (this is the default)
                                                                  #   {:array => ['col1',col2','col3'] Uses the column names provided in the array.  If the array provided is too short defaults to :humanize =>'_'

      # A customized version to create a tab delimited file for this class might look like this:
      # has_csv_pirate_ship   :spyglasses => [:factory_in_germany],
      #                       :booty      => [:id, :name],
      #                       :shrouds    => '\t'
      #                       # keeping the rest of the options at the default values, so they don't need to be defined.
    end

To create a csv of the names and ids of makes with factories in germany and return the text of the export:

    Make.walk_the_plank  # Get it? HA! If you can't believe I wrote this whole thing JUST to be able to make jokes like that... check ma sources :)

The name of the csv that comes out will be (by default located in log directory):

    Make.20090930.export.13.csv

Where Make is the class, 20090930 is today's date, .export is the gibbet, and 13 is the iterative file counter, meaning I've run this export 13 times today.

All of those filename parts are customizable to a degree.  For example if you want to have the date NOT be today's date you can supply your own date:

    Make.walk_the_plank({:chronometer => Date.parse("December 21, 2012") })
    # File name would be: Make.20121221.export.13.csv

    Make.walk_the_plank({:chronometer => false })
    # File name would be: Make.export.13.csv

What if you want the file name to be always the same and to always append to the end of it?

    # Example: I want the file to be named "data", with no extension, both of the following accomplish that:
    Make.walk_the_plank({:chronometer => false, :gibbet => "", :aft => "", :swab => :none, :waggoner => 'data'})
    Make.blindfold(:chronometer => false, :gibbet => "", :aft => "", :swab => :none, :waggoner => 'data')

All of the options to has_csv_pirate_ship are available to walk_the_plank, land_ho, and blindfold, as well as to the raw class methods CsvPirate::TheCapn.new and CsvPirate::TheCapn.create, but not necessarily the other way around.

You can also customize the CSV, for example if you want to customize which columns are in the csv:

    Make.walk_the_plank({:booty => [:id, :name, :sales]})

You want a timestamp file counter instead of the integer default:

    Make.walk_the_plank({:booty => [:id, :name, :sales], :swab => :timestamp})

If you want to append each export to the end of the same file (on a per day basis):

    Make.walk_the_plank({:booty => [:id, :name, :sales], :spyglasses => [:all], :swab => :none, :mop => :dirty})

If you want to restrict the csv to a particular set of named scopes:

    Make.walk_the_plank({:booty => [:id, :name, :sales], :spyglasses => [:with_abs, :with_esc, :with_heated_seats]})

If you want to create a tsv (tab-delimited) or psv (pipe-delimited) instead of a csv:

    Make.walk_the_plank({:booty => [:id, :name, :sales], :shrouds => '\t'})
    Make.walk_the_plank({:booty => [:id, :name, :sales], :shrouds => '|'})

If you have a method in the Make class like this:

    def to_slug
      "#{self.name}_#{self.id}"
    end

getting it in the CSV is easy peasy:

    Make.walk_the_plank({:booty => [:id, :name, :to_slug]})

If you want to traverse Active Record Associations, or call a method on the return value of another method (unlimited nesting):

    Make.walk_the_plank({:booty => [:id, :name, :to_slug, {:to_slug => :hash}]})  #will call .hash on the result of make.to_slug
    Make.walk_the_plank({:booty => [:id, :name, :to_slug, {:to_slug => {:hash => :abs}}]})  #returns make.to_slug.hash.abs

If you want to build your booty using instance functions that require arguments, use an array:

    Make.walk_the_plank({:booty => [:id, :name, [:value_on, Date.today]})  # will call make.value_on(Date.today)

Add whatever methods you want to the :booty array.  Write new methods, and add them!  Make lots of glorious CSVs full of data to impress the pointy ones in the office.

You can also use the raw CsvPirate class itself directly wherever you want.

The following two sets of code are identical:

    csv_pirate = CsvPirate::TheCapn.new({
      :grub => User,
      :spyglasses => [:active,:logged_in],
      :waggoner => 'active_users_logged_in',
      :booty => ["id","number","login","created_at"],
      :chart => ['log','csv']
    })
    csv_pirate.hoist_mainstay() # creates CSV file and writes out the rows

    CsvPirate::TheCapn.create({
      :grub => User,
      :spyglasses => [:active,:logged_in],
      :waggoner => 'active_users_logged_in',
      :booty => ["id","number","login","created_at"],
      :chart => ['log','csv']
    })# creates CSV file and writes out the rows

Another example using swag instead of grub:

    users = User.logged_out.inactive
    csv_pirate = CsvPirate::TheCapn.new({
      :swag => users,
      :waggoner => 'inactive_users_not_logged_in',
      :booty => ["id","number","login","created_at"],
      :chart => ['log','csv']
    })
    csv_pirate.hoist_mainstay()

Then if you want to get your hands on the loot immediately:

    csv_pirate.weigh_anchor()

For those who can't help but copy/paste into console and then edit:

    csv_pirate = CsvPirate::TheCapn.new({:grub => User,:spyglasses => [:active,:logged_in],:waggoner => 'active_users_logged_in',:booty => ["id","number","login","created_at"],:chart => ['log','csv']})

OR

    csv_pirate = CsvPirate::TheCapn.new({:swag => users,:waggoner => 'inactive_users_not_logged_in',:booty => ["id","number","login","created_at"],:chart => ['log','csv']})


## Downloading the CSV

You have the same Make class as above, and you have a MakeController:

    class MakeController < ApplicationController
      def download_csv
        csv_pirate = Make.blindfold

        # maroon saves the read to the file system, by using the text of the csv stored in the CsvPirate object.
        send_data csv_pirate.maroon, ...
            :type => 'text/csv; charset=iso-8859-1; header=present',
            :disposition => "attachment; filename=#{csv_pirate.nocturnal}"

        # However if CSVs are created using multiple CsvPirate objects that all append to a single file,
        #   we need to read the final product from the fs.
        #send_file csv_pirate.brigantine,
        #  :type => 'text/csv; charset=utf-8; header=present',
        #  :disposition => "attachment; filename=#{csv_pirate.nocturnal}"
      end
    end

## Advanced Example with Nested Methods

You have a VehicleModel class and the same Make class as up above:

    # ## Schema Information
    #
    # Table name: vehicle_models
    #
    #  id         :integer(4)      not null, primary key
    #  name       :string(255)
    #  year       :integer(4)
    #  horsepower :integer(4)
    #  price      :integer(4)
    #  electric   :boolean(1)
    #  make_id    :integer(4)
    #

    class VehicleModel < ActiveRecord::Base
      belongs_to :make
      has_csv_pirate_ship :booty => [:id, :name, :year,
                                     {:make => :name},
                                     {:tires => {:size => {:width => :inches}}}]
      def tires; TireSize.new; end
    end

    class TireSize
      # To call an instance method you need to return an instance
      def size; TireWidth.new; end
    end

    class TireWidth
      # To call a class method you need to return the class object
      def width; Measurement; end
    end

    class Measurement
      def self.inches; 13; end
    end

Then to create the CSV:

    a = VehicleModel.blindfold

Then check the output from the console:

    a.weigh_anchor

    Id,Name,Year,Make name,Tires size width inches
    1,Cavalier,1999,Chevrolet,13
    2,Trailblazer,2006,Chevrolet,13
    3,Corvette,2010,Chevrolet,13
    4,Mustang,1976,Ford,13
    5,Lebaron,1987,Chrysler,13
    6,Avalon,1996,Toyota,13
    => #<File:/Users/pboling/RubymineProjects/empty_csv_pirate_app/log/VehicleModel.20091001.export.2.csv (closed)>

Joy to recursive code everywhere!

If you wanted to create the CsvPirate object and then modify it before creating the csv you can do that too.
Does not actually create the csv, so you need to do this in your code:

    csv_pirate = VehicleModel.land_ho({:booty => [:id, :name, :year, :horsepower, :price]})

This allows you to modify the csv_pirate object before creating the csv like this:

    csv_pirate.booty -= [:id, :name]
    csv_pirate.hoist_mainstay()

## Tests

The tests are run with rspec.  The test suite is expanding.  Currently there is ample coverage of basic functionality.

If on a Ruby prior to Ruby 1.9 you will also need the `fastercsv` gem

To run tests cd to where ever you have csv_pirate installed, and do:

    bundle exec rake spec


## How you can help!

This code was written in 2008, as one of my first gems, and is aging well, but can certainly be improved.

Take a look at the `reek` list, which is the file called `REEK`, and stat fixing things.  Once you complete a change, run the tests.  See "Running the gem tests".

If the tests pass refresh the `reek` list:

    bundle exec rake reek > REEK

Follow the instructions for "Contributing" below.


## Compatibility with Micrsoft Excel

Microsoft Office (Excel) "SYLK Invalid Format" Error will occur if the string "ID" (without quotes)
is at the beginning of the CSV file.  This is strangely inconvenient for rails CSVs since every table
in rails starts with an id column.  So buyer beware... make your first column lower case 'id'
if you need to export the id field.

http://www.bradino.com/misc/sylk-file-format-is-not-valid/


## Contributing to CsvPirate

* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests, rspec preferred, for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or change log. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## On The Web

Release Announcement:
  http://galtzo.blogspot.com/2009/03/csv-pirate.html

## Versioning

This library aims to adhere to [Semantic Versioning 2.0.0][semver].
Violations of this scheme should be reported as bugs. Specifically,
if a minor or patch version is released that breaks backward
compatibility, a new version should be immediately released that
restores compatibility. Breaking changes to the public API will
only be introduced with new major versions.

As a result of this policy, you can (and should) specify a
dependency on this gem using the [Pessimistic Version Constraint][pvc]  with two digits of precision.

For example:

    spec.add_dependency 'csv_pirate', '~> 5.0'

## Thanks

Thanks go to:

* [Peter Boling][railsbling], author of CsvPirate, runs the joint.
* TimePerks LLC (http://www.timeperks.com) - Many useful enhancements were requested and paid for by TimePerks

----------------------------------------------------------------------------------
Author: Peter Boling, peter.boling at gmail dot com

Copyright (c) 2008-2013 [Peter H. Boling][peterboling] of [RailsBling.com][railsbling], released under the MIT license.  See LICENSE for details.

[semver]: http://semver.org/
[pvc]: http://docs.rubygems.org/read/chapter/16#page74
[railsbling]: http://www.railsbling.com
[peterboling]: http://www.peterboling.com
[documentation]: http://rdoc.info/github/pboling/flag_shih_tzu/frames
[homepage]: https://github.com/pboling/flag_shih_tzu


[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/pboling/csv_pirate/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

