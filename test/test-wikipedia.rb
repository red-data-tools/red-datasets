class WikipediaTest < Test::Unit::TestCase
  sub_test_case("ja") do
    sub_test_case("articles") do
      include Helper::Sandbox

      def setup
        setup_sandbox
        @dataset = Datasets::Wikipedia.new(language: :ja,
                                           type: :articles)
        def @dataset.cache_dir_path
          @cache_dir_path
        end
        def @dataset.cache_dir_path=(path)
          @cache_dir_path = path
        end
        @dataset.cache_dir_path = @tmp_dir
      end

      def teardown
        teardown_sandbox
      end

      test("#each") do
        def @dataset.download(output_path, url)
          xml_path = output_path.sub_ext("")
          xml_path.open("w") do |xml_file|
            xml_file.puts(<<-XML)
<mediawiki
   xmlns="http://www.mediawiki.org/xml/export-0.10/"
   xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
   xsi:schemaLocation="http://www.mediawiki.org/xml/export-0.10/ http://www.mediawiki.org/xml/export-0.10.xsd"
   version="0.10" xml:lang="ja">
  <siteinfo>
    <sitename>Wikipedia</sitename>
  </siteinfo>
  <page>
    <title>タイトル</title>
    <ns>4</ns>
    <id>1</id>
    <restrictions>sysop</restrictions>
    <revision>
      <id>3</id>
      <parentid>2</parentid>
      <timestamp>2004-04-30T14:46:00Z</timestamp>
      <contributor>
        <username>user</username>
        <id>10</id>
      </contributor>
      <minor />
      <comment>コメント</comment>
      <model>wikitext</model>
      <format>text/x-wiki</format>
      <text xml:space="preserve">テキスト</text>
      <sha1>a9674b19f8c56f785c91a555d0a144522bb318e6</sha1>
    </revision>
  </page>
</mediawiki>
            XML
          end
          unless system("bzip2", xml_path.to_s)
            raise "failed to run bzip2"
          end
        end

        contributor = Datasets::Wikipedia::Contributor.new("user", 10)
        revision = Datasets::Wikipedia::Revision.new
        revision.id = 3
        revision.parent_id = 2
        revision.timestamp = Time.iso8601("2004-04-30T14:46:00Z")
        revision.contributor = contributor
        revision.comment = "コメント"
        revision.model = "wikitext"
        revision.format = "text/x-wiki"
        revision.text = "テキスト"
        revision.sha1 = "a9674b19f8c56f785c91a555d0a144522bb318e6"
        page = Datasets::Wikipedia::Page.new
        page.title = "タイトル"
        page.namespace = 4
        page.id = 1
        page.restrictions = ["sysop"]
        page.revision = revision
        assert_equal(page, @dataset.each.first)
      end

      sub_test_case("#metadata") do
        test("#id") do
          assert_equal("wikipedia-ja-articles",
                       @dataset.metadata.id)
        end

        test("#name") do
          assert_equal("Wikipedia articles (ja)",
                       @dataset.metadata.name)
        end

        test("#description") do
          assert_equal("Wikipedia articles in ja",
                       @dataset.metadata.description)
        end
      end
    end
  end
end
