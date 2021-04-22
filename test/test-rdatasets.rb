class RdatasetsTest < Test::Unit::TestCase
  sub_test_case("RdatasetsList") do
    def setup
      @dataset = Datasets::RdatasetsList.new
    end

    sub_test_case("#each") do
      test("with package_name") do
        records = @dataset.filter(package: "datasets").to_a
        assert_equal([
                       84,
                       {
                         package: "datasets",
                         dataset: "ability.cov",
                         title: "Ability and Intelligence Tests",
                         rows: 6,
                         cols: 8,
                         n_binary: 0,
                         n_character: 0,
                         n_factor: 0,
                         n_logical: 0,
                         n_numeric: 8,
                         csv: "https://vincentarelbundock.github.io/Rdatasets/csv/datasets/ability.cov.csv",
                         doc: "https://vincentarelbundock.github.io/Rdatasets/doc/datasets/ability.cov.html"
                       },
                       {
                         package: "datasets",
                         dataset: "WWWusage",
                         title: "Internet Usage per Minute",
                         rows: 100,
                         cols: 2,
                         n_binary: 0,
                         n_character: 0,
                         n_factor: 0,
                         n_logical: 0,
                         n_numeric: 2,
                         csv: "https://vincentarelbundock.github.io/Rdatasets/csv/datasets/WWWusage.csv",
                         doc: "https://vincentarelbundock.github.io/Rdatasets/doc/datasets/WWWusage.html"
                       }
                     ],
                     [
                       records.size,
                       records[0].to_h,
                       records[-1].to_h
                     ])
      end

      test("without package_name") do
        records = @dataset.each.to_a
        assert_equal([
                       1478,
                       {
                         package: "AER",
                         dataset: "Affairs",
                         title: "Fair's Extramarital Affairs Data",
                         rows: 601,
                         cols: 9,
                         n_binary: 2,
                         n_character: 0,
                         n_factor: 2,
                         n_logical: 0,
                         n_numeric: 7,
                         csv: "https://vincentarelbundock.github.io/Rdatasets/csv/AER/Affairs.csv",
                         doc: "https://vincentarelbundock.github.io/Rdatasets/doc/AER/Affairs.html"
                       },
                       {
                         package: "vcd",
                         dataset: "WomenQueue",
                         title: "Women in Queues",
                         rows: 11,
                         cols: 2,
                         n_binary: 0,
                         n_character: 0,
                         n_factor: 1,
                         n_logical: 0,
                         n_numeric: 1,
                         csv: "https://vincentarelbundock.github.io/Rdatasets/csv/vcd/WomenQueue.csv",
                         doc: "https://vincentarelbundock.github.io/Rdatasets/doc/vcd/WomenQueue.html"
                       },
                     ],
                     [
                       records.size,
                       records[0].to_h,
                       records[-1].to_h
                     ])
      end
    end
  end

  sub_test_case("Rdatasets") do
    sub_test_case("datasets") do
      sub_test_case("AirPassengers") do
        def setup
          @dataset = Datasets::Rdatasets.new("datasets", "AirPassengers")
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
                         records[0],
                         records[-1]
                       ])
        end

        test("#metadata.id") do
          assert_equal("rdatasets-datasets-AirPassengers", @dataset.metadata.id)
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
          Datasets::Rdatasets.new("datasets", "invalid datasets name")
        end
      end
    end

    test("invalid package name") do
      assert_raise(ArgumentError) do
        Datasets::Rdatasets.new("invalid package name", "AirPassengers")
      end
    end
  end
end
