require_relative "dataset"

module Datasets
  class HouseOfCouncillor < Dataset
    Member = Struct.new(:professional_name,
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

    VALID_TYPES = [
      :member,
    ]

    def initialize(type: :member)
      super()
      @type = type
      unless VALID_TYPES.include?(type)
        message = ":type must be one of ["
        message << VALID_TYPES.collect(&:inspect).join(",")
        message << "]: #{@type.inspect}"
        raise ArgumentError, message
      end

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
          case @type
          when :member
            record = Member.new(*row.fields)
          end
          yield(record)
        end
      end
    end

    private

    def open_data
      data_url = "https://smartnews-smri.github.io/house-of-councillors/data"
      case @type
      when :member
        data_url << "/giin.csv"
      end
      data_path = cache_dir_path + "#{@type}.csv"
      download(data_path, data_url)

      CSV.open(data_path, col_sep: ",", headers: true, converters: %i(date integer)) do |csv|
        yield(csv)
      end
    end
  end
end
