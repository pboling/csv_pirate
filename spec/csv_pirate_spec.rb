require 'spec_helper' #here in this same config/ dir

describe "CsvPirate" do
  describe "#initialize" do
    before(:each) do
      @csv_pirate = CsvPirate.new({
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
      @csv_pirate.class.should == CsvPirate
    end

    it "should not export anything" do
      @csv_pirate.maroon.should == ""
    end
  end

  describe "#create" do
    before(:each) do
      @csv_pirate = CsvPirate.create({
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
      @csv_pirate.class.should == CsvPirate
    end

    it "should store export in maroon instance variable" do
      @csv_pirate.maroon[0..100].should ==
              "Name,Distance,Spectral type,Name hash,Name next,Name upcase,Star vowels\nProxima Centauri,4.2 LY,M5.5V"
    end
  end

  describe "#hoist_mainstay" do
    before(:each) do
      @csv_pirate = CsvPirate.new({
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

  describe "#old_csv_dump" do

    before(:each) do
      ["1/1/1998","2/2/2002","1/2/2003","3/2/2001","2/1/2007"].map {|x| Date.parse(x)}.each do |date|
        @csv_pirate = CsvPirate.new({
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

    it "should find first (oldest) dump" do
      @new_csv_pirate = CsvPirate.new({
            :grub => GlowingGasBall,
            :spyglasses => [:get_stars],
            :chart => ["spec","csv","GlowingGasBall","dumps"],
            :booty => [:name, :distance, :spectral_type, {:name => :hash}, {:name => :next}, {:name => :upcase}, :star_vowels ],
            :chronometer => false,
            :brigantine => :first,
            :swab => :none,
            :mop => :clean
      })
      @new_csv_pirate.brigantine.should == "spec/csv/GlowingGasBall/dumps/GlowingGasBall.19980101.export.csv"
    end

    it "should find last (newest) dump" do
      @new_csv_pirate = CsvPirate.new({
            :grub => GlowingGasBall,
            :spyglasses => [:get_stars],
            :chart => ["spec","csv","GlowingGasBall","dumps"],
            :booty => [:name, :distance, :spectral_type, {:name => :hash}, {:name => :next}, {:name => :upcase}, :star_vowels ],
            :chronometer => false,
            :brigantine => :last,
            :swab => :none,
            :mop => :clean
      })
      @new_csv_pirate.brigantine.should == "spec/csv/GlowingGasBall/dumps/GlowingGasBall.20070201.export.csv"
    end
  end

  describe "#to_memory" do

    before(:each) do
      ["1/1/1998","2/2/2002","1/2/2003","3/2/2001","2/1/2007"].map {|x| Date.parse(x)}.each do |date|
        @csv_pirate = CsvPirate.new({
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

    it "should return an array of 10 grubs built from data in CSV" do
      @new_csv_pirate = CsvPirate.new({
            :grub => GlowingGasBall,
            :spyglasses => [:get_stars],
            :chart => ["spec","csv","GlowingGasBall","dumps"],
            :booty => [:name, :distance, :spectral_type, {:name => :hash}, {:name => :next}, {:name => :upcase}, :star_vowels ],
            :chronometer => false,
            :brigantine => :last,
            :swab => :none,
            :mop => :clean
      })
      @new_csv_pirate.brigantine.should == "spec/csv/GlowingGasBall/dumps/GlowingGasBall.20070201.export.csv"
      @new_csv_pirate.to_memory.class.should == Array
      @new_csv_pirate.to_memory.length.should == 10
    end
  end

  describe ":blackjack option" do
    before(:each) do
      @csv_pirate = CsvPirate.new({
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

end
