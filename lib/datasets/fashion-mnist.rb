require_relative 'mnist'

module Datasets
  class FashionMNIST < MNIST
    private
    def base_urls
      [
        "http://fashion-mnist.s3-website.eu-central-1.amazonaws.com/",
      ]
    end

    def dataset_name
      "Fashion-MNIST"
    end

    def licenses
      ["MIT"]
    end
  end
end
