class AozoraBunkoTest < Test::Unit::TestCase
  test('#new') do
    datasets = Datasets::AozoraBunko.new
    assert_equal({
                   title_id: '059898',
                   title: 'ウェストミンスター寺院',
                   title_reading: 'ウェストミンスターじいん',
                   title_reading_collation: 'うえすとみんすたあしいん',
                   subtitle: '',
                   subtitle_reading: '',
                   original_title: '',
                   first_appearance: '',
                   ndc_code: 'NDC 933',
                   syllabary_spelling_type: '新字新仮名',
                   title_copyrighted: 'なし',
                   published_date: '2020-04-03',
                   last_updated_date: '2020-03-28',
                   detail_url: 'https://www.aozora.gr.jp/cards/001257/card59898.html',
                   person_id: '001257',
                   person_family_name: 'アーヴィング',
                   person_first_name: 'ワシントン',
                   person_family_name_reading: 'アーヴィング',
                   person_first_name_reading: 'ワシントン',
                   person_family_name_reading_collation: 'ああういんく',
                   person_first_name_reading_collation: 'わしんとん',
                   person_family_name_romaji: 'Irving',
                   person_first_name_romaji: 'Washington',
                   person_type: '著者',
                   person_birthday: '1783-04-03',
                   person_date_of_death: '1859-11-28',
                   person_copyrighted: 'なし',
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
                   last_text_file_updated_date: '2020-03-28',
                   text_file_character_encoding: 'ShiftJIS',
                   text_file_character_set: 'JIS X 0208',
                   text_file_updating_count: '0',
                   html_file_url: 'https://www.aozora.gr.jp/cards/001257/files/59898_70731.html',
                   last_html_file_updated_date: '2020-03-28',
                   html_file_character_encoding: 'ShiftJIS',
                   html_file_character_set: 'JIS X 0208',
                   html_file_updating_count: '0'

                 },
                 datasets.first.to_h)
  end

  sub_test_case(:Record) do
    test('#text method can read from text_file_url') do
      record = Datasets::AozoraBunko::Record.new
      record.title_id = '059898'
      record.person_id = '001257'
      record.text_file_url = 'https://www.aozora.gr.jp/cards/001257/files/59898_ruby_70679.zip'
      record.text_file_character_encoding = 'ShiftJIS'

      assert_equal([
                     'ウェストミンスター寺',
                     "アの皆さんです。\r\n"
                   ],
                   [
                     record.text[0, 10],
                     record.text[-10, 10]
                   ])
    end

    test('#text method cannot read from text_file_url') do
      record = Datasets::AozoraBunko::Record.new
      record.text_file_url = 'https://mega.nz/file/6tMxgAjZ#PglDDyJL0syRhnULqK0qhTMC7cktsgqwObj5fY_knpE'

      assert_equal(nil, record.text)
    end
  end
end
