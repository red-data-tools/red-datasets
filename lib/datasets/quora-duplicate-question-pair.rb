require "csv"

require_relative "dataset"

module Datasets
  class QuoraDuplicateQuestionPair < Dataset
    Record = Struct.new(:id,
                        :first_question_id,
                        :second_question_id,
                        :first_question,
                        :second_question,
                        :duplicated)

    def initialize
      super()
      @metadata.id = "quora_duplicate_question_pair"
      @metadata.name = "quora_duplicate_question_pair"
      @metadata.url = "https://quoradata.quora.com/First-Quora-Dataset-Release-Question-Pairs"
      @metadata.licenses = ["Quora Terms of Service"]
    end

    def each
      return to_enum(__method__) unless block_given?

      open_data do |csv|
        csv.each do |row|
          next if row[0].nil?
          id,
          first_question_id,
          second_question_id,
          first_question,
          second_question,
          duplicated = row.values_at

          record = Record.new(id,
                              first_question_id,
                              second_question_id,
                              first_question,
                              second_question,
                              !duplicated.zero?)
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
