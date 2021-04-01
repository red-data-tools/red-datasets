class RDatasetsTest < Test::Unit::TestCase
  sub_test_case("datasets") do
    sub_test_case("AirPassengers") do
      def setup
        @dataset = Datasets::RDatasets.new("datasets", "AirPassengers")
      end

      test("#each") do
        records = @dataset.each.to_a
        assert_equal([
                       144,
                       { time: 1949,             value: 112 },
                       { time: 1960.91666666667, value: 432 },
                     ],
                     [
                       records.size,
                       records[0].to_h,
                       records[-1].to_h
                     ])
      end

      test("#metadata.id") do
        assert_equal("RDatasets/datasets/AirPassengers", @dataset.metadata.id)
      end

      test("#metadata.description") do
        description = @dataset.metadata.description
        assert do
          description.include?("Monthly Airline Passenger Numbers 1949-1960")
        end
      end
    end

    test("invalid dataset name") do
      assert_raise(ArgumentError) do
        Datasets::RDatasets.new("datasets", "invalid datasets name")
      end
    end
  end

  test("invalid package name") do
    assert_raise(ArgumentError) do
      Datasets::RDatasets.new("invalid package name", "AirPassengers")
    end
  end
end
