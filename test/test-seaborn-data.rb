class SeabornDataTest < Test::Unit::TestCase
  sub_test_case("fmri") do
    def setup
      @dataset = Datasets::SeabornData.new("fmri")
    end

    def test_each
      records = @dataset.each.to_a
      assert_equal([
                     1064,
                     {
                       subject: "s5",
                       timepoint: 14,
                       event: "stim",
                       region: "parietal",
                       signal: -0.0808829319505
                     },
                     {
                       subject: "s0",
                       timepoint: 0,
                       event: "cue",
                       region: "parietal",
                       signal: -0.00689923478092
                     }
                   ],
                   [
                     records.size,
                     records[1].to_h,
                     records[-1].to_h
                   ])
    end
  end
end
