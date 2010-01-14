class GlowingGasBall
  
  attr_accessor :name, :distance, :spectral_type

  def initialize(*args)
    @name = args.first[:name]
    @distance = args.first[:distance]
    @spectral_type = args.first[:spectral_type]
  end

  def star_vowels
    self.name.tr('aeiou', '*')
  end

  def self.get_stars
    [
    Star.new(:name => "Proxima Centauri", :distance => "4.2 LY", :spectral_type => "M5.5Vc"),
    Star.new(:name => "Rigil Kentaurus", :distance => "4.3 LY", :spectral_type => "G2V"),
    Star.new(:name => "Barnard's Star", :distance => "5.9 LY", :spectral_type => "M3.8V"),
    Star.new(:name => "Wolf 359", :distance => "7.7 LY", :spectral_type => "M5.8Vc"),
    Star.new(:name => "Lalande 21185", :distance => "8.26 LY", :spectral_type => "M2V"),
    Star.new(:name => "Luyten 726-8A and B", :distance => "8.73 LY", :spectral_type => "M5.5 de & M6 Ve"),
    Star.new(:name => "Sirius A and B", :distance => "8.6 LY", :spectral_type => "A1Vm"),
    Star.new(:name => "Ross 154", :distance => "9.693 LY", :spectral_type => "M3.5"),
    Star.new(:name => "Ross 248", :distance => "10.32 LY", :spectral_type => "M5.5V"),
    Star.new(:name => "Epsilon Eridani", :distance => "10.5 LY", :spectral_type => "K2V")
    ]
  end
  
end
