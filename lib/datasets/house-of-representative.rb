require_relative "dataset"
require_relative "japanese-date-parser"

module Datasets
  class HouseOfRepresentative < Dataset
    Record = Struct.new(:carry_time,
                        :caption,
                        :type,
                        :submit_time,
                        :submit_number,
                        :title,
                        :discussion_status,
                        :progress,
                        :progress_url,
                        :text,
                        :text_url,
                        :bill_type,
                        :submitter,
                        :submitter_in_house_groups,
                        :house_of_representatives_of_accepted_bill_on_preliminary_consideration,
                        :house_of_representatives_of_preliminary_refer_on,
                        :house_of_representatives_of_preliminary_refer_commission,
                        :house_of_representatives_of_accepted_bill_on,
                        :house_of_representatives_of_refer_on,
                        :house_of_representatives_of_refer_commission,
                        :house_of_representatives_of_finished_consideration_on,
                        :house_of_representatives_of_consideration_result,
                        :house_of_representatives_of_finished_deliberation_on,
                        :house_of_representatives_of_deliberation_result,
                        :house_of_representatives_of_attitude_of_in_house_group_during_deliberation,
                        :house_of_representatives_of_support_in_house_group_during_deliberation,
                        :house_of_representatives_of_opposition_in_house_group_during_deliberation,
                        :house_of_councillors_of_accepted_bill_on_preliminary_consideration,
                        :house_of_councillors_of_preliminary_refer_on,
                        :house_of_councillors_of_preliminary_refer_commission,
                        :house_of_councillors_of_accepted_bill_on,
                        :house_of_councillors_of_refer_on,
                        :house_of_councillors_of_refer_commission,
                        :house_of_councillors_of_finished_consideration_on,
                        :house_of_councillors_of_consideration_result,
                        :house_of_councillors_of_finished_deliberation_on,
                        :house_of_councillors_of_deliberation_result,
                        :promulgated_on,
                        :law_number,
                        :submitters,
                        :supporters_of_submitted_bill)

    def initialize
      super()

      @metadata.id = "house-of-representative"
      @metadata.name = "Bill of the House of Representatives of Japan"
      @metadata.url = "https://smartnews-smri.github.io/house-of-representatives"
      @metadata.licenses = ["MIT"]
      @metadata.description = "Bill of the House of Representatives of Japan"
    end

    def each
      return to_enum(__method__) unless block_given?

      open_data do |csv|
        csv.each do |row|
          record = Record.new(*row.fields)
          yield(record)
        end
      end
    end

    private

    def open_data
      data_url = "https://raw.githubusercontent.com/smartnews-smri/house-of-representatives/main/data/gian.csv"
      data_path = cache_dir_path + "gian.csv"
      download(data_path, data_url)

      parser = JapaneseDateParser.new
      japanese_date_converter = lambda do |field, info|
        if info.header.end_with?("年月日")
          parser.parse(field)
        else
          field
        end
      end
      array_converter = lambda do |field, info|
        case info.header
        when "議案提出会派", "衆議院審議時賛成会派", "衆議院審議時反対会派", "議案提出者一覧", "議案提出の賛成者"
          parse_array(field)
        else
          field
        end
      end
      File.open(data_path) do |data_file|
        options = {
          col_sep: ",",
          headers: true,
          converters: [:integer, japanese_date_converter, array_converter],
        }
        # There are two columns within one column. To split into two columns, `#gsub` is necessary.
        yield(CSV.new(data_file.read.gsub("／", ","), **options))
      end
    end

    def parse_array(column_value)
      column_value&.split("; ")
    end
  end
end
