class TestDataset < Test::Unit::TestCase
  sub_test_case("#clear_cache!") do
    def setup
      @dataset = Datasets::Iris.new
      @cache_dir_path = @dataset.send(:cache_dir_path)
    end

    test("when the dataset is downloaded") do
      @dataset.first # This ensures the dataset downloaded
      existence = {before: @cache_dir_path.join("iris.csv").exist?}

      @dataset.clear_cache!
      existence[:after] = @cache_dir_path.join("iris.csv").exist?

      assert_equal({before: true, after: false},
                   existence)
    end

    test("when the dataset is not downloaded") do
      FileUtils.rmtree(@cache_dir_path.to_s, secure: true) if @cache_dir_path.exist?

      assert_nothing_raised do
        @dataset.clear_cache!
      end
    end
  end
end
