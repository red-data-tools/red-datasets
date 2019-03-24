class PostalCodeJapanTest < Test::Unit::TestCase
  sub_test_case(":reading") do
    test(":lowercase") do
      dataset = Datasets::PostalCodeJapan.new(reading: :lowercase)
      assert_equal({
                     organization_code: "01101",
                     old_postal_code: "060",
                     postal_code: "0600000",
                     prefecture_reading: "ﾎｯｶｲﾄﾞｳ",
                     city_reading: "ｻｯﾎﾟﾛｼﾁｭｳｵｳｸ",
                     address_reading: "ｲｶﾆｹｲｻｲｶﾞﾅｲﾊﾞｱｲ",
                     prefecture: "北海道",
                     city: "札幌市中央区",
                     address: "以下に掲載がない場合",
                     have_multiple_postal_codes: false,
                     have_address_number_per_koaza: false,
                     have_chome: false,
                     postal_code_is_shared: false,
                     changed: false,
                     change_reason: nil,
                   },
                   dataset.first.to_h)
    end

    test(":uppercase") do
      dataset = Datasets::PostalCodeJapan.new(reading: :uppercase)
      assert_equal({
                     organization_code: "01101",
                     old_postal_code: "060",
                     postal_code: "0600000",
                     prefecture_reading: "ﾎﾂｶｲﾄﾞｳ",
                     city_reading: "ｻﾂﾎﾟﾛｼﾁﾕｳｵｳｸ",
                     address_reading: "ｲｶﾆｹｲｻｲｶﾞﾅｲﾊﾞｱｲ",
                     prefecture: "北海道",
                     city: "札幌市中央区",
                     address: "以下に掲載がない場合",
                     have_multiple_postal_codes: false,
                     have_address_number_per_koaza: false,
                     have_chome: false,
                     postal_code_is_shared: false,
                     changed: false,
                     change_reason: nil,
                   },
                   dataset.first.to_h)
    end

    test(":romaji") do
      dataset = Datasets::PostalCodeJapan.new(reading: :romaji)
      assert_equal({
                     organization_code: nil,
                     old_postal_code: nil,
                     postal_code: "0600000",
                     prefecture_reading: "HOKKAIDO",
                     city_reading: "SAPPORO SHI CHUO KU",
                     address_reading: "IKANIKEISAIGANAIBAAI",
                     prefecture: "北海道",
                     city: "札幌市　中央区",
                     address: "以下に掲載がない場合",
                     have_multiple_postal_codes: false,
                     have_address_number_per_koaza: false,
                     have_chome: false,
                     postal_code_is_shared: false,
                     changed: false,
                     change_reason: nil,
                   },
                   dataset.first.to_h)
    end
  end
end
