module Datasets
  class JapaneseDateParser
    class UnsupportedEraInitialRange < Error; end

    ERA_INITIALS = {
      "平成" => "H",
      "令和" => "R",
    }.freeze

    def parse(string)
      case string
      when nil
        nil
      when /\A(平成|令和|..)\s*(\d{1,2}|元)年\s*(\d{1,2})月\s*(\d{1,2})日\z/
        match_data = Regexp.last_match
        era_initial = ERA_INITIALS[match_data[1]]
        if era_initial.nil?
          message = +"era must be one of ["
          message << ERA_INITIALS.keys.join(", ")
          message << "]: #{match_data[1]}"
          raise UnsupportedEraInitialRange, message
        end

        year = match_data[2]
        if year == "元"
          year = "01"
        else
          year = year.rjust(2, "0")
        end
        month = match_data[3].rjust(2, "0")
        day = match_data[4].rjust(2, "0")
        Date.jisx0301("#{era_initial}#{year}.#{month}.#{day}")
      else
        string
      end
    end
  end
end
