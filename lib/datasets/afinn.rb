require "csv"
require_relative "zip-extractor"

module Datasets
  class AFINN < Dataset
    Record = Struct.new(:word,
                        :valence)

    def initialize
      super()
      @metadata.id = "afinn"
      @metadata.name = "AFINN"
      @metadata.url = "http://www2.imm.dtu.dk/pubdb/pubs/6010-full.html"
      @metadata.licenses = ["ODbL-1.0"]
      @metadata.description = lambda do
        extract_file("AFINN/AFINN-README.txt") do |input|
          readme = input.read
          readme.force_encoding("UTF-8")
          readme.
            gsub(/^AFINN-96:.*?\n\n/m, "").
            gsub(/^In Python.*$/m, "").
            strip
        end
      end
    end

    def each
      return to_enum(__method__) unless block_given?

      extract_file("AFINN/AFINN-111.txt") do |input|
        csv = CSV.new(input, col_sep: "\t", converters: :numeric)
        csv.each do |row|
          yield(Record.new(*row))
        end
      end
    end

    private
    def extract_file(file_path, &block)
      data_path = cache_dir_path + "imm6010.zip"
      data_url = "http://www2.imm.dtu.dk/pubdb/edoc/imm6010.zip"
      download(data_path, data_url)

      extractor = ZipExtractor.new(data_path)
      extractor.extract_file(file_path, &block)
    end
  end
end
