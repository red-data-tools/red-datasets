class HouseOfCouncillorTest < Test::Unit::TestCase
  test("invalid") do
    message = ":type must be one of [:bill, :in_house_group, :member, :question]: :invalid"
    assert_raise(ArgumentError.new(message)) do
      Datasets::HouseOfCouncillor.new(type: :invalid)
    end
  end

  sub_test_case(":bill") do
    def setup
      @dataset = Datasets::HouseOfCouncillor.new
    end

    def record(*args)
      Datasets::HouseOfCouncillor::Bill.new(*args)
    end

    test("#each") do
      assert_equal(record(153,
                          "法律案（内閣提出）",
                          153,
                          1,
                          "司法制度改革推進法案",
                          "https://www.sangiin.go.jp/japanese/joho1/kousei/gian/153/meisai/m15303153001.htm",
                          "https://www.sangiin.go.jp/japanese/joho1/kousei/gian/153/pdf/5315310.pdf",
                          nil,
                          Date.parse("2001-09-28"),
                          Date.parse("2001-10-30"),
                          nil,
                          "衆先議",
                          nil,
                          nil,
                          nil,
                          nil,
                          Date.parse("2001-10-31"),
                          "法務委員会",
                          Date.parse("2001-11-08"),
                          "可決",
                          Date.parse("2001-11-09"),
                          "可決",
                          nil,
                          "多数",
                          "押しボタン",
                          "https://www.sangiin.go.jp/japanese/joho1/kousei/vote/153/153-1109-v005.htm",
                          Date.parse("2001-10-18"),
                          "法務委員会",
                          Date.parse("2001-10-26"),
                          "可決",
                          Date.parse("2001-10-30"),
                          "可決",
                          nil,
                          "多数",
                          "起立",
                          Date.parse("2001-11-16"),
                          119,
                          nil,
                          nil),
                   @dataset.each.next)
    end
  end

  sub_test_case(":in_house_group") do
    def setup
      @dataset = Datasets::HouseOfCouncillor.new(type: :in_house_group)
    end

    def record(*args)
      Datasets::HouseOfCouncillor::InHouseGroup.new(*args)
    end

    test("#each") do
      records = @dataset.each.to_a
      assert_equal([
                     13,
                     record(Date.parse("2026-01-26"),
                            "自由民主党・無所属の会",
                            "自民",
                            Date.parse("2026-02-15"),
                            101,
                            20,
                            Date.parse("2028-07-25"),
                            18,
                            5,
                            43,
                            7,
                            61,
                            12,
                            Date.parse("2031-07-28"),
                            12,
                            3,
                            28,
                            5,
                            40,
                            8),
                     record(Date.parse("2026-01-26"),
                            "各派に属しない議員",
                            "無所属",
                            Date.parse("2026-02-15"),
                            6,
                            2,
                            Date.parse("2028-07-25"),
                            1,
                            0,
                            3,
                            1,
                            4,
                            1,
                            Date.parse("2031-07-28"),
                            0,
                            0,
                            2,
                            1,
                            2,
                            1),
                   ],
                   [
                     records.size,
                     records.first,
                     records.last,
                   ])
    end
  end

  sub_test_case(":member") do
    def setup
      @dataset = Datasets::HouseOfCouncillor.new(type: :member)
    end

    def record(*args)
      Datasets::HouseOfCouncillor::Member.new(*args)
    end

    test("#each") do
      records = @dataset.each.to_a
      assert_equal([
                     247,
                     record("青木　愛",
                            nil,
                            "https://www.sangiin.go.jp/japanese/joho1/kousei/giin/profile/7007006.htm",
                            "あおき　あい",
                            "立憲",
                            "比例",
                            Date.parse("2028-07-25"),
                            "https://www.sangiin.go.jp/japanese/joho1/kousei/giin/photo/g7007006.jpg",
                            [2007, 2016, 2022],
                            3,
                            "外交防衛委員会（理）、国家基本政策委員会、政府開発援助及び国際協力・人道支援等に関する特別委員会",
                            Date.parse("2026-02-15"),
                            "昭和40年8月18日東京都墨田区生まれ。千倉町立千倉中学校（現南房総市）、千葉県立安房高等学校、千葉大学教育学部卒業、千葉大学大学院教育学研究科修了、東京芸術大学大学院音楽教育学研究科研究生、高野山大学大学院文学研究科密教学専攻修了。社会福祉法人櫻の会理事、ゆうひが丘保育園保育士。平成15年11月衆議院議員選挙初当選。平成19年7月参議院議員選挙初当選。衆議院厚労理事、同消費者問題特別委員長ほか。参議院農林水産委員、同文教科学委員、同環境筆頭理事、同国土交通筆頭理事、同資源エネルギーに関する調査会理事、同東日本大震災復興特別委員長、同行政監視委員長、同国土交通委員長、同決算筆頭理事。民主党千葉12区総支部長、同東京12区総支部長、同参議院比例区総支部長、同副幹事長。自由党副代表、同参議院幹事長〇現在立憲民主党、同千葉県連副代表〇著書『子どもは地上の太陽だ』○衆議院議員3期",
                            Date.parse("2025-12-18")),
                     record("渡辺　猛之",
                            nil,
                            "https://www.sangiin.go.jp/japanese/joho1/kousei/giin/profile/7010055.htm",
                            "わたなべ　たけゆき",
                            "自民",
                            "岐阜",
                            Date.parse("2028-07-25"),
                            "https://www.sangiin.go.jp/japanese/joho1/kousei/giin/photo/g7010055.jpg",
                            [2010, 2016, 2022],
                            3,
                            "内閣委員会（理）、政治改革に関する特別委員会、政治倫理審査会（幹）",
                            Date.parse("2026-02-15"),
                            "昭和43年4月18日生、岐阜県加茂郡八百津町出身。岐阜県立加茂高等学校、名古屋大学経済学部卒業。平成4年、財団法人松下政経塾入塾（第13期生）。平成7年、同塾卒業後、26歳で岐阜県議会議員に初当選。以後通算四期当選。在任中は、自民党岐阜県連副幹事長、岐阜県商工会青年部連合会会長、岐阜県商工政治連盟会長、県政自民クラブ幹事長を歴任。平成22年7月、参議院議員初当選〇農林水産委員長、国土交通副大臣兼内閣府副大臣兼復興副大臣、法務委員会筆頭理事を歴任〇現在自民党幹事長代理、内閣委員会筆頭理事、政治倫理審査会筆頭幹事",
                            Date.parse("2025-12-18")),
                   ],
                   [
                     records.size,
                     records.first,
                     records.last,
                   ])
    end
  end

  sub_test_case(":question") do
    def setup
      @dataset = Datasets::HouseOfCouncillor.new(type: :question)
    end

    def record(*args)
      Datasets::HouseOfCouncillor::Question.new(*args)
    end

    test("#each") do
      records = @dataset.each.to_a
      assert_equal([
                     8317,
                     record(1,
                            1,
                            "食生活安定に関する質問主意書",
                            "市来　乙彦",
                            1,
                            "https://www.sangiin.go.jp/japanese/joho1/kousei/syuisyo/001/syuh/s001001.htm",
                            "https://www.sangiin.go.jp/japanese/joho1/kousei/syuisyo/001/touh/t001001.htm",
                            "https://www.sangiin.go.jp/japanese/joho1/kousei/syuisyo/001/syup/s001001.pdf",
                            "https://www.sangiin.go.jp/japanese/joho1/kousei/syuisyo/001/toup/t001001.pdf",
                            "https://www.sangiin.go.jp/japanese/joho1/kousei/syuisyo/001/meisai/m001001.htm",
                            Date.parse("1947-06-06"),
                            Date.parse("1947-06-23"),
                            Date.parse("1947-06-28"),
                            nil),
                     record(220,
                            4,
                            "「外国からの不当な干渉」に関する質問主意書",
                            "奥田　ふみよ",
                            1,
                            "https://www.sangiin.go.jp/japanese/joho1/kousei/syuisyo/220/syuh/s220004.htm",
                            "https://www.sangiin.go.jp/japanese/joho1/kousei/syuisyo/220/touh/t220004.htm",
                            "https://www.sangiin.go.jp/japanese/joho1/kousei/syuisyo/220/syup/s220004.pdf",
                            "https://www.sangiin.go.jp/japanese/joho1/kousei/syuisyo/220/toup/t220004.pdf",
                            "https://www.sangiin.go.jp/japanese/joho1/kousei/syuisyo/220/meisai/m220004.htm",
                            Date.parse("2026-01-23"),
                            Date.parse("2026-01-23"),
                            Date.parse("2026-02-03"),
                            "1月27日内閣から通知書受領（2月3日まで答弁延期）"),
                   ],
                   [
                     records.size,
                     records.first,
                     records.last,
                   ])
    end
  end
end
