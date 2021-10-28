# frozen_string_literal: true
require 'digest/md5'
require 'net/http'
require 'uri'
require 'json'

module Datasets
  module EStatJapan
    Record = Struct.new(:id, :name, :values)
    # configuration injection
    module Configurable
      attr_accessor :app_id

      #
      # configuration for e-Stat API
      # See detail at https://www.e-stat.go.jp/api/api-dev/how_to_use (Japanese only).
      # @example
      #  Datasets::EStatJapan.configure do |config|
      #   # put your App ID for e-Stat app_id
      #   config.app_id = 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
      #  end
      #
      def configure
        yield self
      end
    end

    extend Configurable

    # wrapper class for e-Stat API service
    class StatsData < Dataset
      attr_accessor :app_id, :id

      #
      # generate accessor instance for e-Stat API's endpoint `getStatsData`.
      # for detail spec : https://www.e-stat.go.jp/api/api-info/e-stat-manual
      # @param [String] id Statistical data id
      # @param [Array<String>] areas Target areas (fetch all if omitted)
      # @param [Array<String>] categories Category IDs (fetch all if omitted)
      # @param [Array<String>] times Time axes (fetch all if omitted)
      # @param [Array<Number>] skip_levels Skip levels for parsing (defaults to `[1]`)
      # @param [String] hierarchy_selection Select target from 'child', 'parent', or 'both'. (Example: 札幌市○○区 -> 'child':札幌市○○区 only; 'parent':札幌市 only; 'both': Both selected) (defaults to `both`)
      # @param [Boolean] skip_nil_column Skip column if contains nil
      # @param [Boolean] skip_nil_row Skip row if contains nil
      # @example
      #   stats_data = Datasets::EStatJapan::StatsData.new(
      #     "0000020201", # A Population and household (key name: Ａ　人口・世帯)
      #     categories: ["A1101"], # Population (key name: A1101_人口総数)
      #     areas: ["01105", "01106"], # Toyohira-ku Sapporo-shi Hokkaido, Minami-ku Sapporo-shi Hokkaido
      #     times: ["1981100000", "1982100000"],
      #     hierarchy_selection: 'child',
      #     skip_child_area: true,
      #     skip_nil_column: true,
      #     skip_nil_row: false,
      #   )
      #
      def initialize(id,
                     app_id: nil,
                     areas: nil, categories: nil, times: nil,
                     skip_levels: [1],
                     hierarchy_selection: 'child',
                     skip_nil_column: true,
                     skip_nil_row: false,
                     time_range: nil)
        @app_id = app_id || fetch_app_id
        if @app_id.nil? || @app_id.empty?
          raise ArgumentError, 'Please set app_id via `Datasets::EStatJapan.configure` method, environment var `ESTATJAPAN_APP_ID` or keyword argument `:app_id`'
        end

        super()

        @api_version = '3.0'
        @base_url = "https://api.e-stat.go.jp/rest/#{@api_version}/app/json/getStatsData"
        @metadata.id = "e-stat-japan-#{@api_version}"
        @metadata.name = "e-Stat API #{@api_version}"
        @metadata.url = @base_url
        @metadata.licenses = ["CC-BY-4.0"]
        @metadata.description = "e-Stat API #{@api_version}"

        @id = id
        @areas = areas
        @categories = categories
        @times = times
        @skip_levels = skip_levels
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

        @url = generate_url
        option_hash = Digest::MD5.hexdigest(@url.to_s)
        base_name = "e-stat-japan-#{option_hash}.json"
        @data_path = cache_dir_path + base_name
        @loaded = false
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

        load_data

        # create rows
        @areas.each do |a_key, a_value|
          rows = []
          @time_tables.reject { |_key, x| x[:skip] }.each do |st_key, _st_value|
            row = @columns.reject { |_key, x| x[:skip] }.map do |c_key, _c_value|
              @indexed_data.dig(st_key, a_key, c_key)
            end
            rows << row
          end
          next if @skip_nil_row && rows.flatten.count(nil).positive?

          yield Record.new(a_key, a_value['@name'], rows.flatten)
        end
      end

      def areas
        load_data
        @areas
      end

      def time_tables
        load_data
        @time_tables
      end

      def columns
        load_data
        @columns
      end

      def schema
        load_data
        @schema
      end

      private

      def generate_url
        # generates url for query
        params = {
          appId: @app_id, lang: 'J',
          statsDataId: @id,
          metaGetFlg: 'Y', cntGetFlg: 'N',
          sectionHeaderFlg: '1'
        }
        params['cdArea'] = @areas.join(',') if @areas.instance_of?(Array)
        params['cdCat01'] = @categories.join(',') if @categories.instance_of?(Array)
        params['cdTime'] = @times.join(',') if @times.instance_of?(Array)

        URI.parse("#{@base_url}?#{URI.encode_www_form(params)}")
      end

      def extract_def(data, id)
        rec = data.dig('GET_STATS_DATA',
                       'STATISTICAL_DATA',
                       'CLASS_INF',
                       'CLASS_OBJ')
        rec.select { |x| x['@id'] == id }
      end

      def index_def(data_def)
        unless data_def.first['CLASS'].instance_of?(Array)
          # convert to array when number of element is 1
          data_def.first['CLASS'] = [data_def.first['CLASS']]
        end
        Hash[*data_def.first['CLASS'].map { |x| [x['@code'], x] }.flatten]
      end

      def get_values(data)
        data.dig('GET_STATS_DATA',
                 'STATISTICAL_DATA',
                 'DATA_INF',
                 'VALUE')
      end

      def fetch_app_id
        EStatJapan.app_id || ENV['ESTATJAPAN_APP_ID']
      end

      def load_data
        return if @loaded

        fetch_data
        index_data
      end

      def fetch_data
        # MEMO:
        # The e-stat api always returns 200 (Ok)
        # even if error happens dispite of its error mapping.
        # So we can't avoid caching retrieved response from the api.
        # ref: https://www.e-stat.go.jp/api/api-info/e-stat-manual3-0
        download(@data_path, @url.to_s)
      end

      def index_data
        # parse json
        raw_data = File.open(@data_path) do |io|
          JSON.parse(io.read)
        end

        # check status
        api_status = raw_data.dig('GET_STATS_DATA', 'RESULT', 'STATUS')
        if api_status != 0
          # remove error response cache manually
          FileUtils.rm(@data_path)
          error_msg = raw_data.dig('GET_STATS_DATA', 'RESULT', 'ERROR_MSG')
          raise APIError, "code #{api_status} : #{error_msg}"
        end

        # index data
        ## table_def = extract_def(raw_data, "tab")
        timetable_def = extract_def(raw_data, 'time')
        column_def = extract_def(raw_data, 'cat01')
        area_def = extract_def(raw_data, 'area')

        @time_tables = index_def(timetable_def)
        @columns = index_def(column_def)
        @areas = index_def(area_def)

        ## apply time_range to time_tables
        @time_tables.select! { |k, _v| @time_tables.keys[@time_range].include? k } if @time_range.instance_of?(Range)

        @indexed_data = Hash[*@time_tables.keys.map { |x| [x, {}] }.flatten]
        get_values(raw_data).each do |row|
          next unless @time_tables.key?(row['@time'])

          data = @indexed_data.dig(row['@time'], row['@area']) || {}
          new_data = data.merge(row['@cat01'] => row['$'].to_f)
          @indexed_data[row['@time']][row['@area']] = new_data
        end

        skip_areas
        skip_nil_column
        @schema = create_header
        @loaded = true
      end

      def skip_areas
        # skip levels
        @areas.reject! { |_key, x| @skip_levels.include? x['@level'].to_i }

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
        @areas.reject! { |_a_key, a_value| (@areas.key? a_value['@parentCode']) } if @skip_child_area
      end

      def skip_nil_column
        return unless @skip_nil_column

        # filter time_tables and columns
        @areas.each do |a_key, _a_value|
          @time_tables.each do |st_key, st_value|
            unless @indexed_data[st_key].key?(a_key)
              st_value[:skip] = true
              next
            end
            @columns.each do |c_key, c_value|
              unless @indexed_data.dig(st_key, a_key).key?(c_key)
                c_value[:skip] = true
                next
              end
            end
          end
        end
      end

      def create_header
        schema = []
        @time_tables.reject { |_key, x| x[:skip] }.each do |_st_key, st_value|
          @columns.reject { |_key, x| x[:skip] }.each do |_c_key, c_value|
            schema << "#{st_value['@name']}_#{c_value['@name']}"
          end
        end
        schema
      end
    end

    class ArgumentError < Error
    end

    class APIError < Error
    end
  end
end
