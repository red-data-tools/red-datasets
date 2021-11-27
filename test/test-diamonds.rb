class RubyTest < Test::Unit::TestCase
  def setup
    @dataset = Datasets::Diamonds.new
  end

  def record(*args)
    Datasets::Diamonds::Record.new(*args)
  end

  test('#each') do
    records = @dataset.each.to_a
    assert_equal([
                   53940,
                   {
                     :carat=>0.23,
                     :clarity=>"SI2",
                     :color=>"E",
                     :cut=>"Ideal",
                     :depth=>61.5,
                     :price=>326,
                     :table=>55.0,
                     :x=>3.95,
                     :y=>3.98,
                     :z=>2.43
                   },
                   {
                     :carat=>0.75,
                     :clarity=>"SI2",
                     :color=>"D",
                     :cut=>"Ideal",
                     :depth=>62.2,
                     :price=>2757,
                     :table=>55.0,
                     :x=>5.83,
                     :y=>5.87,
                     :z=>3.64
                   },
                 ],
                 [
                   records.size,
                   records[0].to_h,
                   records[-1].to_h
                 ])
  end
end
