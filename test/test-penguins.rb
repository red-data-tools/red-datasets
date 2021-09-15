class PenguinsTest < Test::Unit::TestCase
  sub_test_case("PenguinsRawData::SpeciesBase") do
    test("#data_path") do
      data_paths = [ Datasets::PenguinsRawData::Adelie,
                     Datasets::PenguinsRawData::Gentoo,
                     Datasets::PenguinsRawData::Chinstrap ].map {|cls|
                       dataset = cls.new
                       dataset.data_path.relative_path_from(dataset.send(:cache_dir_path)).to_s
                     }
      assert_equal(["adelie.csv", "gentoo.csv", "chinstrap.csv"],
                   data_paths)
    end
  end

  sub_test_case("Adelie") do
    def setup
      @dataset = Datasets::PenguinsRawData::Adelie.new
    end

    test("#each") do
      records = @dataset.each.to_a
      assert_equal([ 152,
                     {
                       study_name: "PAL0708",
                       sample_number: 1,
                       species: "Adelie Penguin (Pygoscelis adeliae)",
                       region: "Anvers",
                       island: "Torgersen",
                       stage: "Adult, 1 Egg Stage",
                       individual_id: "N1A1",
                       clutch_completion: "Yes",
                       date_egg: DateTime.new(2007, 11, 11),
                       culmen_length_mm: 39.1,
                       culmen_depth_mm: 18.7,
                       flipper_length_mm: 181,
                       body_mass_g: 3750,
                       sex: "MALE",
                       delta_15_n_permil: nil,
                       delta_13_c_permil: nil,
                       comments: "Not enough blood for isotopes."
                     },
                     {
                       study_name: "PAL0910",
                       sample_number: 152,
                       species: "Adelie Penguin (Pygoscelis adeliae)",
                       region: "Anvers",
                       island: "Dream",
                       stage: "Adult, 1 Egg Stage",
                       individual_id: "N85A2",
                       clutch_completion: "Yes",
                       date_egg: DateTime.new(2009, 11, 17),
                       culmen_length_mm: 41.5,
                       culmen_depth_mm: 18.5,
                       flipper_length_mm: 201,
                       body_mass_g: 4000,
                       sex: "MALE",
                       delta_15_n_permil: 8.89640,
                       delta_13_c_permil: -26.06967,
                       comments: nil
                     }
                   ],
                   [
                     records.size,
                     records[0].to_h,
                     records[-1].to_h
                   ])
    end
  end

  sub_test_case("Gentoo") do
    def setup
      @dataset = Datasets::PenguinsRawData::Gentoo.new
    end

    test("#each") do
      records = @dataset.each.to_a
      assert_equal([ 124,
                     {
                       study_name: "PAL0708",
                       sample_number: 1,
                       species: "Gentoo penguin (Pygoscelis papua)",
                       region: "Anvers",
                       island: "Biscoe",
                       stage: "Adult, 1 Egg Stage",
                       individual_id: "N31A1",
                       clutch_completion: "Yes",
                       date_egg: DateTime.new(2007, 11, 27),
                       culmen_length_mm: 46.1,
                       culmen_depth_mm: 13.2,
                       flipper_length_mm: 211,
                       body_mass_g: 4500,
                       sex: "FEMALE",
                       delta_15_n_permil: 7.993,
                       delta_13_c_permil: -25.5139,
                       comments: nil
                     },
                     {
                       study_name: "PAL0910",
                       sample_number:  124,
                       species: "Gentoo penguin (Pygoscelis papua)",
                       region: "Anvers",
                       island: "Biscoe",
                       stage: "Adult, 1 Egg Stage",
                       individual_id: "N43A2",
                       clutch_completion: "Yes",
                       date_egg: DateTime.new(2009, 11, 22),
                       culmen_length_mm: 49.9,
                       culmen_depth_mm: 16.1,
                       flipper_length_mm: 213,
                       body_mass_g: 5400,
                       sex: "MALE",
                       delta_15_n_permil: 8.3639,
                       delta_13_c_permil: -26.15531,
                       comments: nil
                     }
                   ],
                   [
                     records.size,
                     records[0].to_h,
                     records[-1].to_h
                   ])
    end
  end

  sub_test_case("Chinstrap") do
    def setup
      @dataset = Datasets::PenguinsRawData::Chinstrap.new
    end

    test("#each") do
      records = @dataset.each.to_a
      assert_equal([ 68,
                     {
                       study_name: "PAL0708",
                       sample_number: 1,
                       species: "Chinstrap penguin (Pygoscelis antarctica)",
                       region: "Anvers",
                       island: "Dream",
                       stage: "Adult, 1 Egg Stage",
                       individual_id: "N61A1",
                       clutch_completion: "No",
                       date_egg: DateTime.new(2007, 11, 19),
                       culmen_length_mm: 46.5,
                       culmen_depth_mm: 17.9,
                       flipper_length_mm: 192,
                       body_mass_g: 3500,
                       sex: "FEMALE",
                       delta_15_n_permil: 9.03935,
                       delta_13_c_permil: -24.30229,
                       comments: "Nest never observed with full clutch."
                     },
                     {
                       study_name: "PAL0910",
                       sample_number: 68,
                       species: "Chinstrap penguin (Pygoscelis antarctica)",
                       region: "Anvers",
                       island: "Dream",
                       stage: "Adult, 1 Egg Stage",
                       individual_id: "N100A2",
                       clutch_completion: "Yes",
                       date_egg: DateTime.new(2009, 11, 21),
                       culmen_length_mm: 50.2,
                       culmen_depth_mm: 18.7,
                       flipper_length_mm: 198,
                       body_mass_g: 3775,
                       sex: "FEMALE",
                       delta_15_n_permil: 9.39305,
                       delta_13_c_permil: -24.25255,
                       comments: nil
                     }
                   ],
                   [
                     records.size,
                     records[0].to_h,
                     records[-1].to_h
                   ])
    end
  end

  sub_test_case("Penguins") do
    def setup
      @dataset = Datasets::Penguins.new
    end

    test("order of species") do
      species_values = @dataset.map {|r| r.species }.uniq
      assert_equal(["Adelie", "Chinstrap", "Gentoo"],
                   species_values)
    end

    test("data cleansing") do
      sex_values = @dataset.map {|r| r.sex }.uniq.compact.sort
      assert_equal(["female", "male"],
                   sex_values)
    end

    test("#each") do
      records = @dataset.each.to_a
      assert_equal([
                     344,
                     {
                       species: "Adelie",
                       island: "Torgersen",
                       bill_length_mm: 39.1,
                       bill_depth_mm: 18.7,
                       flipper_length_mm: 181,
                       body_mass_g: 3750,
                       sex: "male",
                       year: 2007
                     },
                     {
                       species: "Chinstrap",
                       island: "Dream",
                       bill_length_mm: 46.5,
                       bill_depth_mm: 17.9,
                       flipper_length_mm: 192,
                       body_mass_g: 3500,
                       sex: "female",
                       year: 2007
                     },
                     {
                       species: "Gentoo",
                       island: "Biscoe",
                       bill_length_mm: 46.1,
                       bill_depth_mm: 13.2,
                       flipper_length_mm: 211,
                       body_mass_g: 4500,
                       sex: "female",
                       year: 2007
                     },
                     {
                       species: "Gentoo",
                       island: "Biscoe",
                       bill_length_mm: 49.9,
                       bill_depth_mm: 16.1,
                       flipper_length_mm: 213,
                       body_mass_g: 5400,
                       sex: "male",
                       year: 2009
                     }
                   ],
                   [
                     records.size,
                     records[0].to_h,
                     records[152].to_h,
                     records[220].to_h,
                     records[-1].to_h,
                   ])
    end
  end
end
