require "csv"
require "fileutils"
require "open-uri"
require "pathname"

module Datasets
  class Iris
    Record = Struct.new(:sepal_length,
                        :sepal_width,
                        :petal_length,
                        :petal_width,
                        :class)

    def each
      return to_enum(__method__) unless block_given?

      open_csv do |csv|
        csv.each do |row|
          next if row[0].nil?
          record = Record.new(*row)
          yield(record)
        end
      end
    end

    private
    def cache_dir_path
      case RUBY_PLATFORM
      when /mswin/, /mingw/
        base_dir = ENV["LOCALAPPDATA"] || "~/AppData"
      when /darwin/
        base_dir = "~/Library/Caches"
      else
        base_dir = ENV["XDG_CACHE_HOME"] || "~/.cache"
      end
      Pathname(base_dir).expand_path + "red-datasets" + "iris"
    end

    def data_path
      @data_path ||= cache_dir_path + "iris.csv"
    end

    def open_csv
      download unless data_path.exist?
      CSV.open(data_path, converters: [:numeric]) do |csv|
        yield(csv)
      end
    end

    def download
      data_path.parent.mkpath
      begin
        open("https://archive.ics.uci.edu/ml/machine-learning-databases/iris/iris.data") do |input|
          data_path.open("wb") do |output|
            IO.copy_stream(input, output)
          end
        end
      rescue
        FileUtils.rm_f(data_path)
        raise
      end
    end
  end
end
