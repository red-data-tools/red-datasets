class AfinnTest < Test::Unit::TestCase
  def setup
    @dataset = Datasets::Afinn.new
  end

  test('#each') do
    records = @dataset.each.to_a
    assert_equal([
                   2477,
                   {
                     :valence => "-2",
                     :word => "abandon"
                   },
                   {
                     :valence => "2",
                     :word => "zealous"
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
        description.start_with?('A sentiment labelled list of 2477 English words and phrases')
      end
    end
  end
end
