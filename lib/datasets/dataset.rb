require "fileutils"
require "open-uri"
require "pathname"

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
      url = URI.parse(url) unless url.is_a?(URI::Generic)
      output_path.parent.mkpath
      begin
        url.open do |input|
          output_path.open("wb") do |output|
            IO.copy_stream(input, output)
          end
        end
      rescue
        FileUtils.rm_f(output_path)
        raise
      end
    end
  end
end
