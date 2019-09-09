require "datasets/dictionary"

module Datasets
  class Table
    class Record
      include Enumerable

      def initialize(table, index)
        @table = table
        @index = index
      end

      def [](column_name_or_column_index)
        @table[column_name_or_column_index][@index]
      end

      def each
        return to_enum(__method__) unless block_given?
        @table.each_column.each do |column_name, column_values|
          yield(column_name, column_values[@index])
        end
      end

      def values
        @table.each_column.collect do |_column_name, column_values|
          column_values[@index]
        end
      end

      def to_h
        hash = {}
        each do |column_name, column_value|
          hash[column_name] = column_value
        end
        hash
      end

      def inspect
        "#<#{self.class.name} #{@table.dataset.metadata.name}[#{@index}] #{to_h.inspect}>"
      end
    end

    include Enumerable

    attr_reader :dataset
    def initialize(dataset)
      @dataset = dataset
      @dictionaries = {}
    end

    def n_columns
      columner_data.size
    end
    alias_method :size, :n_columns
    alias_method :length, :n_columns

    def n_rows
      first_column = columner_data.first
      return 0 if first_column.nil?
      first_column[1].size
    end

    def column_names
      columner_data.keys
    end

    def each_column(&block)
      columner_data.each(&block)
    end
    alias_method :each, :each_column

    def each_record
      return to_enum(__method__) unless block_given?
      n_rows.times do |i|
        yield(Record.new(self, i))
      end
    end

    def find_record(row)
      row += n_rows if row < 0
      return nil if row < 0
      return nil if row >= n_rows
      Record.new(self, row)
    end

    def [](name_or_index)
      case name_or_index
      when Integer
        index = name_or_index
        columner_data.each_with_index do |(_name, values), i|
          return values if i == index
        end
        nil
      else
        name = name_or_index
        columner_data[normalize_name(name)]
      end
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
