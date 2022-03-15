require_relative 'mnist'

module Datasets
  class KuzushijiMNIST < MNIST
    BASE_URL = "http://codh.rois.ac.jp/kmnist/dataset/kmnist/"

    private
    def dataset_name
      "Kuzushiji-MNIST"
    end

    def licenses
      ["CC-BY-SA-4.0"]
    end
  end
end
