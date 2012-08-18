module CsvPirate
  class Railtie < Rails::Railtie
    config.before_initialize do
      ActiveRecord::Base.send(:extend, CsvPirate::PirateShip::ActMethods)
    end
  end
end
