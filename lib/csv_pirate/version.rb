module CsvPirate

  VERSION = "5.0.6.pre1"

  VERSION_ARRAY = VERSION.split('.')

  MAJOR = VERSION_ARRAY[0].to_i
  MINOR = VERSION_ARRAY[2].to_i
  PATCH = VERSION_ARRAY[3].to_i
  BUILD = VERSION_ARRAY[4]

end
