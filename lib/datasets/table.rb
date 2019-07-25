require "datasets/dictionary"

module Datasets
  class Table
    include Enumerable

    def initialize(dataset)
      @dataset = dataset
      @dictionaries = {}
    end

    def n_columns
      columner_data.size
    end

    def n_rows
      first_column = columner_data.first
      return 0 if first_column.nil?
      first_column[1].size
    end

    def each(&block)
      columner_data.each(&block)
    end

    def [](name)
      columner_data[normalize_name(name)]
    end

    def dictionary_encode(name)
      @dictionaries[normalize_name(name)] ||= Dictionary.new(self[name])
    end

    def label_encode(name)
      dictionary = dictionary_encode(name)
      dictionary.encode(self[name])
    end

    def fetch_values(*keys)
      data = columner_data
      keys.collect do |key|
        if data.key?(key)
          data[key]
        else
          raise build_key_error(key) unless block_given?
          yield(key)
        end
      end
    end

    def to_h
      columns = {}
      @dataset.each do |record|
        record.to_h.each do |name, value|
          values = (columns[name] ||= [])
          values << value
        end
      end
      columns
    end

    private
    begin
      KeyError.new("message", receiver: self, key: :key)
    rescue ArgumentError
      def build_key_error(key)
        KeyError.new("key not found: #{key.inspect}")
      end
    else
      def build_key_error(key)
        KeyError.new("key not found: #{key.inspect}",
                     receiver: self,
                     key: key)
      end
    end

    def columner_data
      @columns ||= to_h
    end

    def normalize_name(name)
      name.to_sym
    end
  end
end
