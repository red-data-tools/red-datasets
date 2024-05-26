class HouseOfCouncillorTest < Test::Unit::TestCase
  sub_test_case(":bill") do
    def setup
      @dataset = Datasets::HouseOfCouncillor.new
    end

    def record(*args)
      Datasets::HouseOfCouncillor::Bill.new(*args)
    end

    test("#each") do
      records = @dataset.each.to_a
      assert_equal([
                     9440,
                     record(153,
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
                     record(213,
                            "NHK決算",
                            212,
                            1,
                            "日本放送協会令和四年度財産目録、貸借対照表、損益計算書、資本等変動計算書及びキャッシュ・フロー計算書並びにこれらに関する説明書",
                            "https://www.sangiin.go.jp/japanese/joho1/kousei/gian/213/meisai/m213550212001.htm",
                            nil,
                            nil,
                            Date.parse("2023-12-08"),
                            nil,
                            nil,
                            nil,
                            nil,
                            nil,
                            nil,
                            nil,
                            nil,
                            nil,
                            nil,
                            nil,
                            nil,
                            nil,
                            nil,
                            nil,
                            nil,
                            nil,
                            Date.parse("2024-01-26"),
                            "総務委員会",
                            nil,
                            nil,
                            nil,
                            nil,
                            nil,
                            nil,
                            nil,
                            nil,
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
                     record(Date.parse("2024-01-26"),
                            "自由民主党",
                            "自民",
                            Date.parse("2024-05-25"),
                            115,
                            24,
                            Date.parse("2025-07-28"),
                            19,
                            5,
                            33,
                            6,
                            52,
                            11,
                            Date.parse("2028-07-25"),
                            18,
                            5,
                            45,
                            8,
                            63,
                            13),
                     record(Date.parse("2024-01-26"),
                            "各派に属しない議員",
                            "無所属",
                            Date.parse("2024-05-25"),
                            12,
                            4,
                            Date.parse("2025-07-28"),
                            1,
                            0,
                            7,
                            2,
                            8,
                            2,
                            Date.parse("2028-07-25"),
                            1,
                            0,
                            3,
                            2,
                            4,
                            2),
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
                     record("足立　敏之",
                            nil,
                            "https://www.sangiin.go.jp/japanese/joho1/kousei/giin/profile/7016001.htm",
                            "あだち　としゆき",
                            "自民",
                            "比例",
                            Date.parse("2028-07-25"),
                            "https://www.sangiin.go.jp/japanese/joho1/kousei/giin/photo/g7016001.jpg",
                            [2016, 2022],
                            2,
                            "財政金融委員会（長）",
                            Date.parse("2024-05-25"),
                            "昭和29年5月20日兵庫県西宮市生まれ。（本籍地・京都府福知山市）昭和48年和歌山県立桐蔭高等学校卒業、昭和52年京都大学工学部土木工学科卒業、昭和54年京都大学大学院工学研究科修士課程修了、同年建設省入省後、兵庫県庁、東北及び関東地方整備局、河川局河川計画課河川事業調整官、内閣官房（安全保障・危機管理担当）等を経て、平成15年近畿地方整備局企画部長、平成18年河川局河川計画課長、平成21年四国地方整備局長、平成23年中部地方整備局長、平成24年水管理・国土保全局長、平成25年技監、平成26年国土交通省を退職。平成28年第24回参議院議員通常選挙で初当選○参議院予算委員会理事、災害対策特別委員会理事○著書「激甚化する水害」「いいね！建設産業本当の魅力」（日経BP社）",
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
                            "経済産業委員会、議院運営委員会（理）",
                            Date.parse("2024-05-25"),
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
                     7739,
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
                     record(213,
                            145,
                            "地方自治体職員の国籍に関する質問主意書",
                            "神谷　宗幣",
                            1,
                            nil,
                            nil,
                            nil,
                            nil,
                            "https://www.sangiin.go.jp/japanese/joho1/kousei/syuisyo/213/meisai/m213145.htm",
                            Date.parse("2024-05-23"),
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
