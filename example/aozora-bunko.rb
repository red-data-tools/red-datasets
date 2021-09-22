#!/usr/bin/env ruby

require 'datasets'

aozora = Datasets::AozoraBunko.new
record = aozora.first
p [
  record.novelist,
  record.title
]
#=> ["アーヴィング ワシントン", "ウェストミンスター寺院"]

aozora = Datasets::AozoraBunko.new(type: :extended)
record = aozora.first
p [
  record.novelist_family_name,
  record.novelist_first_name,
  record.title,
  record.ndc_code,
  record.syllabary_spelling_type,
  record.detail_url
]
#=> ["アーヴィング", "ワシントン", "ウェストミンスター寺院", "NDC 933", "新字新仮名", "https://www.aozora.gr.jp/cards/001257/card59898.html"]
