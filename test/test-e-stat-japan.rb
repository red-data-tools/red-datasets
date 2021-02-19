# frozen_string_literal: true

require 'pathname'
require 'tmpdir'

class EStatJapanTest < Test::Unit::TestCase
  sub_test_case('app_id') do
    def setup
      ENV['ESTATJAPAN_APP_ID'] = nil
      Datasets::EStatJapan.app_id = nil
    end

    test('nothing') do
      assert_raise(Datasets::EStatJapan::ArgumentError) do
        Datasets::EStatJapan::StatsData.new('test-data-id')
      end
    end

    test('constructor') do
      stats_data = Datasets::EStatJapan::StatsData.new('test-data-id', app_id: 'test_by_constructor')
      assert_equal('test_by_constructor', stats_data.app_id)
    end

    test('env') do
      ENV['ESTATJAPAN_APP_ID'] = 'test_by_env'
      stats_data = Datasets::EStatJapan::StatsData.new('test-data-id')
      assert_equal('test_by_env', stats_data.app_id)
    end

    test('configure') do
      Datasets::EStatJapan.configure do |config|
        config.app_id = 'test_by_configure'
      end
      stats_data = Datasets::EStatJapan::StatsData.new('test-data-id')
      assert_equal('test_by_configure', stats_data.app_id)
    end

    test('env & configure') do
      ENV['ESTATJAPAN_APP_ID'] = 'test_by_env'
      Datasets::EStatJapan.configure do |config|
        config.app_id = 'test_by_configure'
      end
      stats_data = Datasets::EStatJapan::StatsData.new('test-data-id')
      assert_equal('test_by_configure', stats_data.app_id)
    end

    test('env & configure & constructor') do
      ENV['ESTATJAPAN_APP_ID'] = 'test_by_env'
      Datasets::EStatJapan.configure do |config|
        config.app_id = 'test_by_configure'
      end
      stats_data = Datasets::EStatJapan::StatsData.new('test-data-id', app_id: 'test_by_constructor')
      assert_equal('test_by_constructor', stats_data.app_id)
    end
  end

  sub_test_case('url generation') do
    def setup
      ENV['ESTATJAPAN_APP_ID'] = nil
      Datasets::EStatJapan.app_id = nil
    end

    test('generates url correctly') do
      Datasets::EStatJapan.app_id = 'abcdef'
      stats_data = Datasets::EStatJapan::StatsData.new('test-data-id')
      stats_data_id = '000000'
      stats_data.instance_eval do
        @id = stats_data_id
        @base_url = 'http://testurl/rest/2.1/app/json/getStatsData'
      end
      url = stats_data.send(:generate_url)
      assert_equal(
        'http://testurl/rest/2.1/app/json/getStatsData' \
        '?appId=abcdef&lang=J&statsDataId=000000&' \
        'metaGetFlg=Y&cntGetFlg=N&sectionHeaderFlg=1',
        url.to_s
      )
    end
  end

  sub_test_case('parsing records') do
    def setup
      Datasets::EStatJapan.app_id = nil
      # prepare test data
      class_obj = [
        {
          "@name": 'table1',
          "@id": 'tab',
          "CLASS": {
            "@level": '1',
            "@code": '00001',
            "@name": 'table1'
          }
        },
        {
          "@name": 'data1',
          "@id": 'cat01',
          "CLASS": {
            "@level": '1',
            "@code": 'data1',
            "@name": 'data1_name'
          }
        },
        {
          "@name": 'area1',
          "@id": 'area',
          "CLASS": [
            {
              "@level": '2',
              "@code": '01100',
              "@name": 'test1 big-city',
              "@parentCode": '01000'
            },
            {
              "@level": '3',
              "@code": '01101',
              "@name": 'test1 big-city a-ku',
              "@parentCode": '01100'
            },
            {
              "@level": '3',
              "@code": '01102',
              "@name": 'test1 big-city b-ku',
              "@parentCode": '01100'
            },
            {
              "@level": '2',
              "@code": '02555',
              "@name": 'test2 a-city',
              "@parentCode": '02000'
            },
            {
              "@level": '2',
              "@code": '02556',
              "@name": 'test2 b-city',
              "@parentCode": '02000'
            }
          ]
        },
        {
          "@name": 'time',
          "@id": 'time',
          "CLASS": [
            {
              "@level": '1',
              "@code": 'time1',
              "@name": 'time1'
            },
            {
              "@level": '1',
              "@code": 'time2',
              "@name": 'time2'
            },
            {
              "@level": '1',
              "@code": 'time3',
              "@name": 'time3'
            }
          ]
        }
      ]
      data_inf = class_obj[2][:CLASS].map do |entry|
        [
          {
            "$": 1000,
            "@area": entry[:@code],
            "@cat01": 'data1',
            "@tab": 'table1',
            "@time": 'time1',
            "@unit": 'person'
          },
          {
            "$": 2000,
            "@area": entry[:@code],
            "@cat01": 'data1',
            "@tab": 'table1',
            "@time": 'time2',
            "@unit": 'person'
          }
        ]
      end.flatten
      ## test record for `skip_nil_row: true`
      data_inf << {
        "$": 3000,
        "@area": '02556',
        "@cat01": 'data1',
        "@tab": 'table1',
        "@time": 'time3',
        "@unit": 'person'
      }
      @response_data_default = {
        'GET_STATS_DATA' => {
          'RESULT' => {
            'STATUS' => 0,
            'ERROR_MSG' => 'succeeded'
          },
          'STATISTICAL_DATA' => {
            'DATA_INF' => {
              'VALUE' => data_inf
            },
            'CLASS_INF' => {
              'CLASS_OBJ' => class_obj
            }
          }
        }
      }

      @tmp_dir = Dir.mktmpdir
      @test_data_path = Pathname(File.join(@tmp_dir, '200-ok.json'))
      ENV['ESTATJAPAN_APP_ID'] = 'test_appid_correct'
      File.open(@test_data_path, 'w') do |f|
        f.write(@response_data_default.to_json)
      end
    end

    def teardown
      FileUtils.remove_entry_secure(@test_data_path)
      FileUtils.remove_entry_secure(@tmp_dir)
    end

    test('parsing records with default option') do
      test_data_path = @test_data_path
      stats_data = Datasets::EStatJapan::StatsData.new('test-data-id', app_id: 'valid')
      stats_data.instance_eval do
        @data_path = test_data_path
      end

      records = []
      value_num = 0
      stats_data.each do |record|
        records << record
        value_num += record.values.length
      end
      assert_equal(4, records.length)
      assert_equal(4 * 2, value_num)
      assert_equal(4, stats_data.areas.length)
      assert_equal(3, stats_data.time_tables.length)
      assert_equal(2, stats_data.time_tables.reject { |_k, v| v[:skip] }.to_h.length)
      assert_equal(1, stats_data.columns.length)
      assert_equal(2, stats_data.schema.length)
    end

    test('parsing records with hierarchy_selection') do
      test_data_path = @test_data_path
      stats_data = \
        Datasets::EStatJapan::StatsData.new('test-data-id',
                                            hierarchy_selection: 'parent')
      stats_data.instance_eval do
        @data_path = test_data_path
      end
      records = []
      stats_data.each do |record|
        records << record
      end
      assert_equal(3, records.length)
      assert_equal(3, stats_data.areas.length)
      assert_equal(3, stats_data.time_tables.length)
      assert_equal(2, stats_data.time_tables.reject { |_k, v| v[:skip] }.to_h.length)
      assert_equal(1, stats_data.columns.length)
      assert_equal(2, stats_data.schema.length)

      stats_data = \
        Datasets::EStatJapan::StatsData.new('test-data-id',
                                            hierarchy_selection: 'child')
      stats_data.instance_eval do
        @data_path = test_data_path
      end
      records = []
      stats_data.each do |record|
        records << record
      end
      assert_equal(4, records.length)
      assert_equal(4, stats_data.areas.length)
      assert_equal(3, stats_data.time_tables.length)
      assert_equal(2, stats_data.time_tables.reject { |_k, v| v[:skip] }.to_h.length)
      assert_equal(1, stats_data.columns.length)
      assert_equal(2, stats_data.schema.length)

      stats_data = \
        Datasets::EStatJapan::StatsData.new('test-data-id',
                                            hierarchy_selection: 'both')
      stats_data.instance_eval do
        @data_path = test_data_path
      end
      records = []
      stats_data.each do |record|
        records << record
      end
      assert_equal(5, records.length)
      assert_equal(5, stats_data.areas.length)
      assert_equal(3, stats_data.time_tables.length)
      assert_equal(2, stats_data.time_tables.reject { |_k, v| v[:skip] }.to_h.length)
      assert_equal(1, stats_data.columns.length)
      assert_equal(2, stats_data.schema.length)
    end

    test('parsing records with skip_nil_(column|row)') do
      test_data_path = @test_data_path
      stats_data = \
        Datasets::EStatJapan::StatsData.new('test-data-id',
                                            skip_nil_column: false)
      stats_data.instance_eval do
        @data_path = test_data_path
      end
      records = []
      value_num = 0
      stats_data.each do |record|
        records << record
        value_num += record.values.length
      end
      assert_equal(4, records.length)
      assert_equal(4 * 3, value_num)
      assert_equal(4, stats_data.areas.length)
      assert_equal(3, stats_data.time_tables.length)
      assert_equal(3, stats_data.time_tables.reject { |_k, v| v[:skip] }.to_h.length)
      assert_equal(1, stats_data.columns.length)
      assert_equal(3, stats_data.schema.length)

      stats_data = \
        Datasets::EStatJapan::StatsData.new('test-data-id',
                                            skip_nil_row: true,
                                            skip_nil_column: false)
      stats_data.instance_eval do
        @data_path = test_data_path
      end
      records = []
      value_num = 0
      stats_data.each do |record|
        records << record
        value_num += record.values.length
      end
      assert_equal(1, records.length)
      assert_equal(1 * 3, value_num)
      assert_equal(4, stats_data.areas.length)
      assert_equal(3, stats_data.time_tables.length)
      assert_equal(3, stats_data.time_tables.reject { |_k, v| v[:skip] }.to_h.length)
      assert_equal(1, stats_data.columns.length)
      assert_equal(3, stats_data.schema.length)
    end
  end

  sub_test_case('anomaly responses') do
    def setup
      ENV['ESTATJAPAN_APP_ID'] = nil
      Datasets::EStatJapan.app_id = nil
      @response_data = {
        'GET_STATS_DATA' => {
          'RESULT' => {
            'STATUS' => 100,
            'ERROR_MSG' => 'error message'
          }
        }
      }
      @tmp_dir = Dir.mktmpdir
      @test_data_path = Pathname(File.join(@tmp_dir, '200-error.json'))
      File.open(@test_data_path, 'w') do |f|
        f.write(@response_data.to_json)
      end
    end

    def teardown
      FileUtils.remove_entry_secure(@tmp_dir)
    end

    test('forbidden access with invalid app_id') do
      test_data_path = @test_data_path
      ENV['ESTATJAPAN_APP_ID'] = 'test_appid_invalid'
      stats_data = Datasets::EStatJapan::StatsData.new('test-data-id')
      cache_file_path = nil
      stats_data.instance_eval do
        cache_file_path = @data_path = test_data_path
      end
      assert_raise(Datasets::EStatJapan::APIError) do
        # contains no data
        stats_data.each do |record|
          record
        end
      end
      # ensure remove error response cache
      assert_equal(cache_file_path.exist?, false)
    end
  end
end
