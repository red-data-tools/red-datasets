class Hepatitis < Test::Unit::TestCase
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
                       :class => "LIVE",
                       :age => 10,
                       :sex => "male",
                       :steroid => true,
                       :antivirals => true,
                       :fatigue => true,
                       :malaise => true,
                       :anorexia => true,
                       :liver_big => true,
                       :liver_firm => true,
                       :spleen_palpable => true,
                       :spiders => true,
                       :ascites => true,
                       :varices => true,
                       :bilirubin =>  0.39,
                       :alk_phosphate => 33,
                       :sgot => 13,
                       :albumin => 2.1,
                       :protime => 10,
                       :histology => true
                     },
                     {
                       :class => "LIVE",
                       :age => 10,
                       :sex => "male",
                       :steroid => true,
                       :antivirals => true,
                       :fatigue => true,
                       :malaise => true,
                       :anorexia => true,
                       :liver_big => true,
                       :liver_firm => true,
                       :spleen_palpable => true,
                       :spiders => true,
                       :ascites => true,
                       :varices => true,
                       :bilirubin =>  0.39,
                       :alk_phosphate => 33,
                       :sgot => 13,
                       :albumin => 2.1,
                       :protime => 10,
                       :histology => true
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