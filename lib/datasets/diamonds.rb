require_relative "ggplot2-dataset"

module Datasets
  class Diamonds < Ggplot2Dataset
    Record = Struct.new(:carat,
                        :cut,
                        :color,
                        :clarity,
                        :depth,
                        :table,
                        :price,
                        :x,
                        :y,
                        :z)

    def initialize()
      super("diamonds")
      @metadata.id = "diamonds"
      @metadata.name = "Diamonds"
      @metadata.licenses = ["CC0-1.0"]
    end

    COLUMN_NAME_MAPPING = {
    }
  end
end
