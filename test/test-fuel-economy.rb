class FuelEconomyTest < Test::Unit::TestCase
  def setup
    @dataset = Datasets::FuelEconomy.new
  end

  def record(*args)
    Datasets::FuelEconomy::Record.new(*args)
  end

  test("#each") do
    records = @dataset.each.to_a
    assert_equal([
                   234,
                   {
                      city_mpg: 18,
                      displacement: 1.8,
                      drive_train: "f",
                      fuel: "p",
                      highway_mpg: 29,
                      manufacturer: "audi",
                      model: "a4",
                      n_cylinders: 4,
                      transmission: "auto(l5)",
                      type: "compact",
                      year: 1999
                   },
                   {
                      city_mpg: 17,
                      displacement: 3.6,
                      drive_train: "f",
                      fuel: "p",
                      highway_mpg: 26,
                      manufacturer: "volkswagen",
                      model: "passat",
                      n_cylinders: 6,
                      transmission: "auto(s6)",
                      type: "midsize",
                      year: 2008
                    },
                 ],
                 [
                   records.size,
                   records[0].to_h,
                   records[-1].to_h
                 ])
  end

  sub_test_case("#metadata") do
    test("#description") do
      description = @dataset.metadata.description
      assert_equal(<<-DESCRIPTION, description)
Fuel economy data from 1999 to 2008 for 38 popular models of cars

This dataset contains a subset of the fuel economy data that the EPA makes
available on https://fueleconomy.gov/. It contains only models which
had a new release every year between 1999 and 2008 - this was used as a
proxy for the popularity of the car.

A data frame with 234 rows and 11 variables:

  * manufacturer: manufacturer name
  * model: model name
  * displacement: engine displacement, in litres
  * year: year of manufacture
  * n_cylinders: number of cylinders
  * transmissions: type of transmission
  * drive_train: the type of drive train, where f = front-wheel drive, r = rear wheel drive, 4 = 4wd
  * city_mpg: city miles per gallon
  * highway_mpg: highway miles per gallon
  * fuel: fuel type
  * type: "type" of car
      DESCRIPTION
    end
  end
end
