class WineTest < Test::Unit::TestCase
  def setup
    @dataset = Datasets::Wine.new
  end

  def record(*args)
    Datasets::Wine::Record.new(*args)
  end

  test('#each') do
    records = @dataset.each.to_a
    assert_equal([
                   178,
                   record(1, 14.23, 1.71, 2.43, 15.6, 127, 2.8, 3.06, 0.28, 2.29, 5.64, 1.04, 3.92, 1065),
                   record(3, 14.13, 4.1, 2.74, 24.5, 96, 2.05, 0.76, 0.56, 1.35, 9.2, 0.61, 1.6, 560)
                 ],
                 [records.size, records[0], records[-1]])
  end

  sub_test_case('#metadata') do
    test('#description') do
      description = @dataset.metadata.description
      assert do
        description.start_with?('1. Title of Database: Wine recognition data')
      end
    end
  end
end
