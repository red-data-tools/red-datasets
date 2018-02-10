require "fileutils"
require "open-uri"

module Datasets
  class Downloader
    PROC_STAT_PATH = "/proc/self/stat"

    def initialize(url)
      url = URI.parse(url) unless url.is_a?(URI::Generic)
      @url = url
      @have_proc_stat = File.exist?(PROC_STAT_PATH)
    end

    def download(output_path)
      output_path.parent.mkpath

      if $stderr == STDERR and $stderr.tty?
        max = nil
        base_name = @url.path.split("/").last
        content_length_proc = lambda do |content_length|
          max = content_length
        end
        progress_proc = lambda do |current|
          show_progress(base_name, current, max)
        end
        options = {
          :content_length_proc => content_length_proc,
          :progress_proc => progress_proc,
        }
      else
        options = {}
      end

      begin
        @url.open(options) do |input|
          output_path.open("wb") do |output|
            IO.copy_stream(input, output)
          end
        end
      rescue
        FileUtils.rm_f(output_path)
        raise
      end
    end

    private
    def format_size(size)
      if size < 1024
        "%d" % size
      elsif size < (1024 ** 2)
        "%7.2fKiB" % (size.to_f / 1024)
      elsif size < (1024 ** 3)
        "%7.2fMiB" % (size.to_f / (1024 ** 2))
      elsif size < (1024 ** 4)
        "%7.2fGiB" % (size.to_f / (1024 ** 3))
      else
        "%.2fTiB" % (size.to_f / (1024 ** 4))
      end
    end

    def foreground?
      return false unless @have_proc_stat

      stat = File.read(PROC_STAT_PATH).sub(/\A.+\) /, "").split
      process_group_id = stat[2]
      terminal_process_group_id = stat[5]
      process_group_id == terminal_process_group_id
    end

    def show_progress(base_name, current, max)
      return if max.nil?
      return unless foreground?

      percent = (current / max.to_f) * 100
      formatted_size = "[%s/%s]" % [format_size(current), format_size(max)]
      $stderr.print("\r%s - %06.2f%% %s" %
                    [base_name, percent, formatted_size])
      $stderr.puts if current == max
    end
  end
end
