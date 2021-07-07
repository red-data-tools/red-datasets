require "rubygems/package"
require "zlib"

module Datasets
  module TarGzReadable
    def open_tar_gz(data_path)
      Zlib::GzipReader.open(data_path) do |f|
        Gem::Package::TarReader.new(f) do |tar|
          yield(tar)
        end
      end
    end
  end
end
