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
      # https://github.com/tidyverse/ggplot2/pull/4686#issuecomment-986769199
      #
      # > I don't think we can add anything here without being sure of
      # > the provenance. However, in the US data is not
      # > copyrightable.
      #
      # This data may be public domain but we aren't sure it for now.
      # We use the same license as ggplot2 here for now.
      @metadata.licenses = ["MIT"]
    end

    COLUMN_NAME_MAPPING = {
    }
  end
end
