require_relative 'dataset'
require_relative 'zip-extractor'

module Datasets
  # Dataset for AozoraBunko
  class AozoraBunko < Dataset
    Book = Struct.new(
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
      :copyrighted,
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

    class Book
      attr_writer :cache_path

      def initialize(*args)
        super
        @text = nil
        @html = nil
        @cache_path = nil
      end

      alias_method :copyrighted?, :copyrighted
      alias_method :person_copyrighted?, :person_copyrighted

      def text
        return @text unless @text.nil?
        return @text if text_file_url.nil? || text_file_url.empty?

        # when url is not zip file, it needs to open web page by brower and has to download
        # e.g. https://mega.nz/file/6tMxgAjZ#PglDDyJL0syRhnULqK0qhTMC7cktsgqwObj5fY_knpE
        return @text unless text_file_url.end_with?('.zip')

        downloader = Downloader.new(text_file_url)
        downloader.download(text_file_output_path)

        @text = ZipExtractor.new(text_file_output_path).extract_first_file do |input|
          input.read.encode(Encoding::UTF_8, normalize_encoding(text_file_character_encoding))
        end

        @text
      end

      def html
        return @html unless @html.nil?
        return @html if html_file_url.nil? || html_file_url.empty?

        downloader = Downloader.new(html_file_url)
        downloader.download(html_file_output_path)
        @html = File.read(html_file_output_path).encode(Encoding::UTF_8,
                                                        normalize_encoding(html_file_character_encoding))

        @html
      end

      private

      def text_file_output_path
        cache_base_dir + text_file_name
      end

      def html_file_output_path
        cache_base_dir + html_file_name
      end

      def text_file_name
        text_file_url.split('/').last
      end

      def html_file_name
        html_file_url.split('/').last
      end

      def cache_base_dir
        @cache_path.base_dir + title_id + person_id
      end

      def normalize_encoding(encoding)
        case encoding
        when 'ShiftJIS'
          Encoding::Shift_JIS
        when 'UTF-8'
          Encoding::UTF_8
        else
          encoding
        end
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
          %w[作品著作権フラグ 人物著作権フラグ].each do |boolean_column_name|
            row[boolean_column_name] = normalize_boolean(row[boolean_column_name])
          end
          book = Book.new(*row.fields)
          book.cache_path = cache_path

          yield(book)
        end
      end
    end

    private

    def open_data(&block)
      data_path = cache_dir_path + 'list_person_all_extended_utf8.zip'
      data_url = "https://www.aozora.gr.jp/index_pages/#{data_path.basename}"
      download(data_path, data_url)
      ZipExtractor.new(data_path).extract_first_file do |input|
        block.call(input)
      end
    end

    def normalize_boolean(column_value)
      column_value == 'あり'
    end
  end
end
