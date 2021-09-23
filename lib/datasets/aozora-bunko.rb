require_relative 'dataset'

module Datasets
  # Dataset for AozoraBunko
  class AozoraBunko < Dataset
    # 人物ID,著者名,作品ID,作品名,仮名遣い種別,翻訳者名等,入力者名,校正者名,状態,状態の開始日,底本名,出版社名,入力に使用した版,校正に使用した版
    Record = Struct.new(
      :novelist_id,
      :novelist,
      :title_id,
      :title,
      :syllabary_spelling_type, # 仮名遣い種別
      :translator_name,
      :registered_person_name,
      :proofreader_name,
      :status,
      :status_specified_date,
      :original_book_name,
      :original_book_publisher_name,
      :used_version_for_registration,
      :used_version_for_proofreading
    )

    RecordExtended = Struct.new(
      # 作品ID,作品名,作品名読み,ソート用読み,副題,副題読み,原題,初出,分類番号,文字遣い種別,作品著作権フラグ,公開日,最終更新日,図書カードURL,
      :title_id,
      :title,
      :title_reading,
      :title_reading_collation,
      :sub_title,
      :sub_title_reading,
      :original_title,
      :first_appearance,
      :ndc_code, # 分類番号(日本十進分類法の番号)
      :syllabary_spelling_type, # 文字遣い種別, Recordの仮名遣い種別 と同じ値になっている
      :copyright_for_title,
      :published_date,
      :latest_updated_date,
      :detail_url,
      # 人物ID, 姓,名,姓読み,名読み,姓読みソート用,名読みソート用,姓ローマ字,名ローマ字,役割フラグ,生年月日,没年月日,人物著作権フラグ,
      :novelist_id,
      :novelist_family_name,
      :novelist_first_name,
      :novelist_family_name_reading,
      :novelist_first_name_reading,
      :novelist_family_name_collation,
      :novelist_first_name_collation,
      :novelist_family_name_roman,
      :novelist_first_name_roman,
      :novelist_type,
      :novelist_birthday,
      :novelist_death_day,
      :copyright_for_novelist,
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
      :latest_text_file_updated_date,
      :text_file_character_encoding,
      :text_character_set,
      :text_file_updating_count,
      # XHTML/HTMLファイルURL,XHTML/HTMLファイル最終更新日,XHTML/HTMLファイル符号化方式,XHTML/HTMLファイル文字集合,XHTML/HTMLファイル修正回数
      :html_file_url,
      :latest_html_file_updated_date,
      :html_file_character_encoding,
      :html_character_set,
      :html_file_updating_count
    )

    TYPES = %i[normal extended].freeze

    def initialize(type: :normal)
      unless TYPES.include?(type)
        raise ArgumentError, "Please specify #{TYPES.map(&:to_s).join(' or ')} for :type. <type: #{type}>"
      end

      super()

      @metadata.id = 'aozora-bunko'
      @metadata.name = 'Novelists from Aozora Bunko'
      @metadata.url = 'https://www.aozora.gr.jp/'
      @metadata.licenses = 'CC-BY-2.1-JP'
      @metadata.description = <<~DESCRIPTION
        Aozora Bunko is an activity to collect free electronic books that anyone can access
        on the Internet like a library. The copyrighted works and the works that are said to be
        "free to read" are available after being digitized in text and XHTML (some HTML) formats.
      DESCRIPTION

      @type = type
    end

    def each
      return to_enum(__method__) unless block_given?

      open_data do |csv_file_stream|
        text = csv_file_stream.read.force_encoding(Encoding::UTF_8) # file has Byte Order Mark

        CSV.parse(text, headers: true) do |row|
          yield(record_class.new(*row.fields))
        end
      end
    end

    private

    def data_path
      cache_dir_path + "#{@type}.zip"
    end

    def download
      return if data_path.exist?

      case @type
      when :normal
        data_url = 'https://www.aozora.gr.jp/index_pages/list_person_all_utf8.zip'
      when :extended
        data_url = 'https://www.aozora.gr.jp/index_pages/list_person_all_extended_utf8.zip'
      end
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

    def record_class
      case @type
      when :normal
        Record
      when :extended
        RecordExtended
      end
    end
  end
end
