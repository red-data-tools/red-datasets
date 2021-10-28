require "csv"

require_relative "dataset"

module Datasets
  class Iris < Dataset
    Record = Struct.new(:sepal_length,
                        :sepal_width,
                        :petal_length,
                        :petal_width,
                        :label)

    def initialize
      super()
      @metadata.id = "iris"
      @metadata.name = "Iris"
      @metadata.url = "https://archive.ics.uci.edu/ml/datasets/Iris"
      @metadata.licenses = ["CC-BY-4.0"]
      @metadata.description = lambda do
        read_names
      end
    end

    def each
      return to_enum(__method__) unless block_given?

      open_data do |csv|
        csv.each do |row|
          next if row[0].nil?
          record = Record.new(*row)
          yield(record)
        end
      end
    end

    private
    def open_data
      data_path = cache_dir_path + "iris.csv"
      data_url = "https://archive.ics.uci.edu/ml/machine-learning-databases/iris/iris.data"
      download(data_path, data_url)
      CSV.open(data_path, converters: [:numeric]) do |csv|
        yield(csv)
      end
    end

    def read_names
      names_path = cache_dir_path + "iris.names"
      names_url = "https://archive.ics.uci.edu/ml/machine-learning-databases/iris/iris.names"
      download(names_path, names_url)
      names_path.read
    end
  end
end
