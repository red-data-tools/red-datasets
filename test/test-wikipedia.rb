class WikipediaTest < Test::Unit::TestCase
  sub_test_case("en") do
    sub_test_case("articles") do
      def setup
        @dataset = Datasets::Wikipedia.new(language: :en,
                                           type: :articles)
      end

      test("#each") do
        contributor = Datasets::Wikipedia::Contributor.new("Elli", 20842734)
        revision = Datasets::Wikipedia::Revision.new
        revision.id = 1002250816
        revision.parent_id = 854851586
        revision.timestamp = Time.iso8601("2021-01-23T15:15:01Z")
        revision.contributor = contributor
        revision.comment = "shel"
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
