require 'zlib'

require_relative "dataset"

module Datasets
  class MNIST < Dataset
    class Record < Struct.new(:data, :label)
      def pixels
        data.unpack("C*")
      end

      def to_h
        hash = super
        hash[:pixels] = pixels
        hash
      end
    end

    def initialize(type: :train)
      unless [:train, :test].include?(type)
        raise ArgumentError, "Please set type :train or :test: #{type.inspect}"
      end

      super()

      @metadata.id = "#{dataset_name.downcase}-#{type}"
      @metadata.name = "#{dataset_name}: #{type}"
      @metadata.url = base_urls.first
      @metadata.licenses = licenses
      @type = type

      case type
      when :train
        @metadata.description = "a training set of 60,000 examples"
      when :test
        @metadata.description = "a test set of 10,000 examples"
      end
    end

    def each(&block)
      return to_enum(__method__) unless block_given?

      image_path = cache_dir_path + target_file(:image)
      label_path = cache_dir_path + target_file(:label)
      base_url = base_urls.first
      fallback_url = base_urls.second

      begin
        download(image_path, base_url + target_file(:image))
      rescue Net::HTTPClientException => error
        if error.response.code == "403"
          download(image_path, fallback_url + target_file(:image))
        else
          raise error
        end
      end
      begin
        download(label_path, base_url + target_file(:label))
      rescue Net::HTTPClientException => error
        if error.response.code == "403"
          download(label_path, fallback_url + target_file(:label))
        else
          raise error
        end
      end

      open_data(image_path, label_path, &block)
    end

    private
    def base_urls
      [
        "http://yann.lecun.com/exdb/mnist/",
        "https://ossci-datasets.s3.amazonaws.com/mnist/",
      ]
    end

    def licenses
      []
    end

    def open_data(image_path, label_path, &block)
      labels = parse_labels(label_path)

      Zlib::GzipReader.open(image_path) do |f|
        n_uint32s = 4
        n_bytes = n_uint32s * 4
        mnist_magic_number = 2051
        magic, n_images, n_rows, n_cols = f.read(n_bytes).unpack("N*")
        if magic != mnist_magic_number
          raise Error, "This is not #{dataset_name} image file"
        end
        n_images.times do |i|
          data = f.read(n_rows * n_cols)
          label = labels[i]
          yield Record.new(data, label)
        end
      end
    end

    def target_file(data)
      case @type
      when :train
        case data
        when :image
          "train-images-idx3-ubyte.gz"
        when :label
          "train-labels-idx1-ubyte.gz"
        end
      when :test
        case data
        when :image
          "t10k-images-idx3-ubyte.gz"
        when :label
          "t10k-labels-idx1-ubyte.gz"
        end
      end
    end

    def parse_labels(file_path)
      Zlib::GzipReader.open(file_path) do |f|
        n_uint32s = 4
        n_bytes = n_uint32s * 2
        mnist_magic_number = 2049
        magic, n_labels = f.read(n_bytes).unpack('N2')
        if magic != mnist_magic_number
          raise Error, "This is not #{dataset_name} label file"
        end
        f.read(n_labels).unpack('C*')
      end
    end

    def dataset_name
      "MNIST"
    end
  end
end
