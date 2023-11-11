class GeoloniaTest < Test::Unit::TestCase
  def setup
    @dataset = Datasets::Geolonia.new
  end

  test('#each') do
    records = @dataset.each.to_a
    assert_equal([
                   277656,
                   {
                     :prefecture_code => "01",
                     :prefecture_name => "北海道",
                     :prefecture_kana => "ホッカイドウ",
                     :prefecture_romaji => "HOKKAIDO",
                     :municipality_code => "01101",
                     :municipality_name => "札幌市中央区",
                     :municipality_kana => "サッポロシチュウオウク",
                     :municipality_romaji => "SAPPORO SHI CHUO KU",
                     :street_name => "旭ケ丘一丁目",
                     :street_kana => "アサヒガオカ 1",
                     :street_romaji => "ASAHIGAOKA 1",
                     :alias => nil,
                     :latitude => "43.04223",
                     :longitude => "141.319722"
                   },
                   {
                     :prefecture_code => "47",
                     :prefecture_name => "沖縄県",
                     :prefecture_kana => "オキナワケン",
                     :prefecture_romaji => "OKINAWA KEN",
                     :municipality_code => "47382",
                     :municipality_name => "八重山郡与那国町",
                     :municipality_kana => "ヤエヤマグンヨナグニチョウ",
                     :municipality_romaji => "YAEYAMA GUN YONAGUNI CHO",
                     :street_name => "字与那国",
                     :street_kana => nil,
                     :street_romaji => nil,
                     :alias => nil,
                     :latitude => "24.455925",
                     :longitude => "122.987678",
                   },
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
      assert_equal([
                     "# Geolonia 住所データ",
                     "## 住所データ仕様",
                     "### ファイルフォーマット",
                     "### 列",
                     "### ソート順",
                   ],
                   description.scan(/^#.*$/),
                   description)
    end
  end

end
