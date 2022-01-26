module Datasets
  class FuelEconomy < Dataset
    Record = Struct.new(:manufacturer,
                        :model,
                        :displacement,
                        :year,
                        :n_cylinders,
                        :transmission,
                        :drive_train,
                        :city_mpg,
                        :highway_mpg,
                        :fuel,
                        :type)

    def initialize()
      super()
      @metadata.id = "fuel-economy"
      @metadata.name = "Fuel economy"
      @metadata.licenses = ["CC0-1.0"]
      @metadata.url = "https://ggplot2.tidyverse.org/reference/mpg.html"
      @metadata.description = lambda do
        fetch_description
      end
    end

    def each
      return to_enum(__method__) unless block_given?

      data_path = cache_dir_path + "mpg.csv"
      data_url = "https://github.com/tidyverse/ggplot2/raw/main/data-raw/mpg.csv"
      download(data_path, data_url)
      CSV.open(data_path, headers: :first_row, converters: :all) do |csv|
        csv.each do |row|
          record = Record.new(*row.fields)
          yield record
        end
      end
    end

    private
    def fetch_description
      data_r_path = cache_dir_path + "data.R"
      data_r_url = "https://github.com/tidyverse/ggplot2/raw/main/R/data.R"
      download(data_r_path, data_r_url)
      descriptions = {}
      comment = ""
      File.open(data_r_path) do |data_r|
        data_r.each_line do |line|
          case line.chomp
          when /\A#'/
            comment_content = Regexp.last_match.post_match
            unless comment_content.empty?
              comment_content = comment_content[1..-1]
            end
            comment << comment_content
            comment << "\n"
          when /\A"(.+)"\z/
            name = Regexp.last_match[1]
            descriptions[name] = parse_roxygen(comment.rstrip)
            comment = ""
          end
        end
        descriptions["mpg"]
      end
    end

    COLUMN_NAME_MAPPING = {
      "displ" => "displacement",
      "cyl" => "n_cylinders",
      "trans" => "transmissions",
      "drv" => "drive_train",
      "cty" => "city_mpg",
      "hwy" => "highway_mpg",
      "fl" => "fuel",
      "class" => "type",
    }
    def parse_roxygen(roxygen)
      roxygen
        .gsub(/\\url\{(.*?)\}/, "\\1")
        .gsub(/^@format /, "")
        .gsub(/\\describe\{(.*)\}/m) do
        content = $1
        content.gsub(/\\item\{(.*?)\}\{(.*?)\}/) do
          column_name = $1
          description = $2
          column_name = COLUMN_NAME_MAPPING[column_name] || column_name
          "* #{column_name}: #{description}"
        end
      end
    end
  end
end
