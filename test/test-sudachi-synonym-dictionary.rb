class SudachiSynonymDictionaryTest < Test::Unit::TestCase
  def setup
    @dataset = Datasets::SudachiSynonymDictionary.new
  end

  test('#each') do
    assert_equal({
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
                 @dataset.each.next.to_h)
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
