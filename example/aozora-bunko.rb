#!/usr/bin/env ruby

require 'datasets'

aozora = Datasets::AozoraBunko.new
record = aozora.first
p [
  record.title_id,
  record.title,
  record.title_reading,
  record.title_reading_collation,
  record.sub_title,
  record.sub_title_reading,
  record.original_title,
  record.first_appearance,
  record.ndc_code,
  record.syllabary_spelling_type,
  record.copyright_for_title,
  record.published_date,
  record.latest_updated_date,
  record.detail_url,
  record.person_id,
  record.person_family_name,
  record.person_first_name,
  record.person_family_name_reading,
  record.person_first_name_reading,
  record.person_family_name_collation,
  record.person_first_name_collation,
  record.person_family_name_roman,
  record.person_first_name_roman,
  record.person_type,
  record.person_birthday,
  record.person_death_day,
  record.copyright_for_person,
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
  record.latest_text_file_updated_date,
  record.text_file_character_encoding,
  record.text_character_set,
  record.text_file_updating_count,
  record.html_file_url,
  record.latest_html_file_updated_date,
  record.html_file_character_encoding,
  record.html_character_set,
  record.html_file_updating_count
]

# text API can read from text_file_url field's url
p record.text
#=> "ウェストミンスター寺院\r\nワシントン・アーヴィング..."
