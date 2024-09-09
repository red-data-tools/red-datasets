class AdultTest < Test::Unit::TestCase
  sub_test_case("train") do
    def setup
      @dataset = Datasets::Adult.new(type: :train)
    end

    def record(*args)
      Datasets::Adult::Record.new(*args)
    end

    test("#each") do
      assert_equal({
                     :age => 39,
                     :work_class => "State-gov",
                     :final_weight => 77516,
                     :education => "Bachelors",
                     :n_education_years => 13,
                     :marital_status => "Never-married",
                     :occupation => "Adm-clerical",
                     :relationship => "Not-in-family",
                     :race => "White",
                     :sex => "Male",
                     :capital_gain => 2174,
                     :capital_loss => 0,
                     :hours_per_week => 40,
                     :native_country => "United-States",
                     :label => "<=50K"
                   },
                   @dataset.each.next.to_h)
    end
  end

  sub_test_case("test") do
    def setup
      @dataset = Datasets::Adult.new(type: :test)
    end

    def record(*args)
      Datasets::Adult::Record.new(*args)
    end

    test("#each") do
      assert_equal({
                     :age => 25,
                     :work_class => "Private",
                     :final_weight => 226802,
                     :education => "11th",
                     :n_education_years => 7,
                     :marital_status => "Never-married",
                     :occupation => "Machine-op-inspct",
                     :relationship => "Own-child",
                     :race => "Black",
                     :sex => "Male",
                     :capital_gain => 0,
                     :capital_loss => 0,
                     :hours_per_week => 40,
                     :native_country => "United-States",
                     :label => "<=50K.",
                   },
                   @dataset.each.next.to_h)
    end
  end

  sub_test_case("#metadata") do
    def setup
      @dataset = Datasets::Adult.new(type: :train)
    end

    test("#description") do
      description = @dataset.metadata.description
      assert do
        description.start_with?("| This data was extracted from the census bureau database found at")
      end
    end
  end
end
