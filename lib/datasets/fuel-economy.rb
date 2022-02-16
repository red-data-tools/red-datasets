require_relative "ggplot2-dataset"

module Datasets
  class FuelEconomy < Ggplot2Dataset
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

    def initialize
      super("mpg")
      @metadata.id = "fuel-economy"
      @metadata.name = "Fuel economy"
      @metadata.licenses = ["CC0-1.0"]
    end

    COLUMN_NAME_MAPPING = {
      "displ" => "displacement",
      "cyl" => "n_cylinders",
      "trans" => "transmissions",
      "drv" => "drive_train",
      "cty" => "city_mpg",
      "hwy" => "highway_mpg",
      "fl" => "fuel",
      "class" => "type",
    }
  end
end
