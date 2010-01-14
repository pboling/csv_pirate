require File.dirname(__FILE__) + '/spec_helper'

describe "PirateShip" do
  describe "walk_the_plank" do
    before(:each) do
      @csv_pirate = Star.walk_the_plank
    end

    it "should return a string" do
      @csv_pirate.class.should == String
    end
  end

  describe "blindfold" do
    before(:each) do
      @csv_pirate = Star.blindfold
    end

    it "should return the CsvPirate object" do
      @csv_pirate.class.should == CsvPirate
    end
  end

  describe "land_ho" do
    before(:each) do
      @csv_pirate = Star.land_ho
    end

    it "should return the CsvPirate object" do
      @csv_pirate.class.should == CsvPirate
    end
  end
end
