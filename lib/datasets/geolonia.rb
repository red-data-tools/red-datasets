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
      @metadata.description = lambda do
        fetch_readme
      end
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
    def download_base_url
      "https://raw.githubusercontent.com/geolonia/japanese-addresses/master"
    end

    def open_data
      data_path = cache_dir_path + 'latest.csv'
      data_url = "#{download_base_url}/data/latest.csv"
      download(data_path, data_url)
      CSV.open(data_path) do |csv|
        yield(csv)
      end
    end

    def fetch_readme
      readme_base_name = "README.md"
      readme_path = cache_dir_path + readme_base_name
      readme_url = "#{download_base_url}/#{readme_base_name}"
      download(readme_path, readme_url)
      readme_path.read.split(/^## API/, 2)[0].strip
    end
  end
end
