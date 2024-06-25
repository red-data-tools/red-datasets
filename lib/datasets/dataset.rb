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

    def download(output_path, *urls, &block)
      urls.each do |url|
        downloader = Downloader.new(url)
        downloader.download(output_path, &block)
        return
      rescue Net::HTTPClientException => error
        if urls.last != url
          message = "site is not available: " +
                    "#{error.class}: #{error.message}: " +
                    "Attempting to download from an alternative site"
          $stderr.puts(message)
        else
          raise error
        end
      end
    end

    def extract_bz2(bz2)
      case bz2
      when Pathname, String
        IO.pipe do |input, output|
          pid = spawn("bzcat", bz2.to_s, {out: output})
          begin
            output.close
            yield(input)
          ensure
            input.close
            Process.waitpid(pid)
          end
        end
      else
        IO.pipe do |bz2_input, bz2_output|
          IO.pipe do |plain_input, plain_output|
            bz2_stop = false
            bz2_thread = Thread.new do
              begin
                bz2.each do |chunk|
                  bz2_output.write(chunk)
                  bz2_output.flush
                  break if bz2_stop
                end
              rescue => error
                message = "Failed to read bzcat input: " +
                          "#{error.class}: #{error.message}"
                $stderr.puts(message)
              ensure
                bz2_output.close
              end
            end
            begin
              pid = spawn("bzcat", {in: bz2_input, out: plain_output})
              begin
                bz2_input.close
                plain_output.close
                yield(plain_input)
              ensure
                plain_input.close
                Process.waitpid(pid)
              end
            ensure
              bz2_stop = true
              bz2_thread.join
            end
          end
        end
      end
    end
  end
end
