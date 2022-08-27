require_relative "license"

module Datasets
  class Metadata < Struct.new(:id,
                              :name,
                              :url,
                              :licenses,
                              :description)
    def licenses=(licenses)
      licenses = [licenses] unless licenses.is_a?(Array)
      licenses = licenses.collect do |license|
        l = License.try_convert(license)
        if l.nil?
          raise ArgumentError.new("invalid license: #{license.inspect}")
        end
        l
      end
      super(licenses)
    end

    def description
      description_raw = super
      if description_raw.respond_to?(:call)
        self.description = description_raw = description_raw.call
      end
      description_raw
    end
  end
end
