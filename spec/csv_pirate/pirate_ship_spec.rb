require 'spec_helper' #here in this same config/ dir

describe "PirateShip" do
  describe "#walk_the_plank" do
    before(:each) do
      @csv_pirate = Star.walk_the_plank
    end

    it "should return a string" do
      @csv_pirate.class.should == String
    end
  end

  describe "#blindfold" do
    before(:each) do
      @csv_pirate = Star.blindfold
    end

    it "should return an instance of CsvPirate::TheCapn" do
      @csv_pirate.class.should == CsvPirate::TheCapn
    end
  end

  describe "#land_ho" do
    before(:each) do
      @csv_pirate = Star.land_ho
    end

    it "should return an instance of CsvPirate::TheCapn" do
      @csv_pirate.class.should == CsvPirate::TheCapn
    end
  end

  describe "#land_ho" do
    before(:each) do
      @csv_pirate = Star.land_ho
    end

    it "should return an instance of CsvPirate::TheCapn" do
      @csv_pirate.class.should == CsvPirate::TheCapn
    end
  end

  describe "#weigh_anchor" do
    before(:each) do
      @csv_pirate = Star.weigh_anchor({:chronometer => Date.parse("2/1/2007")})
    end

    it "should return an instance of CsvPirate::TheCapn" do
      @csv_pirate.class.should == CsvPirate::TheCapn
      @csv_pirate.chart.should == ["spec","csv","Star","dumps"]
    end
  end

  describe "#raise_anchor" do
    before(:each) do
      Star.weigh_anchor({:chronometer => Date.parse("03.10.2002")})
      Star.weigh_anchor({:chronometer => Date.parse("06.11.2004")})
      Star.weigh_anchor({:chronometer => Date.parse("12.12.1962")})
    end

    it "should return an array of 10 Stars built from data in CSV" do
      @csv_pirate = Star.raise_anchor({:new => :new})
      @csv_pirate.class.should == Array
      @csv_pirate.length.should == 10
    end
    
  end
  
end
