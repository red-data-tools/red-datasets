class IrisTest < Test::Unit::TestCase
  def setup
    @dataset = Datasets::Iris.new
  end

  def record(*args)
    Datasets::Iris::Record.new(*args)
  end

  test("#each") do
    records = @dataset.each.to_a
    assert_equal([
                   150,
                   record(5.1, 3.5, 1.4, 0.2, "Iris-setosa"),
                   record(5.9, 3.0, 5.1, 1.8, "Iris-virginica"),
                 ],
                 [
                   records.size,
                   records[0],
                   records[-1],
                 ])
  end

  sub_test_case("#metadata") do
    test("#description") do
      description = @dataset.metadata.description
      assert do
        description.start_with?("1. Title: Iris Plants Database")
      end
    end
  end
end
