class DiamondsTest < Test::Unit::TestCase
  def setup
    @dataset = Datasets::Diamonds.new
  end

  def record(*args)
    Datasets::Diamonds::Record.new(*args)
  end

  test("#each") do
    records = @dataset.each.to_a
    assert_equal([
                   53940,
                   {
                     carat: 0.23,
                     clarity: "SI2",
                     color: "E",
                     cut: "Ideal",
                     depth: 61.5,
                     price: 326,
                     table: 55.0,
                     x: 3.95,
                     y: 3.98,
                     z: 2.43,
                   },
                   {
                     carat: 0.75,
                     clarity: "SI2",
                     color: "D",
                     cut: "Ideal",
                     depth: 62.2,
                     price: 2757,
                     table: 55.0,
                     x: 5.83,
                     y: 5.87,
                     z: 3.64,
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
Prices of over 50,000 round cut diamonds

A dataset containing the prices and other attributes of almost 54,000
 diamonds. The variables are as follows:

A data frame with 53940 rows and 10 variables:

  * price: price in US dollars ($326--$18,823)
  * carat: weight of the diamond (0.2--5.01)
  * cut: quality of the cut (Fair, Good, Very Good, Premium, Ideal)
  * color: diamond colour, from D (best) to J (worst)
  * clarity: a measurement of how clear the diamond is (I1 (worst), SI2,
    SI1, VS2, VS1, VVS2, VVS1, IF (best))
  * x: length in mm (0--10.74)
  * y: width in mm (0--58.9)
  * z: depth in mm (0--31.8)
  * depth: total depth percentage = z / mean(x, y) = 2 * z / (x + y) (43--79)
  * table: width of top of diamond relative to widest point (43--95)
      DESCRIPTION
    end
  end
end
