class JMRDTest < Test::Unit::TestCase
  sub_test_case("type") do
    test("train") do
      dataset = Datasets::JMRD.new(type: :train)
      dialogues = dataset.to_a

      assert_equal(4575, dialogues.size)

      first_dialogue = dialogues[0]
      assert_equal("01884", first_dialogue.dialog_id)
      assert_equal("時をかける少女", first_dialogue.movie_title)
      assert_equal("recommender", first_dialogue.first_speaker)

      # Check questionnaire
      assert_not_nil(first_dialogue.questionnaire)
      assert_equal(5, first_dialogue.questionnaire.recommender.q1)
      assert_equal(4, first_dialogue.questionnaire.seeker.q1)

      # Check knowledge
      assert_not_nil(first_dialogue.knowledge)
      assert_equal("時をかける少女", first_dialogue.knowledge.title)
      assert_equal("２００６年", first_dialogue.knowledge.year)
      assert_equal("細田守", first_dialogue.knowledge.director_name)

      # Check utterances
      assert_equal(26, first_dialogue.utterances.size)
      assert_equal("01884_00", first_dialogue.utterances[0].utterance_id)
      assert_equal("recommender", first_dialogue.utterances[0].speaker)
      assert_equal("こんにちは", first_dialogue.utterances[0].text)
      assert_not_nil(first_dialogue.utterances[0].checked_knowledge)
      assert_equal(1, first_dialogue.utterances[0].checked_knowledge.size)
      assert_equal("[知識なし]", first_dialogue.utterances[0].checked_knowledge[0].type)
    end

    test("valid") do
      dataset = Datasets::JMRD.new(type: :valid)
      dialogues = dataset.to_a

      assert_equal(200, dialogues.size)

      first_dialogue = dialogues[0]
      assert_not_nil(first_dialogue.dialog_id)
      assert_not_nil(first_dialogue.movie_title)
      assert(["recommender", "seeker"].include?(first_dialogue.first_speaker))
    end

    test("test") do
      dataset = Datasets::JMRD.new(type: :test)
      dialogues = dataset.to_a

      assert_equal(300, dialogues.size)

      first_dialogue = dialogues[0]
      assert_not_nil(first_dialogue.dialog_id)
      assert_not_nil(first_dialogue.movie_title)
      assert(["recommender", "seeker"].include?(first_dialogue.first_speaker))
    end

    test("invalid") do
      message = "Type must be :train, :valid, or :test: :invalid"
      assert_raise(ArgumentError.new(message)) do
        Datasets::JMRD.new(type: :invalid)
      end
    end
  end

  sub_test_case("#metadata") do
    test("#id") do
      dataset = Datasets::JMRD.new(type: :train)
      assert_equal("jmrd", dataset.metadata.id)
    end

    test("#name") do
      dataset = Datasets::JMRD.new(type: :train)
      assert_equal("Japanese Movie Recommendation Dialogue Dataset (JMRD)",
                   dataset.metadata.name)
    end

    test("#url") do
      dataset = Datasets::JMRD.new(type: :train)
      assert_equal("https://github.com/ku-nlp/JMRD", dataset.metadata.url)
    end

    test("#licenses") do
      dataset = Datasets::JMRD.new(type: :train)
      assert_equal([Datasets::License.new("CC-BY-SA-4.0")],
                   dataset.metadata.licenses)
    end

    test("#description") do
      dataset = Datasets::JMRD.new(type: :train)
      description = dataset.metadata.description
      assert do
        description.include?("Japanese Movie Recommendation Dialogue Dataset")
      end
      assert do
        description.include?("5,000 dialogues")
      end
      assert do
        description.include?("knowledge-grounded")
      end
    end
  end
end
