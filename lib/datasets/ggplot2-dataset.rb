module Datasets
  class Ggplot2Dataset < Dataset
    def initialize(ggplot2_dataset_name)
      super()
      @ggplot2_dataset_name = ggplot2_dataset_name
      @metadata.url =
        "https://ggplot2.tidyverse.org/reference/#{@ggplot2_dataset_name}.html"
      @metadata.description = lambda do
        fetch_description
      end
    end

    def each
      return to_enum(__method__) unless block_given?

      data_base_name = "#{@ggplot2_dataset_name}.csv"
      data_path = cache_dir_path + data_base_name
      data_url = "#{download_base_url}/data-raw/#{data_base_name}"
      download(data_path, data_url)
      CSV.open(data_path, headers: :first_row, converters: :all) do |csv|
        record_class = self.class::Record
        csv.each do |row|
          record = record_class.new(*row.fields)
          yield record
        end
      end
    end

    private
    def download_base_url
      "https://raw.githubusercontent.com/tidyverse/ggplot2/main"
    end

    def fetch_description
      data_r_base_name = "data.R"
      data_r_path = cache_dir_path + data_r_base_name
      data_r_url = "#{download_base_url}/R/#{data_r_base_name}"
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
        descriptions[@ggplot2_dataset_name]
      end
    end

    def parse_roxygen(roxygen)
      column_name_mapping = self.class::COLUMN_NAME_MAPPING
      roxygen
        .gsub(/\\url\{(.*?)\}/, "\\1")
        .gsub(/^@format /, "")
        .gsub(/\\describe\{(.*)\}/m) do
        content = $1
        content.gsub(/\\item\{(.*?)\}\{(.*?)\}/m) do
          column_name = $1
          description = $2
          column_name = column_name_mapping[column_name] || column_name
          description = description
                          .gsub(/\\\$/, "$")
          "* #{column_name}: #{description}"
        end
      end
    end
  end
end
