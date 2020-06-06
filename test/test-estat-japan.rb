# frozen_string_literal: true

require 'pathname'

class EStatJapanTest < Test::Unit::TestCase
  sub_test_case('app_id') do
    def setup
      ENV['ESTATJAPAN_APPID'] = nil
      Datasets::EStatJapan.app_id = nil
    end

    test('nothing') do
      assert_raise(ArgumentError) do
        Datasets::EStatJapan::StatsData.new('test')
      end
    end

    test('env') do
      ENV['ESTATJAPAN_APPID'] = 'test_by_env'
      data = Datasets::EStatJapan::StatsData.new('test')
      assert_equal('test_by_env', data.app_id)
    end

    test('configure') do
      Datasets::EStatJapan.configure do |config|
        config.app_id = 'test_by_method'
      end
      data = Datasets::EStatJapan::StatsData.new('test')
      assert_equal('test_by_method', data.app_id)
    end

    test('env & configure') do
      ENV['ESTATJAPAN_APPID'] = 'test_by_env'
      Datasets::EStatJapan.configure do |config|
        config.app_id = 'test_by_method'
      end
      data = Datasets::EStatJapan::StatsData.new('test')
      assert_equal('test_by_method', data.app_id)
    end
  end

  sub_test_case('stats_data') do
    def setup
      ENV['ESTATJAPAN_APPID'] = nil
      Datasets::EStatJapan.app_id = nil
    end

    test('generates url correctly') do
      app_id = 'abcdef'
      stats_data_id = '000000'
      base_url = 'http://testurl/rest/2.1/app/json/getStatsData'
      Datasets::EStatJapan.app_id = app_id
      url = Datasets::EStatJapan::StatsData.new('test').generate_url(base_url, app_id, stats_data_id)
      assert_equal(
        'http://testurl/rest/2.1/app/json/getStatsData' \
        '?appId=abcdef&lang=J&statsDataId=000000&' \
        'metaGetFlg=Y&cntGetFlg=N&sectionHeaderFlg=1',
        url.to_s
      )
    end

    test('raises when status is invalid') do
      ENV['ESTATJAPAN_APPID'] = 'test_appid_invalid'
      estat_obj = Datasets::EStatJapan::StatsData.new('test')
      estat_obj.instance_eval do
        @data_path = Pathname('test/data/test-estat-japan-403-forbidden.json')
      end
      assert_raise(Exception) do
        estat_obj.each do |record|
          p record
        end
      end
    end

    test('can parse api result correctly') do
      ENV['ESTATJAPAN_APPID'] = 'test_appid_correct'
      test_path = 'test/data/test-estat-japan-200-0000020201.json'

      estat_obj = Datasets::EStatJapan::StatsData.new('test')
      estat_obj.instance_eval do
        @data_path = Pathname(test_path)
      end
      records = []
      sapporo_records = []
      value_num = 0
      estat_obj.each do |record|
        records << record
        value_num += record.values.length
        sapporo_records << record if record.name.start_with? '北海道 札幌市'
      end
      assert_equal(1897, records.length)
      assert_equal(1897 * 4, value_num)
      assert_equal(10, sapporo_records.length)

      estat_obj = \
        Datasets::EStatJapan::StatsData.new('test',
                                            hierarchy_selection: 'parent')
      estat_obj.instance_eval do
        @data_path = Pathname(test_path)
      end
      records = []
      sapporo_records = []
      estat_obj.each do |record|
        records << record
        sapporo_records << record if record.name.start_with? '北海道 札幌市'
      end
      assert_equal(1722, records.length)
      assert_equal(1, sapporo_records.length)

      estat_obj = \
        Datasets::EStatJapan::StatsData.new('test',
                                            hierarchy_selection: 'both')
      estat_obj.instance_eval do
        @data_path = Pathname(test_path)
      end
      records = []
      sapporo_records = []
      estat_obj.each do |record|
        records << record
        sapporo_records << record if record.name.start_with? '北海道 札幌市'
      end
      assert_equal(1917, records.length)
      assert_equal(11, sapporo_records.length)

      estat_obj = \
        Datasets::EStatJapan::StatsData.new('test',
                                            skip_nil_column: false)
      estat_obj.instance_eval do
        @data_path = Pathname(test_path)
      end
      records = []
      value_num = 0
      estat_obj.each do |record|
        records << record
        value_num += record.values.length
      end
      assert_equal(1897, records.length)
      assert_equal(1897 * 38, value_num)

      estat_obj = \
        Datasets::EStatJapan::StatsData.new('test',
                                            skip_nil_row: true,
                                            skip_nil_column: false)
      estat_obj.instance_eval do
        @data_path = Pathname(test_path)
      end
      records = []
      estat_obj.each do |record|
        records << record
      end
      assert_equal(0, records.length)
    end
  end
end
