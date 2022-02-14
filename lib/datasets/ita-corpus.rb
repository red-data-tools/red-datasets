require_relative 'dataset'

module Datasets
  class ITACorpus < Dataset
    Record = Struct.new(:id,
                        :sentence)

    def initialize
      super
      @metadata.id = 'ita-corpus'
      @metadata.name = 'ITA-corpus'
      @metadata.url = 'https://github.com/mmorise/ita-corpus'
      @metadata.licenses = ['Unlicense']
      @metadata.description = lambda do
        fetch_readme
      end
    end

    def each
      return to_enum(__method__) unless block_given?

      open_emotion_data do |text|
        text.each_line  do |line|
          id, sentence = row.split(':', 2)
          record = Record.new(strArry[0] , strArry[1].chomp)
          yield(record)
        end
      end

      open_recitation_data do |text|
        text.each do |row|
          strArry = row.split(':')
          record = Record.new(strArry[0] , strArry[1].chomp)
          yield(record)
        end
      end
    end

    private
    def download_base_url
      "https://raw.githubusercontent.com/mmorise/ita-corpus/main"
    end

    def open_emotion_data
      data_path = cache_dir_path + 'emotion_transcript_utf8.txt'
      data_url = "#{download_base_url}/emotion_transcript_utf8.txt"
      download(data_path, data_url)
      File.open(data_path) do |file|
        yield(file)
      end
    end

    def open_recitation_data
      data_path = cache_dir_path + 'recitation_transcript_utf8.txt'
      data_url = "#{download_base_url}/recitation_transcript_utf8.txt"
      download(data_path, data_url)
      File.open(data_path) do |text|
        yield(text)
      end
    end

    def fetch_readme
      readme_base_name = "README.md"
      readme_path = cache_dir_path + readme_base_name
      readme_url = "#{download_base_url}/#{readme_base_name}"
      download(readme_path, readme_url)
      readme_path.read.split(/^## ITAコーパスの文献情報/, 2)[0].strip
    end
  end
end
