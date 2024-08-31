class HouseOfRepresentativeTest < Test::Unit::TestCase
  def setup
    @dataset = Datasets::HouseOfRepresentative.new
  end

  def record(*args)
    Datasets::HouseOfRepresentative::Record.new(*args)
  end

  test("#each") do
    assert_equal(record(142,
                        "衆法の一覧",
                        nil,
                        139,
                        18,
                        "市民活動促進法案",
                        "成立",
                        "経過",
                        "https://www.shugiin.go.jp/internet/itdb_gian.nsf/html/gian/keika/5516.htm",
                        nil,
                        nil,
                        "衆法",
                        "熊代　昭彦君外四名",
                        %w(自由民主党 社会民主党・市民連合 新党さきがけ),
                        nil,
                        nil,
                        nil,
                        Date.jisx0301("H10.03.04"),
                        Date.jisx0301("H10.03.11"),
                        "内閣",
                        Date.jisx0301("H10.03.17"),
                        "可決",
                        Date.jisx0301("H10.03.19"),
                        "可決",
                        nil,
                        nil,
                        nil,
                        nil,
                        nil,
                        nil,
                        nil,
                        Date.jisx0301("H10.01.12"),
                        "労働・社会政策",
                        Date.jisx0301("H10.03.03"),
                        "修正",
                        Date.jisx0301("H10.03.04"),
                        "修正",
                        Date.jisx0301("H10.03.25"),
                        7,
                        nil,
                        nil),
                 @dataset.each.next)
  end
end
