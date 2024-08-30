class GeoloniaTest < Test::Unit::TestCase
  def setup
    @dataset = Datasets::Geolonia.new
  end

  test('#each') do
    assert_equal({
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
                   :longitude => "141.319722",
                 },
                 @dataset.each.next.to_h)
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
