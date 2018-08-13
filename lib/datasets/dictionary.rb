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
