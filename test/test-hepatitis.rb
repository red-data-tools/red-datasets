class HepatitisTest < Test::Unit::TestCase
  sub_test_case("train") do
    def setup
      @dataset = Datasets::Hepatitis.new(type: :train)
    end

    def record(*args)
      Datasets::Hepatitis::Record.new(*args)
    end

    test("#each") do
      records = @dataset.each.to_a
      assert_equal([
                     155,
                     {
                         :label => 2,
                         :age => 30,
                         :sex => 2,
                         :steroid => 1,
                         :antivirals => 2,
                         :fatigue => 2,
                         :malaise => 2,
                         :anorexia => 2,
                         :liver_big => 1,
                         :liver_firm => 2,
                         :spleen_palpable => 2,
                         :spiders => 2,
                         :ascites => 2,
                         :varices => 2,
                         :bilirubin => 1.0,
                         :alk_phosphate => 85,
                         :sgot => 18,
                         :albumin => 4.0,
                         :protime => "?",
                         :histology => 1
                     },
                     {
                       :label=>1,
                       :age=>43,
                       :sex=>1,
                       :steroid=>2,
                       :antivirals=>2,
                       :fatigue=>1,
                       :malaise=>2,
                       :anorexia=>2,
                       :liver_big=>2,
                       :liver_firm=>2,
                       :spleen_palpable=>1,
                       :spiders=>1,
                       :ascites=>1,
                       :varices=>2,
                       :bilirubin=>1.2,
                       :alk_phosphate=>100,
                       :sgot=>19,
                       :albumin=>3.1,
                       :protime=>42,
                       :histology=>2
                     }
                   ],
                   [
                     records.size,
                     records[0].to_h,
                     records[-1].to_h
                   ])
    end
  end
end
