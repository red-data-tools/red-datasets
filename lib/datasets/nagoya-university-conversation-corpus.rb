require_relative 'dataset'
require_relative 'zip-extractor'

module Datasets
  class NagoyaUniversityConversationCorpus < Dataset
    Data = Struct.new(
      :name,
      :date,
      :place,
      :participants,
      :relationships,
      :note,
      :sentences
    )

    Participant = Struct.new(
      :id,
      :attribute,
      :birthplace,
      :residence
    )

    Sentence = Struct.new(
      :participant_id,
      :content
    )

    def initialize
      super()
      @metadata.id = 'nagoya-university-conversation-curpus'
      @metadata.name = 'Nagoya University Conversation Curpus'
      @metadata.url = 'https://mmsrv.ninjal.ac.jp/nucc/'
      @metadata.licenses = ['CC-BY-NC-ND-4.0']
      @metadata.description = <<~DESCRIPTION
        The "Nagoya University Conversation Corpus" is a corpus of 129 conversations,
        total about 100 hours of chatting among native speakers of Japanese,
        which is converted into text.
      DESCRIPTION
    end

    def each
      return to_enum(__method__) unless block_given?

      open_data do |text_file|
        yield(parse_file(text_file))
      end
    end

    private

    def open_data
      data_path = cache_dir_path + 'nucc.zip'
      data_url = 'https://mmsrv.ninjal.ac.jp/nucc/nucc.zip'
      download(data_path, data_url)
      zip_file = Zip::File.open(data_path)
      zip_file.each do |entry|
        yield(entry) if entry.file?
      end
    end

    def parse_file(text_file)
      data = Data.new
      participants = []
      sentences = []

      text_file.get_input_stream.each do |input|
        input.each_line(chomp: true) do |line|
          line = line.force_encoding('utf-8')
          if line.include?('＠データ')
            data.name = line[1..]
          elsif line.include?('＠収集年月日')
            # mixed cases with and without'：'
            data.date = line[6..].delete('：')
          elsif line.include?('＠場所')
            data.place = line[4..]
          elsif line.include?('＠参加者') && !line.include?('参加者の関係')
            participant = Participant.new
            temp_id, temp_profiles = line.split('：')
            participant.id = temp_id[4..]
            participant.attribute, participant.birthplace, participant.residence = temp_profiles.split('、')

            participants << participant
          elsif line.include?('＠参加者の関係')
            data.relationships = line.split('：')[1]
          elsif line.include?('％ｃｏｍ')
            data.note = line.split('：')[1]
          elsif line.include?('＠ＥＮＤ')
            sentence = Sentence.new
            sentence.participant_id = nil
            sentence.content = '＠ＥＮＤ'

            sentences << sentence
          else
            sentence = Sentence.new
            sentence.participant_id, sentence.content = line.split('：')

            sentences << sentence
          end
        end
      end

      data.participants = participants
      data.sentences = sentences

      data
    end
  end
end
