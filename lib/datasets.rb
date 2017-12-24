require 'csv'

module Datasets
  class Iris
    def initialize
      path = File.expand_path('../data/iris.csv', File.dirname(__FILE__))
      @csv = CSV.open(path)
    end

    def each(&block)
      @csv.each(&block)
    end
  end
end

