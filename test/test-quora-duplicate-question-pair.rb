class QuoraDuplicateQuestionPairTest < Test::Unit::TestCase
  def setup
    @dataset = Datasets::QuoraDuplicateQuestionPair.new
  end

  def record(*args)
    Datasets::QuoraDuplicateQuestionPair::Record.new(*args)
  end

  test("#each") do
    records = @dataset
    assert_equal(record(0,
                        1,
                        2,
                        "What is the step by step guide to invest in share market in india?",
                        "What is the step by step guide to invest in share market?",
                        false),
                 records.first)
  end
end
