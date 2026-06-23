class JMRDTest < Test::Unit::TestCase
  sub_test_case("train") do
    def setup
      @dataset = Datasets::JMRD.new(type: :train)
    end

    test("#each") do
      assert_equal({
                     :dialogue_size => 4575,
                     :dialog_id => "01884",
                     :movie_title => "時をかける少女",
                     :first_speaker => "recommender",
                     :recommender_q1 => 5,
                     :seeker_q1 => 4,
                     :knowledge_title => "時をかける少女",
                     :knowledge_year => "２００６年",
                     :director_name => "細田守",
                     :utterance_size => 26,
                     :utterance_id => "01884_00",
                     :utterance_speaker => "recommender",
                     :utterance_text => "こんにちは",
                     :checked_knowledge_size => 1,
                     :checked_knowledge_type => "[知識なし]",
                   },
                   first_dialogue_summary(@dataset.to_a))
    end
  end

  sub_test_case("valid") do
    def setup
      @dataset = Datasets::JMRD.new(type: :valid)
    end

    test("#each") do
      assert_equal({
                     :dialogue_size => 200,
                     :has_dialog_id => true,
                     :has_movie_title => true,
                     :valid_first_speaker => true,
                   },
                   dialogue_summary(@dataset.to_a))
    end
  end

  sub_test_case("test") do
    def setup
      @dataset = Datasets::JMRD.new(type: :test)
    end

    test("#each") do
      assert_equal({
                     :dialogue_size => 300,
                     :has_dialog_id => true,
                     :has_movie_title => true,
                     :valid_first_speaker => true,
                   },
                   dialogue_summary(@dataset.to_a))
    end
  end

  sub_test_case("invalid type") do
    test("raises error") do
      message = ":type must be one of [:train, :valid, :test]: :invalid"
      assert_raise(ArgumentError.new(message)) do
        Datasets::JMRD.new(type: :invalid)
      end
    end
  end

  sub_test_case("#metadata") do
    def setup
      @dataset = Datasets::JMRD.new(type: :train)
    end

    test("#id") do
      assert_equal("jmrd", @dataset.metadata.id)
    end

    test("#name") do
      assert_equal("Japanese Movie Recommendation Dialogue Dataset (JMRD)",
                   @dataset.metadata.name)
    end

    test("#url") do
      assert_equal("https://github.com/ku-nlp/JMRD", @dataset.metadata.url)
    end

    test("#licenses") do
      assert_equal([Datasets::License.new("CC-BY-SA-4.0")],
                   @dataset.metadata.licenses)
    end

    test("#description") do
      description = @dataset.metadata.description
      assert do
        [
          "Japanese Movie Recommendation Dialogue Dataset",
          "5,000 dialogues",
          "knowledge-grounded",
        ].all? do |phrase|
          description.include?(phrase)
        end
      end
    end
  end

  private

  def dialogue_summary(dialogues)
    first_dialogue = dialogues[0]
    {
      :dialogue_size => dialogues.size,
      :has_dialog_id => !first_dialogue.dialog_id.nil?,
      :has_movie_title => !first_dialogue.movie_title.nil?,
      :valid_first_speaker => valid_speaker?(first_dialogue.first_speaker),
    }
  end

  def valid_speaker?(speaker)
    ["recommender", "seeker"].include?(speaker)
  end

  def first_dialogue_summary(dialogues)
    first_dialogue = dialogues[0]
    first_utterance = first_dialogue.utterances[0]
    first_checked_knowledge = first_utterance.checked_knowledge[0]

    {
      :dialogue_size => dialogues.size,
      :dialog_id => first_dialogue.dialog_id,
      :movie_title => first_dialogue.movie_title,
      :first_speaker => first_dialogue.first_speaker,
      :recommender_q1 => first_dialogue.questionnaire.recommender.q1,
      :seeker_q1 => first_dialogue.questionnaire.seeker.q1,
      :knowledge_title => first_dialogue.knowledge.title,
      :knowledge_year => first_dialogue.knowledge.year,
      :director_name => first_dialogue.knowledge.director_name,
      :utterance_size => first_dialogue.utterances.size,
      :utterance_id => first_utterance.utterance_id,
      :utterance_speaker => first_utterance.speaker,
      :utterance_text => first_utterance.text,
      :checked_knowledge_size => first_utterance.checked_knowledge.size,
      :checked_knowledge_type => first_checked_knowledge.type,
    }
  end
end
