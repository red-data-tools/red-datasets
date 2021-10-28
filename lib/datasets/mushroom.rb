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
      :n_rings,
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
      @metadata.licenses = ["CC-BY-4.0"]
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
          record.members.each do |member|
            record[member] = CONVERTERS[member][record[member]]
          end
          yield(record)
        end
      end
    end

    private
    def open_data
      data_path = cache_dir_path + "agaricus-lepiota.data"
      data_url = "http://archive.ics.uci.edu/ml/machine-learning-databases/mushroom/agaricus-lepiota.data"
      download(data_path, data_url)
      CSV.open(data_path) do |csv|
        yield(csv)
      end
    end

    def read_names
      names_path = cache_dir_path + "agaricus-lepiota.names"
      names_url = "https://archive.ics.uci.edu/ml/machine-learning-databases//mushroom/agaricus-lepiota.names"
      download(names_path, names_url)
      names_path.read
    end

    CONVERTERS = {
      label: {
        "p" => "poisonous",
        "e" => "edible",
      },
      cap_shape: {
        "b" => "bell",
        "c" => "conical",
        "x" => "convex",
        "f" => "flat",
        "k" => "knobbed",
        "s" => "sunken",
      },
      cap_surface: {
        "f" => "fibrous",
        "g" => "grooves",
        "y" => "scaly",
        "s" => "smooth",
      },
      cap_color: {
        "n" => "brown",
        "b" => "buff",
        "c" => "cinnamon",
        "g" => "gray",
        "r" => "green",
        "p" => "pink",
        "u" => "purple",
        "e" => "red",
        "w" => "white",
        "y" => "yellow",
      },
      bruises: {
        "t" => "bruises",
        "f" => "no",
      },
      odor: {
        "a" => "almond",
        "l" => "anise",
        "c" => "creosote",
        "y" => "fishy",
        "f" => "foul",
        "m" => "musty",
        "n" => "none",
        "p" => "pungent",
        "s" => "spicy",
      },
      gill_attachment: {
        "a" => "attached",
        "d" => "descending",
        "f" => "free",
        "n" => "notched",
      },
      gill_spacing: {
        "c" => "close",
        "w" => "crowded",
        "d" => "distant",
      },
      gill_size: {
        "b" => "broad",
        "n" => "narrow",
      },
      gill_color: {
        "k" => "black",
        "n" => "brown",
        "b" => "buff",
        "h" => "chocolate",
        "g" => "gray",
        "r" => "green",
        "o" => "orange",
        "p" => "pink",
        "u" => "purple",
        "e" => "red",
        "w" => "white",
        "y" => "yellow",
      },
      stalk_shape: {
        "e" => "enlarging",
        "t" => "tapering",
      },
      stalk_root: {
        "b" => "bulbous",
        "c" => "club",
        "u" => "cup",
        "e" => "equal",
        "z" => "rhizomorphs",
        "r" => "rooted",
        "?" => "missing",
      },
      stalk_surface_above_ring: {
        "f" => "fibrous",
        "y" => "scaly",
        "k" => "silky",
        "s" => "smooth",
      },
      stalk_surface_below_ring: {
        "f" => "fibrous",
        "y" => "scaly",
        "k" => "silky",
        "s" => "smooth",
      },
      stalk_color_above_ring: {
        "n" => "brown",
        "b" => "buff",
        "c" => "cinnamon",
        "g" => "gray",
        "o" => "orange",
        "p" => "pink",
        "e" => "red",
        "w" => "white",
        "y" => "yellow",
      },
      stalk_color_below_ring: {
        "n" => "brown",
        "b" => "buff",
        "c" => "cinnamon",
        "g" => "gray",
        "o" => "orange",
        "p" => "pink",
        "e" => "red",
        "w" => "white",
        "y" => "yellow",
      },
      veil_type: {
        "p" => "partial",
        "u" => "universal",
      },
      veil_color: {
        "n" => "brown",
        "o" => "orange",
        "w" => "white",
        "y" => "yellow",
      },
      n_rings: {
        "n" => 0,
        "o" => 1,
        "t" => 2,
      },
      ring_type: {
        "c" => "cobwebby",
        "e" => "evanescent",
        "f" => "flaring",
        "l" => "large",
        "n" => "none",
        "p" => "pendant",
        "s" => "sheathing",
        "z" => "zone",
      },
      spore_print_color: {
        "k" => "black",
        "n" => "brown",
        "b" => "buff",
        "h" => "chocolate",
        "r" => "green",
        "o" => "orange",
        "u" => "purple",
        "w" => "white",
        "y" => "yellow",
      },
      population: {
        "a" => "abundant",
        "c" => "clustered",
        "n" => "numerous",
        "s" => "scattered",
        "v" => "several",
        "y" => "solitary",
      },
      habitat: {
        "g" => "grasses",
        "l" => "leaves",
        "m" => "meadows",
        "p" => "paths",
        "u" => "urban",
        "w" => "waste",
        "d" => "woods",
      }
    }
  end
end
