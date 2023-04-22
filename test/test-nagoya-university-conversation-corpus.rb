class NagoyaUniversityConversationCorpusTest < Test::Unit::TestCase
  def setup
    @dataset = Datasets::NagoyaUniversityConversationCorpus.new
  end

  sub_test_case("each") do
    test("#sentences") do
      records = @dataset.each.to_a
      first_sentences = records[0].sentences
      last_sentences = records[-1].sentences
      assert_equal([
                     856,
                     {
                       participant_id: 'F107',
                       content: '＊＊＊の町というのはちいちゃくって、城壁がこう町全体をぐるっと回ってて、それが城壁の上を歩いても１時間ぐらいですよね。'
                     },
                     {
                       participant_id: nil,
                       content: nil
                     },
                     603,
                     {
                       participant_id: 'F007',
                       content: 'それでは話を始めまーす。'
                     },
                     {
                       participant_id: nil,
                       content: nil
                     }
                   ],
                   [
                     first_sentences.size,
                     first_sentences[0].to_h,
                     first_sentences[-1].to_h,
                     last_sentences.size,
                     last_sentences[0].to_h,
                     last_sentences[-1].to_h,
                   ])
    end

    test("#participants") do
      records = @dataset.each.to_a
      first_participants = records[0].participants
      last_participants = records[-1].participants
      assert_equal([
                     4,
                     {
                       id: 'F107',
                       attribute: '女性３０代後半',
                       birthplace: '愛知県幡豆郡出身',
                       residence: '愛知県幡豆郡在住'
                     },
                     {
                       id: 'F128',
                       attribute: '女性２０代前半',
                       birthplace: '愛知県西尾市出身',
                       residence: '西尾市在住'
                     },
                     2,
                     {
                       id: 'F007',
                       attribute: '女性５０代後半',
                       birthplace: '東京都出身',
                       residence: '東京都国分寺市在住'
                     },
                     {
                       id: 'F003',
                       attribute: '女性８０代後半',
                       birthplace: '栃木県宇都宮市出身',
                       residence: '国分寺市在住'
                     }
                   ],
                   [
                     first_participants.size,
                     first_participants[0].to_h,
                     first_participants[-1].to_h,
                     last_participants.size,
                     last_participants[0].to_h,
                     last_participants[-1].to_h
                   ])
    end

    test("others") do
      records = @dataset.each.to_a
      assert_equal([
                     129,
                     [
                       'データ１（約３５分）',
                       '２００１年１０月１６日',
                       'ファミリーレストラン',
                       '英会話教室の友人',
                       nil
                     ],
                     [
                       'データ１２９（３６分）',
                       '２００３年２月１６日',
                       '二人の自宅',
                       '母と娘',
                       'F007は東京に３８年、F003は東京に６０年居住。'
                    ]
                   ],
                   [
                     records.size,
                     [
                       records[0].name,
                       records[0].date,
                       records[0].place,
                       records[0].relationships,
                       records[0].note
                     ],
                     [
                       records[-1].name,
                       records[-1].date,
                       records[-1].place,
                       records[-1].relationships,
                       records[-1].note
                     ]
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
