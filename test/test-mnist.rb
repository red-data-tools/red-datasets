class MnistTest < Test::Unit::TestCase
  include Helper::Sandbox

  def setup_data
    setup_sandbox

    def @dataset.cache_dir_path
      @cache_dir_path
    end

    def @dataset.cache_dir_path=(path)
      @cache_dir_path = path
    end
    @dataset.cache_dir_path = @tmp_dir

    def @dataset.download(output_path, url)

      directory = (Pathname.new(__dir__) + "tmp").expand_path
      image_paths = ["#{directory}/train-images-idx3-ubyte.gz",
                     "#{directory}/t10k-images-idx3-ubyte.gz"]
      label_paths = ["#{directory}/train-labels-idx1-ubyte.gz",
                     "#{directory}/t10k-labels-idx1-ubyte.gz"]
      image_num, image_size_x, image_size_y, label = 10, 28, 28, 1

      Zlib::GzipWriter.open(output_path) do |gz|
        if image_paths.include?(output_path.to_s)
          image_data = ([2051, image_num]).pack('N2') +
                       ([image_size_x,image_size_y]).pack('N2') +
                       ([0] * image_size_x * image_size_y).pack("C*") * image_num
          gz.puts(image_data)
        elsif label_paths.include?(output_path.to_s)
          label_data = ([2049, image_num]).pack('N2') +
                       ([label] * image_num).pack("C*")
          gz.puts(label_data)
        end
      end
    end

  end

  def teardown
    teardown_sandbox
  end

  sub_test_case("mnist") do

    sub_test_case("train") do
      def setup
        @dataset = Datasets::Mnist.new(type: :train)
        setup_data()
      end

      test("#each") do

        raw_dataset = @dataset.collect do |record|
          {
            :label => record.label,
            :pixels => record.pixels
          }
        end

        assert_equal([
                       {
                         :label => 1,
                         :pixels => [0] * 28 * 28
                       }
                      ] * 10,
                     raw_dataset)
      end

      test("#to_table") do
        table_data = @dataset.to_table
        assert_equal([[0] * 28 * 28] * 10,
                     table_data[:pixels])
      end

    end

    sub_test_case("test") do

      def setup
        @dataset = Datasets::Mnist.new(type: :test)
        setup_data()
      end

      test("#each") do

        raw_dataset = @dataset.collect do |record|
          {
            :label => record.label,
            :pixels => record.pixels
          }
        end

        assert_equal([
                       {
                         :label => 1,
                         :pixels => [0] * 28 * 28
                       }
                      ] * 10,
                     raw_dataset)
      end

      test("#to_table") do
        table_data = @dataset.to_table
        assert_equal([[0] * 28 * 28] * 10,
                     table_data[:pixels])
      end

    end

  end
end