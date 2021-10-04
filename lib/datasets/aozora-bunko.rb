require_relative 'dataset'

module Datasets
  # Dataset for AozoraBunko
  class AozoraBunko < Dataset
    Record = Struct.new(
      # 作品ID,作品名,作品名読み,ソート用読み,副題,副題読み,原題,初出,分類番号,文字遣い種別,作品著作権フラグ,公開日,最終更新日,図書カードURL,
      :title_id,
      :title,
      :title_reading,
      :title_reading_collation,
      :subtitle,
      :subtitle_reading,
      :original_title,
      :first_appearance,
      :ndc_code, # 分類番号(日本十進分類法の番号)
      :syllabary_spelling_type,
      :title_copyrighted,
      :published_date,
      :last_updated_date,
      :detail_url,
      # 人物ID, 姓,名,姓読み,名読み,姓読みソート用,名読みソート用,姓ローマ字,名ローマ字,役割フラグ,生年月日,没年月日,人物著作権フラグ,
      :person_id,
      :person_family_name,
      :person_first_name,
      :person_family_name_reading,
      :person_first_name_reading,
      :person_family_name_reading_collation,
      :person_first_name_reading_collation,
      :person_family_name_romaji,
      :person_first_name_romaji,
      :person_type,
      :person_birthday,
      :person_date_of_death,
      :person_copyrighted,
      # 底本名1,底本出版社名1,底本初版発行年1,入力に使用した版1,校正に使用した版1,底本の親本名1,底本の親本出版社名1,底本の親本初版発行年1,
      :original_book_name1,
      :original_book_publisher_name1,
      :original_book_first_published_date1,
      :used_version_for_registration1,
      :used_version_for_proofreading1,
      :base_of_original_book_name1,
      :base_of_original_book_publisher_name1,
      :base_of_original_book_first_published_date1,
      # 底本名2,底本出版社名2,底本初版発行年2,入力に使用した版2,校正に使用した版2,底本の親本名2,底本の親本出版社名2,底本の親本初版発行年2,
      :original_book_name2,
      :original_book_publisher_name2,
      :original_book_first_published_date2,
      :used_version_for_registration2,
      :used_version_for_proofreading2,
      :base_of_original_book_name2,
      :base_of_original_book_publisher_name2,
      :base_of_original_book_first_published_date2,
      # 入力者,校正者,
      :registered_person_name,
      :proofreader_name,
      # テキストファイルURL,テキストファイル最終更新日,テキストファイル符号化方式,テキストファイル文字集合,テキストファイル修正回数,
      :text_file_url,
      :last_text_file_updated_date,
      :text_file_character_encoding,
      :text_file_character_set,
      :text_file_updating_count,
      # XHTML/HTMLファイルURL,XHTML/HTMLファイル最終更新日,XHTML/HTMLファイル符号化方式,XHTML/HTMLファイル文字集合,XHTML/HTMLファイル修正回数
      :html_file_url,
      :last_html_file_updated_date,
      :html_file_character_encoding,
      :html_file_character_set,
      :html_file_updating_count
    )

    class Record
      def initialize(*args)
        super
        @text = nil
      end

      def text
        return @text unless @text.nil?
        return @text if text_file_url.nil? || text_file_url.empty?

        # when url is not zip file, it needs to open web page by brower and has to download
        # e.g. https://mega.nz/file/6tMxgAjZ#PglDDyJL0syRhnULqK0qhTMC7cktsgqwObj5fY_knpE
        return @text unless text_file_url.end_with?('.zip')

        downloader = Datasets::Downloader.new(text_file_url)
        downloader.download(output_path)

        Zip::File.open(output_path) do |zip_file|
          zip_file.each do |entry|
            next unless entry.file?

            entry.get_input_stream do |stream|
              @text = stream.read.encode(Encoding::UTF_8, Encoding::SHIFT_JIS)
            end
          end
        end

        @text
      end

      private

      def output_path
        cache_path.base_dir + text_file_url.split('/').last
      end

      def clear_cache!
        cache_path.remove
      end

      def cache_path
        @cache_path ||= CachePath.new("aozora-bunko-#{title_id}-#{person_id}")
      end
    end

    def initialize
      super()

      @metadata.id = 'aozora-bunko'
      @metadata.name = 'Aozora Bunko'
      @metadata.url = 'https://www.aozora.gr.jp/'
      @metadata.licenses = 'CC-BY-2.1-JP'
      @metadata.description = <<~DESCRIPTION
        Aozora Bunko is an activity to collect free electronic books that anyone can access
        on the Internet like a library. The copyrighted works and the works that are said to be
        "free to read" are available after being digitized in text and XHTML (some HTML) formats.
      DESCRIPTION
    end

    def each
      return to_enum(__method__) unless block_given?

      open_data do |csv_file_stream|
        text = csv_file_stream.read.force_encoding(Encoding::UTF_8) # file has Byte Order Mark

        CSV.parse(text, headers: true) do |row|
          yield(Record.new(*row.fields))
        end
      end
    end

    private

    def data_path
      cache_dir_path + 'list_person_all_extended_utf8.zip'
    end

    def download
      return if data_path.exist?

      data_url = 'https://www.aozora.gr.jp/index_pages/list_person_all_extended_utf8.zip'
      super(data_path, data_url)
    end

    def open_data(&block)
      download

      Zip::File.open(data_path) do |zip_file|
        zip_file.each do |entry|
          next unless entry.file?

          entry.get_input_stream(&block)
        end
      end
    end
  end
end
