require "csv"

require_relative "dataset"

module Datasets
  class Communities < Dataset
    Record = Struct.new(
      :state,
      :county,
      :community,
      :community_name,
      :fold,
      :population,
      :household_size,
      :race_percent_black,
      :race_percent_white,
      :race_percent_asian,
      :race_percent_hispanic,
      :age_percent_12_to_21,
      :age_percent_12_to_29,
      :age_percent_16_to_24,
      :age_percent_65_and_upper,
      :n_people_urban,
      :percent_people_urban,
      :median_income,
      :percent_households_with_wage,
      :percent_households_with_farm_self,
      :percent_households_with_investment_income,
      :percent_households_with_social_security,
      :percent_households_with_public_assistant,
      :percent_households_with_retire,
      :median_family_income,
      :per_capita_income,
      :per_capita_income_white,
      :per_capita_income_black,
      :per_capita_income_indian,
      :per_capita_income_asian,
      :per_capita_income_other,
      :per_capita_income_hispanic,
      :n_people_under_poverty,
      :percent_people_under_poverty,
      :percent_less_9th_grade,
      :percent_not_high_school_graduate,
      :percent_bachelors_or_more,
      :percent_unemployed,
      :percent_employed,
      :percent_employed_manufacturing,
      :percent_employed_professional_service,
      :percent_occupations_manufacturing,
      :percent_occupations_management_professional,
      :male_percent_divorced,
      :male_percent_never_married,
      :female_percent_divorced,
      :total_percent_divorced,
      :mean_persons_per_family,
      :percent_family_2_parents,
      :percent_kids_2_parents,
      :percent_young_kids_2_parents,
      :percent_teen_2_parents,
      :percent_work_mom_young_kids,
      :percent_work_mom,
      :n_illegals,
      :percent_illegals,
      :n_immigrants,
      :percent_immigrants_recent,
      :percent_immigrants_recent_5,
      :percent_immigrants_recent_8,
      :percent_immigrants_recent_10,
      :percent_population_immigranted_recent,
      :percent_population_immigranted_recent_5,
      :percent_population_immigranted_recent_8,
      :percent_population_immigranted_recent_10,
      :percent_speak_english_only,
      :percent_not_speak_english_well,
      :percent_large_households_family,
      :percent_large_households_occupied,
      :mean_persons_per_occupied_household,
      :mean_persons_per_owner_occupied_household,
      :mean_persons_per_rental_occupied_household,
      :percent_persons_owner_occupied_household,
      :percent_persons_dense_housing,
      :percent_housing_less_3_bedrooms,
      :median_n_bedrooms,
      :n_vacant_households,
      :percent_housing_occupied,
      :percent_housing_owner_occupied,
      :percent_vacant_housing_boarded,
      :percent_vacant_housing_more_6_months,
      :median_year_housing_built,
      :percent_housing_no_phone,
      :percent_housing_without_full_plumbing,
      :owner_occupied_housing_lower_quartile,
      :owner_occupied_housing_median,
      :owner_occupied_housing_higher_quartile,
      :rental_housing_lower_quartile,
      :rental_housing_median,
      :rental_housing_higher_quartile,
      :median_rent,
      :median_rent_percent_household_income,
      :median_owner_cost_percent_household_income,
      :median_owner_cost_percent_household_income_no_mortgage,
      :n_people_shelter,
      :n_people_street,
      :percent_foreign_born,
      :percent_born_same_state,
      :percent_same_house_85,
      :percent_same_city_85,
      :percent_same_state_85,
      :lemas_sworn_full_time,
      :lemas_sworn_full_time_per_population,
      :lemas_sworn_full_time_field,
      :lemas_sworn_full_time_field_per_population,
      :lemas_total_requests,
      :lemas_total_requests_per_population,
      :total_requests_per_officer,
      :n_officers_per_population,
      :racial_match_community_police,
      :percent_police_white,
      :percent_police_black,
      :percent_police_hispanic,
      :percent_police_asian,
      :percent_police_minority,
      :n_officers_assigned_drug_units,
      :n_kinds_drugs_seized,
      :police_average_overtime_worked,
      :land_area,
      :population_density,
      :percent_use_public_transit,
      :n_police_cars,
      :n_police_operating_budget,
      :lemas_percent_police_on_patrol,
      :lemas_gang_unit_deployed,
      :lemas_percent_office_drug_units,
      :police_operating_budget_per_population,
      :total_violent_crimes_per_population
    )

    def initialize
      super()
      @metadata.id = "communities"
      @metadata.name = "Communities"
      @metadata.url = "https://archive.ics.uci.edu/ml/datasets/communities+and+crime"
      @metadata.licenses = ["CC-BY-4.0"]
      @metadata.description = lambda do
        read_names
      end
    end

    def each
      return to_enum(__method__) unless block_given?

      open_data do |csv|
        csv.each do |row|
          row = row.collect.with_index do |column, i|
            if column == "?"
              nil
            else
              case i
              when 3 # communityname
              # when 124 # LemasGangUnitDeploy
              # 0 means NO, 1 means YES, 0.5 means Part Time
              else
                column = Float(column)
              end
              column
            end
          end
          record = Record.new(*row)
          yield(record)
        end
      end
    end

    private
    def base_url
      "https://archive.ics.uci.edu/ml/machine-learning-databases/communities"
    end

    def open_data
      data_path = cache_dir_path + "communities.data"
      data_url = "#{base_url}/communities.data"
      download(data_path, data_url)
      CSV.open(data_path) do |csv|
        yield(csv)
      end
    end

    def read_names
      names_path = cache_dir_path + "communities.names"
      names_url = "#{base_url}/communities.names"
      download(names_path, names_url)
      names_path.read
    end
  end
end
