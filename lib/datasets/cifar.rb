require_relative "dataset"
require "zlib"
require 'rubygems/package'

module Datasets
  class Cifar < Dataset
    Record = Struct.new(:sepal_length,
                        :sepal_width,
                        :petal_length,
                        :petal_width,
                        :class)

    def initialize(class_num: 10, set_type: :train, with_label: true)
      raise 'Please set class_num 10 or 100' unless [10, 100].include?(class_num)
      super()
      @metadata.name = "CIFAR-#{class_num}"
      @metadata.url = "https://www.cs.toronto.edu/~kriz/cifar.html"
      @metadata.description = "CIFAR-#{class_num} is 32x32 image datasets"

      @class_num = class_num
      @set_type = set_type.to_sym
      @with_label = with_label
    end

    def each
      return to_enum(__method__) unless block_given?

      open_data do |raw|
        yield(raw)
      end
    end

    private 

    def open_data
      filename = "cifar-#{@class_num}.tar.gz"
      compressed_file_path = cache_dir_path + filename
      unless compressed_file_path.exist?
        data_url = "https://www.cs.toronto.edu/~kriz/cifar-#{@class_num}-binary.tar.gz"
        download(compressed_file_path, data_url)
      end

      if @class_num == 10
        if @set_type == :train
          file_names = ["data_batch_1.bin", "data_batch_2.bin", "data_batch_3.bin", "data_batch_4.bin", "data_batch_5.bin"]
        elsif @set_type == :test
          file_names = ["test_batch.bin"]
        end

        open_tar(compressed_file_path) do |tar|
          file_names.each do |file_name|
            entry = tar.find { |e| File.basename(e.full_name) == file_name }
            while b = entry.read(3073) do
              datasets = b.unpack("C*") 
              label = datasets.shift
              yield(@with_label ? [datasets, label] : datasets)
            end
            tar.rewind
          end
        end
      elsif @class_num == 100
        if @set_type == :train
          file_name = "train.bin"
        elsif @set_type == :test
          file_name = "test.bin"
        end

        open_tar(compressed_file_path) do |tar|
          entry = tar.find { |e| File.basename(e.full_name) == file_name }
          while b = entry.read(3074) do
            datasets = b.unpack("C*") 
            # 0: coarse label, 1: fine label
            labels = datasets.shift(2)
            yield(@with_label ? [datasets, labels[1]] : datasets)
          end
        end
      end
    end

    def open_tar(file_path)
      Zlib::GzipReader.open(file_path) do |f|
        Gem::Package::TarReader.new(f) do |tar|
          yield(tar)
        end
      end
    end
  end
end

