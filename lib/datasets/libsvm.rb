require "csv"

require_relative "dataset"

module Datasets
  class LIBSVM < Dataset
    class Record
      attr_reader :label
      attr_reader :features
      def initialize(label, features)
        @label = label
        @features = features
      end

      def [](index)
        @features[index]
      end

      def to_h
        hash = {
          label: @label,
        }
        @features.each_with_index do |feature, i|
          hash[i] = feature
        end
        hash
      end

      def values
        [@label] + @features
      end
    end

    def initialize(name,
                   note: nil,
                   default_feature_value: 0)
      super()
      @libsvm_dataset_metadata = fetch_dataset_info(name)
      @file = choose_file(note)
      @default_feature_value = default_feature_value
      @metadata.id = "libsvm-#{normalize_name(name)}"
      @metadata.name = "LIBSVM dataset: #{name}"
      @metadata.url = "https://www.csie.ntu.edu.tw/~cjlin/libsvmtools/datasets/"
      @metadata.licenses = ["BSD-3-Clause"]
    end

    def each
      return to_enum(__method__) unless block_given?

      open_data do |input|
        n_features = @libsvm_dataset_metadata.n_features
        csv = CSV.new(input, col_sep: " ")
        csv.each do |row|
          label = parse_label(row.shift)
          features = [@default_feature_value] * n_features
          row.each do |column|
            next if column.nil?
            index, value = column.split(":", 2)
            features[Integer(index, 10) - 1] = parse_value(value)
          end
          yield(Record.new(label, features))
        end
      end
    end

    private
    def fetch_dataset_info(name)
      list = LIBSVMDatasetList.new
      available_datasets = []
      list.each do |record|
        available_datasets << record.name
        if record.name == name
          return record
        end
      end
      message = "unavailable LIBSVM dataset: #{name.inspect}: "
      message << "available datasets: ["
      message << available_datasets.collect(&:inspect).join(", ")
      message << "]"
      raise ArgumentError, message
    end

    def choose_file(note)
      files = @libsvm_dataset_metadata.files
      return files.first if note.nil?

      available_notes = []
      @libsvm_dataset_metadata.files.find do |file|
        return file if file.note == note
        available_notes << file.note if file.note
      end

      name = @libsvm_dataset_metadata.name
      message = "unavailable note: #{name}: #{note.inspect}: "
      message << "available notes: ["
      message << available_notes.collect(&:inspect).join(", ")
      message << "]"
      raise ArgumentError, message
    end

    def open_data(&block)
      data_path = cache_dir_path + @file.name
      download(data_path, @file.url)
      if data_path.extname == ".bz2"
        extract_bz2(data_path, &block)
      else
        data_path.open(&block)
      end
    end

    def normalize_name(name)
      name.gsub(/[()]/, "").gsub(/[ _;]+/, "-").downcase
    end

    def parse_label(label)
      labels = label.split(",").collect do |value|
        parse_value(value)
      end
      if labels.size == 1
        labels[0]
      else
        labels
      end
    end

    def parse_value(value)
      if value.include?(".")
        Float(value)
      else
        Integer(value, 10)
      end
    end
  end
end
