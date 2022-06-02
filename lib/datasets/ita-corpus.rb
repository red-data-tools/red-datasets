require_relative 'dataset'

module Datasets
  class ITACorpus < Dataset
    Record = Struct.new(:id,
                        :sentence)

    def initialize(type: :emotion)
      unless [:emotion, :recitation].include?(type)
        raise ArgumentError, "Please set type :emotion or :recitation: #{type.inspect}"
      end

      super()
      @type = type
      @metadata.id = 'ita-corpus'
      @metadata.name = 'ITA-corpus'
      @metadata.url = 'https://github.com/mmorise/ita-corpus'
      @metadata.licenses = ['Unlicense']
      @metadata.description = lambda do
        fetch_readme
      end
    end

    def each(&block)
      return to_enum(__method__) unless block_given?

      data_path = cache_dir_path + "#{@type}_transcript_utf8.txt"
      data_url = "#{download_base_url}/#{@type}_transcript_utf8.txt"
      download(data_path, data_url)

      parse_data(data_path, &block)
    end

    private
    def fetch_readme
      readme_base_name = "README.md"
      readme_path = cache_dir_path + readme_base_name
      readme_url = "#{download_base_url}/#{readme_base_name}"
      download(readme_path, readme_url)
      readme_path.read.split(/^## ファイル構成/, 2)[0].strip
    end

    def download_base_url
      "https://raw.githubusercontent.com/mmorise/ita-corpus/main"
    end

    def parse_data(data_path)
      File.open(data_path) do |f|
        f.each_line(chomp: true) do |line|
          id, sentence = line.split(':', 2)
          record = Record.new(id , sentence)
          yield(record)
        end
      end
    end
  end
end
