require 'csv'

module Datasets
  class Iris
    Record = Struct.new(:sepal_length,
                        :sepal_width,
                        :petal_length,
                        :petal_width,
                        :class)

    def initialize
      path = File.expand_path('../../data/iris.csv', File.dirname(__FILE__))
      @csv = CSV.open(path, converters: [:numeric])
    end

    def each
      return to_enum(__method__) unless block_given?

      @csv.each do |row|
        next if row[0].nil?
        record = Record.new(*row)
        yield(record)
      end
    end
  end
end
