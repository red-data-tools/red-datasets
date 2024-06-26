require "fileutils"
begin
  require "io/console"
rescue LoadError
end
require "net/http"
require "pathname"

require_relative "error"

module Datasets
  class Downloader
    class TooManyRedirects < Error; end

    def initialize(url)
      if url.is_a?(URI::Generic)
        url = url.dup
      else
        url = URI.parse(url)
      end
      @url = url
      unless @url.is_a?(URI::HTTP)
        raise ArgumentError, "download URL must be HTTP or HTTPS: <#{@url}>"
      end
    end

    def download(output_path, &block)
      if output_path.exist?
        yield_chunks(output_path, &block) if block_given?
        return
      end

      partial_output_path = Pathname.new("#{output_path}.partial")
      synchronize(output_path, partial_output_path) do
        output_path.parent.mkpath

        n_retries = 0
        n_max_retries = 5
        begin
          headers = {
            "Accept-Encoding" => "identity",
            "User-Agent" => "Red Datasets/#{VERSION}",
          }
          start = nil
          if partial_output_path.exist?
            start = partial_output_path.size
            headers["Range"] = "bytes=#{start}-"
          end

          start_http(@url, headers) do |response|
            if response.is_a?(Net::HTTPPartialContent)
              mode = "ab"
            else
              start = nil
              mode = "wb"
            end

            base_name = @url.path.split("/").last
            size_current = 0
            size_max = response.content_length
            if start
              size_current += start
              size_max += start
              if block_given? and n_retries.zero?
                yield_chunks(partial_output_path, &block)
              end
            end
            progress_reporter = ProgressReporter.new(base_name, size_max)
            partial_output_path.open(mode) do |output|
              response.read_body do |chunk|
                size_current += chunk.bytesize
                progress_reporter.report(size_current)
                output.write(chunk)
                yield(chunk) if block_given?
              end
            end
          end
          FileUtils.mv(partial_output_path, output_path)
        rescue Net::ReadTimeout => error
          n_retries += 1
          retry if n_retries < n_max_retries
          raise
        rescue TooManyRedirects => error
          last_url = error.message[/\Atoo many redirections: (.+)\z/, 1]
          raise TooManyRedirects, "too many redirections: #{@url} .. #{last_url}"
        end
      end
    end

    private def synchronize(output_path, partial_output_path)
      begin
        Process.getpgid(Process.pid)
      rescue NotImplementedError
        return yield
      end

      lock_path = Pathname("#{output_path}.lock")
      loop do
        lock_path.parent.mkpath
        begin
          lock = lock_path.open(File::RDWR | File::CREAT | File::EXCL)
        rescue SystemCallError
          valid_lock_path = true
          begin
            pid = Integer(lock_path.read.chomp, 10)
          rescue ArgumentError
            # The process that acquired the lock will be exited before
            # it stores its process ID.
            valid_lock_path = (lock_path.mtime > 10)
          else
            begin
              Process.getpgid(pid)
            rescue SystemCallError
              # Process that acquired the lock doesn't exist
              valid_lock_path = false
            end
          end
          if valid_lock_path
            sleep(1 + rand(10))
          else
            lock_path.delete
          end
          retry
        else
          begin
            lock.puts(Process.pid.to_s)
            lock.flush
            yield
          ensure
            lock.close
            lock_path.delete
          end
          break
        end
      end
    end

    private def start_http(url, headers, limit = 10, &block)
      if limit == 0
        raise TooManyRedirects, "too many redirections: #{url}"
      end
      http = Net::HTTP.new(url.hostname, url.port)
      # http.set_debug_output($stderr)
      http.use_ssl = (url.scheme == "https")
      http.start do
        path = url.path
        path += "?#{url.query}" if url.query
        request = Net::HTTP::Get.new(path, headers)
        http.request(request) do |response|
          case response
          when Net::HTTPSuccess, Net::HTTPPartialContent
            return block.call(response)
          when Net::HTTPRedirection
            url = URI.parse(response[:location])
            $stderr.puts "Redirect to #{url}"
            return start_http(url, headers, limit - 1, &block)
          else
            message = response.code
            if response.message and not response.message.empty?
              message += ": #{response.message}"
            end
            message += ": #{url}"
            raise response.error_type.new(message, response)
          end
        end
      end
    end

    private def yield_chunks(path)
      path.open("rb") do |output|
        chunk_size = 1024 * 1024
        chunk = +""
        while output.read(chunk_size, chunk)
          yield(chunk)
        end
      end
    end

    class ProgressReporter
      def initialize(base_name, size_max)
        @base_name = base_name
        @size_max = size_max

        @time_previous = Time.now
        @size_previous = 0

        @need_report = ($stderr == STDERR and $stderr.tty?)
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

        read_bytes = size_current - @size_previous
        throughput = read_bytes.to_f / (time_current - @time_previous)
        @time_previous = time_current
        @size_previous = size_current

        message = build_message(size_current, throughput)
        $stderr.print("\r#{message}") if message
        $stderr.puts if done
      end

      private
      def build_message(size_current, throughput)
        percent = (size_current / @size_max.to_f) * 100
        formatted_size = "[%s/%s]" % [
          format_size(size_current),
          format_size(@size_max),
        ]
        rest_second = (@size_max - size_current) / throughput
        separator = " - "
        progress = "%05.1f%% %s %s %s" % [
          percent,
          formatted_size,
          format_time_interval(rest_second),
          format_throughput(throughput),
        ]
        base_name = @base_name

        width = guess_terminal_width
        return "#{base_name}#{separator}#{progress}" if width.nil?

        return nil if progress.size > width

        base_name_width = width - progress.size - separator.size
        if base_name.size > base_name_width
          ellipsis = "..."
          shorten_base_name_width = base_name_width - ellipsis.size
          if shorten_base_name_width < 1
            return progress
          else
            base_name = base_name[0, shorten_base_name_width] + ellipsis
          end
        end
        "#{base_name}#{separator}#{progress}"
      end

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
        proc_stat_path = "/proc/self/stat"
        ps_path = "/bin/ps"

        if File.exist?(proc_stat_path)
          stat = File.read(proc_stat_path).sub(/\A.+\) /, "").split
          process_group_id = stat[2]
          terminal_process_group_id = stat[5]
          process_group_id == terminal_process_group_id
        elsif File.executable?(ps_path)
          IO.pipe do |input, output|
            pid = spawn(ps_path, "-o", "stat", "-p", Process.pid.to_s,
                        {:out => output, :err => output})
            output.close
            _, status = Process.waitpid2(pid)
            return false unless status.success?

            input.each_line.to_a.last.include?("+")
          end
        else
          false
        end
      end

      def guess_terminal_width
        guess_terminal_width_from_io ||
          guess_terminal_width_from_command ||
          guess_terminal_width_from_env ||
          80
      end

      def guess_terminal_width_from_io
        if IO.respond_to?(:console)
          IO.console.winsize[1]
        elsif $stderr.respond_to?(:winsize)
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
