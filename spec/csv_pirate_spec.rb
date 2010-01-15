require File.dirname(__FILE__) + '/spec_helper'

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
      @csv_pirate.maroon.should == "Name,Distance,Spectral type,Name hash,Name next,Name upcase,Star vowels\nProxima Centauri,4.2 LY,M5.5Vc,-1176188012,Proxima Centaurj,PROXIMA CENTAURI,Pr*x*m* C*nt**r*\nRigil Kentaurus,4.3 LY,G2V,1916094624,Rigil Kentaurut,RIGIL KENTAURUS,R*g*l K*nt**r*s\nBarnard's Star,5.9 LY,M3.8V,1003964756,Barnard's Stas,BARNARD'S STAR,B*rn*rd's St*r\nWolf 359,7.7 LY,M5.8Vc,-1717989858,Wolf 360,WOLF 359,W*lf 359\nLalande 21185,8.26 LY,M2V,466625069,Lalande 21186,LALANDE 21185,L*l*nd* 21185\nLuyten 726-8A and B,8.73 LY,M5.5 de & M6 Ve,1260790153,Luyten 726-8A and C,LUYTEN 726-8A AND B,L*yt*n 726-8A *nd B\nSirius A and B,8.6 LY,A1Vm,1177502705,Sirius A and C,SIRIUS A AND B,S*r**s A *nd B\nRoss 154,9.693 LY,M3.5,2120976706,Ross 155,ROSS 154,R*ss 154\nRoss 248,10.32 LY,M5.5V,2129428738,Ross 249,ROSS 248,R*ss 248\nEpsilon Eridani,10.5 LY,K2V,931307088,Epsilon Eridanj,EPSILON ERIDANI,Eps*l*n Er*d*n*\n"
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
      @csv_pirate.hoist_mainstay.should == "Name,Distance,Spectral type,Name hash,Name next,Name upcase,Star vowels\nProxima Centauri,4.2 LY,M5.5Vc,-1176188012,Proxima Centaurj,PROXIMA CENTAURI,Pr*x*m* C*nt**r*\nRigil Kentaurus,4.3 LY,G2V,1916094624,Rigil Kentaurut,RIGIL KENTAURUS,R*g*l K*nt**r*s\nBarnard's Star,5.9 LY,M3.8V,1003964756,Barnard's Stas,BARNARD'S STAR,B*rn*rd's St*r\nWolf 359,7.7 LY,M5.8Vc,-1717989858,Wolf 360,WOLF 359,W*lf 359\nLalande 21185,8.26 LY,M2V,466625069,Lalande 21186,LALANDE 21185,L*l*nd* 21185\nLuyten 726-8A and B,8.73 LY,M5.5 de & M6 Ve,1260790153,Luyten 726-8A and C,LUYTEN 726-8A AND B,L*yt*n 726-8A *nd B\nSirius A and B,8.6 LY,A1Vm,1177502705,Sirius A and C,SIRIUS A AND B,S*r**s A *nd B\nRoss 154,9.693 LY,M3.5,2120976706,Ross 155,ROSS 154,R*ss 154\nRoss 248,10.32 LY,M5.5V,2129428738,Ross 249,ROSS 248,R*ss 248\nEpsilon Eridani,10.5 LY,K2V,931307088,Epsilon Eridanj,EPSILON ERIDANI,Eps*l*n Er*d*n*\n"
    end

    it "should store export in maroon instance variable" do
      @csv_pirate.maroon.should == ""
      @csv_pirate.hoist_mainstay
      @csv_pirate.maroon.should == "Name,Distance,Spectral type,Name hash,Name next,Name upcase,Star vowels\nProxima Centauri,4.2 LY,M5.5Vc,-1176188012,Proxima Centaurj,PROXIMA CENTAURI,Pr*x*m* C*nt**r*\nRigil Kentaurus,4.3 LY,G2V,1916094624,Rigil Kentaurut,RIGIL KENTAURUS,R*g*l K*nt**r*s\nBarnard's Star,5.9 LY,M3.8V,1003964756,Barnard's Stas,BARNARD'S STAR,B*rn*rd's St*r\nWolf 359,7.7 LY,M5.8Vc,-1717989858,Wolf 360,WOLF 359,W*lf 359\nLalande 21185,8.26 LY,M2V,466625069,Lalande 21186,LALANDE 21185,L*l*nd* 21185\nLuyten 726-8A and B,8.73 LY,M5.5 de & M6 Ve,1260790153,Luyten 726-8A and C,LUYTEN 726-8A AND B,L*yt*n 726-8A *nd B\nSirius A and B,8.6 LY,A1Vm,1177502705,Sirius A and C,SIRIUS A AND B,S*r**s A *nd B\nRoss 154,9.693 LY,M3.5,2120976706,Ross 155,ROSS 154,R*ss 154\nRoss 248,10.32 LY,M5.5V,2129428738,Ross 249,ROSS 248,R*ss 248\nEpsilon Eridani,10.5 LY,K2V,931307088,Epsilon Eridanj,EPSILON ERIDANI,Eps*l*n Er*d*n*\n"
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
      @csv_pirate.maroon.should == "Name,Distance,Spectral type,Name hash,Name next,Name upcase,Star vowels\nProxima Centauri,4.2 LY,M5.5Vc,-1176188012,Proxima Centaurj,PROXIMA CENTAURI,Pr*x*m* C*nt**r*\nRigil Kentaurus,4.3 LY,G2V,1916094624,Rigil Kentaurut,RIGIL KENTAURUS,R*g*l K*nt**r*s\nBarnard's Star,5.9 LY,M3.8V,1003964756,Barnard's Stas,BARNARD'S STAR,B*rn*rd's St*r\nWolf 359,7.7 LY,M5.8Vc,-1717989858,Wolf 360,WOLF 359,W*lf 359\nLalande 21185,8.26 LY,M2V,466625069,Lalande 21186,LALANDE 21185,L*l*nd* 21185\nLuyten 726-8A and B,8.73 LY,M5.5 de & M6 Ve,1260790153,Luyten 726-8A and C,LUYTEN 726-8A AND B,L*yt*n 726-8A *nd B\nSirius A and B,8.6 LY,A1Vm,1177502705,Sirius A and C,SIRIUS A AND B,S*r**s A *nd B\nRoss 154,9.693 LY,M3.5,2120976706,Ross 155,ROSS 154,R*ss 154\nRoss 248,10.32 LY,M5.5V,2129428738,Ross 249,ROSS 248,R*ss 248\nEpsilon Eridani,10.5 LY,K2V,931307088,Epsilon Eridanj,EPSILON ERIDANI,Eps*l*n Er*d*n*\n"
    end

    it "should work as {:join => '_'}" do
      @csv_pirate.blackjack = {:join => '_'}
      @csv_pirate.blackjack.should == {:join => '_'}
      @csv_pirate.hoist_mainstay
      @csv_pirate.maroon.should == "name,distance,spectral_type,name_hash,name_next,name_upcase,star_vowels\nProxima Centauri,4.2 LY,M5.5Vc,-1176188012,Proxima Centaurj,PROXIMA CENTAURI,Pr*x*m* C*nt**r*\nRigil Kentaurus,4.3 LY,G2V,1916094624,Rigil Kentaurut,RIGIL KENTAURUS,R*g*l K*nt**r*s\nBarnard's Star,5.9 LY,M3.8V,1003964756,Barnard's Stas,BARNARD'S STAR,B*rn*rd's St*r\nWolf 359,7.7 LY,M5.8Vc,-1717989858,Wolf 360,WOLF 359,W*lf 359\nLalande 21185,8.26 LY,M2V,466625069,Lalande 21186,LALANDE 21185,L*l*nd* 21185\nLuyten 726-8A and B,8.73 LY,M5.5 de & M6 Ve,1260790153,Luyten 726-8A and C,LUYTEN 726-8A AND B,L*yt*n 726-8A *nd B\nSirius A and B,8.6 LY,A1Vm,1177502705,Sirius A and C,SIRIUS A AND B,S*r**s A *nd B\nRoss 154,9.693 LY,M3.5,2120976706,Ross 155,ROSS 154,R*ss 154\nRoss 248,10.32 LY,M5.5V,2129428738,Ross 249,ROSS 248,R*ss 248\nEpsilon Eridani,10.5 LY,K2V,931307088,Epsilon Eridanj,EPSILON ERIDANI,Eps*l*n Er*d*n*\n"
    end
  end

end
