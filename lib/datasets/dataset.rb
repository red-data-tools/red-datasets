require "pathname"

require_relative "downloader"
require_relative "error"
require_relative "metadata"
require_relative "table"

module Datasets
  class Dataset
    include Enumerable

    attr_reader :metadata
    def initialize
      @metadata = Metadata.new
    end

    def to_table
      Table.new(self)
    end

    def clear_cache!
      if cache_dir_path.exist?
        FileUtils.rmtree(cache_dir_path.to_s, secure: true)
      end
    end

    private
    def cache_dir_path
      case RUBY_PLATFORM
      when /mswin/, /mingw/
        base_dir = ENV["LOCALAPPDATA"] || "~/AppData/Local"
      when /darwin/
        base_dir = "~/Library/Caches"
      else
        base_dir = ENV["XDG_CACHE_HOME"] || "~/.cache"
      end
      Pathname(base_dir).expand_path + "red-datasets" + metadata.id
    end

    def download(output_path, url)
      downloader = Downloader.new(url)
      downloader.download(output_path)
    end

    def extract_bz2(path)
      input, output = IO.pipe
      pid = spawn("bzcat", path.to_s, {:out => output})
      begin
        output.close
        yield(input)
      ensure
        input.close
        Process.waitpid(pid)
      end
    end
  end
end
