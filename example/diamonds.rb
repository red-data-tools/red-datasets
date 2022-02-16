#!/usr/bin/env ruby

require "datasets"

diamonds = Datasets::Diamonds.new

diamonds.each do |record|
  p [
     record.carat,
     record.cut,
     record.color,
     record.clarity,
     record.depth,
     record.table,
     record.price,
     record.x,
     record.y,
     record.z,
  ]
  # [0.23, "Ideal", "E", "SI2", 61.5, 55, 326, 3.95, 3.98, 2.43]
  # [0.21, "Premium", "E", "SI1", 59.8, 61, 326, 3.89, 3.84, 2.31]
  # ...
end
