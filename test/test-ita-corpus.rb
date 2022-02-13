class ITAcorpusTest < Test::Unit::TestCase
  def setup
    @dataset = Datasets::ITAcorpus.new
  end

  test('#each') do
    records = @dataset.each.to_a
    assert_equal([
                   424,
                   {
                     :id => "EMOTION100_001",
                     :sentence => "えっ嘘でしょ。,エッウソデショ。"
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

  sub_test_case("#metadata") do
    test("#description") do
      description = @dataset.metadata.description
      assert_equal([
                     "# ITAコーパスの文章リスト公開用リポジトリ",
                     "## ITAコーパスとは",
                   ],
                   description.scan(/^#.*$/),
                   description)
    end
  end

end
