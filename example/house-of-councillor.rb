#!/usr/bin/env ruby

require "datasets"

house_of_councillor = Datasets::HouseOfCouncillor.new
house_of_councillor.each do |record|
  # Select using professional name
  next if record.true_name.nil?

  p [
      record.professional_name,
      record.true_name,
      record.professional_name_reading,
    ]
end
