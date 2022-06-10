class CLDRPluralsTest < Test::Unit::TestCase
  def setup
    @dataset = Datasets::CLDRPlurals.new
  end

  def locale(*args)
    Datasets::CLDRPlurals::Locale.new(*args)
  end

  def rule(*args)
    Datasets::CLDRPlurals::Rule.new(*args)
  end

  test("#each") do
    locales = @dataset.each.to_a
    assert_equal([
                   219,
                   locale("bm",
                          [
                            rule("other",
                                 nil,
                                 [
                                   0..15,
                                   100,
                                   1000,
                                   10000,
                                   100000,
                                   1000000,
                                   :elipsis,
                                 ],
                                 [
                                   0.0..1.5,
                                   10.0,
                                   100.0,
                                   1000.0,
                                   10000.0,
                                   100000.0,
                                   1000000.0,
                                   :elipsis,
                                 ])
                          ]),
                   locale("kw",
                          [
                            rule("zero",
                                 [:equal, "n", [0]],
                                 [0],
                                 [0.0, 0.00, 0.000, 0.0000]),
                            rule("one",
                                 [:equal, "n", [1]],
                                 [1],
                                 [1.0, 1.00, 1.000, 1.0000]),
                            rule("two",
                                 [:or,
                                  [:equal,
                                   [:mod, "n", 100],
                                   [2, 22, 42, 62, 82]],
                                  [:and,
                                   [:equal, [:mod, "n", 1000], [0]],
                                   [:equal,
                                    [:mod, "n", 100000],
                                    [1000..20000, 40000, 60000, 80000]]],
                                  [:and,
                                   [:not_equal, "n", [0]],
                                   [:equal, [:mod, "n", 1000000], [100000]]]],
                                 [
                                   2,
                                   22,
                                   42,
                                   62,
                                   82,
                                   102,
                                   122,
                                   142,
                                   1000,
                                   10000,
                                   100000,
                                   :elipsis,
                                 ],
                                 [
                                   2.0,
                                   22.0,
                                   42.0,
                                   62.0,
                                   82.0,
                                   102.0,
                                   122.0,
                                   142.0,
                                   1000.0,
                                   10000.0,
                                   100000.0,
                                   :elipsis,
                                 ]),
                            rule("few",
                                 [:equal,
                                  [:mod, "n", 100],
                                  [3, 23, 43, 63, 83]],
                                 [
                                   3,
                                   23,
                                   43,
                                   63,
                                   83,
                                   103,
                                   123,
                                   143,
                                   1003,
                                   :elipsis,
                                 ],
                                 [
                                   3.0,
                                   23.0,
                                   43.0,
                                   63.0,
                                   83.0,
                                   103.0,
                                   123.0,
                                   143.0,
                                   1003.0,
                                   :elipsis,
                                 ]),
                            rule("many",
                                 [:and,
                                  [:not_equal, "n", [1]],
                                  [:equal,
                                   [:mod, "n", 100],
                                   [1, 21, 41, 61, 81]]],
                                 [
                                   21,
                                   41,
                                   61,
                                   81,
                                   101,
                                   121,
                                   141,
                                   161,
                                   1001,
                                   :elipsis,
                                 ],
                                 [
                                   21.0,
                                   41.0,
                                   61.0,
                                   81.0,
                                   101.0,
                                   121.0,
                                   141.0,
                                   161.0,
                                   1001.0,
                                   :elipsis,
                                 ]),
                            rule("other",
                                 nil,
                                 [4..19, 100, 1004, 1000000, :elipsis],
                                 [
                                   0.1..0.9,
                                   1.1..1.7,
                                   10.0,
                                   100.0,
                                   1000.1,
                                   1000000.0,
                                   :elipsis,
                                 ]),
                          ]),
                 ],
                 [
                   locales.size,
                   locales[0],
                   locales[-4],
                 ])
  end

  sub_test_case("#metadata") do
    test("#description") do
      description = @dataset.metadata.description
      assert do
        description.start_with?("Language plural rules in Unicode Common Locale Data Repository.")
      end
    end
  end
end
