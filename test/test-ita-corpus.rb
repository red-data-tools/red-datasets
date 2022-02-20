class ITACorpusTest < Test::Unit::TestCase

  sub_test_case("type") do  
    test("emotion") do
      dataset = Datasets::ITACorpus.new(type: :emotion)
      records = dataset.to_a
      assert_equal([
                    100,
                    {
                      :id => "EMOTION100_001",
                      :sentence => "えっ嘘でしょ。,エッウソデショ。"
                    },
                    {
                      :id => "EMOTION100_100",
                      :sentence => "ラーテャン。,ラーテャン。",
                    },
                  ],
                  [
                    records.size,
                    records[0].to_h,
                    records[-1].to_h,
                  ])
    end

    test("recitation") do
      dataset = Datasets::ITACorpus.new(type: :recitation)
      records = dataset.to_a
      assert_equal([
                    324,
                    {
                      :id => "RECITATION324_001",
                      :sentence => "女の子がキッキッ嬉しそう。,オンナノコガキッキッウレシソー。"
                    },
                    {
                      :id => "RECITATION324_324",
                      :sentence => "チュクンの波長は、パツンと共通している。,チュクンノハチョーワ、パツントキョーツウシテイル。",
                    },
                  ],
                  [
                    records.size,
                    records[0].to_h,
                    records[-1].to_h,
                  ])
    end

    test("invalid") do
      message = "Please set type :emotion or :recitation: :invalid"
      assert_raise(ArgumentError.new(message)) do
        Datasets::ITACorpus.new(type: :invalid)
      end
    end

  end

  sub_test_case("#metadata") do
    test("#description") do
      dataset = Datasets::ITACorpus.new(type: :emotion)
      description = dataset.metadata.description
      assert_equal([
                     "# ITAコーパスの文章リスト公開用リポジトリ",
                     "## ITAコーパスとは",
                     "## ITAコーパスの文献情報"
                   ],
                   description.scan(/^#.*$/),
                   description)
    end
  end

end
