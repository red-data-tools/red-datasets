#!/usr/bin/env ruby

require "datasets"

categories = [
  :buddhism,
  :bulding,
  :culture,
  :emperor,
  :family,
  :geographical_name,
  :history,
  :literature,
  :person_name,
  :railway,
  :road,
  :shrine_and_temple,
  :school,
  :shinto,
  :title,
]

categories.each do |category|
  wikipedia_kyoto =
    Datasets::WikipediaKyotoJapaneseEnglish.new(category: category)

  wikipedia_kyoto.each_with_index do |article, i|
    puts("=" * 40)
    puts("#{category}: #{i}: #{article.source}")
    article.contents.each do |content|
      puts("  Japanese: #{content.japanese}")
      puts("  English:  #{content.english}")
    end
    puts("=" * 40)
  end
end
