require_relative "dataset"
require_relative "tar-gz-readable"

module Datasets
  class LivedoorNews < Dataset
    include TarGzReadable
    Record = Struct.new(:url,
                        :timestamp,
                        :sentence)

    def initialize(type: :topic_news)
      news_list = [
        :topic_news,
        :sports_watch,
        :it_life_hack,
        :kaden_channel,
        :movie_enter,
        :dokujo_tsushin,
        :smax,
        :livedoor_homme,
        :peachy
      ]
      unless news_list.include?(type)
        valid_type_labels = news_list.collect(&:inspect).join(", ")
        message = ":type must be one of [#{valid_type_labels}]: #{type.inspect}"
        raise ArgumentError, message
      end

      super()
      @type = type
      @metadata.id = 'livedoor-news'
      @metadata.name = 'livedoor-news'
      @metadata.url = 'https://www.rondhuit.com/download.html#ldcc'
      @metadata.licenses = ['CC-BY-ND-2.1-JP']
      @metadata.description = lambda do
        fetch_readme
      end
    end

    def each(&block)
      return to_enum(__method__) unless block_given?

      data_path = download_tar_gz
      parse_data(data_path, &block)
    end

    private
    def download_tar_gz
      data_path = cache_dir_path + "livedoor-news.tar.gz"
      data_url = "https://www.rondhuit.com/download/ldcc-20140209.tar.gz"
      download(data_path, data_url)
      data_path
    end

    def fetch_readme
      data_path = download_tar_gz
      target_file_name = 'text/README.txt'
      open_tar_gz(data_path) do |tar|
        tar.seek(target_file_name) do |entry|
          return entry.read.force_encoding("UTF-8")
        end
      end
    end

    def parse_data(data_path, &block)
      target_directory_name = "text/#{@type.to_s.gsub(/_/, '-')}"
      open_tar_gz(data_path) do |tar|
        tar.each do |entry|
          next unless entry.file?
          directory_name, base_name = File.split(entry.full_name)
          next unless directory_name == target_directory_name
          next if base_name == "LICENSE.txt"
          url, timestamp, sentence = entry.read.force_encoding("UTF-8").split("\n", 3)
          record = Record.new(url, Time.iso8601(timestamp), sentence)
          yield(record)
        end
      end
    end
  end
end
