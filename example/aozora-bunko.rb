#!/usr/bin/env ruby

require 'datasets'

aozora = Datasets::AozoraBunko.new
record = aozora.first
p [
  record.person_family_name,
  record.person_first_name,
  record.title,
  record.ndc_code,
  record.syllabary_spelling_type,
  record.detail_url
]
#=> ["アーヴィング", "ワシントン", "ウェストミンスター寺院", "NDC 933", "新字新仮名", "https://www.aozora.gr.jp/cards/001257/card59898.html"]


# text API can read from text_file_url field's url
p record.text
#=> "ウェストミンスター寺院\r\nワシントン・アーヴィング..."
