module Datasets
  class Metadata < Struct.new(:name,
                              :url,
                              :licenses,
                              :description)
    def description
      description_raw = super
      if description_raw.respond_to?(:call)
        self.description = description_raw = description_raw.call
      end
      description_raw
    end
  end
end
