class AdultTest < Test::Unit::TestCase
  def setup
    @dataset = Datasets::Adult.new
  end

  def record(*args)
    Datasets::Adult::Record.new(*args)
  end

  test("#each") do
    records = @dataset.each.to_a
    assert_equal([
                   32561,
                   record(39, "State-gov", 77516, "Bachelors", 13, "Never-married", "Adm-clerical", "Not-in-family", "White", "Male", 2174, 0, 40, "United-States", "<=50K"),
                   record(52, "Self-emp-inc", 287927, "HS-grad", 9, "Married-civ-spouse", "Exec-managerial", "Wife", "White", "Female", 15024, 0, 40, "United-States", ">50K"),
                 ],
                 [
                   records.size,
                   records[0],
                   records[-1],
                 ])
  end

  sub_test_case("#metadata") do
    test("#description") do
      description = @dataset.metadata.description
      assert do
        description.start_with?("| This data was extracted from the census bureau database found at")
      end
    end
  end
end
