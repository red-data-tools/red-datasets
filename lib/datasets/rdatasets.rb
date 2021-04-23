require_relative "dataset"
require_relative "tar_gz_readable"

module Datasets
  class RdatasetsList < Dataset
    Record = Struct.new(:package,
                        :dataset,
                        :title,
                        :rows,
                        :cols,
                        :n_binary,
                        :n_character,
                        :n_factor,
                        :n_logical,
                        :n_numeric,
                        :csv,
                        :doc)

    def initialize
      super
      @metadata.id = "rdatasets"
      @metadata.name = "Rdatasets"
      @metadata.url = "https://vincentarelbundock.github.io/Rdatasets/"
      @metadata.licenses = ["GPL-3"]
      @data_url = "https://raw.githubusercontent.com/vincentarelbundock/Rdatasets/master/datasets.csv"
      @data_path = cache_dir_path + "datasets.csv"
    end

    def filter(package: nil, dataset: nil)
      return to_enum(__method__, package: package, dataset: dataset) unless block_given?

      conds = {}
      conds["Package"] = package if package
      conds["Item"]    = dataset if dataset
      if conds.empty?
        each_row {|row| yield Record.new(*row.fields) }
      else
        each_row do |row|
          if conds.all? {|k, v| row[k] == v }
            yield Record.new(*row.fields)
          end
        end
      end
    end

    def each(&block)
      filter(&block)
    end

    private def each_row(&block)
      download(@data_path, @data_url) unless @data_path.exist?
      CSV.open(@data_path, headers: :first_row, converters: :all) do |csv|
        csv.each(&block)
      end
    end
  end

  class Rdatasets < Dataset
    def initialize(package_name, dataset_name)
      list = RdatasetsList.new

      info = list.filter(package: package_name, dataset: dataset_name).first
      unless info
        raise ArgumentError, "Unable to locate dataset #{package_name}/#{dataset_name}"
      end

      super()
      @metadata.id = "rdatasets-#{package_name}-#{dataset_name}"
      @metadata.name = "Rdatasets: #{package_name}: #{dataset_name}"
      @metadata.url = info.csv
      @metadata.licenses = ["GPL-3"]
      @metadata.description = info.title

      # Follow the original directory structure in the cache directory
      @data_path = cache_dir_path + (dataset_name + ".csv")

      @package_name = package_name
      @dataset_name = dataset_name
    end

    def each(&block)
      return to_enum(__method__) unless block_given?

      download(@data_path, @metadata.url) unless @data_path.exist?
      CSV.open(@data_path, headers: :first_row, converters: :all) do |csv|
        csv.each do |row|
          record = row.to_h
          record.delete("")
          record.transform_keys!(&:to_sym)
          yield record
        end
      end
    end
  end
end
