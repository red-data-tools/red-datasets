class CaliforniaHousingTest < Test::Unit::TestCase
  def setup
    @dataset = Datasets::CaliforniaHousing.new
  end

  def record(*args)
    Datasets::CaliforniaHousing::Record.new(*args)
  end

  test("#each") do
    records = @dataset.each.to_a
    assert_equal([
                   20640,
                   {
                     median_house_value: 452600.000000,
                     median_income: 8.325200,
                     housing_median_age: 41.000000,
                     total_rooms: 880.000000,
                     total_bedrooms: 129.000000,
                     population: 322.000000,
                     households: 126.000000,
                     latitude: 37.880000,
                     longitude: -122.230000
                   },
                   {
                     median_house_value: 89400.000000,
                     median_income: 2.388600,
                     housing_median_age: 16.000000,
                     total_rooms: 2785.000000,
                     total_bedrooms: 616.000000,
                     population: 1387.000000,
                     households: 530.000000,
                     latitude: 39.370000,
                     longitude: -121.240000
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
Housing information from the 1990 census used in
Pace, R. Kelley and Ronald Barry,
"Sparse Spatial Autoregressions",
Statistics and Probability Letters, 33 (1997) 291-297.
Available from http://lib.stat.cmu.edu/datasets/.
      DESCRIPTION
    end
  end
end
