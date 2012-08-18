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

  def sub_name(old_letter, new_letter)
    name.gsub(old_letter, new_letter)
  end

  def self.get_stars
    [
    GlowingGasBall.new(:name => "Proxima Centauri", :distance => "4.2 LY", :spectral_type => "M5.5Vc"),
    GlowingGasBall.new(:name => "Rigil Kentaurus", :distance => "4.3 LY", :spectral_type => "G2V"),
    GlowingGasBall.new(:name => "Barnard's Star", :distance => "5.9 LY", :spectral_type => "M3.8V"),
    GlowingGasBall.new(:name => "Wolf 359", :distance => "7.7 LY", :spectral_type => "M5.8Vc"),
    GlowingGasBall.new(:name => "Lalande 21185", :distance => "8.26 LY", :spectral_type => "M2V"),
    GlowingGasBall.new(:name => "Luyten 726-8A and B", :distance => "8.73 LY", :spectral_type => "M5.5 de & M6 Ve"),
    GlowingGasBall.new(:name => "Sirius A and B", :distance => "8.6 LY", :spectral_type => "A1Vm"),
    GlowingGasBall.new(:name => "Ross 154", :distance => "9.693 LY", :spectral_type => "M3.5"),
    GlowingGasBall.new(:name => "Ross 248", :distance => "10.32 LY", :spectral_type => "M5.5V"),
    GlowingGasBall.new(:name => "Epsilon Eridani", :distance => "10.5 LY", :spectral_type => "K2V")
    ]
  end
  
end
