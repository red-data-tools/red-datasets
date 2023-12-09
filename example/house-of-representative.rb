#!/usr/bin/env ruby

require "datasets"

house_of_representative = Datasets::HouseOfRepresentative.new
house_of_representative.each do |record|
  # Select support of one hundred or more members and promulgated
  next unless 100 <= record.supporters_of_submitted_bill.size
  next if record.promulgated_on_and_law_number == "／"

  p [
      record.supporters_of_submitted_bill.size,
      record.promulgated_on_and_law_number,
      record.title,
    ]
end
