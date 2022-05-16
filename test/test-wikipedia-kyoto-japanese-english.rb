class WikipediaKyotoJapaneseEnglishTest < Test::Unit::TestCase
  sub_test_case("article") do
    def setup
      @dataset = Datasets::WikipediaKyotoJapaneseEnglish.new(type: :article)
    end

    def shorten_text(text)
      max = 20
      if text.size <= max
        text
      else
        "#{text[0, max]}..."
      end
    end

    def hashify(record)
      hash = {class: record.class.name.split("::").last}
      case record
      when Datasets::WikipediaKyotoJapaneseEnglish::Title
        hash[:section] = record.section&.id
        hash[:japanese] = shorten_text(record.japanese)
        hash[:english] = shorten_text(record.english)
      when Datasets::WikipediaKyotoJapaneseEnglish::Sentence
        hash[:id] = record.id
        hash[:section] = record.section&.id
        hash[:paragraph] = record.paragraph&.id
        hash[:japanese] = shorten_text(record.japanese)
        hash[:english] = shorten_text(record.english)
      else
        record.members.each do |member|
          value = record[member]
          case value
          when Array
            value = value.collect do |v|
              hashify(v)
            end
          when String
            value = shorten_text(value)
          when Struct
            value = hasify(value)
          end
          hash[member] = value
        end
      end
      hash
    end

    test("#each") do
      first_record = @dataset.each.first
      assert_equal({
                     class: "Article",
                     copyright: "copyright (c) 2010 前...",
                     sections: [],
                     source: "jawiki-20080607-page...",
                     contents: [
                       {
                         class: "Title",
                         section: nil,
                         english: "Genkitsu SANYO",
                         japanese: "三要元佶",
                       },
                       {
                         class: "Sentence",
                         id: "1",
                         section: nil,
                         paragraph: "1",
                         english: "Genkitsu SANYO (1548...",
                         japanese: "三要元佶（さんよう げんきつ, 天文 (...",
                       },
                       {
                         class: "Sentence",
                         id: "2",
                         section: nil,
                         paragraph: "2",
                         english: "He was originally fr...",
                         japanese: "肥前国（佐賀県）の出身。",
                       },
                       {
                         class: "Sentence",
                         id: "3",
                         section: nil,
                         paragraph: "2",
                         english: "His Go (pen name) wa...",
                         japanese: "号は閑室。",
                       },
                       {
                         class: "Sentence",
                         id: "4",
                         section: nil,
                         paragraph: "2",
                         english: "He was called Kiccho...",
                         japanese: "佶長老、閑室和尚と呼ばれた。",
                       },
                       {
                         class: "Sentence",
                         id: "5",
                         section: nil,
                         paragraph: "3",
                         english: "He went up to the ca...",
                         japanese: "幼少時に都に上り、岩倉の円通寺 (京都市...",
                       },
                       {
                         class: "Sentence",
                         id: "6",
                         section: nil,
                         paragraph: "4",
                         english: "After assuming the p...",
                         japanese: "足利学校の長となるが、関ヶ原の戦いの折に...",
                       },
                       {
                         class: "Sentence",
                         id: "7",
                         section: nil,
                         paragraph: "5",
                         english: "He assumed the posit...",
                         japanese: "金地院崇伝と寺社奉行の任に当たり、西笑承...",
                       },
                       {
                         class: "Sentence",
                         id: "8",
                         section: nil,
                         paragraph: "6",
                         english: "Later, he was invite...",
                         japanese: "家康によって、伏見区の学校に招かれ、円光...",
                       },
                     ],
                   },
                   hashify(first_record))
    end
  end

  sub_test_case("lexicon") do
    def setup
      @dataset = Datasets::WikipediaKyotoJapaneseEnglish.new(type: :lexicon)
    end

    test("#each") do
      records = @dataset.each.to_a
      assert_equal([
                     51982,
                     {
                       :japanese => "102世吉田日厚貫首",
                       :english => "the 102nd head priest, Nikko TOSHIDA"
                     },
                     {
                       :japanese => "龗神社",
                       :english => "Okami-jinja Shrine"
                     },
                    ],
                    [
                      records.size,
                      records[0].to_h,
                      records[-1].to_h,
                    ])
    end
  end

  test("invalid") do
    message = "Please set type :article or :lexicon: :invalid"
    assert_raise(ArgumentError.new(message)) do
      Datasets::WikipediaKyotoJapaneseEnglish.new(type: :invalid)
    end
  end

  test("description") do
    dataset = Datasets::WikipediaKyotoJapaneseEnglish.new
    description = dataset.metadata.description
    assert_equal(<<-DESCRIPTION, description)
"The Japanese-English Bilingual Corpus of Wikipedia's Kyoto Articles"
aims mainly at supporting research and development relevant to
high-performance multilingual machine translation, information
extraction, and other language processing technologies. The National
Institute of Information and Communications Technology (NICT) has
created this corpus by manually translating Japanese Wikipedia
articles (related to Kyoto) into English.
    DESCRIPTION
  end
end
