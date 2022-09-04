require "parquet"
require_relative "../dataset"

module Datasets
  module TLC
    class YellowTaxiTrip < Dataset
      class Record < Struct.new(:vendor,
                                :tpep_pickup_datetime,
                                :tpep_dropoff_datetime,
                                :passenger_count,
                                :trip_distance,
                                :rate_code,
                                :store_and_fwd,
                                :pu_location_id,
                                :do_location_id,
                                :payment,
                                :fare_amount,
                                :extra,
                                :mta_tax,
                                :tip_amount,
                                :tolls_amount,
                                :improvement_surcharge,
                                :total_amount,
                                :congestion_surcharge,
                                :airport_fee)
        alias_method :store_and_fwd?, :store_and_fwd

        def initialize(*values)
          super()
          members.zip(values) do |member, value|
            __send__("#{member}=", value)
          end
        end

        def vendor=(vendor)
          super(vendor == 1 ? :creative_mobile_technologies : :veri_fone_inc)
        end

        def rate_code=(rate_code)
          case rate_code
          when 1.0
            super(:standard_rate)
          when 2.0
            super(:jfk)
          when 3.0
            super(:newark)
          when 4.0
            super(:Nassau_or_westchester)
          when 5.0
            super(:negotiated_fare)
          when 6.0
            super(:group_ride)
          end
        end

        def store_and_fwd=(store_and_fwd)
          super(store_and_fwd === 'Y')
        end

        def payment=(payment)
          case payment
          when 1
            super(:credit_card)
          when 2
            super(:cash)
          when 3
            super(:no_charge)
          when 4
            super(:dispute)
          when 5
            super(:unknown)
          when 6
            super(:voided_trip)
          end
        end
      end

      def initialize(year: Date.today.year, month: Date.today.month)
        super()
        @metadata.id = "nyc-taxi-and-limousine-commission-trip-yello-taxi"
        @metadata.name = "New York city's taxi and limousine commission trip yellow taxi record dataset"
        @metadata.url = "https://d37ci6vzurychx.cloudfront.net/trip-data"
        @metadata.licenses = [
          {
            name: "Public",
            url: "https://opendata.cityofnewyork.us/open-data-law/",
          }
        ]
        @year = format("%04d", year)
        @month = format("%02d", month)
      end

      def each
        return to_enum(__method__) unless block_given?

        open_data.raw_records.each do |raw_record|
          record = Record.new(*raw_record)
          yield(record)
        end
      end

      private
      def open_data
        file_name = "yellow_tripdata_#{@year}-#{@month}.parquet"
        data_path = cache_dir_path + file_name
        data_url = "https://d37ci6vzurychx.cloudfront.net/trip-data/#{file_name}"
        download(data_path, data_url)
        Arrow::Table.load(data_path)
      end
    end
  end
end
