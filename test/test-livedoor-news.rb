class LivedoorNewsTest < Test::Unit::TestCase
  sub_test_case("type") do
    test("topic_news") do
      dataset = Datasets::LivedoorNews.new(type: :topic_news)
      records = dataset.to_a
      assert_equal([
                     770,
                     [
                       "http://news.livedoor.com/article/detail/5903225/",
                       Time.iso8601("2011-10-02T10:00:00+0900"),
                       "悪評が次から次へと溢",
                       "/5571502/\n"
                     ],
                     [
                       "http://news.livedoor.com/article/detail/6918105/",
                       Time.iso8601("2012-09-04T12:45:00+0900"),
                       "ジャンプ連載漫画が終",
                       "提案も散見された。\n"
                     ],
                   ],
                   [
                     records.size,
                     [
                       records[0].url,
                       records[0].timestamp,
                       records[0].sentence[0, 10],
                       records[0].sentence[-10, 10]
                     ],
                     [
                       records[-1].url,
                       records[-1].timestamp,
                       records[-1].sentence[0, 10],
                       records[-1].sentence[-10, 10]
                     ],
                   ])
    end

    test("sports_watch") do
      dataset = Datasets::LivedoorNews.new(type: :sports_watch)
      records = dataset.to_a
      assert_equal([
                     900,
                     [
                       "http://news.livedoor.com/article/detail/4597641/",
                       Time.iso8601("2010-02-10T10:50:00+0900"),
                       "【Sports Wa",
                       "送る秋山であった。\n"
                     ],
                     [
                       "http://news.livedoor.com/article/detail/6917848/",
                       Time.iso8601("2012-09-04T11:25:00+0900"),
                       "ジーコ、本田圭佑につ",
                       "る」と語っている。\n"
                     ],
                   ],
                   [
                     records.size,
                     [
                       records[0].url,
                       records[0].timestamp,
                       records[0].sentence[0, 10],
                       records[0].sentence[-10, 10]
                     ],
                     [
                       records[-1].url,
                       records[-1].timestamp,
                       records[-1].sentence[0, 10],
                       records[-1].sentence[-10, 10]
                     ],
                   ])
    end

    test("it_life_hack") do
      dataset = Datasets::LivedoorNews.new(type: :it_life_hack)
      records = dataset.to_a
      assert_equal([
                     870,
                     [
                       "http://news.livedoor.com/article/detail/6292880/",
                       Time.iso8601("2012-02-19T13:00:00+0900"),
                       "旧式Macで禁断のパ",
                       "p\n" + "クチコミを見る\n"
                     ],
                     [
                       "http://news.livedoor.com/article/detail/6918825/",
                       Time.iso8601("2012-09-04T15:00:00+0900"),
                       "レノボWindows",
                       "J\n" + "クチコミを見る\n"
                     ],
                   ],
                   [
                     records.size,
                     [
                       records[0].url,
                       records[0].timestamp,
                       records[0].sentence[0, 10],
                       records[0].sentence[-10, 10]
                     ],
                     [
                       records[-1].url,
                       records[-1].timestamp,
                       records[-1].sentence[0, 10],
                       records[-1].sentence[-10, 10]
                     ],
                   ])
    end

    test("kaden_channel") do
      dataset = Datasets::LivedoorNews.new(type: :kaden_channel)
      records = dataset.to_a
      assert_equal([
                     864,
                     [
                       "http://news.livedoor.com/article/detail/5774093/",
                       Time.iso8601("2011-08-10T10:00:00+0900"),
                       "【ニュース】電力使用",
                       "に備える【デジ通】\n"
                     ],
                     [
                       "http://news.livedoor.com/article/detail/6919353/",
                       Time.iso8601("2012-09-04T17:00:00+0900"),
                       "Hulu、ついに待望",
                       "uに今後も注目だ。\n"
                     ],
                   ],
                   [
                     records.size,
                     [
                       records[0].url,
                       records[0].timestamp,
                       records[0].sentence[0, 10],
                       records[0].sentence[-10, 10]
                     ],
                     [
                       records[-1].url,
                       records[-1].timestamp,
                       records[-1].sentence[0, 10],
                       records[-1].sentence[-10, 10]
                     ],
                   ])
    end

    test("movie_enter") do
      dataset = Datasets::LivedoorNews.new(type: :movie_enter)
      records = dataset.to_a
      assert_equal([
                     870,
                     [
                       "http://news.livedoor.com/article/detail/5840081/",
                       Time.iso8601("2011-09-08T10:00:00+0900"),
                       "インタビュー：宮崎あ",
                       "ない。 1 2 3\n"
                     ],
                     [
                       "http://news.livedoor.com/article/detail/6909318/",
                       Time.iso8601("2012-09-01T10:30:00+0900"),
                       "【週末映画まとめ読み",
                       "レイ+DVDセット\n"
                     ],
                   ],
                   [
                     records.size,
                     [
                       records[0].url,
                       records[0].timestamp,
                       records[0].sentence[0, 10],
                       records[0].sentence[-10, 10]
                     ],
                     [
                       records[-1].url,
                       records[-1].timestamp,
                       records[-1].sentence[0, 10],
                       records[-1].sentence[-10, 10]
                     ],
                   ])
    end

    test("dokujo_tsushin") do
      dataset = Datasets::LivedoorNews.new(type: :dokujo_tsushin)
      records = dataset.to_a
      assert_equal([
                     870,
                     [
                       "http://news.livedoor.com/article/detail/4778030/",
                       Time.iso8601("2010-05-22T14:30:00+0900"),
                       "友人代表のスピーチ、",
                       "も幸あれ（高山惠）\n"
                     ],
                     [
                       "http://news.livedoor.com/article/detail/6915005/",
                       Time.iso8601("2012-09-03T14:00:00+0900"),
                       "男女間で“カワイイ”",
                       "ツー／神田はるひ）\n"
                     ],
                   ],
                   [
                     records.size,
                     [
                       records[0].url,
                       records[0].timestamp,
                       records[0].sentence[0, 10],
                       records[0].sentence[-10, 10]
                     ],
                     [
                       records[-1].url,
                       records[-1].timestamp,
                       records[-1].sentence[0, 10],
                       records[-1].sentence[-10, 10]
                     ],
                   ])
    end

    test("smax") do
      dataset = Datasets::LivedoorNews.new(type: :smax)
      records = dataset.to_a
      assert_equal([
                     870,
                     [
                       "http://news.livedoor.com/article/detail/6507397/",
                       Time.iso8601("2012-04-26T16:55:00+0900"),
                       "あのアプリもこのアプ",
                       "n Twitter\n"
                     ],
                     [
                       "http://news.livedoor.com/article/detail/6919324/",
                       Time.iso8601("2012-09-04T16:55:00+0900"),
                       "【究極にカスタマイズ",
                       "個人） : 富士通\n"
                     ],
                   ],
                   [
                     records.size,
                     [
                       records[0].url,
                       records[0].timestamp,
                       records[0].sentence[0, 10],
                       records[0].sentence[-10, 10]
                     ],
                     [
                       records[-1].url,
                       records[-1].timestamp,
                       records[-1].sentence[0, 10],
                       records[-1].sentence[-10, 10]
                     ],
                   ])
    end

    test("livedoor_homme") do
      dataset = Datasets::LivedoorNews.new(type: :livedoor_homme)
      records = dataset.to_a
      assert_equal([
                     511,
                     [
                       "http://news.livedoor.com/article/detail/4568088/",
                       Time.iso8601("2010-01-24T18:10:00+0900"),
                       "フォーエバー２１旗艦",
                       "フォーエバー２１」\n"
                     ],
                     [
                       "http://news.livedoor.com/article/detail/6828491/",
                       Time.iso8601("2012-08-06T14:30:00+0900"),
                       "【女子座談会】ぶっち",
                       "タートキャンペーン\n"
                     ],
                   ],
                   [
                     records.size,
                     [
                       records[0].url,
                       records[0].timestamp,
                       records[0].sentence[0, 10],
                       records[0].sentence[-10, 10]
                     ],
                     [
                       records[-1].url,
                       records[-1].timestamp,
                       records[-1].sentence[0, 10],
                       records[-1].sentence[-10, 10]
                     ],
                   ])
    end

    test("peachy") do
      dataset = Datasets::LivedoorNews.new(type: :peachy)
      records = dataset.to_a
      assert_equal([
                     842,
                     [
                       "http://news.livedoor.com/article/detail/4289213/",
                       Time.iso8601("2009-08-07T20:30:00+0900"),
                       "韓国の伝統菓子を食べ",
                       "試してみませんか？\n"
                     ],
                     [
                       "http://news.livedoor.com/article/detail/6908055/",
                       Time.iso8601("2012-09-01T18:00:00+0900"),
                       "初デートで彼を悶絶さ",
                       "hyアプリの使い方\n"
                     ],
                   ],
                   [
                     records.size,
                     [
                       records[0].url,
                       records[0].timestamp,
                       records[0].sentence[0, 10],
                       records[0].sentence[-10, 10]
                     ],
                     [
                       records[-1].url,
                       records[-1].timestamp,
                       records[-1].sentence[0, 10],
                       records[-1].sentence[-10, 10]
                     ],
                   ])
    end

    test("invalid") do
      message = ":type must be one of [" +
                ":topic_news, " +
                ":sports_watch, " +
                ":it_life_hack, " +
                ":kaden_channel, " +
                ":movie_enter, " +
                ":dokujo_tsushin, " +
                ":smax, " +
                ":livedoor_homme, " +
                ":peachy" +
                "]: :invalid"
      assert_raise(ArgumentError.new(message)) do
        Datasets::LivedoorNews.new(type: :invalid)
      end
    end
  end

  sub_test_case("#metadata") do
    test("#description") do
      dataset = Datasets::LivedoorNews.new(type: :topic_news)
      description = dataset.metadata.description
      assert_equal([
                     "livedoor ニ",
                     "に感謝いたします。\n"
                   ],
                   [
                     description[0,10],
                     description[-10,10]
                   ],
                   description)
    end
  end
end
