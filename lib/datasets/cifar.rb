require_relative "tar-gz-readable"
require_relative "dataset"

module Datasets
  class CIFAR < Dataset
    include TarGzReadable

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

    class Record10 < Struct.new(:data, :label)
      include Pixelable
    end

    class Record100 < Struct.new(:data, :coarse_label, :fine_label)
      include Pixelable
    end

    def initialize(n_classes: 10, type: :train)
      unless [10, 100].include?(n_classes)
        message = "Please set n_classes 10 or 100: #{n_classes.inspect}"
        raise ArgumentError, message
      end
      unless [:train, :test].include?(type)
        message = "Please set type :train or :test: #{type.inspect}"
        raise ArgumentError, message
      end

      super()

      @metadata.id = "cifar-#{n_classes}"
      @metadata.name = "CIFAR-#{n_classes}"
      @metadata.url = "https://www.cs.toronto.edu/~kriz/cifar.html"
      @metadata.description = "CIFAR-#{n_classes} is 32x32 image dataset"

      @n_classes = n_classes
      @type = type
    end

    def each(&block)
      return to_enum(__method__) unless block_given?

      data_path = cache_dir_path + "cifar-#{@n_classes}.tar.gz"
      data_url = "https://www.cs.toronto.edu/~kriz/cifar-#{@n_classes}-binary.tar.gz"
      download(data_path, data_url)

      parse_data(data_path, &block)
    end

    private

    def parse_data(data_path, &block)
      open_tar_gz(data_path) do |tar|
        target_file_names.each do |target_file_name|
          tar.seek(target_file_name) do |entry|
            parse_entry(entry, &block)
          end
        end
      end
    end

    def target_file_names
      case @n_classes
      when 10
        prefix = 'cifar-10-batches-bin'
        case @type
        when :train
          [
            "#{prefix}/data_batch_1.bin",
            "#{prefix}/data_batch_2.bin",
            "#{prefix}/data_batch_3.bin",
            "#{prefix}/data_batch_4.bin",
            "#{prefix}/data_batch_5.bin",
          ]
        when :test
          [
            "#{prefix}/test_batch.bin"
          ]
        end
      when 100
        prefix = "cifar-100-binary"
        case @type
        when :train
          [
            "#{prefix}/train.bin",
          ]
        when :test
          [
            "#{prefix}/test.bin",
          ]
        end
      end
    end

    def parse_entry(entry)
      case @n_classes
      when 10
        loop do
          label = entry.read(1)
          break if label.nil?
          label = label.unpack("C")[0]
          data = entry.read(3072)
          yield Record10.new(data, label)
        end
      when 100
        loop do
          coarse_label = entry.read(1)
          break if coarse_label.nil?
          coarse_label = coarse_label.unpack("C")[0]
          fine_label = entry.read(1).unpack("C")[0]
          data = entry.read(3072)
          yield Record100.new(data, coarse_label, fine_label)
        end
      end
    end
  end
end

