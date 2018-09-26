require "csv"

require_relative "dataset"

module Datasets
  class Adult < Dataset
    Record = Struct.new(
      :age,
      :workclass,
      :fnlwgt,
      :education,
      :education_num,
      :marital_status,
      :occupation,
      :relationship,
      :race,
      :sex,
      :capital_gain,
      :capital_loss,
      :hours_per_week,
      :native_country,
      :income_per_year
    )

    def initialize
      super()
      @metadata.id = "adult"
      @metadata.name = "Adult"
      @metadata.url = "http://archive.ics.uci.edu/ml/datasets/adult"
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
      data_path = cache_dir_path + "adult.csv"
      unless data_path.exist?
        data_url = "http://archive.ics.uci.edu/ml/machine-learning-databases/adult/adult.data"
        download(data_path, data_url)
      end
      CSV.open(data_path, converters: [:numeric, lambda {|f| f ? f.strip : nil}]) do |csv|
        yield(csv)
      end
    end

    def read_names
      names_path = cache_dir_path + "adult.names"
      unless names_path.exist?
        names_url = "https://archive.ics.uci.edu/ml/machine-learning-databases/adult/adult.names"
        download(names_path, names_url)
      end
      names_path.read
    end
  end
end
