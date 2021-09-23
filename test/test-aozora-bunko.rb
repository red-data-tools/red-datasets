class AozoraBunkoTest < Test::Unit::TestCase
  test('#new') do
    datasets = Datasets::AozoraBunko.new
    assert_equal({
                   title_id: '059898',
                   title: 'ウェストミンスター寺院',
                   title_reading: 'ウェストミンスターじいん',
                   title_reading_collation: 'うえすとみんすたあしいん',
                   sub_title: '',
                   sub_title_reading: '',
                   original_title: '',
                   first_appearance: '',
                   ndc_code: 'NDC 933',
                   syllabary_spelling_type: '新字新仮名',
                   copyright_for_title: 'なし',
                   published_date: '2020-04-03',
                   latest_updated_date: '2020-03-28',
                   detail_url: 'https://www.aozora.gr.jp/cards/001257/card59898.html',
                   person_id: '001257',
                   person_family_name: 'アーヴィング',
                   person_first_name: 'ワシントン',
                   person_family_name_reading: 'アーヴィング',
                   person_first_name_reading: 'ワシントン',
                   person_family_name_collation: 'ああういんく',
                   person_first_name_collation: 'わしんとん',
                   person_family_name_roman: 'Irving',
                   person_first_name_roman: 'Washington',
                   person_type: '著者',
                   person_birthday: '1783-04-03',
                   person_death_day: '1859-11-28',
                   copyright_for_person: 'なし',
                   original_book_name1: 'スケッチ・ブック',
                   original_book_publisher_name1: '新潮文庫、新潮社',
                   original_book_first_published_date1: '1957（昭和32）年5月20日',
                   used_version_for_registration1: '2000（平成12）年2月20日33刷改版',
                   used_version_for_proofreading1: '2000（平成12）年2月20日33刷改版',
                   base_of_original_book_name1: '',
                   base_of_original_book_publisher_name1: '',
                   base_of_original_book_first_published_date1: '',
                   original_book_name2: '',
                   original_book_publisher_name2: '',
                   original_book_first_published_date2: '',
                   used_version_for_registration2: '',
                   used_version_for_proofreading2: '',
                   base_of_original_book_name2: '',
                   base_of_original_book_publisher_name2: '',
                   base_of_original_book_first_published_date2: '',
                   registered_person_name: 'えにしだ',
                   proofreader_name: '砂場清隆',
                   text_file_url: 'https://www.aozora.gr.jp/cards/001257/files/59898_ruby_70679.zip',
                   latest_text_file_updated_date: '2020-03-28',
                   text_file_character_encoding: 'ShiftJIS',
                   text_character_set: 'JIS X 0208',
                   text_file_updating_count: '0',
                   html_file_url: 'https://www.aozora.gr.jp/cards/001257/files/59898_70731.html',
                   latest_html_file_updated_date: '2020-03-28',
                   html_file_character_encoding: 'ShiftJIS',
                   html_character_set: 'JIS X 0208',
                   html_file_updating_count: '0'

                 },
                 datasets.first.to_h)
  end

  sub_test_case(:Record) do
    test('#text method can read from text_file_url') do
      source_text = '"059898","ウェストミンスター寺院","ウェストミンスターじいん","うえすとみんすたあしいん","","","","","NDC 933","新字新仮名","なし",2020-04-03,2020-03-28,"https://www.aozora.gr.jp/cards/001257/card59898.html","001257","アーヴィング","ワシントン","アーヴィング","ワシントン","ああういんく","わしんとん","Irving","Washington","著者","1783-04-03","1859-11-28","なし","スケッチ・ブック","新潮文庫、新潮社","1957（昭和32）年5月20日","2000（平成12）年2月20日33刷改版","2000（平成12）年2月20日33刷改版","","","","","","","","","","","","えにしだ","砂場清隆","https://www.aozora.gr.jp/cards/001257/files/59898_ruby_70679.zip","2020-03-28","ShiftJIS","JIS X 0208","0","https://www.aozora.gr.jp/cards/001257/files/59898_70731.html","2020-03-28","ShiftJIS","JIS X 0208","0"'
      csv = CSV.parse(source_text)
      record = Datasets::AozoraBunko::Record.new(*csv.first)

      assert_equal(
        true,
        record.text.start_with?('ウェストミンスター寺院')
      )

      assert_equal(
        true,
        record.text.chomp.end_with?('制作にあたったのは、ボランティアの皆さんです。')
      )
    end

    test('#text method cannot read from text_file_url') do
      source_text = '"060543","Ｊ・Ｆ・ケネディ大統領就任演説　1961年１月20日","ジェー・エフ・ケネディだいとうりょうしゅうにんえんぜつ　せんきゅうひゃくろくじゅういちねんいちがつはつか","しえええふけねていたいとうりようしゆうにんえんせつせんきゆうひやくろくしゆういちねんいちかつはつか","","","","","","新字新仮名","あり",2021-01-20,2020-12-26,"https://www.aozora.gr.jp/cards/000892/card60543.html","002160","加藤","光一","かとう","こういち","かとう","こういち","Kato","Koichi","翻訳者","","","あり","","","","","","","","","","","","","","","","","加藤　光一","","https://mega.nz/file/6tMxgAjZ#PglDDyJL0syRhnULqK0qhTMC7cktsgqwObj5fY_knpE","2020-04-13","UTF-8","Unicode","0","","","","",""'
      csv = CSV.parse(source_text)
      record = Datasets::AozoraBunko::Record.new(*csv.first)

      assert_equal('', record.text)
    end
  end
end
