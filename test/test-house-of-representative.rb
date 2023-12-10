class HouseOfRepresentativeTest < Test::Unit::TestCase
  def setup
    @dataset = Datasets::HouseOfRepresentative.new
  end

  def record(*args)
    Datasets::HouseOfRepresentative::Record.new(*args)
  end

  test("#each") do
    records = @dataset.each.to_a
    assert_equal([
                   10516,
                   record(142,
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
                          "平成10年 3月 4日",
                          "平成10年 3月11日",
                          "内閣",
                          "平成10年 3月17日",
                          "可決",
                          "平成10年 3月19日",
                          "可決",
                          nil,
                          [],
                          [],
                          nil,
                          nil,
                          nil,
                          nil,
                          "平成10年 1月12日",
                          "労働・社会政策",
                          "平成10年 3月 3日",
                          "修正",
                          "平成10年 3月 4日",
                          "修正",
                          "平成10年 3月25日",
                          "7",
                          [],
                          []),
                   record(212,
                          "規則の一覧",
                          nil,
                          211,
                          1,
                          "衆議院規則の一部を改正する規則案",
                          "衆議院で審議中",
                          "経過",
                          "https://www.shugiin.go.jp/internet/itdb_gian.nsf/html/gian/keika/1DD8EE6.htm",
                          nil,
                          nil,
                          "規則",
                          "中司　宏君外三名",
                          %w(日本維新の会),
                          nil,
                          nil,
                          nil,
                          nil,
                          "令和 5年10月20日",
                          "議院運営",
                          nil,
                          nil,
                          nil,
                          nil,
                          nil,
                          [],
                          [],
                          nil,
                          nil,
                          nil,
                          nil,
                          nil,
                          nil,
                          nil,
                          nil,
                          nil,
                          nil,
                          nil,
                          nil,
                          %w(中司宏君 岩谷良平君 守島正君 吉田とも代君),
                          %w(足立康史君 阿部司君 阿部弘樹君 青柳仁士君 赤木正幸君 浅川義治君 井上英孝君 伊東信久君 池下卓君 池畑浩太朗君 一谷勇一郎君 市村浩一郎君 浦野靖人君 漆間譲司君 遠藤敬君 遠藤良太君 小野泰輔君 奥下剛光君 金村龍那君 沢田良君 杉本和巳君 住吉寛紀君 空本誠喜君 高橋英明君 馬場伸幸君 早坂敦君 林佑美君 藤田文武君 藤巻健太君 堀場幸子君 掘井健智君 三木圭恵君 美延映夫君 岬麻紀君 山本剛正君 和田有一朗君)),
                 ],
                 [
                   records.size,
                   records.first,
                   records.last,
                 ])
  end
end
