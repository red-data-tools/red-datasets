require "rubygems/package"
require_relative 'dataset'

module Datasets
  class LivedoorNews < Dataset
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
      @metadata.licenses = ['CC']
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
    def fetch_readme
      data_path = download_tar_gz
      target_file_name = 'text/README.txt'
      File.open(data_path) do |f|
        Gem::Package::TarReader.new(f) do |tar|
          tar.seek(target_file_name) do |entry|
            return entry.read.force_encoding("UTF-8")
          end
        end
      end
    end

    def download_tar_gz
      data_path = cache_dir_path + "livedoor-news.tar.gz"
      data_url = "https://www.rondhuit.com/download/ldcc-20140209.tar.gz"
      download(data_path, data_url)
      data_path
    end

    def parse_data(data_path, &block)
      target_file_name = @type.to_s.gsub(/_/, '-')
      File.open(data_path) do |f|
        Gem::Package::TarReader.new(f) do |tar|
          tar.each do |entry|
            if entry.file? && entry.full_name.include?(target_file_name) && !entry.full_name.include?('LICENSE')
                url, timestamp, sentence = entry.read().force_encoding("UTF-8").split(/\R/,3)
                record = Record.new(url , timestamp, sentence)
                yield(record)
            end
          end
        end
      end
    end
  end
end
