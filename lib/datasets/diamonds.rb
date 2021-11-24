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
      @metadata.licenses = ["CC0"]
      @metadata.url = "https://ggplot2.tidyverse.org/reference/diamonds.html"
      @metadata.description = "Diamonds dataset original from ggplot2, see also https://ggplot2.tidyverse.org/reference/diamonds.html"

      @data_path = cache_dir_path + "diamonds.csv"
    end

    def each(&block)

      download(@data_path, @metadata.url)
      CSV.open(@data_path, headers: :first_row, converters: :all) do |csv|
        csv.each do |row|
          record = Record.new(*row.fields)
          yield record
        end
      end
    end

 end
end
