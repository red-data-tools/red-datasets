# frozen_string_literal: true

require 'pathname'

class EStatJapanTest < Test::Unit::TestCase
  sub_test_case('test') do
    test('raises api APPID is unset') do
      # error if app_id is undefined
      ENV['ESTATJAPAN_APPID'] = nil
      assert_raise(ArgumentError) do
        Datasets::EStatJapan::StatsData.new('test')
      end
    end

    test('is ok when APPID is set') do
      # ok if app_id is set by ENV
      ENV['ESTATJAPAN_APPID'] = 'test_by_env'
      assert_nothing_raised do
        obj = Datasets::EStatJapan::StatsData.new('test')
        assert_equal('test_by_env', obj.app_id)
      end
      ENV['ESTATJAPAN_APPID'] = nil

      # ok if app_id is set by configure method
      Datasets::EStatJapan.configure do |config|
        config.app_id = 'test_by_method'
      end
      assert_nothing_raised do
        obj = Datasets::EStatJapan::StatsData.new('test')
        assert_equal('test_by_method', obj.app_id)
      end
      Datasets::EStatJapan.app_id = nil

      # ok if app_id is set by ENV
      ENV['ESTATJAPAN_APPID'] = 'test_by_env2'
      assert_nothing_raised do
        obj = Datasets::EStatJapan::StatsData.new('test')
        assert_equal('test_by_env2', obj.app_id)
      end
      ENV['ESTATJAPAN_APPID'] = nil
    end

    test('generates url correctly') do
      app_id = 'abcdef'
      stats_data_id = '000000'
      base_url = 'http://testurl/rest/2.1/app/json/getStatsData'
      url = Datasets::EStatJapan::StatsData.generate_url(base_url, app_id, stats_data_id)
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
      ENV['ESTATJAPAN_APPID'] = nil
    end

    test('can parse api result correctly') do
      ENV['ESTATJAPAN_APPID'] = 'test_appid_correct'
      test_path = 'test/data/test-estat-japan-200-0000020201.json'

      estat_obj = Datasets::EStatJapan::StatsData.new('test')
      estat_obj.instance_eval do
        @data_path = Pathname(test_path)
      end
      assert_nothing_raised do
        records = []
        sapporo_records = []
        estat_obj.each do |record|
          records << record
          sapporo_records << record if record.name.start_with? '北海道 札幌市'
        end
        assert_equal(1897, records.length)
        assert_equal(10, sapporo_records.length)
      end

      estat_obj = \
        Datasets::EStatJapan::StatsData.new('test',
                                            hierarchy_selection: 'parent')
      estat_obj.instance_eval do
        @data_path = Pathname(test_path)
      end
      assert_nothing_raised do
        records = []
        sapporo_records = []
        estat_obj.each do |record|
          records << record
          sapporo_records << record if record.name.start_with? '北海道 札幌市'
        end
        assert_equal(1722, records.length)
        assert_equal(1, sapporo_records.length)
      end

      estat_obj = \
        Datasets::EStatJapan::StatsData.new('test',
                                            hierarchy_selection: 'both')
      estat_obj.instance_eval do
        @data_path = Pathname(test_path)
      end
      assert_nothing_raised do
        records = []
        sapporo_records = []
        estat_obj.each do |record|
          records << record
          sapporo_records << record if record.name.start_with? '北海道 札幌市'
        end
        assert_equal(1917, records.length)
        assert_equal(11, sapporo_records.length)
      end

      # skip_nil_column: true,
      # skip_nil_row: false,

      ENV['ESTATJAPAN_APPID'] = nil
    end
  end
end
