require_relative 'mnist'

module Datasets
  class FashionMNIST < MNIST
    BASE_URL = "http://fashion-mnist.s3-website.eu-central-1.amazonaws.com/"

    private
    def dataset_name
      "Fashion-MNIST"
    end

    def licenses
      ["MIT"]
    end
  end
end
