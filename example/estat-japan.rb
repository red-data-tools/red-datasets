#!/usr/bin/env ruby -Ku

require 'datasets'

Datasets::EStatJapan.configure do |config|
  # put your App ID for e-Stat app_id
  # see detail at https://www.e-stat.go.jp/api/api-dev/how_to_use (Japanese only)
  config.app_id = 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
end

estat = Datasets::EStatJapan::StatsData.new(
  '0000020201', # Ａ　人口・世帯
  hierarchy_selection: 'child',
  skip_nil_column: true,
  skip_nil_row: false,
  category: ['A1101'] # A1101_人口総数
)

# prepare for clustering
indices = []
rows = []
map_id_name = {}
estat.each do |record|
  # 北海道に限定する
  next unless record.id.to_s.start_with? '01' # '01' == '北海道'
  indices << record.id
  rows << record.values
  map_id_name[record.id] = record.name
  p record.name, rows
end
