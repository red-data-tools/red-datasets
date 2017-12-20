require 'csv'

module Datasets
  class Iris
    def initialize
      path = File.expand_path('../data/iris.csv', File.dirname(__FILE__))
      @csv = CSV.open(path)
    end

      @csv.each(&block)
    end
  end
end

