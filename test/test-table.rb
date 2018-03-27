class TableTest < Test::Unit::TestCase
  def setup
    @table = Datasets::Iris.new.to_table
  end

  test("#to_h") do
    shorten_hash = {}
    @table.to_h.each do |name, values|
      shorten_hash[name] = values.first(5)
    end
    assert_equal({
                   :class        => ["Iris-setosa"] * 5,
                   :petal_length => [1.4, 1.4, 1.3, 1.5, 1.4],
                   :petal_width  => [0.2, 0.2, 0.2, 0.2, 0.2],
                   :sepal_length => [5.1, 4.9, 4.7, 4.6, 5.0],
                   :sepal_width  => [3.5, 3.0, 3.2, 3.1, 3.6],
                 },
                 shorten_hash)
  end
end
