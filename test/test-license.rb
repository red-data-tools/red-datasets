class LicenseTest < Test::Unit::TestCase
  sub_test_case(".try_convert") do
    test("String") do
      assert_equal(Datasets::License.new("Apache-2.0"),
                   Datasets::License.try_convert("Apache-2.0"))
    end

    test("{spdx_id:}") do
      assert_equal(Datasets::License.new("Apache-2.0"),
                   Datasets::License.try_convert(spdx_id: "Apache-2.0"))
    end

    test("{name:, url:}") do
      license = {
        name: "Quora's Terms of Service",
        url: "https://www.quora.com/about/tos",
      }
      assert_equal(Datasets::License.new(nil,
                                         "Quora's Terms of Service",
                                         "https://www.quora.com/about/tos"),
                   Datasets::License.try_convert(license))
    end
  end
end
