class JapaneseDateParserTest < Test::Unit::TestCase
  data("month and day with leading a space in Heisei", ["H10.01.01", "平成10年 1月 1日"])
  data("month         with leading a space in Heisei", ["H10.01.10", "平成10年 1月10日"])
  data("          day with leading a space in Heisei", ["H10.10.01", "平成10年10月 1日"])
  data("           without leading a space in Heisei", ["H10.10.10", "平成10年10月10日"])
  data("year, month and day with leading a space in Reiwa", ["R02.01.01", "令和 2年 1月 1日"])
  data("year, month         with leading a space in Reiwa", ["R02.01.10", "令和 2年 1月10日"])
  data("year,           day with leading a space in Reiwa", ["R02.10.01", "令和 2年10月 1日"])
  data("year,            without leading a space in Reiwa", ["R02.10.10", "令和 2年10月10日"])
  data("boundary within Heisei", ["H31.04.30", "平成31年 4月30日"])
  data("boundary within Reiwa", ["R01.05.01", "令和元年 5月 1日"])
  test("#parse") do
    expected_jisx0301, japanese_date_string = data
    assert_equal(expected_jisx0301, Datasets::JapaneseDateParser.new(japanese_date_string).parse.jisx0301)
  end

  test("unsupported era initial range") do
    expected_message = "era must be one of [平成, 令和]: 昭和"
    assert_raise(Datasets::JapaneseDateParser::UnsupportedEraInitialRange.new(expected_message)) do
      Datasets::JapaneseDateParser.new("昭和元年 1月 1日").parse
    end
  end
end
