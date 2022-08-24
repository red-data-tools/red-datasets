class RdatasetTest < Test::Unit::TestCase
  sub_test_case("RdatasetList") do
    def setup
      @dataset = Datasets::RdatasetList.new
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
                       1892,
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
                         package: "wooldridge",
                         dataset: "wine",
                         title: "wine",
                         rows: 21,
                         cols: 5,
                         n_binary: 0,
                         n_character: 1,
                         n_factor: 0,
                         n_logical: 0,
                         n_numeric: 4,
                         csv: "https://vincentarelbundock.github.io/Rdatasets/csv/wooldridge/wine.csv",
                         doc: "https://vincentarelbundock.github.io/Rdatasets/doc/wooldridge/wine.html"
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

  sub_test_case("Rdataset") do
    test('invalid package name') do
      assert_raise(ArgumentError) do
        Datasets::Rdataset.new('invalid package name', 'AirPassengers')
      end
    end

    sub_test_case("datasets") do
      test("invalid dataset name") do
        assert_raise(ArgumentError) do
          Datasets::Rdataset.new("datasets", "invalid datasets name")
        end
      end

      sub_test_case("AirPassengers") do
        def setup
          @dataset = Datasets::Rdataset.new("datasets", "AirPassengers")
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
          assert_equal("rdataset-datasets-AirPassengers", @dataset.metadata.id)
        end

        test("#metadata.description") do
          description = @dataset.metadata.description
          assert do
            description.include?("Monthly Airline Passenger Numbers 1949-1960")
          end
        end
      end

      sub_test_case("airquality") do
        def setup
          @dataset = Datasets::Rdataset.new("datasets", "airquality")
        end

        test("#each") do
          records = @dataset.each.to_a
          assert_equal([
                         153,
                         { Ozone: nil, "Solar.R": nil, Wind: 14.3, Temp: 56, Month: 5, Day: 5 },
                         { Ozone: 20, "Solar.R": 223, Wind: 11.5, Temp: 68, Month: 9, Day: 30 },
                       ],
                       [
                         records.size,
                         records[4],
                         records[-1]
                       ])
        end
      end

      sub_test_case('attenu') do
        def setup
          @dataset = Datasets::Rdataset.new('datasets', 'attenu')
        end

        test('#each') do
          records = @dataset.each.to_a
          assert_equal([
                         182,
                         { event: 1, mag: 7, station: "117", dist: 12, accel: 0.359 },
                         { event: 16, mag: 5.1, station: nil, dist: 7.6, accel: 0.28 },
                         { event: 23, mag: 5.3, station: "c168", dist: 25.3, accel: 0.23 },
                         { event: 23, mag: 5.3, station: "5072", dist: 53.1, accel: 0.022 }
                       ],
                       [
                         records.size,
                         records[0],
                         records[78],
                         records[169],
                         records[-1]
                       ])
        end
      end
    end

    sub_test_case('drc') do
      sub_test_case('germination') do
        def setup
          @dataset = Datasets::Rdataset.new('drc', 'germination')
        end

        test('#each') do
          records = @dataset.each.to_a
          assert_equal([
                         192,
                         { temp: 10, species: 'wheat', start: 0, end: 1.0, germinated: 0 },
                         { temp: 40, species: 'rice', start: 18, end: Float::INFINITY, germinated: 12 }
                       ],
                       [
                         records.size,
                         records[0],
                         records[-1]
                       ])
        end
      end
    end

    sub_test_case('validate') do
      sub_test_case('nace_rev2') do
        def setup
          @dataset = Datasets::Rdataset.new('validate', 'nace_rev2')
        end

        test('#each') do
          records = @dataset.each.to_a
          assert_equal([
                        996,
                        {
                          Order: 398_481,
                          Level: 1,
                          Code: 'A',
                          Parent: '',
                          Description: 'AGRICULTURE, FORESTRY AND FISHING',
                          This_item_includes: 'This section includes the exploitation of vegetal and animal natural resources, comprising the activities of growing of crops, raising and breeding of animals, harvesting of timber and other plants, animals or animal products from a farm or their natural habitats.',
                          This_item_also_includes: '',
                          Rulings: '',
                          This_item_excludes: '',
                          "Reference_to_ISIC_Rev._4": 'A'
                        },
                        {
                          Order: 399_476,
                          Level: 4,
                          Code: '99.00',
                          Parent: '99.0',
                          Description: 'Activities of extraterritorial organisations and bodies',
                          This_item_includes: "This class includes:\n- activities of international organisations such as the United Nations and the specialised agencies of the United Nations system, regional bodies etc., the International Monetary Fund, the World Bank, the World Customs Organisation, the Organisation for Economic Co-operation and Development, the organisation of Petroleum Exporting Countries, the European Communities, the European Free Trade Association etc.",
                          This_item_also_includes: "This class also includes:\n- activities of diplomatic and consular missions when being determined by the country of their location rather than by the country they represent",
                          Rulings: '',
                          This_item_excludes: '',
                          "Reference_to_ISIC_Rev._4": '9900'
                        }
                      ],
                      [
                        records.size,
                        records[0],
                        records[-1]
                      ])
        end
      end
    end
  end
end
