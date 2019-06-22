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
                     32561,
                     {
                       :Class => "LIVE",
                       :AGE => 10,
                       :SEX => "male",
                       :STEROID => true,
                       :ANTIVIRALS => true,
                       :FATIGUE => true,
                       :MALAISE => true,
                       :ANOREXIA => true,
                       :LIVER_BIG => true,
                       :LIVER_FIRM => true,
                       :SPLEEN_PALPABLE => true,
                       :SPIDERS => true,
                       :ASCITES => true,
                       :VARICES => true,
                       :BILIRUBIN =>  0.39,
                       :ALK_PHOSPHATE => 33,
                       :SGOT => 13,
                       :ALBUMIN => 2.1,
                       :PROTIME => 10,
                       :HISTOLOGY => true
                     },
                     {
                       :Class => "LIVE",
                       :AGE => 10,
                       :SEX => "male",
                       :STEROID => true,
                       :ANTIVIRALS => true,
                       :FATIGUE => true,
                       :MALAISE => true,
                       :ANOREXIA => true,
                       :LIVER_BIG => true,
                       :LIVER_FIRM => true,
                       :SPLEEN_PALPABLE => true,
                       :SPIDERS => true,
                       :ASCITES => true,
                       :VARICES => true,
                       :BILIRUBIN =>  0.39,
                       :ALK_PHOSPHATE => 33,
                       :SGOT => 13,
                       :ALBUMIN => 2.1,
                       :PROTIME => 10,
                       :HISTOLOGY => true
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