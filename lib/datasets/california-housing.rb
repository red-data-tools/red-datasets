require "csv"
require "zip"

require_relative "dataset"
require "rubygems/package"

module Datasets
  class CaliforniaHousing < Dataset
    Record = Struct.new(:medianHouseValue,
                        :medianIncome,
                        :housingMedianAge,
                        :totalRooms,
                        :totalBedrooms,
                        :population,
                        :households,
                        :latitude,
                        :longitude)

    def initialize
      super()
      @metadata.id = "california-housing"
      @metadata.name = "California Housing"
      @metadata.url = "http://lib.stat.cmu.edu/datasets/"
      @metadata.licenses = ["CCO"]
      @metadata.description =  <<~DESCRIPTION
Housing information from the 1990 census used in
Pace, R. Kelley and Ronald Barry,
"Sparse Spatial Autoregressions",
Statistics and Probability Letters, 33 (1997) 291-297.
Available from http://lib.stat.cmu.edu/datasets/.
      DESCRIPTION
    end

    def each
      return to_enum(__method__) unless block_given?

      data_path = cache_dir_path + "houses.zip"
      data_url = "http://lib.stat.cmu.edu/datasets/houses.zip"
      file_name = "cadata.txt"
      download(data_path, data_url)
      open_data(data_path, file_name) do |input|
        input.each_with_index do |line, id|
          if id > 26
            options = {
              converters: [:numeric],
            }
            row = CSV.parse(line[2..-1].gsub(/\s+/,","),**options)
            record = Record.new(row[0][0],
                                row[0][1],
                                row[0][2],
                                row[0][3],
                                row[0][4],
                                row[0][5],
                                row[0][6],
                                row[0][7],
                                row[0][8])
            yield(record)
          end
        end
      end
    end

    private
    def open_data(data_path, file_name)
      Zip::File.open(data_path) do |zip_file|
        yield zip_file.get_input_stream(file_name)
      end
    end
  end
end
