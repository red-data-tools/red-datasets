require_relative "dataset"

module Datasets
  class PMJTDatasetList < Dataset
    Record = Struct.new(:unit,
                        :open_data_category,
                        :tag,
                        :release_time,
                        :n_volumes,
                        :type,
                        :publication_year,
                        :original_request_code,
                        :id,
                        :title,
                        :text,
                        :bibliographical_introduction,
                        :year)

    def initialize
      super()
      @metadata.id = "pmjt-dataset-list"
      @metadata.name = "List of pre-modern Japanese text dataset"
      @metadata.url = "http://codh.rois.ac.jp/pmjt/"
      @metadata.licenses = ["CC-BY-SA-4.0"]
      @metadata.description = <<~DESCRIPTION
        Pre-Modern Japanese Text, owned by National Institute of Japanese Literature, is released image and text data as open data.
        In addition, some text has description, transcription, and tagging data.
      DESCRIPTION

      @data_path = cache_dir_path + (@metadata.id + ".csv")
    end

    def each(&block)
      return to_enum(__method__) unless block_given?

      latest_version = "201901"
      url = "http://codh.rois.ac.jp/pmjt/list/pmjt-dataset-list-#{latest_version}.csv"
      download(@data_path, url)
      CSV.open(@data_path, headers: :first_row, encoding: "Windows-31J:UTF-8") do |csv|
        csv.each do |row|
          record = create_record(row)
          yield record
        end
      end
    end

    private
    def create_record(csv_row)
      record = Record.new
      record.unit = csv_row["(単位)"]
      record.open_data_category = csv_row["オープンデータ分類"]
      record.tag = csv_row["タグ"]
      record.release_time = csv_row["公開時期"]
      record.n_volumes = csv_row["冊数等"]
      record.type = csv_row["刊・写"]
      record.publication_year = csv_row["刊年・書写年"]
      record.original_request_code = csv_row["原本請求記号"]
      record.id = csv_row["国文研書誌ID"]
      record.title = csv_row["書名（統一書名）"]
      record.text = csv_row["本文"]
      record.bibliographical_introduction = csv_row["解題"]
      record.year = csv_row["（西暦）"]

      record
    end
  end
end
