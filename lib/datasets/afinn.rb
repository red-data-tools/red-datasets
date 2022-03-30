require "csv"
require "zip"
require_relative "dataset"
#require_relative "zip_extractor"

module Datasets
  class Afinn < Dataset
    Record = Struct.new(:word,
                        :valence)

    def initialize
      super()
      @metadata.id = "afinn"
      @metadata.name = "AFINN"
      @metadata.url = "http://www2.imm.dtu.dk/pubdb/pubs/6010-full.html"
      @metadata.licenses = ["ODbL-1.0"]
      @metadata.description = "A sentiment labelled list of 2477 English words and phrases"
    end

    def each
      return to_enum(__method__) unless block_given?

      file_path = "AFINN/AFINN-111.txt"
      data_path = cache_dir_path + "imm6010.zip"
      data_url = "http://www2.imm.dtu.dk/pubdb/edoc/imm6010.zip"
      download(data_path, data_url)

      open_data(data_path, file_path) do |csv|
        csv.each do |row|
          next if row[0].nil?
          record = Record.new(*row)
          yield(record)
        end
      end
    end

    private
    def open_data(data_path, file_path)
      Zip::File.open(data_path) do |file|
        entry = file.glob(file_path).first
        yield CSV.parse(entry.get_input_stream.read, col_sep: "\t", quote_char: nil)
      end
    end
  end
end
