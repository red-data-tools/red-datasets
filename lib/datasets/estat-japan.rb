# frozen_string_literal: true

require 'digest/md5'
require 'net/http'
require 'uri'
require 'json'

module Datasets
  Record = Struct.new(:id, :name, :values)

  # Estat module
  module EStatJapan
    # configuration injection
    module Configuration
      attr_accessor :app_id

      #
      # configuration for e-Stat API
      # See detail at https://www.e-stat.go.jp/api/api-dev/how_to_use (Japanese only).
      # @example
      #  Datasets::Estat.configure do |config|
      #   # put your App ID for e-Stat app_id
      #   config.app_id = 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
      #  end
      #
      def configure
        yield self
      end
    end

    extend Configuration

    # wrapper class for e-Stat API service
    class StatsData < Dataset
      attr_accessor :app_id, :areas, :timetables, :schema

      def self.generate_url(base_url,
                            app_id,
                            stats_data_id,
                            area: nil, category: nil, time: nil)
        # generates url for query
        params = {
          appId: app_id, lang: 'J',
          statsDataId: stats_data_id,
          metaGetFlg: 'Y', cntGetFlg: 'N',
          sectionHeaderFlg: '1'
        }
        params['cdArea'] = area.join(',') if area.instance_of?(Array)
        params['cdCat01'] = category.join(',') if category.instance_of?(Array)
        params['cdTime'] = time.join(',') if time.instance_of?(Array)

        URI.parse("#{base_url}?#{URI.encode_www_form(params)}")
      end

      def self.extract_def(data, id)
        rec = data.dig('GET_STATS_DATA',
                       'STATISTICAL_DATA',
                       'CLASS_INF',
                       'CLASS_OBJ')
        rec.select { |x| x['@id'] == id }
      end

      def self.index_def(data_def)
        unless data_def.first['CLASS'].instance_of?(Array)
          # convert to array when number of element is 1
          data_def.first['CLASS'] = [data_def.first['CLASS']]
        end
        Hash[*data_def.first['CLASS'].map { |x| [x['@code'], x] }.flatten]
      end

      def self.get_values(data)
        data['GET_STATS_DATA']['STATISTICAL_DATA']['DATA_INF']['VALUE']
      end

      #
      # generate accessor instance for e-Stat API's endpoint `getStatsData`.
      # for detail spec : https://www.e-stat.go.jp/api/api-info/e-stat-manual
      # @param [String] api_version API Version (defaults to `'2.1'`)
      # @param [String] stats_data_id Statistical data id
      # @param [Array<String>] category Category IDs (fetch all if omitted)
      # @param [Array<String>] area Target areas (fetch all if omitted)
      # @param [Array<String>] time Time axes (fetch all if omitted)
      # @param [Array<Number>] skip_level Skip levels for parsing (defaults to `[1]`)
      # @param [String] hierarchy_selection Select target from 'child', 'parent', or 'both'. (Example: 札幌市○○区 -> 'child':札幌市○○区 only; 'parent':札幌市 only; 'both': Both selected) (defaults to `both`)
      # @param [Boolean] skip_nil_column Skip column if contains nil
      # @param [Boolean] skip_nil_row Skip row if contains nil
      # @example
      #   estat = Datasets::ESTATJAPAN::StatsData.new(
      #     "0000020201", # A Population and household (key name: Ａ　人口・世帯)
      #     category: ["A1101"], # Population (key name: A1101_人口総数)
      #     area: ["01105", "01106"], # Toyohira-ku Sapporo-shi Hokkaido, Minami-ku Sapporo-shi Hokkaido
      #     time: ["1981100000", "1982100000"],
      #     hierarchy_selection: 'child',
      #     skip_child_area: true,
      #     skip_nil_column: true,
      #     skip_nil_row: false,
      #   )
      #
      def initialize(stats_data_id,
                     area: nil, category: nil, time: nil,
                     skip_level: [1],
                     hierarchy_selection: 'child',
                     skip_nil_column: true,
                     skip_nil_row: false,
                     time_range: nil)
        @app_id = fetch_appid
        if @app_id.nil? || @app_id.empty?
          raise ArgumentError, 'Please set app_id via `Datasets::EStatJapan.configure` method or environment var `ESTATJAPAN_APPID`'
        end

        super()

        @api_version = '2.1'
        @base_url = "https://api.e-stat.go.jp/rest/#{@api_version}/app/json/getStatsData"
        @metadata.id = "estat-api-#{@api_version}"
        @metadata.name = "e-Stat API #{@api_version}"
        @metadata.url = @base_url
        @metadata.description = "e-Stat API #{@api_version}"

        @stats_data_id = stats_data_id
        @area = area
        @category = category
        @time = time
        @skip_level = skip_level
        case hierarchy_selection
        when 'child' then
          @skip_child_area = false
          @skip_parent_area = true
        when 'parent' then
          @skip_child_area = true
          @skip_parent_area = false
        else # 'both'
          @skip_child_area = false
          @skip_parent_area = false
        end
        @skip_nil_column = skip_nil_column
        @skip_nil_row = skip_nil_row
        @time_range = time_range

        @url = StatsData.generate_url(@base_url,
                                      @app_id,
                                      @stats_data_id,
                                      area: @area,
                                      category: @category,
                                      time: @time)
        option_hash = Digest::MD5.hexdigest(@url.to_s)
        base_name = "estat-#{option_hash}.json"
        @data_path = cache_dir_path + base_name
      end

      #
      # fetch data records from Remote API
      # @example
      #   indices = []
      #   rows = []
      #   map_id_name = {}
      #   estat.each do |record|
      #     # Select Hokkaido prefecture only
      #     next unless record.id.to_s.start_with? '01'
      #     indices << record.id
      #     rows << record.values
      #     map_id_name[record.id] = record.name
      #   end
      #
      def each
        return to_enum(__method__) unless block_given?

        fetch_data
        index_data

        # create rows
        @areas.each do |a_key, a_value|
          rows = []
          @timetables.reject { |_key, x| x[:skip] }.each do |st_key, _st_value|
            row = []
            @columns.reject { |_key, x| x[:skip] }.each do |c_key, _c_value|
              row << @indexed_data[st_key][a_key][c_key]
            rescue NoMethodError
              row << nil
            end
            rows << row
          end
          next if @skip_nil_row && rows.flatten.count(nil).positive?
          yield Record.new(a_key, a_value['@name'], rows.flatten)
        end
      end

      private

      def fetch_appid
        defined?(EStatJapan.app_id) && !EStatJapan.app_id.nil? ? EStatJapan.app_id : ENV.fetch('ESTATJAPAN_APPID', nil)
      end

      def fetch_data
        download(@data_path, @url.to_s) unless @data_path.exist?
        # TODO: check error
      end

      def index_data
        # parse json
        json_data = File.open(@data_path) do |io|
          JSON.parse(io.read)
        end

        # check status
        api_status = json_data['GET_STATS_DATA']['RESULT']['STATUS']
        if api_status != 0
          error_msg = json_data['GET_STATS_DATA']['RESULT']['ERROR_MSG']
          raise Exception, "code #{api_status} : #{error_msg}"
        end

        # index data
        ## table_def = StatsData.extract_def(json_data, "tab")
        timetable_def = StatsData.extract_def(json_data, 'time')
        column_def = StatsData.extract_def(json_data, 'cat01')
        area_def = StatsData.extract_def(json_data, 'area')

        ## p table_def.map { |x| x["@name"] }
        @timetables = StatsData.index_def(timetable_def)
        @columns = StatsData.index_def(column_def)
        @areas = StatsData.index_def(area_def)

        ## apply time_range to timetables
        if @time_range.instance_of?(Range)
          @timetables.select! { |k, _v| @timetables.keys[@time_range].include? k }
        end

        @indexed_data = Hash[*@timetables.keys.map { |x| [x, {}] }.flatten]
        StatsData.get_values(json_data).each do |row|
          next unless @timetables.key?(row['@time'])

          oldhash = @indexed_data[row['@time']][row['@area']]
          oldhash = {} if oldhash.nil?
          newhash = oldhash.merge(row['@cat01'] => row['$'].to_f)
          @indexed_data[row['@time']][row['@area']] = newhash
        end

        skip_areas
        skip_nil_column
        @schema = create_header
      end

      def skip_areas
        # skip levels
        @areas.reject! { |_key, x| @skip_level.include? x['@level'].to_i }

        # skip area that has children
        if @skip_parent_area
          # inspect hieralchy of areas
          @areas.each do |_a_key, a_value|
            next unless @areas.key? a_value['@parentCode']

            @areas[a_value['@parentCode']][:has_children] = true
          end
          # filter areas without children
          @areas.reject! { |_key, x| x[:has_children] }
        end

        # skip child area
        if @skip_child_area
          @areas.reject! { |_a_key, a_value| (@areas.key? a_value['@parentCode']) }
        end
      end

      def skip_nil_column
        # filter timetables and columns
        if @skip_nil_column
          @areas.each do |a_key, _a_value|
            @timetables.each do |st_key, st_value|
              unless @indexed_data[st_key].key?(a_key)
                st_value[:skip] = true
                next
              end
              @columns.each do |c_key, c_value|
                unless @indexed_data[st_key][a_key].key?(c_key)
                  c_value[:skip] = true
                  next
                end
              end
            end
          end
        end
      end

      def create_header
        schema = []
        @timetables.reject { |_key, x| x[:skip] }.each do |_st_key, st_value|
          @columns.reject { |_key, x| x[:skip] }.each do |_c_key, c_value|
            schema << "#{st_value['@name']}_#{c_value['@name']}"
          end
        end
        schema
      end
    end
  end
end
