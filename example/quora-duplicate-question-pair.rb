#!/usr/bin/env ruby

require "datasets"

question_pair = Datasets::QuoraDuplicateQuestionPair.new
question_pair.each do |pair|
  p [
    pair.id,
    pair.first_question_id,
    pair.second_question_id,
    pair.first_question,
    pair.second_question,
    pair.duplicated?
  ]
  # [0, 1, 2, "What is the step by step guide to invest in share market in india?", "What is the step by step guide to invest in share market?", false]
  # [1, 3, 4, "What is the story of Kohinoor (Koh-i-Noor) Diamond?", "What would happen if the Indian government stole the Kohinoor (Koh-i-Noor) diamond back?", false]
end
