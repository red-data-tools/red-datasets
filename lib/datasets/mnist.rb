require 'zlib'

require_relative "dataset"


module Datasets
  class MNIST < Dataset

    Record = Struct.new(:pixels, :label)

    def initialize(type: :train)
      unless [:train, :test].include?(type)
        raise 'Please set type :train or :test'
      end

      super()

      @metadata.name = "mnist-#{type}"
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
      images = parse_images(image_path)
      lables = parse_labels(label_path)
      images.zip(lables) do |row|
        pixels = row[0]
        label = row[1]
        yield Record.new(pixels, label)
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

    def parse_images(file_path)
      n_rows, n_cols = 0, 0
      Zlib::GzipReader.open(file_path) do |f|
        magic, n_images = f.read(8).unpack('N2')
        n_rows, n_cols = f.read(8).unpack('N2')
        n_images.times.collect do
          f.read(n_rows * n_cols).unpack('C*')
        end
      end
    end

    def parse_labels(file_path)
      Zlib::GzipReader.open(file_path) do |f|
        magic, n_labels = f.read(8).unpack('N2')
        f.read(n_labels).unpack('C*')
      end
    end
  end
end