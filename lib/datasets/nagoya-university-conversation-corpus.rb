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

      open_data do |input_stream|
        yield(parse_file(input_stream))
      end
    end

    private

    def open_data
      data_path = cache_dir_path + 'nucc.zip'
      data_url = 'https://mmsrv.ninjal.ac.jp/nucc/nucc.zip'
      download(data_path, data_url)

      zip_file = Zip::File.open(data_path)
      zip_file.each do |entry|
        next unless entry.file?
        ZipExtractor.new(data_path).extract_file(entry.name) do |input_stream|
          yield(input_stream)
        end
      end
    end

    def parse_file(input_stream)
      data = Data.new
      participants = []
      sentences = []

      input_stream.each do |input|
        input.each_line(chomp: true) do |line|
          line.force_encoding('utf-8')
          if line.start_with?('＠データ')
            data.name = line[1..]
          elsif line.start_with?('＠収集年月日')
            # mixed cases with and without'：'
            data.date = line[6..].delete('：')
          elsif line.start_with?('＠場所')
            data.place = line[4..]
          elsif line.start_with?('＠参加者の関係')
            data.relationships = line.split('：', 2)[1]
          elsif line.start_with?('＠参加者')
            participant = Participant.new
            temp_id, temp_profiles = line.split('：', 2)
            participant.id = temp_id[4..]
            participant.attribute, participant.birthplace, participant.residence = temp_profiles.split('、')

            participants << participant
          elsif line.start_with?('％ｃｏｍ')
            data.note = line.split('：', 2)[1]
          elsif line.start_with?('＠ＥＮＤ')
            sentence = Sentence.new
            sentence.participant_id = nil
            sentence.content = '＠ＥＮＤ'

            sentences << sentence
          else
            sentence = Sentence.new
            sentence.participant_id, sentence.content = line.split('：', 2)

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
