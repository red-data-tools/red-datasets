#!/usr/bin/ruby

require 'datasets'

#WIP
billingualCorpus = Datasets::JapaneseEnglishBilingualCorpus.new

emptyArticle = Datasets::JapaneseEnglishBilingualCorpus::Article.new
#emptyTitle = Datasets::JapaneseEnglishBilingualCorpus::Title.new
#emptySection = Datasets::JapaneseEnglishBilingualCorpus::Section.new
#emptyPage = Datasets::JapaneseEnglishBilingualCorpus::Page.new
#emptySentence = Datasets::JapaneseEnglishBilingualCorpus::Sentence.new

#articles = billingualCorpus.select{|x| x.is_a?(emptyArticle.class)}
#titles = billingualCorpus.select{|x| x.is_a?(emptyTitle.class)}
#sections = billingualCorpus.select{|x| x.is_a?(emptySection.class)}
#pages = billingualCorpus.select{|x| x.is_a?(emptyPage.class)}
sentences = billingualCorpus.select{|x| x.is_a?(emptySentence.class)}

count = 0
sentences.each do |record|
    count += 1
    #if count > 100 then
    #  break
    #end
    p [
      record.class,
      record
    ]
end
p count
p billingualCorpus.metadata.name