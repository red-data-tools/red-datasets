require_relative "helper"

class DownloaderTest < Test::Unit::TestCase
  include Helper::Sandbox

  sub_test_case("#download") do
    def setup
      setup_sandbox
    end

    def teardown
      teardown_sandbox
    end

    test("too many redirection") do
      first_url = "https://example.com/file"
      last_url = "https://example.com/last_redirection"
      expected_message = "too many redirections: #{first_url} .. #{last_url}"
      output_path = @tmp_dir + "file"
      downloader = Datasets::Downloader.new(first_url)

      downloader.define_singleton_method(:start_http) do |url, fallback_urls, headers|
        raise Datasets::Downloader::TooManyRedirects, "too many redirections: #{last_url}"
      end

      assert_raise(Datasets::Downloader::TooManyRedirects.new(expected_message)) do
        downloader.download(output_path)
      end
    end

  end

  sub_test_case("#start_http") do
    test("uses GH_TOKEN for api.github.com requests") do
      original_gh_token = ENV["GH_TOKEN"]
      ENV["GH_TOKEN"] = "token"

      request = nil
      response = Net::HTTPOK.new("1.1", "200", "OK")
      def response.read_body
      end
      http = Object.new
      http.define_singleton_method(:use_ssl=) do |value|
      end
      http.define_singleton_method(:use_ssl?) do
        true
      end
      http.define_singleton_method(:cert_store=) do |store|
      end
      http.define_singleton_method(:start) do |&block|
        block.call
      end
      http.define_singleton_method(:request) do |requested, &block|
        request = requested
        block.call(response)
      end

      original_http_new = Net::HTTP.method(:new)
      Net::HTTP.singleton_class.send(:define_method, :new) do |host, port|
        http
      end
      begin
        downloader = Datasets::Downloader.new("https://api.github.com/repos/red-data-tools/red-datasets")
        downloader.send(:start_http,
                        URI.parse("https://api.github.com/repos/red-data-tools/red-datasets"),
                        [],
                        {}) do |download_response|
        end
      ensure
        Net::HTTP.singleton_class.send(:define_method, :new, original_http_new)
        ENV["GH_TOKEN"] = original_gh_token
      end

      assert_equal(["Bearer", "token"].join(" "), request["Authorization"])
    end
  end
end
