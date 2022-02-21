require "csv"

require_relative "dataset"
require "rubygems/package"
require "zlib"

module Datasets
  class CaliforniaHousing < Dataset
    Record = Struct.new(:longitude,
                        :latitude,
                        :housingMedianAge,
                        :totalRooms,
                        :totalBedrooms,
                        :population,
                        :households,
                        :medianIncome,
                        :medianHouseValue)

    def initialize
      super()
      @metadata.id = "california-housing"
      @metadata.name = "California Housing"
      @metadata.url = "https://www.dcc.fc.up.pt/~ltorgo/Regression/cal_housing.html"
      @metadata.licenses = ["Unknown"]
      @metadata.description =  <<~DESCRIPTION
Housing information from the 1990 census used in
Pace, R. Kelley and Ronald Barry,
"Sparse Spatial Autoregressions",
Statistics and Probability Letters, 33 (1997) 291-297.
      DESCRIPTION
    end

    def each
      return to_enum(__method__) unless block_given?

      data_path = cache_dir_path + "cal_housing.tgz"
      data_url = "https://www.dcc.fc.up.pt/~ltorgo/Regression/cal_housing.tgz"
      file_name = "CaliforniaHousing/cal_housing.data"
      download(data_path, data_url)
      open_data(data_path, file_name) do |csv|
        csv.each do |row|
          next if row[0].nil?
          record = Record.new(*row)
          yield(record)
        end
      end
    end

    private
    def open_data(data_path, file_name)
      File.open(data_path) do |file|
        Zlib::GzipReader.open(file) do |gz|
          Gem::Package::TarReader.new(gz) do |tar|
            tar.each do |entry|
              if entry.header.name == file_name
                yield CSV.parse(entry.read, converters: [:numeric])
              end
            end
          end
        end
      end
    end
  end
end
