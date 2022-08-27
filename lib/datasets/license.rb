module Datasets
  class License < Struct.new(:spdx_id,
                             :name,
                             :url)
    class << self
      def try_convert(value)
        case value
        when self
          value
        when String
          license = new
          license.spdx_id = value
          license
        when Hash
          license = new
          license.spdx_id = value[:spdx_id]
          license.name = value[:name]
          license.url = value[:url]
          license
        else
          nil
        end
      end
    end
  end
end
