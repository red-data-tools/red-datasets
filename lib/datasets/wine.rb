require 'csv'

require_relative 'dataset'

module Datasets
  class Wine < Dataset
    Record = Struct.new(:label,
                        :alcohol,
                        :malic_acid,
                        :ash,
                        :alcalinity_of_ash,
                        :n_magnesiums,
                        :total_phenols,
                        :total_flavonoids,
                        :total_nonflavanoid_phenols,
                        :total_proanthocyanins,
                        :color_intensity,
                        :hue,
                        :optical_nucleic_acid_concentration,
                        :n_prolines)

    def initialize
      super
      @metadata.id = 'wine'
      @metadata.name = 'Wine'
      @metadata.url = 'https://archive.ics.uci.edu/ml/datasets/wine'
      @metadata.licenses = ["CC-BY-4.0"]
      @metadata.description = -> { read_names }
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

    def read_names
      names_path = cache_dir_path + 'wine.names'
      names_url = 'https://archive.ics.uci.edu/ml/machine-learning-databases/wine/wine.names'
      download(names_path, names_url)
      names_path.read
    end

    def open_data
      data_path = cache_dir_path + 'wine.data'
      data_url = 'https://archive.ics.uci.edu/ml/machine-learning-databases/wine/wine.data'
      download(data_path, data_url)
      CSV.open(data_path, converters: %i[numeric]) do |csv|
        yield(csv)
      end
    end
  end
end
