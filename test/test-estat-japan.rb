# frozen_string_literal: true

require 'pathname'

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
    test_path = 'test/data/test-estat-japan-200-0000020201.json'
    def setup
      ENV['ESTATJAPAN_APP_ID'] = 'test_appid_correct'
      Datasets::EStatJapan.app_id = nil
    end

    test('parsing records with default option') do
      stats_data = Datasets::EStatJapan::StatsData.new('test-data-id')
      stats_data.instance_eval do
        @data_path = Pathname(test_path)
      end
      records = []
      sapporo_records = []
      value_num = 0
      stats_data.each do |record|
        records << record
        value_num += record.values.length
        sapporo_records << record if record.name.start_with? '北海道 札幌市'
      end
      assert_equal(1897, records.length)
      assert_equal(1897 * 4, value_num)
      assert_equal(10, sapporo_records.length)
      assert_equal(1897, stats_data.areas.length)
      assert_equal(38, stats_data.timetables.length)
      assert_equal(4, stats_data.timetables.reject { |_k, v| v[:skip] }.to_h.length)
      assert_equal(1, stats_data.columns.length)
      assert_equal(4, stats_data.schema.length)
    end

    test('parsing records with hierarchy_selection') do
      stats_data = \
        Datasets::EStatJapan::StatsData.new('test-data-id',
                                            hierarchy_selection: 'parent')
      stats_data.instance_eval do
        @data_path = Pathname(test_path)
      end
      records = []
      sapporo_records = []
      stats_data.each do |record|
        records << record
        sapporo_records << record if record.name.start_with? '北海道 札幌市'
      end
      assert_equal(1722, records.length)
      assert_equal(1, sapporo_records.length)
      assert_equal(1722, stats_data.areas.length)
      assert_equal(38, stats_data.timetables.length)
      assert_equal(8, stats_data.timetables.reject { |_k, v| v[:skip] }.to_h.length)
      assert_equal(1, stats_data.columns.length)
      assert_equal(8, stats_data.schema.length)

      stats_data = \
        Datasets::EStatJapan::StatsData.new('test-data-id',
                                            hierarchy_selection: 'child')
      stats_data.instance_eval do
        @data_path = Pathname(test_path)
      end
      records = []
      sapporo_records = []
      stats_data.each do |record|
        records << record
        sapporo_records << record if record.name.start_with? '北海道 札幌市'
      end
      assert_equal(1897, records.length)
      assert_equal(10, sapporo_records.length)
      assert_equal(1897, stats_data.areas.length)
      assert_equal(38, stats_data.timetables.length)
      assert_equal(4, stats_data.timetables.reject { |_k, v| v[:skip] }.to_h.length)
      assert_equal(1, stats_data.columns.length)
      assert_equal(4, stats_data.schema.length)

      stats_data = \
        Datasets::EStatJapan::StatsData.new('test-data-id',
                                            hierarchy_selection: 'both')
      stats_data.instance_eval do
        @data_path = Pathname(test_path)
      end
      records = []
      sapporo_records = []
      stats_data.each do |record|
        records << record
        sapporo_records << record if record.name.start_with? '北海道 札幌市'
      end
      assert_equal(1917, records.length)
      assert_equal(11, sapporo_records.length)
      assert_equal(1917, stats_data.areas.length)
      assert_equal(38, stats_data.timetables.length)
      assert_equal(4, stats_data.timetables.reject { |_k, v| v[:skip] }.to_h.length)
      assert_equal(1, stats_data.columns.length)
      assert_equal(4, stats_data.schema.length)
    end

    test('parsing records with skip_nil_(column|row)') do
      stats_data = \
        Datasets::EStatJapan::StatsData.new('test-data-id',
                                            skip_nil_column: false)
      stats_data.instance_eval do
        @data_path = Pathname(test_path)
      end
      records = []
      value_num = 0
      stats_data.each do |record|
        records << record
        value_num += record.values.length
      end
      assert_equal(1897, records.length)
      assert_equal(1897 * 38, value_num)
      assert_equal(1897, stats_data.areas.length)
      assert_equal(38, stats_data.timetables.length)
      assert_equal(38, stats_data.timetables.reject { |_k, v| v[:skip] }.to_h.length)
      assert_equal(1, stats_data.columns.length)
      assert_equal(38, stats_data.schema.length)

      stats_data = \
        Datasets::EStatJapan::StatsData.new('test-data-id',
                                            skip_nil_row: true,
                                            skip_nil_column: false)
      stats_data.instance_eval do
        @data_path = Pathname(test_path)
      end
      records = []
      stats_data.each do |record|
        records << record
      end
      assert_equal(0, records.length)
      assert_equal(1897, stats_data.areas.length)
      assert_equal(38, stats_data.timetables.length)
      assert_equal(38, stats_data.timetables.reject { |_k, v| v[:skip] }.to_h.length)
      assert_equal(1, stats_data.columns.length)
      assert_equal(38, stats_data.schema.length)
    end
  end

  sub_test_case('anomaly responses') do
    def setup
      ENV['ESTATJAPAN_APP_ID'] = nil
      Datasets::EStatJapan.app_id = nil
    end
    test('forbidden access with invalid app_id') do
      ENV['ESTATJAPAN_APP_ID'] = 'test_appid_invalid'
      stats_data = Datasets::EStatJapan::StatsData.new('test-data-id')
      stats_data.instance_eval do
        @data_path = Pathname('test/data/test-estat-japan-403-forbidden.json')
      end
      assert_raise(Datasets::EStatJapan::APIError) do
        # contains no data
        stats_data.each do |record|
          record
        end
      end
    end
  end
end
