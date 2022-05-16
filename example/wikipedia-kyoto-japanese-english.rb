#!/usr/bin/env ruby

require "datasets"

wikipedia_kyoto_articles =
  Datasets::WikipediaKyotoJapaneseEnglish.new(type: :article)
wikipedia_kyoto_articles.each_with_index do |article, i|
  puts("#{i}: #{article.source}")
  article.contents.each do |content|
    puts("  Japanese: #{content.japanese}")
    puts("  English:  #{content.english}")
  end
end

wikipedia_kyoto_lexicon =
 Datasets::WikipediaKyotoJapaneseEnglish.new(type: :lexicon)
wikipedia_kyoto_lexicon.each do |record|
 puts("  Japanese: #{record.japanese}")
 puts("  English:  #{record.english}")
end
