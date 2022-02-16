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
    def extract(location)
      Zip::File.open(@path) do |zip_file|
        zip_file.each do |entry|
          entry_path = File.join(location, entry.name)
          FileUtils.mkdir_p(File.dirname(entry_path))
          entry.extract(entry_path) unless File.exist?(entry_path)
        end
      end
    end
  end
end
