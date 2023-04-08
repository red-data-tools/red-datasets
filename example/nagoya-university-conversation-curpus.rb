#!/usr/bin/env ruby

require 'datasets'

nagoya_university_conversation_curpus = Datasets::NagoyaUniversityConversationCurpus.new

nagoya_university_conversation_curpus.each do |data|
  data.sentences.each do |sentence|
    p [
      sentence.sentence_order_number,
      sentence.participant_id,
      sentence.content
      ]
  end
end
