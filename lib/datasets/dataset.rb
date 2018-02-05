require "pathname"

require_relative "downloader"
require_relative "metadata"

module Datasets
  class Dataset
    attr_reader :metadata
    def initialize
      @metadata = Metadata.new
    end

    private
    def cache_dir_path
      case RUBY_PLATFORM
      when /mswin/, /mingw/
        base_dir = ENV["LOCALAPPDATA"] || "~/AppData"
      when /darwin/
        base_dir = "~/Library/Caches"
      else
        base_dir = ENV["XDG_CACHE_HOME"] || "~/.cache"
      end
      Pathname(base_dir).expand_path + "red-datasets" + metadata.name
    end

    def download(output_path, url)
      downloader = Downloader.new(url)
      downloader.download(output_path)
    end
  end
end
