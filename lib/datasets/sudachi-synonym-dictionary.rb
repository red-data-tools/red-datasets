require "csv"

require_relative "dataset"

module Datasets
  class SudachiSynonymDictionary < Dataset
    class Synonym < Struct.new(:group_id,
                               :is_noun,
                               :expansion_type,
                               :lexeme_id,
                               :form_type,
                               :acronym_type,
                               :variant_type,
                               :categories,
                               :notation)
      alias_method :noun?, :is_noun
    end

    def initialize
      super()
      @metadata.id = "sudachi-synonym-dictionary"
      @metadata.name = "Sudachi synonym dictionary"
      @metadata.url = "https://github.com/WorksApplications/SudachiDict/blob/develop/docs/synonyms.md"
      @metadata.licenses = ["Apache-2.0"]
      @metadata.description = lambda do
        download_description
      end
    end

    def each
      return to_enum(__method__) unless block_given?

      lexeme_id_context = {}
      open_data do |csv|
        csv.each do |row|
          group_id = row[0]
          if group_id != lexeme_id_context[:group_id]
            lexeme_id_context[:group_id] = group_id
            lexeme_id_context[:counter] = 0
          end
          is_noun = (row[1] == "1")
          expansion_type = normalize_expansion_type(row[2])
          lexeme_id = normalize_lexeme_id(row[3], lexeme_id_context)
          form_type = normalize_form_type(row[4])
          acronym_type = normalize_acronym_type(row[5])
          variant_type = normalize_variant_type(row[6])
          categories = normalize_categories(row[7])
          notation = row[8]
          synonym = Synonym.new(group_id,
                                is_noun,
                                expansion_type,
                                lexeme_id,
                                form_type,
                                acronym_type,
                                variant_type,
                                categories,
                                notation)
          yield(synonym)
        end
      end
    end

    private
    def open_data
      data_path = cache_dir_path + "synonyms.txt"
      data_url = "https://raw.githubusercontent.com/WorksApplications/SudachiDict/develop/src/main/text/synonyms.txt"
      download(data_path, data_url)
      CSV.open(data_path,
               encoding: "UTF-8",
               skip_blanks: true) do |csv|
        yield(csv)
      end
    end

    def download_description
      description_path = cache_dir_path + "synonyms.md"
      description_url = "https://raw.githubusercontent.com/WorksApplications/SudachiDict/develop/docs/synonyms.md"
      download(description_path, description_url)
      description_path.read
    end

    def normalize_expansion_type(type)
      case type
      when "0", ""
        :always
      when "1"
        :expanded
      when "2"
        :never
      else
        raise Error, "unknown expansion type: #{type.inspect}"
      end
    end

    def normalize_lexeme_id(id, context)
      case id
      when ""
        lexeme_id_context[:counter] += 1
        lexeme_id_context[:counter]
      else
        # Use only the first lexeme ID.
        # Example:
        #   000116,1,0,1/2,0,2,0,(IT/娯楽),ネットゲー,,
        #   000116,1,0,1/2,0,2,0,(IT/娯楽),ネトゲ,,
        Integer(id.split("/").first, 10)
      end
    end

    def normalize_form_type(type)
      case type
      when "0", ""
        :typical
      when "1"
        :translation
      when "2"
        :alias
      when "3"
        :old_name
      when "4"
        :misnomer
      else
        raise Error, "unknown form type: #{type.inspect}"
      end
    end

    def normalize_acronym_type(type)
      case type
      when "0", ""
        :typical
      when "1"
        :alphabet
      when "2"
        :others
      else
        raise Error, "unknown acronym type: #{type.inspect}"
      end
    end

    def normalize_variant_type(type)
      case type
      when "0", ""
        :typical
      when "1"
        :alphabet
      when "2"
        :general
      when "3"
        :misspelled
      else
        raise Error, "unknown variant type: #{type.inspect}"
      end
    end

    def normalize_categories(categories)
      case categories
      when ""
        nil
      when /\A\((.*)\)\z/
        $1.split("/")
      else
        raise Error, "invalid categories: #{categories.inspect}"
      end
    end
  end
end
