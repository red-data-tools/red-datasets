require_relative "dataset"

module Datasets
  class PennTreebank < Dataset
    Record = Struct.new(:word, :id)

    DESCRIPTION = <<~DESC
      `Penn Tree Bank <https://www.cis.upenn.edu/~treebank/>`_ is originally a
      corpus of English sentences with linguistic structure annotations. This
      function uses a variant distributed at
      `https://github.com/wojzaremba/lstm <https://github.com/wojzaremba/lstm>`_,
      which omits the annotation and splits the dataset into three parts:
      training, validation, and test.
    DESC

    def initialize(type: :train)
      valid_types = [:train, :test, :valid]
      unless valid_types.include?(type)
        valid_types_label = valid_types.collect(&:inspect).join(", ")
        message = "Type must be one of [#{valid_types_label}]: #{type.inspect}"
        raise ArgumentError, message
      end
      @type = type

      super()

      @metadata.name = "PennTreebank"
      @metadata.description = DESCRIPTION
      @metadata.url = "https://github.com/wojzaremba/lstm"
      @metadata.licenses = ["Apache-2.0"]
    end

    def each(&block)
      return to_enum(__method__) unless block_given?

      base_name = "ptb.#{@type}.txt"
      data_path = cache_dir_path + base_name
      unless data_path.exist?
        base_url = "https://raw.githubusercontent.com/wojzaremba/lstm/master/data"
        download(data_path, "#{base_url}/#{base_name}")
      end

      parse_data(data_path, &block)
    end

    private
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
            yield(Record.new(word, vocabulary[word]))
          end
        end
      end
    end
  end
end
