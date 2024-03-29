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
                   10521,
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
                   record(212,
                          "規則の一覧",
                          nil,
                          212,
                          1,
                          "衆議院規則の一部を改正する規則案",
                          "衆議院で閉会中審査",
                          "経過",
                          "https://www.shugiin.go.jp/internet/itdb_gian.nsf/html/gian/keika/1DDAB2A.htm",
                          nil,
                          nil,
                          "規則",
                          "遠藤　敬君外五名",
                          %w(日本維新の会 国民民主党・無所属クラブ 有志の会),
                          nil,
                          nil,
                          nil,
                          Date.jisx0301("R05.12.11"),
                          Date.jisx0301("R05.12.12"),
                          "議院運営",
                          nil,
                          nil,
                          nil,
                          "閉会中審査",
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
                          nil,
                          nil,
                          nil,
                          %w(遠藤敬君 中司宏君 金村龍那君 古川元久君 浅野哲君 福島伸享君),
                          %w(足立康史君 阿部司君 阿部弘樹君 青柳仁士君 赤木正幸君 浅川義治君 井上英孝君 伊東信久君 池下卓君 池畑浩太朗君 一谷勇一郎君 市村浩一郎君 岩谷良平君 浦野靖人君 漆間譲司君 遠藤良太君 小野泰輔君 奥下剛光君 沢田良君 杉本和巳君 住吉寛紀君 空本誠喜君 高橋英明君 中嶋秀樹君 馬場伸幸君 早坂敦君 林佑美君 藤田文武君 藤巻健太君 堀場幸子君 掘井健智君 三木圭恵君 美延映夫君 岬麻紀君 守島正君 山本剛正君 吉田とも代君 和田有一朗君 鈴木義弘君 田中健君 玉木雄一郎君 長友慎治君 西岡秀子君 吉良州司君 北神圭朗君 緒方林太郎君)),
                 ],
                 [
                   records.size,
                   records.first,
                   records.last,
                 ])
  end
end
