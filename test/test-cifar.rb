class CifarTest < Test::Unit::TestCase
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
        @dataset = Datasets::Cifar.new(class_num: 10, set_type: :train)
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
          }
        end
        assert_equal([
                       {
                         :label => 1,
                         :data => [10] * 3072,
                       },
                       {
                         :label => 2,
                         :data => [20] * 3072,
                       },
                       {
                         :label => 3,
                         :data => [30] * 3072,
                       },
                       {
                         :label => 4,
                         :data => [40] * 3072,
                       },
                       {
                         :label => 5,
                         :data => [50] * 3072,
                       },
                     ],
                     raw_dataset)
      end
    end

    sub_test_case("test") do
      def setup
        @dataset = Datasets::Cifar.new(class_num: 10, set_type: :test)
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
          }
        end
        assert_equal([
                       {
                         :label => 1,
                         :data => [100] * 3072,
                       },
                       {
                         :label => 2,
                         :data => [200] * 3072,
                       },
                     ],
                     raw_dataset)
      end
    end
  end

  sub_test_case("cifar-100") do
    sub_test_case("train") do
      def setup
        @dataset = Datasets::Cifar.new(class_num: 100, set_type: :train)
      end

      test("#each") do
        records = @dataset.to_a
        assert_equal([
                       50000,
                       3072,
                       19,
                     ],
                     [
                       records.size,
                       records[0].data.size,
                       records[0].label,
                     ])
      end
    end

    sub_test_case("test") do
      def setup
        @dataset = Datasets::Cifar.new(class_num: 100, set_type: :test)
      end

      test("#each") do
        records = @dataset.to_a
        assert_equal([
                       10000,
                       3072,
                       49,
                     ],
                     [
                       records.size,
                       records[0].data.size,
                       records[0].label
                     ])
      end
    end
  end
end
