class WikipediaTest < Test::Unit::TestCase
  sub_test_case("en") do
    sub_test_case("articles") do
      def setup
        @dataset = Datasets::Wikipedia.new(language: :en,
                                           type: :articles)
      end

      test("#each") do
        contributor = Datasets::Wikipedia::Contributor.new("Asparagusus", 43603280)
        revision = Datasets::Wikipedia::Revision.new
        revision.id = 1219062925
        revision.parent_id = 1219062840
        revision.timestamp = Time.iso8601("2024-04-15T14:38:04Z")
        revision.contributor = contributor
        revision.comment = "Restored revision 1002250816 by [[Special:Contributions/Elli|Elli]] ([[User talk:Elli|talk]]): Unexplained redirect breaking"
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
