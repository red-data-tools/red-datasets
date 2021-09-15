module Datasets
  class PMJTDatasetList < Dataset
    LATEST_VERSION = '201901'
    URL_FORMAT = "http://codh.rois.ac.jp/pmjt/list/pmjt-dataset-list-%{version}.csv".freeze

    Record = Struct.new(:unit,
                        :open_data_category,
                        :tag,
                        :release_time,
                        :number,
                        :pubished_or_copied,
                        :publication_year,
                        :original_number,
                        :id,
                        :title,
                        :text,
                        :bibliographical_introduction,
                        :year)

    def initialize
      super()
      @metadata.id = "pmjt-dataset-list-#{LATEST_VERSION}"
      @metadata.name = "List of pre-modern Japanese text dataset"
      @metadata.url = URL_FORMAT % {version: LATEST_VERSION}
      @metadata.licenses = ["CC-BY-SA-4.0"]
      @metadata.description = <<~DESCRIPTION
        Pre-Modern Japanese Text, owned by National Institute of Japanese Literature, is released image and text data as open data.
        In addition, some text has description, transcription, and tagging data.
      DESCRIPTION

      @data_path = cache_dir_path + (@metadata.id + ".csv")
    end

    def each(&block)
      return to_enum(__method__) unless block_given?

      download(@data_path, @metadata.url) unless @data_path.exist?
      CSV.open(@data_path, headers: :first_row, encoding: "Windows-31J:UTF-8") do |csv|
        csv.each do |row|
          record = prepare_record(row)
          yield record
        end
      end
    end

    private
    def prepare_record(csv_row)
      row_hash = csv_row.to_h

      record = Record.new
      record.unit = row_hash["(単位)"]
      record.open_data_category = row_hash["オープンデータ分類"]
      record.tag = row_hash["タグ"]
      record.release_time = row_hash["公開時期"]
      record.number = row_hash["冊数等"]
      record.pubished_or_copied = row_hash["刊・写"]
      record.publication_year = row_hash["刊年・書写年"]
      record.original_number = row_hash["原本請求記号"]
      record.id = row_hash["国文研書誌ID"]
      record.title = row_hash["書名（統一書名）"]
      record.text = row_hash["本文"]
      record.bibliographical_introduction = row_hash["解題"]
      record.year = row_hash["（西暦）"]

      record
    end
  end
end
