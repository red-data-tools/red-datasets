require "rubygems/package"
require "zlib"

require_relative "dataset"

module Datasets
  class CIFAR < Dataset
    class CIFAR10Record < Struct.new(:data, :label)
      def pixels
        data.unpack("C*")
      end
    end

    class CIFAR100Record < Struct.new(:data, :coarse_label, :fine_label)
      def pixels
        data.unpack("C*")
      end
    end

    def initialize(n_classes: 10, type: :train)
      unless [10, 100].include?(n_classes)
        raise 'Please set n_classes 10 or 100'
      end
      unless [:train, :test].include?(type)
        raise 'Please set type :train or :test'
      end

      super()

      @metadata.name = "CIFAR-#{n_classes}"
      @metadata.url = "https://www.cs.toronto.edu/~kriz/cifar.html"
      @metadata.description = "CIFAR-#{n_classes} is 32x32 image dataset"

      @n_classes = n_classes
      @type = type
    end

    def each
      return to_enum(__method__) unless block_given?

      open_data do |row|
        klass = if @n_classes == 10
                  CIFAR10Record
                elsif @n_classes == 100
                  CIFAR100Record
                end
        record = klass.new(*row)
        yield(record)
      end
    end

    private

    def open_data
      data_path = cache_dir_path + "cifar-#{@n_classes}.tar.gz"
      unless data_path.exist?
        data_url = "https://www.cs.toronto.edu/~kriz/cifar-#{@n_classes}-binary.tar.gz"
        download(data_path, data_url)
      end

      send("open_cifar#{@n_classes}", data_path) do |*data|
        yield data
      end
    end

    def open_cifar10(data_path)
      if @type == :train
        file_names = [
          "data_batch_1.bin",
          "data_batch_2.bin",
          "data_batch_3.bin",
          "data_batch_4.bin",
          "data_batch_5.bin",
        ]
      elsif @type == :test
        file_names = ["test_batch.bin"]
      end

      open_tar(data_path) do |tar|
        file_names.each do |file_name|
          tar.seek("cifar-10-batches-bin/#{file_name}") do |entry|
            while b = entry.read(3073) do
              label = b.slice!(0)
              yield b, label.getbyte(0)
            end
          end
        end
      end
    end

    def open_cifar100(data_path)
      if @type == :train
        file_name = "train.bin"
      elsif @type == :test
        file_name = "test.bin"
      end

      open_tar(data_path) do |tar|
        tar.seek("cifar-100-binary/#{file_name}") do |entry|
          while b = entry.read(3074) do
            labels = b.slice!(0..1)
            # 0: coarse label, 1: fine label
            yield b, labels.getbyte(0), labels.getbyte(1)
          end
        end
      end
    end

    def open_tar(data_path)
      Zlib::GzipReader.open(data_path) do |f|
        Gem::Package::TarReader.new(f) do |tar|
          yield(tar)
        end
      end
    end
  end
end

