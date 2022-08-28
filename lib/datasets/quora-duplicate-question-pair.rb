require "csv"

require_relative "dataset"

module Datasets
  class QuoraDuplicateQuestionPair < Dataset
    class Record < Struct.new(:id,
                              :first_question_id,
                              :second_question_id,
                              :first_question,
                              :second_question,
                              :duplicated)
      alias_method :duplicated?, :duplicated
    end

    def initialize
      super()
      @metadata.id = "quora-duplicate-question-pair"
      @metadata.name = "Quora's duplicated question pair dataset"
      @metadata.url = "https://quoradata.quora.com/First-Quora-Dataset-Release-Question-Pairs"
      @metadata.licenses = [
        {
          name: "Quora's Terms of Service",
          url: "https://www.quora.com/about/tos",
        }
      ]
    end

    def each
      return to_enum(__method__) unless block_given?

      open_data do |csv|
        csv.each do |row|
          row["is_duplicate"] = (row["is_duplicate"] == 1)
          record = Record.new(*row.fields)
          yield(record)
        end
      end
    end

    private
    def open_data
      data_path = cache_dir_path + "quora_duplicate_questions.tsv"
      data_url = "https://qim.fs.quoracdn.net/quora_duplicate_questions.tsv"
      download(data_path, data_url)
      CSV.open(data_path, col_sep: "\t", headers: true, converters: :all) do |csv|
        yield(csv)
      end
    end
  end
end
