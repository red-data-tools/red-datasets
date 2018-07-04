require_relative "dataset"

module Datasets
  class PennTreebank < Dataset
    Record = Struct.new(:word, :id)

    TRAIN_URL = "https://raw.githubusercontent.com/wojzaremba/lstm/master/data/ptb.train.txt"
    TEST_URL = "https://raw.githubusercontent.com/wojzaremba/lstm/master/data/ptb.test.txt"
    VALID_URL = "https://raw.githubusercontent.com/wojzaremba/lstm/master/data/ptb.valid.txt"

    DESCRIPTION = <<~DESC
      `Penn Tree Bank <https://www.cis.upenn.edu/~treebank/>`_ is originally a
      corpus of English sentences with linguistic structure annotations. This
      function uses a variant distributed at
      `https://github.com/wojzaremba/lstm <https://github.com/wojzaremba/lstm>`_,
      which omits the annotation and splits the dataset into three parts:
      training, validation, and test.
    DESC

    def initialize(type: :train)
      super()

      @metadata.name = "PennTreebank"
      @metadata.description = DESCRIPTION
      @metadata.url = "https://github.com/wojzaremba/lstm"
      @metadata.licenses = ["Apache-2.0"]

      @type = type
    end

    def each(&block)
      return to_enum(__method__) unless block_given?

      data_path = cache_dir_path + "ptb-#{@type}.txt"
      unless data_path.exist?
        download(data_path, data_url(@type))
      end

      parse_data(data_path, &block)
    end

    def parse_data(data_path)
      index = 0
      vocabulary = {}
      File.open(data_path) do |f|
        f.each_line do |line|
          line.split.each do |word|
            word = word.strip
            unless vocabulary.key?(word)
              vocabulary[word] = index
              index += 1
            end
            yield(Record.new(word, index))
          end
        end
      end
    end

    def data_url(type)
      case type
      when :train
        TRAIN_URL
      when :test
        TEST_URL
      when :valid
        VALID_URL
      else
        raise ArgumentError, "Invalid type: #{type}, please choose from [:train, :test, :valid]"
      end
    end
  end
end
