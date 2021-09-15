class PmjtDatasetListTest < Test::Unit::TestCase
  def setup
    @dataset = Datasets:: PmjtDatasetList.new(version: '201901')
  end

  test("#each") do
    records = @dataset.each.to_a
    assert_equal([
                    3126,
                    {
                      "(単位)": "冊",
                      オープンデータ分類: "総記",
                      タグ: nil,
                      公開時期: "H31.1",
                      冊数等: "2",
                      刊・写: "刊",
                      刊年・書写年: "元禄９",
                      原本請求記号: "９９－３７－１～２",
                      国文研書誌ID: "200003090",
                      書名（統一書名）: "人倫重宝記",
                      本文: nil,
                      解題: nil,
                      （西暦）: nil
                    },
                    {
                      "(単位)": "冊",
                      オープンデータ分類: "総記",
                      タグ: nil,
                      公開時期: "H27.11",
                      冊数等: "1",
                      刊・写: "刊",
                      刊年・書写年: "慶応2",
                      原本請求記号: "４９－１７３",
                      国文研書誌ID: "200021837",
                      書名（統一書名）: "洋学便覧",
                      本文: nil,
                      解題: "○",
                      （西暦）: "1866"
                    },
                  ],
                  [
                    records.size,
                    records[1].to_h,
                    records[-1].to_h
                  ])
  end
end
