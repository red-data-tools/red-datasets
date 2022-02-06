class GeoloniaTest < Test::Unit::TestCase
  def setup
    @dataset = Datasets::Geolonia.new
  end

  test('#each') do
    records = @dataset.each.to_a
    assert_equal([
                   277191,
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
                     :municipality_code => "47325",
                     :municipality_name => "中頭郡嘉手納町",
                     :municipality_kana => "ナカガミグンカデナチョウ",
                     :municipality_romaji => "NAKAGAMI GUN KADENA CHO",
                     :street_name => "字兼久",
                     :street_kana => nil,
                     :street_romaji => nil,
                     :alias => "下原",
                     :latitude => "26.351841",
                     :longitude => "127.744975",
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
                   ],
                   description.scan(/^#.*$/),
                   description)
    end
  end

end
