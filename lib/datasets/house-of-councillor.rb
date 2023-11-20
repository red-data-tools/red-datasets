require_relative "dataset"

module Datasets
  class HouseOfCouncillor < Dataset
    Record = Struct.new(:professional_name,
                        :true_name,
                        :profile_url,
                        :professional_name_reading,
                        :in_house_group_abbreviation,
                        :constituency,
                        :expiration_of_term,
                        :photo_url,
                        :elected_years,
                        :elected_number,
                        :responsibilities,
                        :responsibility_on,
                        :career,
                        :career_on)

    def initialize
      super
      @metadata.id = "house-of-councillor"
      @metadata.name = "Bill of the House of Councillors of Japan"
      @metadata.url = "https://smartnews-smri.github.io/house-of-councillors"
      @metadata.licenses = ["MIT"]
      @metadata.description = "Bill of the House of Councillors of Japan"
    end

    def each
      return to_enum(__method__) unless block_given?

      open_data do |csv|
        csv.each do |row|
          record = Record.new(*row.fields)
          yield(record)
        end
      end
    end

    private

    def open_data
      data_path = cache_dir_path + "giin.csv"
      data_url = "https://smartnews-smri.github.io/house-of-councillors/data/giin.csv"
      download(data_path, data_url)
      CSV.open(data_path, col_sep: ",", headers: true, converters: %i(date integer)) do |csv|
        yield(csv)
      end
    end
  end
end
