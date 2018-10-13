class DictionaryTest < Test::Unit::TestCase
  def setup
    penn_treebank = Datasets::PennTreebank.new(type: :test)
    @dictionary = penn_treebank.to_table.dictionary_encode(:word)
  end

  test("#id") do
    assert_equal(95, @dictionary.id("<unk>"))
  end

  test("#value") do
    assert_equal("<unk>", @dictionary.value(95))
  end

  test("#ids") do
    assert_equal([0, 1, 2, 3, 4], @dictionary.ids.first(5))
  end

  test("#values") do
    assert_equal(["no", "it", "was", "n't", "black"],
                 @dictionary.values.first(5))
  end

  test("#each") do
    assert_equal([
                   [0, "no"],
                   [1, "it"],
                   [2, "was"],
                   [3, "n't"],
                   [4, "black"],
                 ],
                 @dictionary.each.first(5).to_a)
  end

  test("#size") do
    assert_equal(6048, @dictionary.size)
  end

  test("#length") do
    assert_equal(@dictionary.size,
                 @dictionary.length)
  end
end
