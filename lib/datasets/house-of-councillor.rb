require_relative "dataset"

module Datasets
  class HouseOfCouncillor < Dataset
    Bill = Struct.new(:council_time,
                      :bill_type,
                      :submit_time,
                      :submit_number,
                      :title,
                      :bill_url,
                      :bill_summary_url,
                      :proposed_bill_url,
                      :proposed_on,
                      :proposed_on_from_house_of_representatives,
                      :proposed_on_to_house_of_representatives,
                      :prior_deliberations_type,
                      :continuation_type,
                      :proposers,
                      :submitter,
                      :submitter_type,
                      :progress_of_house_of_councillors_committees_etc_refer_on,
                      :progress_of_house_of_councillors_committees_etc_committee_etc,
                      :progress_of_house_of_councillors_committees_etc_pass_on,
                      :progress_of_house_of_councillors_committees_etc_result,
                      :progress_of_house_of_councillors_plenary_sitting_pass_on,
                      :progress_of_house_of_councillors_plenary_sitting_result,
                      :progress_of_house_of_councillors_plenary_sitting_committees,
                      :progress_of_house_of_councillors_plenary_sitting_vote_type,
                      :progress_of_house_of_councillors_plenary_sitting_vote_method,
                      :progress_of_house_of_councillors_plenary_sitting_result_url,
                      :progress_of_house_of_representatives_committees_etc_refer_on,
                      :progress_of_house_of_representatives_committees_etc_committee_etc,
                      :progress_of_house_of_representatives_committees_etc_pass_on,
                      :progress_of_house_of_representatives_committees_etc_result,
                      :progress_of_house_of_representatives_plenary_sitting_pass_on,
                      :progress_of_house_of_representatives_plenary_sitting_result,
                      :progress_of_house_of_representatives_plenary_sitting_committees,
                      :progress_of_house_of_representatives_plenary_sitting_vote_type,
                      :progress_of_house_of_representatives_plenary_sitting_vote_method,
                      :promulgated_on,
                      :law_number,
                      :entracted_law_url,
                      :notes)

    Member = Struct.new(:professional_name,
                        :true_name,
                        :profile_url,
                        :professional_name_reading,
                        :in_house_group_abbreviation,
                        :constituency,
                        :expiration_of_term,
                        :photo_url,
                        :elected_years,
                        :elected_number,
                        :responsibilities,
                        :responsibility_on,
                        :career,
                        :career_on)

    VALID_TYPES = [
      :bill,
      :member,
    ]

    def initialize(type: :bill)
      super()
      @type = type
      unless VALID_TYPES.include?(type)
        message = ":type must be one of ["
        message << VALID_TYPES.collect(&:inspect).join(",")
        message << "]: #{@type.inspect}"
        raise ArgumentError, message
      end

      @metadata.id = "house-of-councillor"
      @metadata.name = "Bill and member of the House of Councillors of Japan"
      @metadata.url = "https://smartnews-smri.github.io/house-of-councillors"
      @metadata.licenses = ["MIT"]
      @metadata.description = "The House of Councillors of Japan (type: #{@type})"
    end

    def each
      return to_enum(__method__) unless block_given?

      open_data do |csv|
        csv.each do |row|
          case @type
          when :bill
            record = Bill.new(*row.fields)
          when :member
            record = Member.new(*row.fields)
          end
          yield(record)
        end
      end
    end

    private

    def open_data
      data_url = "https://smartnews-smri.github.io/house-of-councillors/data"
      case @type
      when :bill
        data_url << "/gian.csv"
      when :member
        data_url << "/giin.csv"
      end
      data_path = cache_dir_path + "#{@type}.csv"
      download(data_path, data_url)

      CSV.open(data_path, col_sep: ",", headers: true, converters: %i(date integer)) do |csv|
        yield(csv)
      end
    end
  end
end
