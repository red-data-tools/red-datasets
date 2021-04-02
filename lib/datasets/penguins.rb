require_relative "dataset"

module Datasets
  module PenguinsRawData
    Record = Struct.new(:study_name,
                        :sample_number,
                        :species,
                        :region,
                        :island,
                        :stage,
                        :individual_id,
                        :clutch_completion,
                        :date_egg,
                        :culmen_length_mm,
                        :culmen_depth_mm,
                        :flipper_length_mm,
                        :body_mass_g,
                        :sex,
                        :delta_15_n_permil,
                        :delta_13_c_permil,
                        :comments)

    class SpeciesBase < Dataset
      def initialize
        super
        species = self.class.name.split("::").last.downcase
        @metadata.id = "palmerpenguins-raw-#{species}"
        @metadata.url = self.class::URL
        @metadata.licenses = ["CC0"]
        @data_path = cache_dir_path + "penguins" + (species + ".csv")
      end

      attr_reader :data_path

      def each
        return to_enum(__method__) unless block_given?

        open_data do |csv|
          csv.each do |row|
            next if row[0].nil?
            record = Record.new(*row.fields)
            yield record
          end
        end
      end

      private def open_data
        download unless data_path.exist?
        CSV.open(data_path, headers: :first_row, converters: :all) do |csv|
          yield csv
        end
      end

      private def download
        super(data_path, metadata.url)
      end
    end

    # Adelie penguin data from: https://doi.org/10.6073/pasta/abc50eed9138b75f54eaada0841b9b86
    class Adelie < SpeciesBase
      DOI = "doi.org/10.6073/pasta/abc50eed9138b75f54eaada0841b9b86".freeze
      URL = "https://portal.edirepository.org/nis/dataviewer?packageid=knb-lter-pal.219.3&entityid=002f3893385f710df69eeebe893144ff".freeze
    end

    # Gentoo penguin data from: https://doi.org/10.6073/pasta/2b1cff60f81640f182433d23e68541ce
    class Gentoo < SpeciesBase
      DOI = "doi.org/10.6073/pasta/2b1cff60f81640f182433d23e68541ce".freeze
      URL = "https://portal.edirepository.org/nis/dataviewer?packageid=knb-lter-pal.220.3&entityid=e03b43c924f226486f2f0ab6709d2381".freeze
    end

    # Chinstrap penguin data from: https://doi.org/10.6073/pasta/409c808f8fc9899d02401bdb04580af7
    class Chinstrap < SpeciesBase
      DOI = "doi.org/10.6073/pasta/409c808f8fc9899d02401bdb04580af7".freeze
      URL = "https://portal.edirepository.org/nis/dataviewer?packageid=knb-lter-pal.221.2&entityid=fe853aa8f7a59aa84cdd3197619ef462".freeze
    end
  end

  # This dataset provides the same dataset as https://github.com/allisonhorst/palmerpenguins
  class Penguins < Dataset
    Record = Struct.new(:species,
                        :island,
                        :bill_length_mm,
                        :bill_depth_mm,
                        :flipper_length_mm,
                        :body_mass_g,
                        :sex,
                        :year)

    def initialize
      super
      @metadata.id = "palmerpenguins"
      @metadata.name = "palmerpenguins"
      @metadata.url = "https://allisonhorst.github.io/palmerpenguins/"
      @metadata.licenses = ["CC0"]
      @metadata.description = "A great dataset for data exploration & visualization, as an alternative to iris"
    end

    def each(&block)
      return to_enum(__method__) unless block_given?

      species_classes = [
        PenguinsRawData::Adelie,
        PenguinsRawData::Gentoo,
        PenguinsRawData::Chinstrap
      ]

      species_classes.each do |species_class|
        species_class.new.each do |raw_record|
          yield convert_record(raw_record)
        end
      end
    end

    private def convert_record(raw_record)
      Record.new(raw_record.species.split(' ')[0],
                 raw_record.island,
                 raw_record.culmen_length_mm,
                 raw_record.culmen_depth_mm,
                 raw_record.flipper_length_mm&.to_i,
                 raw_record.body_mass_g&.to_i,
                 raw_record.sex&.downcase,
                 raw_record.date_egg&.year)
    end
  end
end
