class LIBSVMDatasetListTest < Test::Unit::TestCase
  def setup
    @dataset = Datasets::LIBSVMDatasetList.new
  end

  test("#each") do
    assert_equal({
                   name: "a1a",
                   source: "UCI / Adult",
                   preprocessing:
                     "The original Adult data set has 14 features, " +
                     "among which six are continuous and eight are " +
                     "categorical. In this data set, continuous features " +
                     "are discretized into quantiles, and each quantile is " +
                     "represented by a binary feature. Also, a categorical " +
                     "feature with m categories is converted to m binary " +
                     "features. Details on how each feature is converted " +
                     "can be found in the beginning of each file from this " +
                     "page. [JP98a]",
                   n_classes: 2,
                   n_data: 1605,
                   n_features: 123,
                   files: [
                     {
                       name: "a1a",
                       url: "https://www.csie.ntu.edu.tw/~cjlin/libsvmtools/datasets/binary/a1a",
                       note: nil,
                     },
                     {
                       name: "a1a.t",
                       url: "https://www.csie.ntu.edu.tw/~cjlin/libsvmtools/datasets/binary/a1a.t",
                       note: "testing",
                     }
                   ],
                 },
                 @dataset.first.to_h)
  end

  sub_test_case("#metadata") do
    test("#description") do
      description = @dataset.metadata.description
      assert do
        description.start_with?("This page contains many classification, ")
      end
    end
  end
end
