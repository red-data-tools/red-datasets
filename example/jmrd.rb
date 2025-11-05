#!/usr/bin/env ruby

require 'datasets'

jmrd = Datasets::JMRD.new(type: :train)

jmrd.each do |dialogue|
  puts "=" * 80
  puts "Dialogue ID: #{dialogue.dialog_id}"
  puts "Movie: #{dialogue.movie_title}"
  puts "First Speaker: #{dialogue.first_speaker}"
  puts

  if dialogue.knowledge
    puts "Knowledge:"
    puts "  Title: #{dialogue.knowledge.title}"
    puts "  Year: #{dialogue.knowledge.year}"
    puts "  Director: #{dialogue.knowledge.director_name}"
    puts "  Genres: #{dialogue.knowledge.genres.join(', ')}" if dialogue.knowledge.genres
    puts
  end

  puts "Dialogue:"
  dialogue.utterances.each do |utterance|
    speaker_label = utterance.speaker == "recommender" ? "[R]" : "[S]"
    puts "  #{speaker_label} #{utterance.text}"

    if utterance.checked_knowledge && !utterance.checked_knowledge.empty?
      knowledge_types = utterance.checked_knowledge.map { |ck| ck.type }.join(", ")
      puts "      (knowledge: #{knowledge_types})"
    end
  end

  # Show only first dialogue as example
  break
end
