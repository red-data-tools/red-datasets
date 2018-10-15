require 'csv'

require_relative 'dataset'

module Datasets
  class Wine < Dataset
    Record = Struct.new(:class,
                        :alcohol,
                        :malic_acid,
                        :ash,
                        :alcalinity_of_ash,
                        :n_magnesiums,
                        :total_phenols,
                        :n_flavonoids,
                        :n_nonflavanoid_phenols,
                        :n_proanthocyanins,
                        :color_intensity,
                        :hue,
                        :optical_nucleic_acid_concentration,
                        :n_proline)

    def initialize
      super
      @metadata.id = 'wine'
      @metadata.name = 'Wine'
      @metadata.url = 'http://archive.ics.uci.edu/ml/datasets/wine'
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
      unless names_path.exist?
        names_url = 'http://archive.ics.uci.edu/ml/machine-learning-databases/wine/wine.names'
        download(names_path, names_url)
      end
      names_path.read
    end

    def open_data
      data_path = cache_dir_path + 'wine.data'
      unless data_path.exist?
        data_url = 'http://archive.ics.uci.edu/ml/machine-learning-databases/wine/wine.data'
        download(data_path, data_url)
      end
      CSV.open(data_path, converters: %i[numeric]) do |csv|
        yield(csv)
      end
    end
  end
end
