require 'spec_helper' #here in this same config/ dir

describe CsvPirate do
  describe "VERSION" do
    it "should be a string" do
      CsvPirate::VERSION.class.should == String
    end
  end
  describe "MAJOR" do
    it "should be a string" do
      CsvPirate::MAJOR.class.should == Fixnum
      CsvPirate::MAJOR.should_not == ''
    end
  end
  describe "MINOR" do
    it "should be a string" do
      CsvPirate::MINOR.class.should == Fixnum
      CsvPirate::MINOR.should_not == ''
    end
  end
  describe "PATCH" do
    it "should be a string" do
      CsvPirate::PATCH.class.should == Fixnum
      CsvPirate::PATCH.should_not == ''
    end
  end
  describe "BUILD" do
    it "should be a string" do
      [String, NilClass].include?(CsvPirate::BUILD.class).should == true
    end
  end

end
