module Datasets
  class FuelEconomy < Dataset
    Record = Struct.new(:manufacturer,
                        :model,
                        :displacement,
                        :year,
                        :n_cylinders,
                        :transmission,
                        :drive_train,
                        :city_mpg,
                        :highway_mpg,
                        :fuel,
                        :type)

    def initialize()
      super()
      @metadata.id = "fuel-economy"
      @metadata.name = "Fuel economy"
      @metadata.licenses = ["CC0-1.0"]
      @metadata.url = "https://ggplot2.tidyverse.org/reference/mpg.html"
      @metadata.description = "Fuel economy dataset from ggplot2, originally from https://www.fueleconomy.gov"
    end

    def each
      return to_enum(__method__) unless block_given?

      data_path = cache_dir_path + "mpg.csv"
      data_url = "https://github.com/tidyverse/ggplot2/raw/main/data-raw/mpg.csv"
      download(data_path, data_url)
      CSV.open(data_path, headers: :first_row, converters: :all) do |csv|
        csv.each do |row|
          record = Record.new(*row.fields)
          yield record
        end
      end
    end
  end
end
