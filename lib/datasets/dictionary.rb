module Datasets
  class Dictionary
    include Enumerable

    def initialize(values)
      build_dictionary(values)
    end

    def id(value)
      @value_to_id[value]
    end

    def value(id)
      @id_to_value[id]
    end

    def ids
      @id_to_value.keys
    end

    def values
      @id_to_value.values
    end

    def each(&block)
      @id_to_value.each(&block)
    end

    def size
      @id_to_value.size
    end
    alias_method :length, :size

    def encode(values)
      values.collect do |value|
        id(value)
      end
    end

    def decode(ids)
      ids.collect do |id|
        value(id)
      end
    end

    private
    def build_dictionary(values)
      @id_to_value = {}
      @value_to_id = {}
      id = 0
      values.each do |value|
        next if @value_to_id.key?(value)
        @id_to_value[id] = value
        @value_to_id[value] = id
        id += 1
      end
    end
  end
end
