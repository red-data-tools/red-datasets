module Datasets
  class FuelEconomy < Dataset
    Record = Struct.new(:manufacturer,
                        :model,
                        :displ,
                        :year,
                        :cyl,
                        :trans,
                        :drv,
                        :cty,
                        :hwy,
                        :fl,
                        :class)

    def initialize()
      super()
      @metadata.id = "FuelEconomy"
      @metadata.name = "Fuel-Economy"
      @metadata.licenses = ["PublicDomain"]
      @metadata.url = "https://ggplot2.tidyverse.org/reference/mpg.html"
      @metadata.description = "Fuel economy dataset from ggplot2, originally from https://www.fueleconomy.gov"

      @data_path = cache_dir_path + "mpg.csv"
    end

    def each
      return to_enum(__method__) unless block_given?

      data_url = "https://github.com/tidyverse/ggplot2/raw/main/data-raw/mpg.csv"
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
