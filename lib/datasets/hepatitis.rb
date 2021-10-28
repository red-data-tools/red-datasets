require "csv"

require_relative "dataset"

module Datasets
  class Hepatitis < Dataset
    class Record < Struct.new(:label,
                              :age,
                              :sex,
                              :steroid,
                              :antivirals,
                              :fatigue,
                              :malaise,
                              :anorexia,
                              :liver_big,
                              :liver_firm,
                              :spleen_palpable,
                              :spiders,
                              :ascites,
                              :varices,
                              :bilirubin,
                              :alkaline_phosphate,
                              :sgot,
                              :albumin,
                              :protime,
                              :histology)
      def initialize(*values)
        super()
        members.zip(values) do |member, value|
          __send__("#{member}=", value)
        end
      end

      def label=(label)
        case label
        when "1"
          super(:die)
        when "2"
          super(:live)
        else
          super(label)
        end
      end

      def age=(age)
        super(normalize_integer(age))
      end

      def sex=(sex)
        case sex
        when "1"
          super(:male)
        when "2"
          super(:female)
        else
          super(sex)
        end
      end

      def steroid=(steroid)
        super(normalize_boolean(steroid))
      end

      def antivirals=(antivirals)
        super(normalize_boolean(antivirals))
      end

      def fatigue=(fatigue)
        super(normalize_boolean(fatigue))
      end

      def malaise=(malaise)
        super(normalize_boolean(malaise))
      end

      def anorexia=(anorexia)
        super(normalize_boolean(anorexia))
      end

      def liver_big=(liver_big)
        super(normalize_boolean(liver_big))
      end

      def liver_firm=(liver_firm)
        super(normalize_boolean(liver_firm))
      end

      def spleen_palpable=(spleen_palpable)
        super(normalize_boolean(spleen_palpable))
      end

      def spiders=(spiders)
        super(normalize_boolean(spiders))
      end

      def ascites=(ascites)
        super(normalize_boolean(ascites))
      end

      def varices=(varices)
        super(normalize_boolean(varices))
      end

      def bilirubin=(bilirubin)
        super(normalize_float(bilirubin))
      end

      def alkaline_phosphate=(alkaline_phosphate)
        super(normalize_integer(alkaline_phosphate))
      end

      def sgot=(sgot)
        super(normalize_integer(sgot))
      end

      def albumin=(albumin)
        super(normalize_float(albumin))
      end

      def protime=(protime)
        super(normalize_integer(protime))
      end

      def histology=(histology)
        super(normalize_boolean(histology))
      end

      private
      def normalize_boolean(value)
        case value
        when "?"
          nil
        when "1"
          false
        when "2"
          true
        else
          value
        end
      end

      def normalize_float(value)
        case value
        when "?"
          nil
        else
          Float(value)
        end
      end

      def normalize_integer(value)
        case value
        when "?"
          nil
        else
          Integer(value, 10)
        end
      end
    end

    def initialize
      super()
      @metadata.id = "hepatitis"
      @metadata.name = "Hepatitis"
      @metadata.url = "https://archive.ics.uci.edu/ml/datasets/hepatitis"
      @metadata.licenses = ["CC-BY-4.0"]
      @metadata.description = lambda do
        read_names
      end
    end

    def each
      return to_enum(__method__) unless block_given?

      open_data do |csv|
        csv.each do |row|
          record = Record.new(*row)
          yield(record)
        end
      end
    end

    private
    def base_url
      "https://archive.ics.uci.edu/ml/machine-learning-databases/hepatitis"
    end

    def open_data
      data_path = cache_dir_path + "hepatitis.csv"
      data_url = "#{base_url}/hepatitis.data"
      download(data_path, data_url)
      CSV.open(data_path) do |csv|
        yield(csv)
      end
    end

    def read_names
      names_path = cache_dir_path + "hepatitis.names"
      names_url = "#{base_url}/hepatitis.names"
      download(names_path, names_url)
      names_path.read
    end
  end
end
