require "fileutils"
require "open-uri"
require "pathname"

module Datasets
  class Downloader
    def initialize(url)
      if url.is_a?(URI::Generic)
        url = url.dup
      else
        url = URI.parse(url)
      end
      @url = url
      @url.extend(CurrentBufferReadable)
    end

    def download(output_path)
      output_path.parent.mkpath

      start = nil
      partial_output_path = Pathname.new("#{output_path}.partial")
      if partial_output_path.exist?
        start = partial_output_path.size
      end

      progress_reporter = nil
      content_length_proc = lambda do |content_length|
        base_name = @url.path.split("/").last
        size_max = content_length
        size_max += start if start
        progress_reporter = ProgressReporter.new(base_name, size_max)
      end
      progress_proc = lambda do |size_current|
        size_current += start if start
        progress_reporter.report(size_current) if progress_reporter
      end
      options = {
        :content_length_proc => content_length_proc,
        :progress_proc => progress_proc,
      }
      if start
        options["Range"] = "bytes=#{start}-"
      end

      begin
        @url.open(options) do |input|
          copy_stream(input, partial_output_path)
        end
      rescue Interrupt, Net::ReadTimeout
        if @url.current_buffer
          input = @url.current_buffer.io
          input.rewind
          copy_stream(input, partial_output_path)
        end
        raise
      end

      FileUtils.mv(partial_output_path, output_path)
    end

    private
    def copy_stream(input, partial_output_path)
      if partial_output_path.exist?
        # TODO: It's better that we use "206 Partial Content" response
        # to detect partial response.
        partial_head = partial_output_path.open("rb") do |partial_output|
          partial_output.read(256)
        end
        input_head = input.read(partial_head.bytesize)
        input.rewind
        if partial_head == input_head
          mode = "wb"
        else
          mode = "ab"
        end
      else
        mode = "wb"
      end
      partial_output_path.open(mode) do |partial_output|
        IO.copy_stream(input, partial_output)
      end
    end

    module CurrentBufferReadable
      attr_reader :current_buffer
      def buffer_open(buffer, proxy, options)
        @current_buffer = buffer
        super
      end
    end

    class ProgressReporter
      PROC_STAT_PATH = "/proc/self/stat"

      def initialize(base_name, size_max)
        @base_name = base_name
        @size_max = size_max

        @time_previous = Time.now
        @size_previous = 0

        @need_report = ($stderr == STDERR and $stderr.tty?)
        @have_proc_stat = File.exist?(PROC_STAT_PATH)
      end

      def report(size_current)
        return unless @need_report
        return if @size_max.nil?
        return unless foreground?

        done = (size_current == @size_max)
        time_current = Time.now
        if not done and time_current - @time_previous <= 1
          return
        end

        width = guess_terminal_width

        read_bytes = size_current - @size_previous
        throughput = read_bytes.to_f / (time_current - @time_previous)
        tp = @time_previous
        @time_previous = time_current
        @size_previous = size_current

        percent = (size_current / @size_max.to_f) * 100
        formatted_size = "[%s/%s]" % [
          format_size(size_current),
          format_size(@size_max),
        ]
        rest_second = (@size_max - size_current) / throughput
        progress = " - %05.1f%% %s %s %s" % [
          percent,
          formatted_size,
          format_time_interval(rest_second),
          format_throughput(throughput),
        ]
        base_name = @base_name
        if width
          base_name_width = width - progress.size
          if base_name.size > base_name_width
            ellipsis = "..."
            base_name = base_name[0, base_name_width - ellipsis.size] + ellipsis
          end
        end
        $stderr.print("\r#{base_name}#{progress}")
        $stderr.puts if done
      end

      private
      def format_size(size)
        if size < 1000
          "%d" % size
        elsif size < (1000 ** 2)
          "%6.2fKB" % (size.to_f / 1000)
        elsif size < (1000 ** 3)
          "%6.2fMB" % (size.to_f / (1000 ** 2))
        elsif size < (1000 ** 4)
          "%6.2fGB" % (size.to_f / (1000 ** 3))
        else
          "%.2fTB" % (size.to_f / (1000 ** 4))
        end
      end

      def format_time_interval(interval)
        if interval < 60
          "00:00:%02d" % interval
        elsif interval < (60 * 60)
          minute, second = interval.divmod(60)
          "00:%02d:%02d" % [minute, second]
        elsif interval < (60 * 60 * 24)
          minute, second = interval.divmod(60)
          hour, minute = minute.divmod(60)
          "%02d:%02d:%02d" % [hour, minute, second]
        else
          minute, second = interval.divmod(60)
          hour, minute = minute.divmod(60)
          day, hour = hour.divmod(24)
          "%dd %02d:%02d:%02d" % [day, hour, minute, second]
        end
      end

      def format_throughput(throughput)
        throughput_byte = throughput / 8
        if throughput_byte <= 1000
          "%3dB/s" % throughput_byte
        elsif throughput_byte <= (1000 ** 2)
          "%3dKB/s" % (throughput_byte / 1000)
        elsif throughput_byte <= (1000 ** 3)
          "%3dMB/s" % (throughput_byte / (1000 ** 2))
        else
          "%3dGB/s" % (throughput_byte / (1000 ** 3))
        end
      end

      def foreground?
        return false unless @have_proc_stat

        stat = File.read(PROC_STAT_PATH).sub(/\A.+\) /, "").split
        process_group_id = stat[2]
        terminal_process_group_id = stat[5]
        process_group_id == terminal_process_group_id
      end

      def guess_terminal_width
        guess_terminal_width_from_io ||
          guess_terminal_width_from_command ||
          guess_terminal_width_from_env ||
          80
      end

      def guess_terminal_width_from_io
        if $stderr.respond_to?(:winsize)
          begin
            $stderr.winsize[1]
          rescue SystemCallError
            nil
          end
        else
          nil
        end
      end

      def guess_terminal_width_from_command
        IO.pipe do |input, output|
          begin
            pid = spawn("tput", "cols", {:out => output, :err => output})
          rescue SystemCallError
            return nil
          end

          output.close
          _, status = Process.waitpid2(pid)
          return nil unless status.success?

          result = input.read.chomp
          begin
            Integer(result, 10)
          rescue ArgumentError
            nil
          end
        end
      end

      def guess_terminal_width_from_env
        env = ENV["COLUMNS"] || ENV["TERM_WIDTH"]
        return nil if env.nil?

        begin
          Integer(env, 10)
        rescue ArgumentError
          nil
        end
      end
    end
  end
end
