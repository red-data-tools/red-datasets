class AFINNTest < Test::Unit::TestCase
  def setup
    @dataset = Datasets::AFINN.new
  end

  test('#each') do
    records = @dataset.each.to_a
    assert_equal([
                   2477,
                   {
                     :valence => -2,
                     :word => "abandon"
                   },
                   {
                     :valence => 2,
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
      assert_equal(<<-DESCRIPTION.chomp, description)
AFINN is a list of English words rated for valence with an integer
between minus five (negative) and plus five (positive). The words have
been manually labeled by Finn Årup Nielsen in 2009-2011. The file
is tab-separated. There are two versions:

AFINN-111: Newest version with 2477 words and phrases.

An evaluation of the word list is available in:

Finn Årup Nielsen, "A new ANEW: Evaluation of a word list for
sentiment analysis in microblogs", http://arxiv.org/abs/1103.2903

The list was used in: 

Lars Kai Hansen, Adam Arvidsson, Finn Årup Nielsen, Elanor Colleoni,
Michael Etter, "Good Friends, Bad News - Affect and Virality in
Twitter", The 2011 International Workshop on Social Computing,
Network, and Services (SocialComNet 2011).


This database of words is copyright protected and distributed under
"Open Database License (ODbL) v1.0"
http://www.opendatacommons.org/licenses/odbl/1.0/ or a similar
copyleft license.

See comments on the word list here:
http://fnielsen.posterous.com/old-anew-a-sentiment-about-sentiment-analysis
      DESCRIPTION
    end
  end
end
