class FashionMNISTTest < Test::Unit::TestCase
  sub_test_case("Normal") do
    sub_test_case("train") do
      def setup
        @dataset = Datasets::FashionMNIST.new(type: :train)
      end

      test("#each") do
        records = @dataset.each.to_a
        assert_equal([
                       60000,
                       [
                         5,
                         784,
                         [0, 0, 0, 49, 238, 253, 253, 253, 253, 253],
                         [0, 0, 0, 0, 0, 81, 240, 253, 253, 119],
                       ],
                       [8,
                         784,
                         [0, 0, 0, 0, 0, 0, 0, 0, 0, 62],
                         [0, 0, 190, 196, 14, 2, 97, 254, 252, 146],
                       ],
                     ],
                     [
                       records.size,
                       [
                         records[0].label,
                         records[0].pixels.size,
                         records[0].pixels[200, 10],
                         records[0].pixels[400, 10],
                       ],
                       [
                         records[-1].label,
                         records[-1].pixels.size,
                         records[-1].pixels[200, 10],
                         records[-1].pixels[400, 10],
                       ],
                     ])
      end

      test("#to_table") do
        table_data = @dataset.to_table
        assert_equal([
                       [0, 0, 0, 49, 238, 253, 253, 253, 253, 253],
                       [0, 0, 0, 0, 0, 0, 0, 0, 0, 62],
                     ],
                     [
                       table_data[:pixels][0][200, 10],
                       table_data[:pixels][-1][200, 10],
                     ])
      end
    end

    sub_test_case("test") do
      def setup
        @dataset = Datasets::FashionMNIST.new(type: :test)
      end

      test("#each") do
        records = @dataset.each.to_a
        assert_equal([
                       10000,
                       [
                         9,
                         784,
                         [1, 0, 0, 0, 98, 136, 110, 109, 110, 162],
                         [172, 161, 189, 62, 0, 68, 94, 90, 111, 114],
                       ],
                       [
                         5,
                         784,
                         [45, 45, 69, 128, 100, 120, 132, 123, 135, 171],
                         [63, 74, 72, 0, 1, 0, 0, 0, 4, 85],
                       ],
                     ],
                     [
                       records.size,
                       [
                         records[0].label,
                         records[0].pixels.size,
                         records[0].pixels[400, 10],
                         records[0].pixels[500, 10],
                       ],
                       [
                         records[-1].label,
                         records[-1].pixels.size,
                         records[-1].pixels[400, 10],
                         records[-1].pixels[500, 10],
                       ],
                     ])
      end

      test("#to_table") do
        table_data = @dataset.to_table
        assert_equal([
                       [1, 0, 0, 0, 98, 136, 110, 109, 110, 162],
                       [45, 45, 69, 128, 100, 120, 132, 123, 135, 171],
                     ],
                     [
                       table_data[:pixels][0][400, 10],
                       table_data[:pixels][-1][400, 10],
                     ])
      end
    end
  end

  sub_test_case("Abnormal") do
    test("invalid type") do
      invalid_type = :invalid
      message = "Please set type :train or :test: #{invalid_type.inspect}"
      assert_raise(ArgumentError.new(message)) do
        Datasets::FashionMNIST.new(type: invalid_type)
      end
    end
  end
end
