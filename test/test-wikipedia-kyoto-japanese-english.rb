class WikipediaKyotoJapaneseEnglishTest < Test::Unit::TestCase
  def setup
    @dataset_articles = Datasets::WikipediaKyotoJapaneseEnglish.new(type: :article)
    @dataset_lexicon = Datasets::WikipediaKyotoJapaneseEnglish.new(type: :lexicon)
  end

  test('#article') do
    first_article = @dataset_articles.each.first
    assert_equal([
                    "jawiki-20080607-pages-articles.xml",
                    "copyright (c) 2010 前田左衛門佐(id:194701), 与左衛門(id:159462), R28Bot(id:177951), 遠藤(id:30275), Dream100(id:41924), 独立行政法人情報通信研究機構．このテキストの利用はCreative Commons Attribution-Share-Alike License 3.0 の条件の下に許諾されます．（この著作権者一覧には、Wikipedia IPユーザーを含んでおりません．この点に関するお問い合わせはこちらまで：kyoto-corpus@khn.nict.go.jp）",
                    9,
                    0
                  ],
                  [
                    first_article.to_h[:source],
                    first_article.to_h[:copyright],
                    first_article.to_h[:contents].size,
                    first_article.to_h[:sections].size
                  ])
  end

  test('#title_and_sentence') do
    title, sentence = @dataset_articles.each.first.to_h[:contents].first(2)
    assert_equal([
                  [
                    nil,
                    "三要元佶",
                    "Genkitsu SANYO"
                  ],
                  [
                    "1",
                    nil,
                    "1",
                    1,
                    "三要元佶（さんよう げんきつ, 天文 (元号)17年（1548年） - 慶長17年5月20日 (旧暦)（1612年6月19日））は、安土桃山時代から江戸時代初頭にかけて活躍した禅僧である。",
                    "Genkitsu SANYO (1548 - June 19, 1612) was a Zen priest who was active during the period from the Azuchi-Momoyama period to the early Edo period."]
                  ],
                  [
                   [
                     title.to_h[:section],
                     title.to_h[:japanese],
                     title.to_h[:english]
                   ],
                   [
                     sentence.to_h[:id],
                     sentence.to_h[:section],
                     sentence.to_h[:paragraph][:id],
                     sentence.to_h[:paragraph][:sentences].size,
                     sentence.to_h[:japanese],
                     sentence.to_h[:english]
                    ]
                  ])
  end

  test('#lexicon') do
    records = @dataset_lexicon.each.to_a
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

  test("invalid") do
    message = "Please set type :article or :lexicon :invalid"
    assert_raise(ArgumentError.new(message)) do
      Datasets::WikipediaKyotoJapaneseEnglish.new(type: :invalid)
    end
  end

  test("#description") do
    description = @dataset_articles.metadata.description
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