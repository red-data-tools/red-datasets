class CifarTest < Test::Unit::TestCase
  sub_test_case("cifar-10") do
    sub_test_case("train") do
      def setup
        @dataset = Datasets::Cifar.new(class_num: 10, set_type: :train)
      end

      test("#each") do
        records = @dataset.to_a
        assert_equal([
                       50000,
                       3072,
                       6,
                     ],
                     [
                       records.size,
                       records[0].data.size,
                       records[0].label,
                     ])
      end
    end

    sub_test_case("test") do
      def setup
        @dataset = Datasets::Cifar.new(class_num: 10, set_type: :test)
      end

      test("#each") do
        records = @dataset.to_a
        assert_equal([
                       10000,
                       3072,
                       3,
                     ],
                     [
                       records.size,
                       records[0].data.size,
                       records[0].label,
                     ])
      end
    end
  end

  sub_test_case("cifar-100") do
    sub_test_case("train") do
      def setup
        @dataset = Datasets::Cifar.new(class_num: 100, set_type: :train)
      end

      test("#each") do
        records = @dataset.to_a
        assert_equal([
                       50000,
                       3072,
                       19,
                     ],
                     [
                       records.size,
                       records[0].data.size,
                       records[0].label,
                     ])
      end
    end

    sub_test_case("test") do
      def setup
        @dataset = Datasets::Cifar.new(class_num: 100, set_type: :test)
      end

      test("#each") do
        records = @dataset.to_a
        assert_equal([
                       10000,
                       3072,
                       49,
                     ],
                     [
                       records.size,
                       records[0].data.size,
                       records[0].label
                     ])
      end
    end
  end
end
