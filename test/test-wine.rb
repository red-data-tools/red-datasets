class WineTest < Test::Unit::TestCase
  def setup
    @dataset = Datasets::Wine.new
  end

  test('#each') do
    records = @dataset.each.to_a
    assert_equal([
                   178,
                   {
                     :alcalinity_of_ash => 15.6,
                     :alcohol => 14.23,
                     :ash => 2.43,
                     :label => 1,
                     :color_intensity => 5.64,
                     :hue => 1.04,
                     :malic_acid => 1.71,
                     :total_flavonoids => 3.06,
                     :n_magnesiums => 127,
                     :total_nonflavanoid_phenols => 0.28,
                     :total_proanthocyanins => 2.29,
                     :n_prolines => 1065,
                     :optical_nucleic_acid_concentration => 3.92,
                     :total_phenols => 2.8
                   },
                   {
                     :alcalinity_of_ash => 24.5,
                     :alcohol => 14.13,
                     :ash => 2.74,
                     :label => 3,
                     :color_intensity => 9.2,
                     :hue => 0.61,
                     :malic_acid => 4.1,
                     :total_flavonoids => 0.76,
                     :n_magnesiums => 96,
                     :total_nonflavanoid_phenols => 0.56,
                     :total_proanthocyanins => 1.35,
                     :n_prolines => 560,
                     :optical_nucleic_acid_concentration => 1.6,
                     :total_phenols => 2.05,
                   },
                 ],
                 [
                   records.size,
                   records[0].to_h,
                   records[-1].to_h,
                 ])
  end

  sub_test_case('#metadata') do
    test('#description') do
      description = @dataset.metadata.description
      assert do
        description.start_with?('1. Title of Database: Wine recognition data')
      end
    end
  end
end
