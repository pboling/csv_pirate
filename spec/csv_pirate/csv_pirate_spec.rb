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

  describe "support the old < v5 syntax" do
    # Mapping needs to be a separate test, because testing the method call mocks the object, and breaks the actual #new
    describe "#new mapping" do
      it "should map to CsvPirate::TheCapn.new" do
        CsvPirate::TheCapn.should_receive(:new)
        # Similar to old example from the v5 readme
        @csv_pirate = CsvPirate.new({
          :swag => [Struct.new(:first_name, :last_name, :birthday).new('Joe','Smith','12/24/1805')],
          :waggoner => 'active_users_logged_in',
          :booty => [:first_name, :last_name],
          :chart => ['log','csv'],
          :bury_treasure => true,
        })
      end
    end
    describe "#new" do
      before(:each) do
        # Similar to old example from the v5 readme
        @csv_pirate = CsvPirate.new({
          :swag => [Struct.new(:first_name, :last_name, :birthday).new('Joe','Smith','12/24/1805')],
          :waggoner => 'active_users_logged_in',
          :booty => [:first_name, :last_name],
          :chart => ['log','csv'],
          :bury_treasure => true,
        })
      end
      it "should create an instance of CsvPirate::TheCapn" do
        @csv_pirate.class.should == CsvPirate::TheCapn
      end
      it "should NOT mine the data" do
        @csv_pirate.buried_treasure.length.should == 0
      end
    end

    # Mapping needs to be a separate test, because testing the method call mocks the object, and breaks the actual #new
    describe "#create mapping" do
      it "should map to CsvPirate::TheCapn.create" do
        CsvPirate::TheCapn.should_receive(:create)
        # Similar to old example from the v5 readme
        @csv_pirate = CsvPirate.create({
                                      :swag => [Struct.new(:first_name, :last_name, :birthday).new('Joe','Smith','12/24/1805')],
                                      :waggoner => 'active_users_logged_in',
                                      :booty => [:first_name, :last_name],
                                      :chart => ['log','csv'],
                                      :bury_treasure => true,
                                    })
      end
    end
    describe "#create" do
      before(:each) do
        # Similar to old example from the v5 readme
        @csv_pirate = CsvPirate.create({
          :swag => [Struct.new(:first_name, :last_name, :birthday).new('Joe','Smith','12/24/1805')],
          :waggoner => 'active_users_logged_in',
          :booty => [:first_name, :last_name],
          :chart => ['log','csv'],
          :bury_treasure => true,
        })
      end
      it "should create an instance of CsvPirate::TheCapn" do
        @csv_pirate.class.should == CsvPirate::TheCapn
      end
      it "should mine the data" do
        @csv_pirate.buried_treasure.length.should == 1
      end
    end
  end

end
