require_relative "dataset"
require_relative "tar_gz_readable"

module Datasets
  class RDatasets < Dataset
    class FileNotFound < StandardError; end

    class Master < Dataset
      include TarGzReadable

      def initialize
        super
        @metadata.id = "RDatasets"
        @metadata.name = "RDatasets"
        @metadata.url = "https://vincentarelbundock.github.io/Rdatasets/"
        @metadata.licenses = ["GPL-3"]
        @data_url = "https://github.com/vincentarelbundock/Rdatasets/archive/refs/heads/master.tar.gz"
        @data_path = cache_dir_path + "rdatasets.tar.gz"
      end

      attr_reader :data_path

      def download(force: false)
        if force || !@data_path.exist?
          super(@data_path, @data_url)
        end
      end

      def dataset_info(package_name, dataset_name)
        each_dataset(package_name) do |row|
          if row["Item"] == dataset_name
            record = row.to_h
            record.transform_keys! {|key| key.downcase.to_sym }
            return record
          end
        end
      end

      def exist?(package_name, dataset_name = nil)
        if dataset_name.nil?
          each_dataset(package_name) { return true }
          return false
        else
          each_dataset(package_name).any? {|row| row["Item"] == dataset_name }
        end
      end

      def each_dataset(package_name = nil)
        return to_enum(__method__, package_name) unless block_given?

        download
        open_dataset_file("datasets.csv") do |entry|
          csv = CSV.parse(entry.read, col_sep: ",", row_sep: :auto, headers: :first_row, quote_char: '"')
          csv.each do |row|
            if package_name.nil? || row["Package"] == package_name
              yield row
            end
          end
        end
      rescue FileNotFound
        raise "Unable to find datasets.csv. " +
              "Please try Datasets::RDatasets.update to update the data source."
      end

      def open_dataset_file(path)
        open_tar(data_path) do |tar|
          tar.seek("Rdatasets-master/#{path}") do |entry|
            return yield(entry)
          end
          raise FileNotFound, "File not found in RDatasets: #{path}"
        end
      end
    end

    def self.update
      Master.new.download(force: true)
    end

    def self.datasets(package_name = nil)
      Master.new.each_dataset(package_name).to_a
    end

    def self.exist?(package_name, dataset_name = nil)
      Master.new.exist?(package_name, dataset_name)
    end

    def initialize(package_name, dataset_name)
      master = Master.new
      unless master.exist?(package_name, dataset_name)
        raise ArgumentError, "Unable to locate dataset #{package_name}/#{dataset_name}"
      end

      super()
      @metadata.id = "rdatasets-#{package_name}-#{dataset_name}"

      info = master.dataset_info(package_name, dataset_name)
      @metadata.description = info[:title]

      @package_name = package_name
      @dataset_name = dataset_name
    end

    private def check_availability(package_name, dataset_name)
    end

    def each(&block)
      return to_enum(__method__) unless block_given?

      csv_name = File.join(@package_name, @dataset_name) + ".csv"
      Master.new.open_dataset_file("csv/#{csv_name}") do |entry|
        read_csv_entry(entry.read, &block)
      end
    end

    private def read_csv_entry(data, &block)
      csv = CSV.new(data, col_sep: ",", row_sep: :auto, headers: :first_row,
                    quote_char: '"', converters: :all)
      csv.each do |row|
        record = row.to_h
        record.delete("")
        record.transform_keys!(&:to_sym)
        yield record
      end
    end
  end
end
