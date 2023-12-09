require_relative "version"

module Datasets
  class LazyLoader
    def initialize
      @constants = {}
    end

    def exist?(constant_name)
      @constants.key?(constant_name)
    end

    def load(constant_name)
      feature = @constants[constant_name]
      raise LoadError, "unknown dataset: #{constant_name}" unless feature
      require feature
    end

    def load_all
      @constants.each_value do |feature|
        require feature
      end
    end

    def register(constant_name, feature)
      @constants[constant_name] = feature
    end

    def constant_names
      @constants.keys
    end
  end

  LAZY_LOADER = LazyLoader.new

  class << self
    def const_missing(name)
      if LAZY_LOADER.exist?(name)
        LAZY_LOADER.load(name)
        const_get(name)
      else
        super
      end
    end
  end

  LAZY_LOADER.register(:Adult, "datasets/adult")
  LAZY_LOADER.register(:AFINN, "datasets/afinn")
  LAZY_LOADER.register(:AozoraBunko, "datasets/aozora-bunko")
  LAZY_LOADER.register(:CaliforniaHousing, "datasets/california-housing")
  LAZY_LOADER.register(:CIFAR, "datasets/cifar")
  LAZY_LOADER.register(:CLDRPlurals, "datasets/cldr-plurals")
  LAZY_LOADER.register(:Communities, "datasets/communities")
  LAZY_LOADER.register(:Diamonds, "datasets/diamonds")
  LAZY_LOADER.register(:EStatJapan, "datasets/e-stat-japan")
  LAZY_LOADER.register(:FashionMNIST, "datasets/fashion-mnist")
  LAZY_LOADER.register(:FuelEconomy, "datasets/fuel-economy")
  LAZY_LOADER.register(:Geolonia, "datasets/geolonia")
  LAZY_LOADER.register(:Hepatitis, "datasets/hepatitis")
  LAZY_LOADER.register(:HouseOfCouncillor, "datasets/house-of-councillor")
  LAZY_LOADER.register(:HouseOfRepresentative, "datasets/house-of-representative")
  LAZY_LOADER.register(:Iris, "datasets/iris")
  LAZY_LOADER.register(:ITACorpus, "datasets/ita-corpus")
  LAZY_LOADER.register(:KuzushijiMNIST, "datasets/kuzushiji-mnist")
  LAZY_LOADER.register(:LIBSVM, "datasets/libsvm")
  LAZY_LOADER.register(:LIBSVMDatasetList, "datasets/libsvm-dataset-list")
  LAZY_LOADER.register(:LivedoorNews, "datasets/livedoor-news")
  LAZY_LOADER.register(:MNIST, "datasets/mnist")
  LAZY_LOADER.register(:Mushroom, "datasets/mushroom")
  LAZY_LOADER.register(:NagoyaUniversityConversationCorpus,
                       "datasets/nagoya-university-conversation-corpus")
  LAZY_LOADER.register(:Penguins, "datasets/penguins")
  LAZY_LOADER.register(:PennTreebank, "datasets/penn-treebank")
  LAZY_LOADER.register(:PMJTDatasetList, "datasets/pmjt-dataset-list")
  LAZY_LOADER.register(:PostalCodeJapan, "datasets/postal-code-japan")
  LAZY_LOADER.register(:QuoraDuplicateQuestionPair,
                       "datasets/quora-duplicate-question-pair")
  LAZY_LOADER.register(:RdatasetList, "datasets/rdataset")
  # For backward compatibility
  LAZY_LOADER.register(:RdatasetsList, "datasets/rdataset")
  LAZY_LOADER.register(:Rdataset, "datasets/rdataset")
  # For backward compatibility
  LAZY_LOADER.register(:Rdatasets, "datasets/rdataset")
  LAZY_LOADER.register(:SeabornList, "datasets/seaborn")
  LAZY_LOADER.register(:Seaborn, "datasets/seaborn")
  LAZY_LOADER.register(:SudachiSynonymDictionary,
                       "datasets/sudachi-synonym-dictionary")
  LAZY_LOADER.register(:Wikipedia, "datasets/wikipedia")
  LAZY_LOADER.register(:WikipediaKyotoJapaneseEnglish,
                       "datasets/wikipedia-kyoto-japanese-english")
  LAZY_LOADER.register(:Wine, "datasets/wine")
end
