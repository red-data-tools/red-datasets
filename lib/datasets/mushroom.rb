require "csv"

require_relative "dataset"
module Datasets
  class Mushroom < Dataset
    Record = Struct.new(
      :label,
      :cap_shape,
      :cap_surface,
      :cap_color,
      :bruises,
      :odor,
      :gill_attachment,
      :gill_spacing,
      :gill_size,
      :gill_color,
      :stalk_shape,
      :stalk_root,
      :stalk_surface_above_ring,
      :stalk_surface_below_ring,
      :stalk_color_above_ring,
      :stalk_color_below_ring,
      :veil_type,
      :veil_color,
      :ring_number,
      :ring_type,
      :spore_print_color,
      :population,
      :habitat,
    )

    def initialize
      super()
      @metadata.id = "mushroom"
      @metadata.name = "Mushroom"
      @metadata.url = "https://archive.ics.uci.edu/ml/datasets/mushroom"
      @metadata.description = lambda do
        read_names
      end
    end

    def each
      return to_enum(__method__) unless block_given?

      open_data do |csv|
        csv.each do |row|
          next if row[0].nil?
          record = Record.new(*row)
          yield(record)
        end
      end
    end

    private
    def open_data
      data_path = cache_dir_path + "agaricus-lepiota.data"
      unless data_path.exist?
        data_url = "http://archive.ics.uci.edu/ml/machine-learning-databases/mushroom/agaricus-lepiota.data"
        download(data_path, data_url)
      end
      CSV.open(data_path) do |csv|
        yield(csv)
      end
    end

    def read_names
      names_path = cache_dir_path + "agaricus-lepiota.names"
      unless names_path.exist?
        names_url = "https://archive.ics.uci.edu/ml/machine-learning-databases//mushroom/agaricus-lepiota.names"
        download(names_path, names_url)
      end
      names_path.read
    end
  end
end
