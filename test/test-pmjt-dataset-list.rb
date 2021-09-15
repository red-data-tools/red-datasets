class PMJTDatasetListTest < Test::Unit::TestCase
  def setup
    @dataset = Datasets:: PMJTDatasetList.new
  end

  test("#each") do
    records = @dataset.each.to_a

    record_first = Datasets::PMJTDatasetList::Record.new
    record_first.unit = '冊'
    record_first.open_data_category = '総記'
    record_first.tag = nil
    record_first.release_time = 'H31.1'
    record_first.n_volumes = '2'
    record_first.type = '刊'
    record_first.publication_year = '元禄９'
    record_first.original_request_code = '９９－３７－１～２'
    record_first.id = '200003090'
    record_first.title = '人倫重宝記'
    record_first.text = nil
    record_first.bibliographical_introduction = nil
    record_first.year = nil

    record_last = Datasets::PMJTDatasetList::Record.new
    record_last.unit = '冊'
    record_last.open_data_category = '総記'
    record_last.tag = nil
    record_last.release_time = 'H27.11'
    record_last.n_volumes = '1'
    record_last.type = '刊'
    record_last.publication_year = '慶応2'
    record_last.original_request_code = '４９－１７３'
    record_last.id = '200021837'
    record_last.title = '洋学便覧'
    record_last.text = nil
    record_last.bibliographical_introduction = '○'
    record_last.year = '1866'

    assert_equal([
                    3126,
                    record_first,
                    record_last
                  ],
                  [
                    records.size,
                    records[1],
                    records[-1]
                  ])
  end
end
