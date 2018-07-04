require "rubygems/package"

require_relative "dataset"

module Datasets
  class PennTreebank < Dataset
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

    def initialize(type: :train, keep_vocabulary: false)
      super()

      @metadata.name = "PennTreebank"
      @metadata.description = DESCRIPTION
      @metadata.url = "https://github.com/wojzaremba/lstm"
      @metadata.licenses = ["Apache-2.0"]

      @type = type
      @keep_vocabulary = keep_vocabulary
    end

    def each(&block)
      return to_enum(__method__) unless block_given?

      data_path = cache_dir_path + "ptb-#{@type}.txt"
      unless data_path.exist?
        download(data_path, data_url(@type))
      end

      vocab = {}
      if @keep_vocabulary
        @vocabulary = vocab
      end

      parse_data(data_path, vocab, &block)
      cache_vocabulaty(vocab)
      self
    end

    def vocabulary
      if @keep_vocabulary
        @vocabulary
      else
        vocab_cache_path.each_line.with_index.each_with_object({}) {|(word, index), vocab| vocab[word] = index }
      end
    end

    def parse_data(data_path, vocab, &block)
      index = 0
      File.open(data_path) do |f|
        f.each_line do |line|
          line.split.each do |word|
            word = word.strip
            x = if vocab.has_key?(word)
              vocab[word]
            else
              vocab[word] = index
              index.tap{ index += 1 }
            end
            block.call(x)
          end
        end
      end
    end

    def vocab_cache_path
      cache_dir_path + "ptb-vocab-#{@type}.txt"
    end

    def cache_vocabulaty(vocab)
      if vocab_cache_path.exist?
        File.open(path, "w") do |f|
          vocab.keys.each{|word| f.write(word + "\n") }
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
