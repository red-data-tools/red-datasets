class QuoraDuplicateQuestionPairTest < Test::Unit::TestCase
  def setup
    @dataset = Datasets::QuoraDuplicateQuestionPair.new
  end

  def record(*args)
    Datasets::QuoraDuplicateQuestionPair::Record.new(*args)
  end

  test("#each") do
    records = @dataset.each.to_a
    assert_equal([
                   404290,
                   record(0,
                          1,
                          2,
                          "What is the step by step guide to invest in share market in india?",
                          "What is the step by step guide to invest in share market?",
                          false),
                   record(404289,
                          537932,
                          537933,
                          "What is like to have sex with cousin?",
                          "What is it like to have sex with your cousin?",
                          false),
                 ],
                 [
                   records.size,
                   records.first,
                   records.last,
                 ])
  end
end
