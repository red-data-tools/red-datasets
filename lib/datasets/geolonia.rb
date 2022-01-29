require 'csv'

require_relative 'dataset'

module Datasets
  class Geolonia < Dataset
    Record = Struct.new(:prefecture_code,
                        :prefecture_name,
                        :prefecture_kana,
                        :prefecture_romaji,
                        :municipality_code,
                        :municipality_name,
                        :municipality_kana,
                        :municipality_romaji,
                        :street_name,
                        :street_kana,
                        :street_romaji,
                        :alias,
                        :latitude,
                        :longitude)

    def initialize
      super
      @metadata.id = 'geolonia'
      @metadata.name = 'Geolonia'
      @metadata.url = 'https://github.com/geolonia/japanese-addresses'
      @metadata.licenses = ["CC-BY-4.0"]
      @metadata.description = <<~DESCRIPTION
    DESCRIPTION
    end

    def each
      return to_enum(__method__) unless block_given?

      open_data do |csv|
        csv.readline
        csv.each do |row|
          record = Record.new(*row)
          yield(record)
        end
      end
    end

    private

    def open_data
      data_path = cache_dir_path + 'latest.csv'
      data_url = 'https://raw.githubusercontent.com/geolonia/japanese-addresses/develop/data/latest.csv'
      download(data_path, data_url)
      CSV.open(data_path) do |csv|
        yield(csv)
      end
    end
  end
end
