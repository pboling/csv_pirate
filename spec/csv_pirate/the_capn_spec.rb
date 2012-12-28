require 'spec_helper' #here in this same config/ dir

describe CsvPirate::TheCapn do
  describe "#initialize" do
    before(:each) do
      @csv_pirate = CsvPirate::TheCapn.new({
            :grub => GlowingGasBall,
            :spyglasses => [:get_stars],
            :chart => ["spec","csv","GlowingGasBall"],
            :booty => [:name, :distance, :spectral_type, {:name => :hash}, {:name => :next}, {:name => :upcase}, :star_vowels ],
            :chronometer => false,
            :gibbet => "",
            :aft => ".csv",
            :swab => :none,
            :mop => :clean,
            :waggoner => 'data'
      })
    end

    it "should return an instance of CsvPirate" do
      @csv_pirate.class.should == CsvPirate::TheCapn
    end

    it "should not export anything" do
      @csv_pirate.maroon.should == ""
    end
  end

  describe "#create" do
    before(:each) do
      @csv_pirate = CsvPirate::TheCapn.create({
            :grub => GlowingGasBall,
            :spyglasses => [:get_stars],
            :chart => ["spec","csv","GlowingGasBall"],
            :booty => [:name, :distance, :spectral_type, {:name => :hash}, {:name => :next}, {:name => :upcase}, :star_vowels ],
            :chronometer => false,
            :gibbet => "",
            :aft => ".csv",
            :swab => :none,
            :mop => :clean,
            :waggoner => 'data'
      })
    end

    it "should return an instance of CsvPirate" do
      @csv_pirate.class.should == CsvPirate::TheCapn
    end

    it "should store export in maroon instance variable" do
      @csv_pirate.maroon[0..100].should ==
              "Name,Distance,Spectral type,Name hash,Name next,Name upcase,Star vowels\nProxima Centauri,4.2 LY,M5.5V"
    end
  end


  describe "#create with function-arg booty" do
    before(:each) do
      @csv_pirate = CsvPirate::TheCapn.create({
            :grub => GlowingGasBall,
            :spyglasses => [:get_stars],
            :chart => ["spec","csv","GlowingGasBall"],
            :booty => [[:sub_name, 'a', 'Z'], :distance, :spectral_type, {:name => :hash}, {:name => :next}, {:name => :upcase}, :star_vowels ],
            :chronometer => false,
            :gibbet => "",
            :aft => ".csv",
            :swab => :none,
            :mop => :clean,
            :waggoner => 'data'
      })
    end

    it "should call instance functions with arguments an instance of CsvPirate" do
      @csv_pirate.maroon.should =~ /ProximZ CentZuri/
    end
  end


  describe "#hoist_mainstay" do
    before(:each) do
      @csv_pirate = CsvPirate::TheCapn.new({
            :grub => GlowingGasBall,
            :spyglasses => [:get_stars],
            :chart => ["spec","csv","GlowingGasBall"],
            :booty => [:name, :distance, :spectral_type, {:name => :hash}, {:name => :next}, {:name => :upcase}, :star_vowels ],
            :chronometer => false,
            :gibbet => "",
            :aft => ".csv",
            :swab => :none,
            :mop => :clean,
            :waggoner => 'data'
      })
    end

    it "should return an instance of String" do
      @csv_pirate.hoist_mainstay.class.should == String
    end

    it "should return the export as a string" do
      @csv_pirate.hoist_mainstay[0..100].should == "Name,Distance,Spectral type,Name hash,Name next,Name upcase,Star vowels\nProxima Centauri,4.2 LY,M5.5V"
    end

    it "should store export in maroon instance variable" do
      @csv_pirate.maroon.should == ""
      @csv_pirate.hoist_mainstay
      @csv_pirate.maroon[0..100].should == "Name,Distance,Spectral type,Name hash,Name next,Name upcase,Star vowels\nProxima Centauri,4.2 LY,M5.5V"
    end
  end

  describe "dated dumps" do
    before(:each) do
      ["1/1/1998","2/2/2002","1/2/2003","3/2/2001","2/1/2007"].each do |x|
        date = Date.parse(x)
        @csv_pirate = CsvPirate::TheCapn.new({
              :grub => GlowingGasBall,
              :spyglasses => [:get_stars],
              :chart => ["spec","csv","GlowingGasBall","dumps"],
              :booty => [:name, :distance, :spectral_type, {:name => :hash}, {:name => :next}, {:name => :upcase}, :star_vowels ],
              :chronometer => date,
              :swab => :none,
              :mop => :clean
        })
        @csv_pirate.hoist_mainstay
      end
    end

    describe "#flies" do
      it "should list exported files" do
        @csv_pirate.flies.include?("GlowingGasBall.19980101.export.csv").should be_true
        @csv_pirate.flies.include?("GlowingGasBall.20010203.export.csv").should be_true
        @csv_pirate.flies.include?("GlowingGasBall.20020202.export.csv").should be_true
        @csv_pirate.flies.include?("GlowingGasBall.20030201.export.csv").should be_true
        @csv_pirate.flies.include?("GlowingGasBall.20070102.export.csv").should be_true
      end
    end

    describe "#old_csv_dump" do
      it "should find first (oldest) dump" do
        @new_csv_pirate = CsvPirate::TheCapn.new({
              :grub => GlowingGasBall,
              :spyglasses => [:get_stars],
              :chart => ["spec","csv","GlowingGasBall","dumps"],
              :booty => [:name, :distance, :spectral_type, {:name => :hash}, {:name => :next}, {:name => :upcase}, :star_vowels ],
              :chronometer => Date.parse('18/4/2011'),
              :brigantine => :first,
              :swab => :none,
              :mop => :clean
        })
        @new_csv_pirate.brigantine.should == "spec/csv/GlowingGasBall/dumps/GlowingGasBall.19980101.export.csv"
      end

      it "should find last (newest) dump" do
        @new_csv_pirate = CsvPirate::TheCapn.new({
              :grub => GlowingGasBall,
              :spyglasses => [:get_stars],
              :chart => ["spec","csv","GlowingGasBall","dumps"],
              :booty => [:name, :distance, :spectral_type, {:name => :hash}, {:name => :next}, {:name => :upcase}, :star_vowels ],
              :chronometer => nil,
              :brigantine => :last,
              :swab => :none,
              :mop => :clean
        })
        @new_csv_pirate.brigantine.should == "spec/csv/GlowingGasBall/dumps/GlowingGasBall.20070102.export.csv"
      end
    end

    describe "#to_memory" do
      it "should return an array of 10 grubs built from data in CSV" do
        @new_csv_pirate = CsvPirate::TheCapn.new({
              :grub => GlowingGasBall,
              :spyglasses => [:get_stars],
              :chart => ["spec","csv","GlowingGasBall","dumps"],
              :booty => [:name, :distance, :spectral_type, {:name => :hash}, {:name => :next}, {:name => :upcase}, :star_vowels ],
              :chronometer => false,
              :brigantine => :last,
              :swab => :none,
              :mop => :clean
        })
        @new_csv_pirate.brigantine.should == "spec/csv/GlowingGasBall/dumps/GlowingGasBall.export.csv"
        @new_csv_pirate.to_memory.class.should == Array
        @new_csv_pirate.hoist_mainstay
        # After the CSV is written we should have an array of stuff
        @new_csv_pirate.to_memory.length.should == 10
      end
    end

    context "protected methods" do
      before(:each) do
        @new_csv_pirate = CsvPirate::TheCapn.new({
              :grub => GlowingGasBall,
              :spyglasses => [:get_stars],
              :chart => ["spec","csv","GlowingGasBall","dumps"],
              :booty => [:name, :distance, :spectral_type, {:name => :hash}, {:name => :next}, {:name => :upcase}, :star_vowels ],
              :chronometer => false,
              :swab => :none,
              :mop => :clean
        })
      end

      describe "#lantern" do
        it "should be a glob" do
          @new_csv_pirate.send(:lantern).should == "spec/csv/GlowingGasBall/dumps/GlowingGasBall.export.*"
        end
      end
      describe "#merchantman" do
        it "should be" do
          @new_csv_pirate.send(:merchantman).should == "GlowingGasBall.export"
        end
      end
    end
  end

  describe ":blackjack option" do
    before(:each) do
      @csv_pirate = CsvPirate::TheCapn.new({
            :grub => GlowingGasBall,
            :spyglasses => [:get_stars],
            :chart => ["spec","csv","GlowingGasBall"],
            :booty => [:name, :distance, :spectral_type, {:name => :hash}, {:name => :next}, {:name => :upcase}, :star_vowels ],
            :chronometer => false,
            :gibbet => "",
            :aft => ".csv",
            :swab => :none,
            :mop => :clean,
            :waggoner => 'data'
      })
    end

    it "should be {humanize => '_'} by default" do
      @csv_pirate.blackjack.should == {:humanize => '_'}
      @csv_pirate.hoist_mainstay
      @csv_pirate.maroon[0..100].should == "Name,Distance,Spectral type,Name hash,Name next,Name upcase,Star vowels\nProxima Centauri,4.2 LY,M5.5V"
    end

    it "should work as {:join => '_'}" do
      @csv_pirate.blackjack = {:join => '_'}
      @csv_pirate.blackjack.should == {:join => '_'}
      @csv_pirate.hoist_mainstay
      @csv_pirate.maroon[0..100].should == "name,distance,spectral_type,name_hash,name_next,name_upcase,star_vowels\nProxima Centauri,4.2 LY,M5.5V"
    end
  end

  describe ":bury_treasure option" do
    describe "when true" do
      before(:each) do
        # Similar to example from the readme
        @csv_pirate = CsvPirate::TheCapn.create({
                                                  :swag => [Struct.new(:first_name, :last_name, :birthday).new('Joe','Smith','12/24/1805')],
                                                  :waggoner => 'active_users_logged_in',
                                                  :booty => [:first_name, :last_name],
                                                  :chart => ['log','csv'],
                                                  :bury_treasure => true
                                                })
      end
      it "should bury treasure in buried_treasure as array" do
        @csv_pirate.buried_treasure.class.should == Array
      end
      it "should have buried treasure" do
        @csv_pirate.buried_treasure.first.should == %w(Joe Smith)
      end
    end
    describe "when false" do
      before(:each) do
        # Similar to example from the readme
        @csv_pirate = CsvPirate::TheCapn.create({
                                                  :swag => [Struct.new(:first_name, :last_name, :birthday).new('Joe','Smith','12/24/1805')],
                                                  :waggoner => 'active_users_logged_in',
                                                  :booty => [:first_name, :last_name],
                                                  :chart => ['log','csv'],
                                                  :bury_treasure => false
                                                })
      end
      it "should not bury any treasure in the buried_treasure array" do
        @csv_pirate.buried_treasure.should == []
      end
    end
  end

end
