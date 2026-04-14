require "json"

require_relative "dataset"

module Datasets
  class JMRD < Dataset
    Dialogue = Struct.new(
      :dialog_id,
      :movie_title,
      :first_speaker,
      :questionnaire,
      :knowledge,
      :utterances
    )

    Questionnaire = Struct.new(
      :recommender,
      :seeker
    )

    QuestionnaireAnswers = Struct.new(
      :q1,
      :q2,
      :q3,
      :q4,
      :q5
    )

    Knowledge = Struct.new(
      :title,
      :year,
      :director_name,
      :director_description,
      :cast_names,
      :cast_descriptions,
      :genres,
      :reviews,
      :synopsis
    )

    Utterance = Struct.new(
      :utterance_id,
      :speaker,
      :text,
      :checked_knowledge
    )

    CheckedKnowledge = Struct.new(
      :type,
      :content
    )

    def initialize(type: :train)
      super()
      @metadata.id = "jmrd"
      @metadata.name = "Japanese Movie Recommendation Dialogue Dataset (JMRD)"
      @metadata.url = "https://github.com/ku-nlp/JMRD"
      @metadata.licenses = ["CC-BY-SA-4.0"]
      @metadata.description = <<~DESCRIPTION
        JMRD (Japanese Movie Recommendation Dialogue Dataset) is a Japanese
        knowledge-grounded dialogue dataset consisting of annotated movie
        recommendation dialogues between humans. Every recommender's utterance
        is associated with movie information as external knowledge.

        The dataset consists of about 5,000 dialogues between crowdworkers,
        each of which consists of 23 utterances on average. All dialogues in
        this dataset are divided into the train (4,575 dialogues), valid
        (200 dialogues), and test sets (300 dialogues).

        Published in the 2nd DialDoc Workshop on Document-grounded Dialogue
        and Conversational Question Answering, 2022.

        Reference:
        Takashi Kodama, Ribeka Tanaka, and Sadao Kurohashi.
        "Construction of Hierarchical Structured Knowledge-based Recommendation
        Dialogue Dataset and Dialogue System."
      DESCRIPTION

      unless [:train, :valid, :test].include?(type)
        raise ArgumentError, ":type must be one of [:train, :valid, :test]: #{type.inspect}"
      end
      @type = type
    end

    def each
      return to_enum(__method__) unless block_given?

      open_data do |json_data|
        json_data.each do |dialogue_data|
          yield parse_dialogue(dialogue_data)
        end
      end
    end

    private

    def open_data
      data_path = cache_dir_path + "#{@type}.json"
      data_url = "https://raw.githubusercontent.com/ku-nlp/JMRD/main/data/#{@type}.json"
      download(data_path, data_url)

      json_data = JSON.parse(File.read(data_path))
      yield json_data
    end

    def parse_dialogue(data)
      Dialogue.new(
        data["dialog_id"],
        data["movie_title"],
        data["first_speaker"],
        parse_questionnaire(data["questionnaire"]),
        parse_knowledge(data["knowledge"]),
        parse_utterances(data["dialog"])
      )
    end

    def parse_questionnaire(data)
      return nil if data.nil?

      Questionnaire.new(
        parse_questionnaire_answers(data["recommender"]),
        parse_questionnaire_answers(data["seeker"])
      )
    end

    def parse_questionnaire_answers(data)
      return nil if data.nil?

      QuestionnaireAnswers.new(
        data["Q1"],
        data["Q2"],
        data["Q3"],
        data["Q4"],
        data["Q5"]
      )
    end

    def parse_knowledge(data)
      return nil if data.nil?

      Knowledge.new(
        data["タイトル"],
        data["製作年度"],
        data["監督名"],
        data["監督説明"],
        data["キャスト名"],
        data["キャスト説明"],
        data["ジャンル"],
        data["レビュー"],
        data["あらすじ"]
      )
    end

    def parse_utterances(data)
      return [] if data.nil?

      data.map do |utterance_data|
        parse_utterance(utterance_data)
      end
    end

    def parse_utterance(data)
      checked_knowledge = nil
      if data["checked_knowledge"]
        checked_knowledge = data["checked_knowledge"].map do |ck|
          CheckedKnowledge.new(ck["type"], ck["content"])
        end
      end

      Utterance.new(
        data["utterance_id"],
        data["speaker"],
        data["text"],
        checked_knowledge
      )
    end
  end
end
