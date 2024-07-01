require_relative 'mnist'

module Datasets
  class KuzushijiMNIST < MNIST
    private
    def base_urls
      [
        "http://codh.rois.ac.jp/kmnist/dataset/kmnist/",
      ]
    end

    def dataset_name
      "Kuzushiji-MNIST"
    end

    def licenses
      ["CC-BY-SA-4.0"]
    end
  end
end
