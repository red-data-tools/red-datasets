module Datasets
  class SeabornData < Dataset
    URL_FORMAT = "https://raw.githubusercontent.com/mwaskom/seaborn-data/master/%{name}.csv".freeze

    def initialize(name)
      super()
      @metadata.id = "seaborn-data-#{name}"
      @metadata.name = "SeabornData: #{name}"
      @metadata.url = URL_FORMAT % {name: name}

      @data_path = cache_dir_path + (name + ".csv")
      @name = name
    end

    def each(&block)
      return to_enum(__method__) unless block_given?

      download(@data_path, @metadata.url)
      CSV.open(@data_path, headers: :first_row, converters: :all) do |csv|
        csv.each do |row|
          record = prepare_record(row)
          yield record
        end
      end
    end

    private
    def prepare_record(csv_row)
      record = csv_row.to_h
      record.transform_keys!(&:to_sym)

      # Perform the same preprocessing as seaborn's load_dataset function
      preprocessor = :"preprocess_#{@name}_record"
      __send__(preprocessor, record) if respond_to?(preprocessor, true)

      record
    end

    # The same preprocessing as seaborn.load_dataset
    def preprocess_flights_record(record)
      record[:month] &&= record[:month][0,3]
    end

    # The same preprocessing as seaborn.load_dataset
    def preprocess_penguins_record(record)
      record[:sex] &&= record[:sex].capitalize
    end
  end
end
