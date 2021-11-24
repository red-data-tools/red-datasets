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
                     :cty=>18,
                     :cyl=>4,
                     :displ=>1.8,
                     :drv=>"f",
                     :hwy=>29,
                     :fl=>"p",
                     :manufacturer=>"audi",
                     :model=>"a4",
                     :trans=>"auto(l5)",
                     :year=>1999
                   },
                   {
                     :class=>"midsize",
                     :cty=>17,
                     :cyl=>6,
                     :displ=>3.6,
                     :drv=>"f",
                     :hwy=>26,
                     :fl=>"p",
                     :manufacturer=>"volkswagen",
                     :model=>"passat",
                     :trans=>"auto(s6)",
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
