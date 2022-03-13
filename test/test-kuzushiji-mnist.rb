class KuzushijiMNISTTest < Test::Unit::TestCase
  sub_test_case("Normal") do
    sub_test_case("train") do
      def setup
        @dataset = Datasets::KuzushijiMNIST.new(type: :train)
      end

      test("#each") do
        records = @dataset.each.to_a
        assert_equal([
                       60000,
                       [
                         8,
                         784,
                         [213, 233, 255, 186, 2, 0, 0, 0, 0, 0],
                         [0, 0, 0, 0, 0, 0, 0, 0, 45, 252],
                       ],
                       [
                         9,
                         784,
                         [81, 246, 254, 155, 224, 255, 230, 39, 0, 0],
                         [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
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
                       [213, 233, 255, 186, 2, 0, 0, 0, 0, 0],
                       [81, 246, 254, 155, 224, 255, 230, 39, 0, 0],
                     ],
                     [
                       table_data[:pixels][0][400, 10],
                       table_data[:pixels][-1][400, 10],
                     ])
      end

      sub_test_case("#metadata") do
        test("#id") do
          assert_equal("kuzushiji-mnist-train", @dataset.metadata.id)
        end

        test("#name") do
          assert_equal("Kuzushiji-MNIST: train", @dataset.metadata.name)
        end
      end
    end

    sub_test_case("test") do
      def setup
        @dataset = Datasets::KuzushijiMNIST.new(type: :test)
      end

      test("#each") do
        records = @dataset.each.to_a
        assert_equal([
                       10000,
                       [
                         2,
                         784,
                         [0, 0, 0, 0, 0, 0, 0, 0, 0, 75],
                         [44, 255, 255, 246, 119, 252, 46, 0, 70, 255],
                       ],
                       [
                         2,
                         784,
                         [0, 0, 0, 0, 0, 0, 0, 84, 255, 192],
                         [0, 0, 0, 0, 0, 23, 245, 92, 42, 254],
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
                       [0, 0, 0, 0, 0, 0, 0, 0, 0, 75],
                       [0, 0, 0, 0, 0, 0, 0, 84, 255, 192],
                     ],
                     [
                       table_data[:pixels][0][400, 10],
                       table_data[:pixels][-1][400, 10],
                     ])
      end

      sub_test_case("#metadata") do
        test("#id") do
          assert_equal("kuzushiji-mnist-test", @dataset.metadata.id)
        end

        test("#name") do
          assert_equal("Kuzushiji-MNIST: test", @dataset.metadata.name)
        end
      end
    end
  end

  sub_test_case("Abnormal") do
    test("invalid type") do
      invalid_type = :invalid
      message = "Please set type :train or :test: #{invalid_type.inspect}"
      assert_raise(ArgumentError.new(message)) do
        Datasets::KuzushijiMNIST.new(type: invalid_type)
      end
    end
  end
end
