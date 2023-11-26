#!/usr/bin/env ruby

require "datasets"

# Bill
house_of_councillor = Datasets::HouseOfCouncillor.new
house_of_councillor.each do |record|
  # Select promulgated after 2020
  next unless 2020 <= record.promulgated_on&.year.to_i

  p record.promulgated_on, record.values
end

# In-House group
house_of_councillor = Datasets::HouseOfCouncillor.new(type: :in_house_group)
house_of_councillor.each do |record|
  p record.values
end

# Member
house_of_councillor = Datasets::HouseOfCouncillor.new(type: :member)
house_of_councillor.each do |record|
  # Select using professional name
  next if record.true_name.nil?

  p [
      record.professional_name,
      record.true_name,
      record.professional_name_reading,
    ]
end
