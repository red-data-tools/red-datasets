#!/usr/bin/env ruby

require "datasets"

fuel_economy = Datasets::FuelEconomy.new

fuel_economy.each do |record|
  p [
     record.manufacturer,
     record.model,
     record.displacement,
     record.year,
     record.n_cylinders,
     record.transmission,
     record.drive_train,
     record.city_mpg,
     record.highway_mpg,
     record.fuel,
     record.type,
  ]
  # ["audi", "a4", 1.8, 1999, 4, "auto(l5)", "f", 18, 29, "p", "compact"]
  # ["audi", "a4", 1.8, 1999, 4, "manual(m5)", "f", 21, 29, "p", "compact"]
  # ...
end
