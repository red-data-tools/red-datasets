#!/usr/bin/env ruby
require "datasets"

diamonds = Datasets::Diamonds.new

diamonds.each do |record|
  p [
     record.color,
     record.carat,
     record.price,
  ]
end

#  ["H", 0.86, 2757]
#  ["D", 0.75, 2757]

