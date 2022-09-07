class TLCGreenTaxiTripTest < Test::Unit::TestCase
  def record(*args)
    Datasets::TLC::GreenTaxiTrip::Record.new(*args)
  end

  test("each") do
    dataset = Datasets::TLC::GreenTaxiTrip.new(year: 2022, month: 1)
    records = dataset.each.to_a

    assert_equal([
                   62495,
                   record(2,
                          Time.parse('2022-01-01 09:14:21 +0900'),
                          Time.parse('2022-01-01 09:15:33 +0900'),
                          "N",
                          1.0,
                          42,
                          42,
                          1.0,
                          0.44,
                          3.5,
                          0.5,
                          0.5,
                          0.0,
                          0.0,
                          nil,
                          0.3,
                          4.8,
                          2.0,
                          1.0,
                          0.0),
                   record(2,
                          Time.parse('2022-02-01 08:52:00 +0900'),
                          Time.parse('2022-02-01 09:26:00 +0900'),
                          nil,
                          nil,
                          225,
                          179,
                          nil,
                          9.6,
                          32.18,
                          0.0,
                          0.0,
                          7.23,
                          10.0,
                          nil,
                          0.3,
                          49.71,
                          nil,
                          nil,
                          nil)
                 ],
                 [
                   records.size,
                   records.first,
                   records.last,
                 ])
  end
end
