module Datasets
  class PmjtDatasetList < Dataset
    LATEST_VERSION = '201901'
    URL_FORMAT = "http://codh.rois.ac.jp/pmjt/list/pmjt-dataset-list-%{version}.csv".freeze

    def initialize(version: LATEST_VERSION)
      super()
      @metadata.id = "pmjt-dataset-list-#{version}"
      @metadata.name = "PmjtDatasetList #{version}"
      @metadata.url = URL_FORMAT % {version: version}
      @metadata.licenses = ["CC-BY-SA-4.0"]
      @metadata.description = "Japanese Classic Book #{version}"

      @data_path = cache_dir_path + (@metadata.id + ".csv")
    end

    def each(&block)
      return to_enum(__method__) unless block_given?

      download(@data_path, @metadata.url) unless @data_path.exist?
      CSV.open(@data_path, headers: :first_row, encoding: "Windows-31J:UTF-8") do |csv|
        csv.each do |row|
          record = row.to_h
          record.transform_keys!(&:to_sym)
          yield record
        end
      end
    end
  end
end
