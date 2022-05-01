require "json"

module Datasets
  class SeabornList < Dataset
    def initialize
      super
      @metadata.id = "seaborn-data-list"
      @metadata.name = "seaborn: data list"
      @metadata.url = "https://github.com/mwaskom/seaborn-data"
      # Treat as the same license as seaborn
      @metadata.licenses = ["BSD-3-Clause"]
      @metadata.description = "Datasets for seaborn examples."
    end

    def each(&block)
      return to_enum(__method__) unless block_given?

      data_path = cache_dir_path + "trees.json"
      url = "https://api.github.com/repos/mwaskom/seaborn-data/git/trees/master"
      download(data_path, url)

      tree = JSON.parse(File.read(data_path))["tree"]
      tree.each do |content|
        path = content["path"]
        next unless path.end_with?(".csv")
        dataset = File.basename(path, ".csv")
        record = {dataset: dataset}
        yield record
      end
    end
  end

  class Seaborn < Dataset
    URL_FORMAT = "https://raw.githubusercontent.com/mwaskom/seaborn-data/master/%{name}.csv".freeze

    def initialize(name)
      super()
      @metadata.id = "seaborn-#{name}"
      @metadata.name = "seaborn: #{name}"
      @metadata.url = URL_FORMAT % {name: name}
      # @metadata.licenses = TODO

      @name = name
    end

    def each(&block)
      return to_enum(__method__) unless block_given?

      data_path = cache_dir_path + "#{@name}.csv"
      download(data_path, @metadata.url)
      CSV.open(data_path, headers: :first_row, converters: :all) do |csv|
        csv.each do |row|
          record = prepare_record(row)
          yield record
        end
      end
    end

    private
    def prepare_record(csv_row)
      record = csv_row.to_h
      record.transform_keys! do |key|
        if key.nil?
          :index
        else
          key.to_sym
        end
      end

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

  # For backward compatibility
  SeabornData = Seaborn
end
