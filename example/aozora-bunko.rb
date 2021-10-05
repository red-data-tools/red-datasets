#!/usr/bin/env ruby

require 'datasets'

aozora = Datasets::AozoraBunko.new
record = aozora.first
p [
  record.title_id,
  record.title,
  record.title_reading,
  record.title_reading_collation,
  record.subtitle,
  record.subtitle_reading,
  record.original_title,
  record.first_appearance,
  record.ndc_code,
  record.syllabary_spelling_type,
  record.copyrighted,
  record.published_date,
  record.last_updated_date,
  record.detail_url,
  record.person_id,
  record.person_family_name,
  record.person_first_name,
  record.person_family_name_reading,
  record.person_first_name_reading,
  record.person_family_name_reading_collation,
  record.person_first_name_reading_collation,
  record.person_family_name_romaji,
  record.person_first_name_romaji,
  record.person_type,
  record.person_birthday,
  record.person_date_of_death,
  record.person_copyrighted,
  record.original_book_name1,
  record.original_book_publisher_name1,
  record.original_book_first_published_date1,
  record.used_version_for_registration1,
  record.used_version_for_proofreading1,
  record.base_of_original_book_name1,
  record.base_of_original_book_publisher_name1,
  record.base_of_original_book_first_published_date1,
  record.original_book_name2,
  record.original_book_publisher_name2,
  record.original_book_first_published_date2,
  record.used_version_for_registration2,
  record.used_version_for_proofreading2,
  record.base_of_original_book_name2,
  record.base_of_original_book_publisher_name2,
  record.base_of_original_book_first_published_date2,
  record.registered_person_name,
  record.proofreader_name,
  record.text_file_url,
  record.last_text_file_updated_date,
  record.text_file_character_encoding,
  record.text_file_character_set,
  record.text_file_updating_count,
  record.html_file_url,
  record.last_html_file_updated_date,
  record.html_file_character_encoding,
  record.html_file_character_set,
  record.html_file_updating_count
]

# text API can read from text_file_url field's url
p record.text
#=> "ウェストミンスター寺院\r\nワシントン・アーヴィング..."

# html API can read from html_file_url field's url
p record.html
#=> "<?xml version=\"1.0\" encoding=\"Shift_JIS\"?>\r\n..."

# remove cached text file downloaded from text_file_url
record.clear_text_file!

# remove cached html file downloaded from html_file_url
record.clear_html_file!

# remove all cached files
record.clear_cache!
