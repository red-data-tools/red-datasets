#!/usr/bin/env ruby

require 'datasets'

aozora = Datasets::AozoraBunko.new
book = aozora.first
p [
  book.title_id,
  book.title,
  book.title_reading,
  book.title_reading_collation,
  book.subtitle,
  book.subtitle_reading,
  book.original_title,
  book.first_appearance,
  book.ndc_code,
  book.syllabary_spelling_type,
  book.copyrighted?,
  book.published_date,
  book.last_updated_date,
  book.detail_url,
  book.person_id,
  book.person_family_name,
  book.person_first_name,
  book.person_family_name_reading,
  book.person_first_name_reading,
  book.person_family_name_reading_collation,
  book.person_first_name_reading_collation,
  book.person_family_name_romaji,
  book.person_first_name_romaji,
  book.person_type,
  book.person_birthday,
  book.person_date_of_death,
  book.person_copyrighted?,
  book.original_book_name1,
  book.original_book_publisher_name1,
  book.original_book_first_published_date1,
  book.used_version_for_registration1,
  book.used_version_for_proofreading1,
  book.base_of_original_book_name1,
  book.base_of_original_book_publisher_name1,
  book.base_of_original_book_first_published_date1,
  book.original_book_name2,
  book.original_book_publisher_name2,
  book.original_book_first_published_date2,
  book.used_version_for_registration2,
  book.used_version_for_proofreading2,
  book.base_of_original_book_name2,
  book.base_of_original_book_publisher_name2,
  book.base_of_original_book_first_published_date2,
  book.registered_person_name,
  book.proofreader_name,
  book.text_file_url,
  book.last_text_file_updated_date,
  book.text_file_character_encoding,
  book.text_file_character_set,
  book.text_file_updating_count,
  book.html_file_url,
  book.last_html_file_updated_date,
  book.html_file_character_encoding,
  book.html_file_character_set,
  book.html_file_updating_count
]

# text API can read from text_file_url field's url
p book.text
#=> "ウェストミンスター寺院\r\nワシントン・アーヴィング..."

# html API can read from html_file_url field's url
p book.html
#=> "<?xml version=\"1.0\" encoding=\"Shift_JIS\"?>\r\n..."

# remove all cached files
# aozora.clear_cache!
