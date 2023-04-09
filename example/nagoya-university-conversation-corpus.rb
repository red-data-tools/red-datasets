#!/usr/bin/env ruby

require 'datasets'

nagoya_university_conversation_corpus = Datasets::NagoyaUniversityConversationCorpus.new

nagoya_university_conversation_corpus.each do |data|
  data.sentences.each do |sentence|
    p [
      sentence.participant_id,
      sentence.content
      ]
  end
end
