require File.dirname(__FILE__) + '/spec_helper'

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

    it "should return an instance of CsvPirate" do
      @csv_pirate.class.should == CsvPirate
    end
  end

  describe "#land_ho" do
    before(:each) do
      @csv_pirate = Star.land_ho
    end

    it "should return an instance of CsvPirate" do
      @csv_pirate.class.should == CsvPirate
    end
  end

  describe "#land_ho" do
    before(:each) do
      @csv_pirate = Star.land_ho
    end

    it "should return an instance of CsvPirate" do
      @csv_pirate.class.should == CsvPirate
    end
  end

  describe "#weigh_anchor" do
    before(:each) do
      @csv_pirate = Star.weigh_anchor({:chronometer => Date.parse("2/1/2007")})
    end

    it "should return an instance of CsvPirate" do
      @csv_pirate.class.should == CsvPirate
      @csv_pirate.chart.should == ["spec","csv","Star","dumps"]
    end
  end

  describe "#raise_anchor" do
    before(:each) do
      Star.weigh_anchor({:chronometer => Date.parse("3/29/2002")})
      Star.weigh_anchor({:chronometer => Date.parse("6/14/2004")})
      Star.weigh_anchor({:chronometer => Date.parse("12/25/1962")})
    end

    it "should return an array of 10 Stars built from data in CSV" do
      @csv_pirate = Star.raise_anchor({:new => :new})
      @csv_pirate.class.should == Array
      @csv_pirate.length.should == 10
    end
    
  end
  
end
