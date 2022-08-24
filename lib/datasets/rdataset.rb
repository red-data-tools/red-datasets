require_relative "dataset"
require_relative "tar-gz-readable"

module Datasets
  class RdatasetList < Dataset
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
      @metadata.id = "rdataset-list"
      @metadata.name = "Rdataset"
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
      download(@data_path, @data_url)
      CSV.open(@data_path, headers: :first_row, converters: :all) do |csv|
        csv.each(&block)
      end
    end
  end

  # For backward compatibility
  RdatasetsList = RdatasetList

  class Rdataset < Dataset
    def initialize(package_name, dataset_name)
      list = RdatasetList.new

      info = list.filter(package: package_name, dataset: dataset_name).first
      unless info
        raise ArgumentError, "Unable to locate dataset #{package_name}/#{dataset_name}"
      end

      super()
      @metadata.id = "rdataset-#{package_name}-#{dataset_name}"
      @metadata.name = "Rdataset: #{package_name}: #{dataset_name}"
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

      download(@data_path, @metadata.url)

      na_converter = lambda do |field|
        begin
          if field.encode(CSV::ConverterEncoding) == "NA"
            nil
          else
            field
          end
        rescue
          field
        end
      end

      inf_converter = lambda do |field|
        begin
          if field.encode(CSV::ConverterEncoding) == "Inf"
            Float::INFINITY
          else
            field
          end
        rescue
          field
        end
      end

      quote_preserving_converter = lambda do |field, info|
        f = field.encode(CSV::ConverterEncoding)
        return f if info.quoted?

        begin
          begin
            begin
              return DateTime.parse(f) if f.match?(DateTimeMatcher)
            rescue
              return Integer(f)
            end
          rescue
            return Float(f)
          end
        rescue
          field
        end
      end

      table = CSV.table(@data_path,
                        header_converters: [:symbol_raw],
                        # quote_preserving_converter should be the last
                        converters: [na_converter, inf_converter, quote_preserving_converter])
      table.delete(:"") # delete 1st column for indices.

      table.each do |row|
        yield row.to_h
      end
    end
  end

  # For backward compatibility
  Rdatasets = Rdataset
end
