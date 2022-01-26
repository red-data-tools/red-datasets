class FuelEconomyTest < Test::Unit::TestCase
  def setup
    @dataset = Datasets::FuelEconomy.new
  end

  def record(*args)
    Datasets::FuelEconomy::Record.new(*args)
  end

  test('#each') do
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
end
