module Datasets
  class Diamonds < Dataset
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
      super()
      @metadata.id = "diamonds"
      @metadata.name = "Diamonds"
      @metadata.licenses = ["Unknown"]
      @metadata.url = "https://ggplot2.tidyverse.org/reference/diamonds.html"
      @metadata.description = "Diamonds dataset from ggplot2"

      @data_path = cache_dir_path + "diamonds.csv"
    end

    def each
      return to_enum(__method__) unless block_given?

      data_url = "https://github.com/tidyverse/ggplot2/raw/main/data-raw/diamonds.csv"
      download(@data_path, data_url)
      CSV.open(@data_path, headers: :first_row, converters: :all) do |csv|
        csv.each do |row|
          record = Record.new(*row.fields)
          yield record
        end
      end
    end

  end
end
