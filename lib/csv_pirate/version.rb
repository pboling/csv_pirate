module CsvPirate

  @@conf = YAML::load( File.read( File.absolute_path('VERSION.yml') ) )

  MAJOR = @@conf[:major]
  MINOR = @@conf[:minor]
  PATCH = @@conf[:patch]
  BUILD = @@conf[:build]

  VERSION = [MAJOR, MINOR, PATCH, BUILD].compact.join('.')
end
