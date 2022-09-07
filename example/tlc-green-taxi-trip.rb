#!/usr/bin/env ruby

require "datasets"

trips = Datasets::TLC::GreenTaxiTrip.new(year: 2022, month: 1)
trips.each do |trip|
  p [
      trip.vendor,
      trip.lpep_pickup_datetime,
      trip.lpep_dropoff_datetime,
      trip.store_and_fwd?,
      trip.rate_code,
      trip.pu_location_id,
      trip.do_location_id,
      trip.passenger_count,
      trip.trip_distance,
      trip.fare_amount,
      trip.extra,
      trip.mta_tax,
      trip.tip_amount,
      trip.tolls_amount,
      trip.ehail_fee,
      trip.improvement_surcharge,
      trip.total_amount,
      trip.payment,
      trip.trip,
      trip.congestion_surcharge,
  ]
  # [:veri_fone_inc, 2022-01-01 09:14:21 +0900, 2022-01-01 09:15:33 +0900, false, :standard_rate, 42, 42, 1.0, 0.44, 3.5, 0.5, 0.5, 0.0, 0.0, nil, 0.3, 4.8, :cash, :street_hail, 0.0]
  # [:creative_mobile_technologies, 2022-01-01 09:20:55 +0900, 2022-01-01 09:29:38 +0900, false, :standard_rate, 116, 41, 1.0, 2.1, 9.5, 0.5, 0.5, 0.0, 0.0, nil, 0.3, 10.8, :cash, :street_hail, 0.0]
end
