class TableTest < Test::Unit::TestCase
  def setup
    @table = Datasets::Iris.new.to_table
  end

  test("#n_columns") do
    assert_equal(5, @table.n_columns)
  end

  test("#n_rows") do
    assert_equal(150, @table.n_rows)
  end

  test("#column_names") do
    assert_equal([
                   :sepal_length,
                   :sepal_width,
                   :petal_length,
                   :petal_width,
                   :label,
                 ],
                 @table.column_names)
  end

  sub_test_case("#[]") do
    test("index") do
      assert_equal([1.4, 1.4, 1.3, 1.5, 1.4],
                   @table[2].first(5))
    end

    test("name") do
      assert_equal([1.4, 1.4, 1.3, 1.5, 1.4],
                   @table[:petal_length].first(5))
    end
  end

  test("#dictionary_encode") do
    assert_equal([
                   [0, "Iris-setosa"],
                   [1, "Iris-versicolor"],
                   [2, "Iris-virginica"],
                 ],
                 @table.dictionary_encode(:label).to_a)
  end

  test("#label_encode") do
    label_encoded_labels = @table.label_encode(:label)
    labels = @table[:label]
    assert_equal([0, 1, 2],
                 [
                   label_encoded_labels[labels.find_index("Iris-setosa")],
                   label_encoded_labels[labels.find_index("Iris-versicolor")],
                   label_encoded_labels[labels.find_index("Iris-virginica")],
                 ])
  end

  sub_test_case("#fetch_values") do
    test("found") do
      values = @table.fetch_values(:petal_length, :petal_width)
      assert_equal([
                     [1.4, 1.4, 1.3, 1.5, 1.4],
                     [0.2, 0.2, 0.2, 0.2, 0.2],
                   ],
                   values.collect {|v| v.first(5)})
    end

    sub_test_case("not found") do
      test("with block") do
        values = @table.fetch_values(:petal_length, :unknown) do |key|
          [key] * 5
        end
        assert_equal([
                       [1.4, 1.4, 1.3, 1.5, 1.4],
                       [:unknown] * 5,
                     ],
                     values.collect {|v| v.first(5)})
      end

      test("without block") do
        assert_raise(KeyError) do
          @table.fetch_values(:unknown)
        end
      end
    end
  end

  test("#each") do
    shorten_hash = {}
    @table.each do |name, values|
      shorten_hash[name] = values.first(5)
    end
    assert_equal({
                   :label        => ["Iris-setosa"] * 5,
                   :petal_length => [1.4, 1.4, 1.3, 1.5, 1.4],
                   :petal_width  => [0.2, 0.2, 0.2, 0.2, 0.2],
                   :sepal_length => [5.1, 4.9, 4.7, 4.6, 5.0],
                   :sepal_width  => [3.5, 3.0, 3.2, 3.1, 3.6],
                 },
                 shorten_hash)
  end

  test("#to_h") do
    shorten_hash = {}
    @table.to_h.each do |name, values|
      shorten_hash[name] = values.first(5)
    end
    assert_equal({
                   :label        => ["Iris-setosa"] * 5,
                   :petal_length => [1.4, 1.4, 1.3, 1.5, 1.4],
                   :petal_width  => [0.2, 0.2, 0.2, 0.2, 0.2],
                   :sepal_length => [5.1, 4.9, 4.7, 4.6, 5.0],
                   :sepal_width  => [3.5, 3.0, 3.2, 3.1, 3.6],
                 },
                 shorten_hash)
  end
end
