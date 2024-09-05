class NagoyaUniversityConversationCorpusTest < Test::Unit::TestCase
  def setup
    @dataset = Datasets::NagoyaUniversityConversationCorpus.new
  end

  sub_test_case("each") do
    test("#sentences") do
      first_sentences = @dataset.each.next.sentences
      assert_equal([
                     {
                       participant_id: 'F107',
                       content: '＊＊＊の町というのはちいちゃくって、城壁がこう町全体をぐるっと回ってて、それが城壁の上を歩いても１時間ぐらいですよね。',
                     },
                     {
                       participant_id: nil,
                       content: nil,
                     },
                   ],
                   [
                     first_sentences[0].to_h,
                     first_sentences[-1].to_h,
                   ])
    end

    test("#participants") do
      first_participants = @dataset.each.next.participants
      assert_equal([
                     {
                       id: 'F107',
                       attribute: '女性３０代後半',
                       birthplace: '愛知県幡豆郡出身',
                       residence: '愛知県幡豆郡在住',
                     },
                     {
                       id: 'F128',
                       attribute: '女性２０代前半',
                       birthplace: '愛知県西尾市出身',
                       residence: '西尾市在住',
                     },
                   ],
                   [
                     first_participants[0].to_h,
                     first_participants[-1].to_h,
                   ])
    end

    test("others") do
      first_record = @dataset.each.next
      assert_equal([
                     '１（約３５分）',
                     '２００１年１０月１６日',
                     'ファミリーレストラン',
                     '英会話教室の友人',
                     nil,
                   ],
                   [
                     first_record.name,
                     first_record.date,
                     first_record.place,
                     first_record.relationships,
                     first_record.note,
                   ])
    end
  end

  sub_test_case("#metadata") do
    test("#description") do
      description = @dataset.metadata.description
      assert_equal(<<~DESCRIPTION, description)
        The "Nagoya University Conversation Corpus" is a corpus of 129 conversations,
        total about 100 hours of chatting among native speakers of Japanese,
        which is converted into text.
      DESCRIPTION
    end
  end
end
