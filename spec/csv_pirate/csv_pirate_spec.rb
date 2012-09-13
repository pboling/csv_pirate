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

  describe "#new" do
    it "should support the old < v5 syntax" do
      # Similar to example from the readme
      CsvPirate.new({
        :swag => [Struct.new(:first_name, :last_name, :birthday).new('Joe','Smith','12/24/1805')],
        :waggoner => 'active_users_logged_in',
        :booty => [:first_name, :last_name],
        :chart => ['log','csv']
      }).class.should == CsvPirate::TheCapn
    end
  end

  describe "#create" do
    it "should support the old < v5 syntax" do
      # Similar to example from the readme
      CsvPirate.create({
        :swag => [Struct.new(:first_name, :last_name, :birthday).new('Joe','Smith','12/24/1805')],
        :waggoner => 'active_users_logged_in',
        :booty => [:first_name, :last_name],
        :chart => ['log','csv']
      }).class.should == CsvPirate::TheCapn
    end
  end

end
