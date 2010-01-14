require File.dirname(__FILE__) + '/spec_helper'

describe "CsvPirate" do
  describe "initialize" do
    before(:each) do
      @csv_pirate = CsvPirate.new({
            :grub => GlowingGasBall,
            :spyglasses => [:get_stars],
            :chart => ["spec","csv","GlowingGasBall"],
            :booty => [:name, :distance, :spectral_type, {:name => :hash}, {:name => :next}, {:name => :upcase}, :star_vowels ]})
    end

    it "should create an instance of CsvPirate" do
      @csv_pirate.class.should == CsvPirate
    end
  end
end
