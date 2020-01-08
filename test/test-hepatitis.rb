class HepatitisTest < Test::Unit::TestCase
  def setup
    @dataset = Datasets::Hepatitis.new
  end

  def record(*args)
    Datasets::Hepatitis::Record.new(*args)
  end

  test("#each") do
    records = @dataset.each.to_a
    assert_equal([
                   155,
                   {
                     :label => :live,
                     :age => 30,
                     :sex => :female,
                     :steroid => false,
                     :antivirals => true,
                     :fatigue => true,
                     :malaise => true,
                     :anorexia => true,
                     :liver_big => false,
                     :liver_firm => true,
                     :spleen_palpable => true,
                     :spiders => true,
                     :ascites => true,
                     :varices => true,
                     :bilirubin => 1.0,
                     :alkaline_phosphate => 85,
                     :sgot => 18,
                     :albumin => 4.0,
                     :protime => nil,
                     :histology => false,
                   },
                   {
                     :label => :die,
                     :age => 43,
                     :sex => :male,
                     :steroid => true,
                     :antivirals => true,
                     :fatigue => false,
                     :malaise => true,
                     :anorexia => true,
                     :liver_big => true,
                     :liver_firm => true,
                     :spleen_palpable => false,
                     :spiders => false,
                     :ascites => false,
                     :varices => true,
                     :bilirubin => 1.2,
                     :alkaline_phosphate => 100,
                     :sgot => 19,
                     :albumin => 3.1,
                     :protime => 42,
                     :histology => true,
                   }
                 ],
                 [
                   records.size,
                   records[0].to_h,
                   records[-1].to_h,
                 ])
  end

  sub_test_case("#metadata") do
    test("#description") do
      description = @dataset.metadata.description
      assert do
        description.start_with?("1. Title: Hepatitis Domain")
      end
    end
  end
end
