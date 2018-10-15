class MNISTTest < Test::Unit::TestCase
  sub_test_case("Normal") do
    sub_test_case("train") do
      def setup
        @dataset = Datasets::MNIST.new(type: :train)
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

      sub_test_case("#metadata") do
        test("#id") do
          assert_equal("mnist-train", @dataset.metadata.id)
        end

        test("#name") do
          assert_equal("MNIST: train", @dataset.metadata.name)
        end
      end
    end

    sub_test_case("test") do
      def setup
        @dataset = Datasets::MNIST.new(type: :test)
      end

      test("#each") do
        records = @dataset.each.to_a
        assert_equal([
                       10000,
                       [
                         7,
                         784,
                         [0, 0, 84, 185, 159, 151, 60, 36, 0, 0],
                         [0, 0, 0, 0, 0, 0, 0, 0, 59, 249],
                       ],
                       [
                         6,
                         784,
                         [0, 0, 0, 0, 0, 15, 60, 60, 168, 253],
                         [253, 253, 132, 64, 0, 0, 18, 43, 157, 171],
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
                       [0, 0, 84, 185, 159, 151, 60, 36, 0, 0],
                       [0, 0, 0, 0, 0, 15, 60, 60, 168, 253],
                     ],
                     [
                       table_data[:pixels][0][200, 10],
                       table_data[:pixels][-1][200, 10],
                     ])
      end

      sub_test_case("#metadata") do
        test("#id") do
          assert_equal("mnist-test", @dataset.metadata.id)
        end

        test("#name") do
          assert_equal("MNIST: test", @dataset.metadata.name)
        end
      end
    end
  end

  sub_test_case("Abnormal") do
    test("invalid type") do
      invalid_type = :invalid
      message = "Please set type :train or :test: #{invalid_type.inspect}"
      assert_raise(ArgumentError.new(message)) do
        Datasets::MNIST.new(type: invalid_type)
      end
    end
  end
end
