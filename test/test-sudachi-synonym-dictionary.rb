class SudachiSynonymDictionaryTest < Test::Unit::TestCase
  def setup
    @dataset = Datasets::SudachiSynonymDictionary.new
  end

  test('#each') do
    records = @dataset.each.to_a
    assert_equal([
                   67725,
                   {
                     group_id: "000001",
                     is_noun: true,
                     expansion_type: :always,
                     lexeme_id: 1,
                     form_type: :typical,
                     acronym_type: :typical,
                     variant_type: :typical,
                     categories: [],
                     notation: "曖昧",
                   },
                   {
                     group_id: "026057",
                     is_noun: true,
                     expansion_type: :always,
                     lexeme_id: 1,
                     form_type: :typical,
                     acronym_type: :others,
                     variant_type: :typical,
                     categories: ["商品"],
                     notation: "マイクラ",
                   },
                 ],
                 [
                   records.size,
                   records[0].to_h,
                   records[-1].to_h,
                 ])
  end

  sub_test_case('#metadata') do
    test('#description') do
      description = @dataset.metadata.description
      assert do
        description.start_with?('# Sudachi 同義語辞書')
      end
    end
  end
end
