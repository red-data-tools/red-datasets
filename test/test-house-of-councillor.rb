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
                     11,
                     record(Date.parse("2025-08-01"),
                            "自由民主党",
                            "自民",
                            Date.parse("2025-08-11"),
                            100,
                            19,
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
                            27,
                            4,
                            39,
                            7),
                     record(Date.parse("2025-08-01"),
                            "各派に属しない議員",
                            "無所属",
                            Date.parse("2025-08-11"),
                            9,
                            4,
                            Date.parse("2028-07-25"),
                            1,
                            0,
                            3,
                            1,
                            4,
                            1,
                            Date.parse("2031-07-28"),
                            1,
                            0,
                            4,
                            3,
                            5,
                            3),
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
                     248,
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
                            "環境委員会、決算委員会（理）",
                            Date.parse("2025-08-11"),
                            "昭和40年8月18日東京都墨田区生まれ。千葉大学教育学部卒業、千葉大学大学院教育学研究科修了、東京芸術大学音楽研究科研究生。社会福祉法人櫻の会理事、ゆうひが丘保育園保育士。平成15年11月衆議院議員選挙初当選。平成19年7月参議院議員選挙初当選。衆議院厚労理事、文科委員ほか。衆議院消費者問題特別委員長。民主党千葉12区総支部長、同参議院比例区総支部長。同東京12区総支部長、同副幹事長。国民の生活が第一、日本未来の党、生活の党、自由党、国民民主党、立憲民主党。その間、国土交通委員会筆頭理事、環境委員会筆頭理事。東日本大震災復興特別委員長ほか○現在立憲民主党、行政監視委員長○衆議院議員3期",
                            Date.parse("2022-11-30")),
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
                            "法務委員会（理）、議院運営委員会、政治倫理審査会（幹）",
                            Date.parse("2025-08-11"),
                            "昭和43年4月18日生、岐阜県加茂郡八百津町出身。岐阜県立加茂高等学校、名古屋大学経済学部卒業。平成4年、財団法人松下政経塾入塾（第13期生）。平成7年、同塾卒業後、26歳で岐阜県議会議員に初当選。以後通算4期当選。在任中は、自民党岐阜県連副幹事長、岐阜県商工会青年部連合会会長、岐阜県商工政治連盟会長、県監査委員、県政自民クラブ幹事長を歴任。平成22年7月、参議院議員初当選○農林水産委員長、政治倫理の確立及び選挙制度に関する特別委員長、参議院自民党筆頭副幹事長、国土交通副大臣兼内閣府副大臣兼復興副大臣を歴任○現在議院運営委員会筆頭理事。環境委員",
                            Date.parse("2022-11-30")),
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
                     8218,
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
                     record(218,
                            24,
                            "オスプレイの安全性並びにオスプレイを含めた防衛装備品の調達及びプロジェクト管理に関する質問主意書",
                            "青木　愛",
                            1,
                            "https://www.sangiin.go.jp/japanese/joho1/kousei/syuisyo/218/syuh/s218024.htm",
                            nil,
                            "https://www.sangiin.go.jp/japanese/joho1/kousei/syuisyo/218/syup/s218024.pdf",
                            nil,
                            "https://www.sangiin.go.jp/japanese/joho1/kousei/syuisyo/218/meisai/m218024.htm",
                            Date.parse("2025-08-05"),
                            Date.parse("2025-08-05"),
                            nil,
                            "8月8日内閣から通知書受領（8月15日まで答弁延期）"),
                   ],
                   [
                     records.size,
                     records.first,
                     records.last,
                   ])
    end
  end
end
