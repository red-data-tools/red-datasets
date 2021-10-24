class AozoraBunkoTest < Test::Unit::TestCase
  include Helper::PathRestorable

  def setup
    @dataset = Datasets::AozoraBunko.new
    @cache_path = @dataset.send(:cache_path)
  end

  test('#new') do
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
                   copyrighted: false,
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
                   person_copyrighted: false,
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
                 @dataset.first.to_h)
  end

  sub_test_case(:Record) do
    sub_test_case('#text') do
      test('#readable') do
        record = Datasets::AozoraBunko::Record.new
        record.cache_path = @cache_path
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

      test('not readable') do
        record = Datasets::AozoraBunko::Record.new
        record.text_file_url = 'https://mega.nz/file/6tMxgAjZ#PglDDyJL0syRhnULqK0qhTMC7cktsgqwObj5fY_knpE'

        assert_equal(nil, record.text)
      end
    end

    sub_test_case('html') do
      sub_test_case('readable') do
        test('encoding is ShiftJIS') do
          record = Datasets::AozoraBunko::Record.new
          record.cache_path = @cache_path
          record.title_id = '059898'
          record.person_id = '001257'
          record.html_file_url = 'https://www.aozora.gr.jp/cards/001257/files/59898_70731.html'
          record.html_file_character_encoding = 'ShiftJIS'

          assert_equal("\t<title>ワシントン・アーヴィング　Washington Irving 吉田甲子太郎訳 ウェストミンスター寺院</title>",
                       record.html.split("\r\n")[8])
        end

        test('encoding is UTF-8') do
          record = Datasets::AozoraBunko::Record.new
          record.cache_path = @cache_path

          record.title_id = '000750'
          record.person_id = '000146'
          record.html_file_url = 'http://www.lcv.ne.jp/~ibs52086/fire/'
          record.html_file_character_encoding = 'UTF-8'

          assert_equal('<title>種田山頭火句集 | 『草木塔抄』他　FIRE ON THE MOUNTAIN</title>',
                       record.html.split("\n")[7])
        end
      end

      test('not readable') do
        record = Datasets::AozoraBunko::Record.new
        record.html_file_url = ''

        assert_equal(nil, record.html)
      end
    end

    sub_test_case('converting boolean') do
      test('#person_copyrighted?') do
        record = @dataset.first
        assert_equal([
                       false,
                       false,
                       false,
                     ],
                     [
                       record.person_copyrighted?,
                       record.person_copyrighted,
                       record.to_h[:person_copyrighted],
                     ])
      end

      test('#copyrighted?') do
        record = @dataset.first
        assert_equal([
                       false,
                       false,
                       false,
                     ],
                     [
                       record.copyrighted?,
                       record.copyrighted,
                       record.to_h[:copyrighted],
                     ])
      end
    end

    test('#clear_cache! removes all cache files') do
      record = Datasets::AozoraBunko::Record.new
      record.cache_path = @cache_path

      record.title_id = '059898'
      record.person_id = '001257'
      record.text_file_url = 'https://www.aozora.gr.jp/cards/001257/files/59898_ruby_70679.zip'
      record.text_file_character_encoding = 'ShiftJIS'
      record.html_file_url = 'https://www.aozora.gr.jp/cards/001257/files/59898_70731.html'
      record.html_file_character_encoding = 'ShiftJIS'

      record.text
      record.html

      restore_path(@cache_path.base_dir) do
        assert_equal(true, @cache_path.base_dir.exist?)
        assert_equal(true, record.send(:text_file_output_path).exist?)
        assert_equal(true, record.send(:html_file_output_path).exist?)
        @dataset.clear_cache!
        assert_equal(false, record.send(:html_file_output_path).exist?)
        assert_equal(false, record.send(:text_file_output_path).exist?)
        assert_equal(false, @cache_path.base_dir.exist?)
      end
    end
  end
end
