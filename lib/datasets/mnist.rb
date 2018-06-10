require 'zlib'

require_relative "dataset"


module Datasets
  class MNIST < Dataset
    module Pixelable
      def pixels
        data.unpack("C*")
      end

      def to_h
        hash = super
        hash[:pixels] = pixels
        hash
      end
    end

    class Record < Struct.new(:data, :label)
      include Pixelable
    end

    def initialize(type: :train)
      unless [:train, :test].include?(type)
        raise 'Please set type :train or :test'
      end

      super()

      @metadata.name = "MNIST-#{type}"
      @metadata.url = "http://yann.lecun.com/exdb/mnist/"
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

      image_path = cache_dir_path + target_file(:img)
      label_path = cache_dir_path + target_file(:label)
      base_url = "http://yann.lecun.com/exdb/mnist/"

      unless image_path.exist?
        download(image_path, base_url + target_file(:img))
      end

      unless label_path.exist?
        download(label_path, base_url + target_file(:label))
      end

      open_data(image_path, label_path, &block)
    end

    private
    def open_data(image_path, label_path, &block)
      labels = parse_labels(label_path)

      Zlib::GzipReader.open(image_path) do |f|
        n_uint32s = 4
        n_bytes = n_uint32s * 4
        magic, n_images, n_rows, n_cols = f.read(n_bytes).unpack("N*")
        raise 'This is not MNIST image file' if magic != 2051
        n_images.times.collect do |i|
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
        when :img
          "train-images-idx3-ubyte.gz"
        when :label
          "train-labels-idx1-ubyte.gz"
        end
      when :test
        case data
        when :img
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
        magic, n_labels = f.read(n_bytes).unpack('N2')
        raise 'This is not MNIST label file' if magic != 2049
        f.read(n_labels).unpack('C*')
      end
    end
  end
end
