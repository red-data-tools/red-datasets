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

      downloader.define_singleton_method(:start_http) do |url, headers|
        raise Datasets::Downloader::TooManyRedirects, "too many redirections: #{last_url}"
      end

      assert_raise(Datasets::Downloader::TooManyRedirects.new(expected_message)) do
        downloader.download(output_path)
      end
    end
  end
end
