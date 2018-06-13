class CIFARTest < Test::Unit::TestCase
  include Helper::Sandbox

  def setup_raw_data(data)
    setup_sandbox

    def @dataset.cache_dir_path
      @cache_dir_path
    end
    def @dataset.cache_dir_path=(path)
      @cache_dir_path = path
    end
    @dataset.cache_dir_path = @tmp_dir

    def @dataset.data=(data)
      @data = data
    end
    @dataset.data = data

    def @dataset.download(output_path, url)
      Zlib::GzipWriter.open(output_path) do |gz|
        Gem::Package::TarWriter.new(gz) do |tar|
          @data.each do |path, content|
            if content == :directory
              tar.mkdir(path, 0755)
            else
              tar.add_file_simple(path, 0644, content.bytesize) do |file|
                file.write(content)
              end
            end
          end
        end
      end
    end
  end

  def teardown
    teardown_sandbox
  end

  sub_test_case("cifar-10") do
    def create_data(label, pixel)
      [label].pack("C") + ([pixel] * 3072).pack("C*")
    end

    sub_test_case("train") do
      def setup
        @dataset = Datasets::CIFAR.new(n_classes: 10, type: :train)
        directory = "cifar-10-batches-bin"
        setup_raw_data(directory => :directory,
                       "#{directory}/data_batch_1.bin" => create_data(1, 10),
                       "#{directory}/data_batch_2.bin" => create_data(2, 20),
                       "#{directory}/data_batch_3.bin" => create_data(3, 30),
                       "#{directory}/data_batch_4.bin" => create_data(4, 40),
                       "#{directory}/data_batch_5.bin" => create_data(5, 50),
                       "#{directory}/data_batch_6.bin" => create_data(6, 60))
      end

      test("#each") do
        raw_dataset = @dataset.collect do |record|
          {
            :label => record.label,
            :data => record.data,
            :pixels => record.pixels
          }
        end
        assert_equal([
                       {
                         :label => 1,
                         :data => ([10] * 3072).pack("C*"),
                         :pixels => [10] * 3072
                       },
                       {
                         :label => 2,
                         :data => ([20] * 3072).pack("C*"),
                         :pixels => [20] * 3072
                       },
                       {
                         :label => 3,
                         :data => ([30] * 3072).pack("C*"),
                         :pixels => [30] * 3072
                       },
                       {
                         :label => 4,
                         :data => ([40] * 3072).pack("C*"),
                         :pixels => [40] * 3072
                       },
                       {
                         :label => 5,
                         :data => ([50] * 3072).pack("C*"),
                         :pixels => [50] * 3072
                       },
                     ],
                     raw_dataset)
      end
    end

    sub_test_case("test") do
      def setup
        @dataset = Datasets::CIFAR.new(n_classes: 10, type: :test)
        directory = "cifar-10-batches-bin"
        data = create_data(1, 100) + create_data(2, 200)
        setup_raw_data(directory => :directory,
                       "#{directory}/test_batch.bin" => data)
      end

      test("#each") do
        raw_dataset = @dataset.collect do |record|
          {
            :label => record.label,
            :data => record.data,
            :pixels => record.pixels,
          }
        end
        assert_equal([
                       {
                         :label => 1,
                         :data => ([100] * 3072).pack("C*"),
                         :pixels => [100] * 3072
                       },
                       {
                         :label => 2,
                         :data => ([200] * 3072).pack("C*"),
                         :pixels => [200] * 3072
                       },
                     ],
                     raw_dataset)
      end
    end
  end

  sub_test_case("cifar-100") do
    def create_data(coarse_label, fine_label, pixel)
      [coarse_label, fine_label].pack("C*") + ([pixel] * 3072).pack("C*")
    end

    sub_test_case("train") do
      def setup
        @dataset = Datasets::CIFAR.new(n_classes: 100, type: :train)
        directory = "cifar-100-binary"
        data = create_data(1, 11, 10) + create_data(2, 22, 20)
        setup_raw_data(directory => :directory,
                       "#{directory}/train.bin" => data)
      end

      test("#each") do
        raw_dataset = @dataset.collect do |record|
          {
            :coarse_label => record.coarse_label,
            :fine_label => record.fine_label,
            :data => record.data,
            :pixels => record.pixels,
          }
        end
        assert_equal([
                       {
                         :coarse_label => 1,
                         :fine_label => 11,
                         :data => ([10] * 3072).pack("C*"),
                         :pixels => [10] * 3072
                       },
                       {
                         :coarse_label => 2,
                         :fine_label => 22,
                         :data => ([20] * 3072).pack("C*"),
                         :pixels => [20] * 3072
                       },
                     ],
                     raw_dataset)
      end

      test("#to_table") do
        assert_equal([[10] * 3072, [20] * 3072],
                     @dataset.to_table[:pixels])
      end
    end

    sub_test_case("test") do
      def setup
        @dataset = Datasets::CIFAR.new(n_classes: 100, type: :test)
        directory = "cifar-100-binary"
        data = create_data(1, 11, 100) + create_data(6, 66, 200)
        setup_raw_data(directory => :directory,
                       "#{directory}/test.bin" => data)
      end

      test("#each") do
        raw_dataset = @dataset.collect do |record|
          {
            :coarse_label => record.coarse_label,
            :fine_label => record.fine_label,
            :data => record.data,
            :pixels => record.pixels,
          }
        end
        assert_equal([
                       {
                         :coarse_label => 1,
                         :fine_label => 11,
                         :data => ([100] * 3072).pack("C*"),
                         :pixels => [100] * 3072
                       },
                       {
                         :coarse_label => 6,
                         :fine_label => 66,
                         :data => ([200] * 3072).pack("C*"),
                         :pixels => [200] * 3072
                       },
                     ],
                     raw_dataset)
      end

      test("#to_table") do
        assert_equal([[100] * 3072, [200] * 3072],
                     @dataset.to_table[:pixels])
      end
    end
  end

  sub_test_case("invalid") do
    test("type") do
      invalid_type = :invalid
      message = "Please set type :train or :test: #{invalid_type.inspect}"
      assert_raise(ArgumentError.new(message)) do
        Datasets::CIFAR.new(type: invalid_type)
      end
    end
  end
end
