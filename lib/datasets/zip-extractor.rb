require 'zip'

module Datasets
  class ZipExtractor
    def initialize(path)
      @path = path
    end

    def extract_one_file
      Zip::File.open(@path) do |zip_file|
        zip_file.each do |entry|
          next unless entry.file?

          entry.get_input_stream do |input|
            return yield(input)
          end
        end
      end
      nil
    end
  end
end
