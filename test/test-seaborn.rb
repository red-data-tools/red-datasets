class SeabornTest < Test::Unit::TestCase
  sub_test_case("list") do
    def setup
      @dataset = Datasets::SeabornList.new
    end

    def test_each
      records = @dataset.each.to_a
      assert_equal([
                     {dataset: "anagrams"},
                     {dataset: "anscombe"},
                     {dataset: "attention"},
                     {dataset: "brain_networks"},
                     {dataset: "car_crashes"},
                     {dataset: "diamonds"},
                     {dataset: "dots"},
                     {dataset: "exercise"},
                     {dataset: "flights"},
                     {dataset: "fmri"},
                     {dataset: "geyser"},
                     {dataset: "glue"},
                     {dataset: "healthexp"},
                     {dataset: "iris"},
                     {dataset: "mpg"},
                     {dataset: "penguins"},
                     {dataset: "planets"},
                     {dataset: "seaice"},
                     {dataset: "taxis"},
                     {dataset: "tips"},
                     {dataset: "titanic"},
                   ],
                   records)
    end
  end

  sub_test_case("fmri") do
    def setup
      @dataset = Datasets::Seaborn.new("fmri")
    end

    def test_each
      records = @dataset.each.to_a
      assert_equal([
                     1064,
                     {
                       subject: "s5",
                       timepoint: 14,
                       event: "stim",
                       region: "parietal",
                       signal: -0.0808829319505
                     },
                     {
                       subject: "s0",
                       timepoint: 0,
                       event: "cue",
                       region: "parietal",
                       signal: -0.00689923478092
                     }
                   ],
                   [
                     records.size,
                     records[1].to_h,
                     records[-1].to_h
                   ])
    end
  end

  sub_test_case("flights") do
    def setup
      @dataset = Datasets::Seaborn.new("flights")
    end

    def test_each
      records = @dataset.each.to_a
      assert_equal([
                     144,
                     {
                       year: 1949,
                       month: "Feb",
                       passengers: 118
                     },
                     {
                       year: 1960,
                       month: "Dec",
                       passengers: 432
                     }
                   ],
                   [
                     records.size,
                     records[1].to_h,
                     records[-1].to_h
                   ])
    end
  end

  sub_test_case("penguins") do
    def setup
      @dataset = Datasets::Seaborn.new("penguins")
    end

    def test_each
      records = @dataset.each.to_a
      assert_equal([
                     344,
                     {
                       species: "Adelie",
                       island: "Torgersen",
                       bill_length_mm: 39.5,
                       bill_depth_mm: 17.4,
                       flipper_length_mm: 186,
                       body_mass_g: 3800,
                       sex: "Female"
                     },
                     {
                       species: "Gentoo",
                       island: "Biscoe",
                       bill_length_mm: 49.9,
                       bill_depth_mm: 16.1,
                       flipper_length_mm: 213,
                       body_mass_g: 5400,
                       sex: "Male"
                     }
                   ],
                   [
                     records.size,
                     records[1].to_h,
                     records[-1].to_h
                   ])
    end
  end

  sub_test_case("attention") do
    def setup
      @dataset = Datasets::Seaborn.new("attention")
    end

    def test_each
      records = @dataset.to_a
      assert_equal([
                     60,
                     {
                       index: 1,
                       subject: 2,
                       attention: "divided",
                       solutions: 1,
                       score: 3.0
                     },
                     {
                       index: 59,
                       subject: 20,
                       attention: "focused",
                       solutions: 3,
                       score: 5.0
                     }
                   ],
                   [
                     records.size,
                     records[1],
                     records[-1]
                   ])
    end
  end
end
