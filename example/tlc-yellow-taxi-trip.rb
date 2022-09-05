#!/usr/bin/env ruby

require "datasets"

trips = Datasets::TLC::YellowTaxiTrip.new(year: 2022, month: 1)
trips.each do |trip|
  p [
      trip.vendor,
      trip.tpep_pickup_datetime,
      trip.tpep_dropoff_datetime,
      trip.passenger_count,
      trip.trip_distance,
      trip.rate_code,
      trip.store_and_fwd?,
      trip.pu_location_id,
      trip.do_location_id,
      trip.payment,
      trip.fare_amount,
      trip.extra,
      trip.mta_tax,
      trip.tip_amount,
      trip.tolls_amount,
      trip.improvement_surcharge,
      trip.total_amount,
      trip.congestion_surcharge,
      trip.airport_fee
  ]
  # [:creative_mobile_technologies, 2022-01-01 09:35:40 +0900, 2022-01-01 09:53:29 +0900, 2.0, 3.8, :standard_rate, false, 142, 236, :credit_card, 14.5, 3.0, 0.5, 3.65, 0.0, 0.3, 21.95, 2.5, 0.0]
  # [:creative_mobile_technologies, 2022-01-01 09:33:43 +0900, 2022-01-01 09:42:07 +0900, 1.0, 2.1, :standard_rate, false, 236, 42, :credit_card, 8.0, 0.5, 0.5, 4.0, 0.0, 0.3, 13.3, 0.0, 0.0]
end
