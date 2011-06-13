module CsvPirate

#  @@conf = YAML::load( File.read('VERSION.yaml') )

#  MAJOR = @@conf[:major]
#  MINOR = @@conf[:minor]
#  PATCH = @@conf[:patch]
#  BUILD = @@conf[:build]

  MAJOR = 5
  MINOR = 0
  PATCH = 0
  BUILD = 0


  STRING = [MAJOR, MINOR, PATCH, BUILD].compact.join('.')
end
