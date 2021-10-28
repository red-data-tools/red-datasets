require "csv"
require "zip"

require_relative "dataset"

module Datasets
  class PostalCodeJapan < Dataset
    class Record < Struct.new(:organization_code,
                              :old_postal_code,
                              :postal_code,
                              :prefecture_reading,
                              :city_reading,
                              :address_reading,
                              :prefecture,
                              :city,
                              :address,
                              :have_multiple_postal_codes,
                              :have_address_number_per_koaza,
                              :have_chome,
                              :postal_code_is_shared,
                              :changed,
                              :change_reason)
      alias_method :have_multiple_postal_codes?,
                   :have_multiple_postal_codes
      alias_method :have_address_number_per_koaza?,
                   :have_address_number_per_koaza
      alias_method :have_chome?,
                   :have_chome
      alias_method :postal_code_is_shared?,
                   :postal_code_is_shared
      alias_method :changed?,
                   :changed
    end

    VALID_READINGS = [
      :lowercase,
      :uppercase,
      :romaji,
    ]
    def initialize(reading: :lowercase)
      super()
      @reading = reading
      unless VALID_READINGS.include?(@reading)
        message = ":reading must be one of ["
        message << VALID_READINGS.collect(&:inspect).join(", ")
        message << "]: #{@reading.inspect}"
        raise ArgumentError, message
      end
      @metadata.id = "postal-code-japan-#{@reading}"
      @metadata.name = "Postal code in Japan (#{@reading})"
      @metadata.url = "https://www.post.japanpost.jp/zipcode/download.html"
      @metadata.licenses = ["CC0-1.0"]
      @metadata.description = "Postal code in Japan (reading: #{@reading})"
    end

    def each(&block)
      return to_enum(__method__) unless block_given?

      open_data do |input|
        utf8_data = input.read.encode(Encoding::UTF_8, Encoding::CP932)
        options = {
          quote_char: nil,
          strip: %Q["],
        }
        if @reading == :romaji
          CSV.parse(utf8_data, **options) do |row|
            yield(Record.new(nil,
                             nil,
                             row[0],
                             row[4],
                             row[5],
                             row[6],
                             row[1],
                             row[2],
                             row[3],
                             false,
                             false,
                             false,
                             false,
                             false,
                             nil))
          end
        else
          CSV.parse(utf8_data, **options) do |row|
            yield(Record.new(row[0],
                             row[1].rstrip,
                             row[2],
                             row[3],
                             row[4],
                             row[5],
                             row[6],
                             row[7],
                             row[8],
                             (row[9] == "1"),
                             (row[10] == "1"),
                             (row[11] == "1"),
                             (row[12] == "1"),
                             (row[13] != "0"),
                             convert_change_reason(row[14])))
          end
        end
      end
    end

    private
    def open_data
      data_url = "https://www.post.japanpost.jp/zipcode/dl"
      case @reading
      when :lowercase
        data_url << "/kogaki/zip/ken_all.zip"
      when :uppercase
        data_url << "/oogaki/zip/ken_all.zip"
      when :romaji
        data_url << "/roman/ken_all_rome.zip"
      end
      data_path = cache_dir_path + "#{@reading}-ken-all.zip"
      download(data_path, data_url)

      Zip::File.open(data_path.to_s) do |zip_file|
        zip_file.each do |entry|
          next unless entry.file?
          entry.get_input_stream do |input|
            yield(input)
          end
        end
      end
    end

    def convert_change_reason(reason)
      case reason
      when "0"
        nil
      when "1"
        :new
      when "2"
        :japanese_addressing_system
      when "3"
        :land_readjustment
      when "4"
        :postal_district_adjustment
      when "5"
        :correction
      when "6"
        :deletion
      else
        :unknown
      end
    end
  end
end
