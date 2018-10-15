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
                         9,
                         784,
                         [0, 0, 0, 0, 237, 226, 217, 223, 222, 219],
                         [220, 232, 246, 0, 3, 202, 228, 224, 221, 211],
                       ],
                       [
                         5,
                         784,
                         [129, 153, 34, 0, 3, 3, 0, 3, 0, 24],
                         [180, 177, 177, 47, 101, 235, 194, 223, 232, 255],
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
                       [0, 0, 0, 0, 237, 226, 217, 223, 222, 219],
                       [129, 153, 34, 0, 3, 3, 0, 3, 0, 24],
                     ],
                     [
                       table_data[:pixels][0][400, 10],
                       table_data[:pixels][-1][400, 10],
                     ])
      end

      sub_test_case("#metadata") do
        test("#id") do
          assert_equal("fashion-mnist-train", @dataset.metadata.id)
        end

        test("#name") do
          assert_equal("Fashion-MNIST: train", @dataset.metadata.name)
        end
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

      sub_test_case("#metadata") do
        test("#id") do
          assert_equal("fashion-mnist-test", @dataset.metadata.id)
        end

        test("#name") do
          assert_equal("Fashion-MNIST: test", @dataset.metadata.name)
        end
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
