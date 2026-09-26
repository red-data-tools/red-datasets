require "csv"

require_relative "dataset"

module Datasets
  class PVDAQ < Dataset
    Record = Struct.new(
      :system_id,
      :system_public_name,
      :site_location,
      :timezone_or_utc_offset,
      :latitude,
      :longitude,
      :elevation_m,
      :dc_capacity_kw,
      :koppen_geiger_climate,
      :pvcz_composite,
      :pvcz_t_rack,
      :pvcz_t_roof,
      :pvcz_humidity,
      :pvcz_wind,
      :tracking,
      :type,
      :azimuth,
      :tilt,
      :first_timestamp,
      :last_timestamp,
      :years,
      :n_records,
      :dataset_size_mb,
      :n_available_sensor_channels,
      :qa_status,
      :qa_issue
    )

    def initialize
      super()
      @metadata.id = "pvdaq"
      @metadata.name = "Photovoltaic Data Acquisition (PVDAQ)"
      @metadata.url = "https://catalog.data.gov/dataset/photovoltaic-data-acquisition-pvdaq-public-datasets"
      @metadata.licenses = ["CC-BY-4.0"]
      @metadata.description = <<~DESCRIPTION
        PVDAQ (Photovoltaic Data Acquisition) is a fleet of PV systems
        operated by the National Renewable Energy Laboratory (NREL) and its
        partners that collect performance data of PV installations across
        the United States.

        This dataset provides the list of PV systems in the PVDAQ fleet,
        including each system's location, capacity, mounting configuration,
        and the time range of its available sensor data.

        Detailed per-system time-series sensor data (irradiance, power,
        temperature, and so on) is also published but isn't provided by
        this dataset.

        Document: https://github.com/openEDI/documentation/blob/main/pvdaq.md
      DESCRIPTION
    end

    def each
      return to_enum(__method__) unless block_given?

      open_data do |csv|
        csv.each do |row|
          yield(build_record(row))
        end
      end
    end

    private
    def open_data
      version = "20250729"
      data_path = cache_dir_path + "systems-#{version}.csv"
      data_url =
        "https://oedi-data-lake.s3.amazonaws.com/pvdaq/csv/systems_#{version}.csv"
      download(data_path, data_url)

      CSV.open(data_path, headers: true, converters: %i[numeric]) do |csv|
        yield(csv)
      end
    end

    def build_record(row)
      Record.new(
        row["system_id"],
        row["system_public_name"],
        row["site_location"],
        row["timezone_or_utc_offset"],
        row["latitude"],
        row["longitude"],
        row["elevation_m"],
        row["dc_capacity_kW"],
        row["kg_climate"],
        row["pvcz_composite"],
        row["pvcz_t_rack"],
        row["pvcz_t_roof"],
        row["pvcz_humidity"],
        row["pvcz_wind"],
        row["tracking"],
        row["type"],
        row["azimuth"],
        row["tilt"],
        row["first_timestamp"],
        row["last_timestamp"],
        row["years"],
        row["number_records"],
        row["dataset_size_mb"],
        row["available_sensor_channels"],
        row["qa_status"],
        row["qa_issue"]
      )
    end
  end
end
