class RubyTest < Test::Unit::TestCase
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
                     :class=>"compact",
                     :city_mpg=>18,
                     :n_cylinders=>4,
                     :displacement=>1.8,
                     :drive_train=>"f",
                     :highway_mpg=>29,
                     :fuel=>"p",
                     :manufacturer=>"audi",
                     :model=>"a4",
                     :transmission=>"auto(l5)",
                     :year=>1999
                   },
                   {
                     :class=>"midsize",
                     :city_mpg=>17,
                     :n_cylinders=>6,
                     :displacement=>3.6,
                     :drive_train=>"f",
                     :highway_mpg=>26,
                     :fuel=>"p",
                     :manufacturer=>"volkswagen",
                     :model=>"passat",
                     :transmission=>"auto(s6)",
                     :year=>2008
                    },
                 ],
                 [
                   records.size,
                   records[0].to_h,
                   records[-1].to_h
                 ])
  end
end
