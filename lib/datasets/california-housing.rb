require "csv"
require_relative 'zip-extractor'

module Datasets
  class CaliforniaHousing < Dataset
    Record = Struct.new(:median_house_value,
                        :median_income,
                        :housing_median_age,
                        :total_rooms,
                        :total_bedrooms,
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
      @metadata.description = <<-DESCRIPTION
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
        data = ""
        input.each_line do |line|
          next unless line.start_with?(" ")
          data << line.lstrip.gsub(/ +/, ",")
        end
        options = {
          converters: [:numeric],
        }
        CSV.parse(data, **options) do |row|
          yield(Record.new(*row))
        end
      end
    end

    private
    def open_data(data_path, file_name)
      ZipExtractor.new(data_path).extract_first_file do |input|
        yield input
      end
    end
  end
end
