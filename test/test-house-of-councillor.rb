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
                     10,
                     record(Date.parse("2025-05-26"),
                            "自由民主党",
                            "自民",
                            Date.parse("2025-05-31"),
                            113,
                            22,
                            Date.parse("2025-07-28"),
                            19,
                            5,
                            33,
                            5,
                            52,
                            10,
                            Date.parse("2028-07-25"),
                            18,
                            5,
                            43,
                            7,
                            61,
                            12),
                     record(Date.parse("2025-05-26"),
                            "各派に属しない議員",
                            "無所属",
                            Date.parse("2025-05-31"),
                            10,
                            5,
                            Date.parse("2025-07-28"),
                            1,
                            0,
                            6,
                            4,
                            7,
                            4,
                            Date.parse("2028-07-25"),
                            1,
                            0,
                            2,
                            1,
                            3,
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
                     240,
                     record("阿達　雅志",
                            nil,
                            "https://www.sangiin.go.jp/japanese/joho1/kousei/giin/profile/7014002.htm",
                            "あだち　まさし",
                            "自民",
                            "比例",
                            Date.parse("2028-07-25"),
                            "https://www.sangiin.go.jp/japanese/joho1/kousei/giin/photo/g7014002.jpg",
                            [2014, 2016, 2022],
                            3,
                            "総務委員会、国家基本政策委員会、災害対策特別委員会",
                            Date.parse("2025-05-31"),
                            "昭和34年9月27日京都市生まれ、福井県、大阪府で育つ。私立洛星中学・高校を経て、昭和58年東京大学法学部卒業。同年住友商事株式会社入社。鉄道車輌の輸出営業、米国車輌工場勤務後、ニューヨーク大学ロー・スクールにて比較法修士（MCJ）、法学修士（LLM）を取得。平成5年米国ニューヨーク州弁護士登録。その後同社法務部、北京駐在勤務後、平成12年退職。衆議院議員佐藤信二氏秘書。平成16年ポール・ワイス外国法事務弁護士事務所勤務。日本大学法科大学院非常勤講師、東京大学大学院情報学環特任研究員を歴任。平成26年12月繰上げ当選。平成28年9月党外交部会長（2期連続）。平成30年10月国土交通大臣政務官兼内閣府大臣政務官、令和2年内閣総理大臣補佐官（経済・外交担当）○著書「世界パラダイム・シフト」「政治家になった父から18歳の息子へ（わが家の主権者教育）」",
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
                            "法務委員会（理）、議院運営委員会",
                            Date.parse("2025-05-31"),
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
                     8080,
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
                     record(217,
                            133,
                            "虐待判定AI及び相談事業AIをめぐる利益誘導に関する質問主意書",
                            "浜田　聡",
                            1,
                            nil,
                            nil,
                            nil,
                            nil,
                            "https://www.sangiin.go.jp/japanese/joho1/kousei/syuisyo/217/meisai/m217133.htm",
                            Date.parse("2025-05-28"),
                            nil,
                            nil,
                            nil),
                   ],
                   [
                     records.size,
                     records.first,
                     records.last,
                   ])
    end
  end
end
