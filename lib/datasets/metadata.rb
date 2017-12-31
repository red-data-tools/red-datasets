module Datasets
  class Metadata < Struct.new(:name,
                              :url,
                              :license,
                              :description)
  end
end
