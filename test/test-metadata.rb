class MetadataTest < Test::Unit::TestCase
  def setup
    @metadata = Datasets::Metadata.new
  end

  sub_test_case("#licenses") do
    test("String") do
      @metadata.licenses = "Apache-2.0"
      assert_equal([Datasets::License.new("Apache-2.0")],
                   @metadata.licenses)
    end

    test("[String]") do
      @metadata.licenses = ["Apache-2.0"]
      assert_equal([Datasets::License.new("Apache-2.0")],
                   @metadata.licenses)
    end

    test("{name:, url:}") do
      @metadata.licenses = {
        name: "Quora's Terms of Service",
        url: "https://www.quora.com/about/tos",
      }
      assert_equal([Datasets::License.new(nil,
                                          "Quora's Terms of Service",
                                          "https://www.quora.com/about/tos")],
                   @metadata.licenses)
    end

    test("Symbol") do
      assert_raise(ArgumentError.new("invalid license: :apache_2_0")) do
        @metadata.licenses = :apache_2_0
      end
    end
  end
end
