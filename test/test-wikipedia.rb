class WikipediaTest < Test::Unit::TestCase
  sub_test_case("en") do
    sub_test_case("articles") do
      def setup
        @dataset = Datasets::Wikipedia.new(language: :en,
                                           type: :articles)
      end

      test("#each") do
        contributor = Datasets::Wikipedia::Contributor.new("Graham87", 194203)
        revision = Datasets::Wikipedia::Revision.new
        revision.id = 1367012995
        revision.parent_id = 1362980932
        revision.timestamp = Time.iso8601("2026-07-31T12:02:55Z")
        revision.contributor = contributor
        revision.comment = "1 revision imported: import old edit from [[nost:AccessibleComputing]]"
        revision.model = "wikitext"
        revision.format = "text/x-wiki"
        revision.text = <<-TEXT.chomp
#REDIRECT [[Computer accessibility]]

{{rcat shell|
{{R from move}}
{{R from CamelCase}}
{{R unprintworthy}}
}}
        TEXT
        revision.sha1 = "kmysdltgexdwkv2xsml3j44jb56dxvn"
        page = Datasets::Wikipedia::Page.new
        page.title = "AccessibleComputing"
        page.namespace = 0
        page.id = 10
        page.restrictions = nil
        page.redirect = "Computer accessibility"
        page.revision = revision
        assert_equal(page, @dataset.each.first)
      end

      sub_test_case("#metadata") do
        test("#id") do
          assert_equal("wikipedia-en-articles",
                       @dataset.metadata.id)
        end

        test("#name") do
          assert_equal("Wikipedia articles (en)",
                       @dataset.metadata.name)
        end

        test("#description") do
          assert_equal("Wikipedia articles in en",
                       @dataset.metadata.description)
        end
      end
    end
  end
end
