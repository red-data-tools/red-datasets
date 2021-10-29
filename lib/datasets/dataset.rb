require "pathname"

require_relative "cache-path"
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
      cache_path.remove
    end

    private

    def cache_dir_path
      cache_path.base_dir
    end

    def cache_path
      @cache_path ||= CachePath.new(@metadata.id)
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
