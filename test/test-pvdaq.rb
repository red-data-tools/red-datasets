class PVDAQTest < Test::Unit::TestCase
  def setup
    @dataset = Datasets::PVDAQ.new
  end

  test("#each") do
    assert_equal({
                   :system_id => 2,
                   :system_public_name => "Residential 1a",
                   :site_location => "Lakewood, CO",
                   :timezone_or_utc_offset => "America/Denver",
                   :latitude => 39.7214,
                   :longitude => -105.0972,
                   :elevation_m => 1675,
                   :dc_capacity_kw => 2.912,
                   :koppen_geiger_climate => "Dfb",
                   :pvcz_composite => 12,
                   :pvcz_t_rack => 2,
                   :pvcz_t_roof => 4,
                   :pvcz_humidity => 1,
                   :pvcz_wind => 3,
                   :tracking => "fixed",
                   :type => "roof",
                   :azimuth => 181.2,
                   :tilt => 18.5,
                   :first_timestamp => "1/21/2010 11:02",
                   :last_timestamp => "1/13/2020 16:45",
                   :years => 9.9835,
                   :n_records => 13685898,
                   :dataset_size_mb => 313.25,
                   :n_available_sensor_channels => 7,
                   :qa_status => "fail",
                   :qa_issue => "less than 1.0 years data",
                 },
                 @dataset.each.next.to_h)
  end

  sub_test_case("#metadata") do
    test("#id") do
      assert_equal("pvdaq", @dataset.metadata.id)
    end

    test("#name") do
      assert_equal("Photovoltaic Data Acquisition (PVDAQ)",
                   @dataset.metadata.name)
    end

    test("#url") do
      assert_equal("https://catalog.data.gov/dataset/photovoltaic-data-acquisition-pvdaq-public-datasets",
                   @dataset.metadata.url)
    end

    test("#licenses") do
      assert_equal([Datasets::License.new("CC-BY-4.0")],
                   @dataset.metadata.licenses)
    end

    test("#description") do
      description = @dataset.metadata.description
      assert do
        [
          "Photovoltaic Data Acquisition",
          "National Renewable Energy Laboratory",
        ].all? do |phrase|
          description.include?(phrase)
        end
      end
    end
  end
end
