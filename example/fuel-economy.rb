#!/usr/bin/env ruby
require "datasets"

diamonds = Datasets::FuelEconomy.new

diamonds.each do |record|
  p [
     record.manufacturer,
     record.model,
     record.trans,
     record.cty,
     record.hwy
  ]
end

#  ["audi", "a4", "auto(l5)", 18, 29]
#  ["audi", "a4", "manual(m5)", 21, 29]

