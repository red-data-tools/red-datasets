module Datasets
  class Diamonds < Dataset
    Record = Struct.new(:label,
                        :price,
                        :carat,
                        :cut,
                        :color,
                        :clarity,
                        :depth,
                        :table,
                        :x,
                        :y,
                        :z)

    def initialize(name)
      super()
      @metadata.id = "diamonds"
      @metadata.name = "Diamonds"
      @metadata.licenses = ["CC-0"]
      @metadata.url = "https://www.openml.org/data/get_csv/21792853/dataset"
      @metadata.description = "Diamonds dataset original from ggplot2"

      @data_path = cache_dir_path + (name + ".csv")
      @name = name
    end

    def each(&block)

      download(@data_path, @metadata.url)
      CSV.open(@data_path, headers: :first_row, converters: :all) do |csv|
        csv.each do |row|
          record = prepare_record(row)
          yield record
        end
      end
    end

    private
    def prepare_record(csv_row)
      record = csv_row.to_h
      record.transform_keys!(&:to_sym)
   end

 end
end
