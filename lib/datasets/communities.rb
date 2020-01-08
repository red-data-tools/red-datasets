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
      :race_percent_hisp,
      :age_percent_12_to_21,
      :age_percent_12_to_29,
      :age_percent_16_to_24,
      :age_percent_65_and_upper,
      :n_urban,
      :percent_urban,
      :median_income,
      :percent_with_wage,
      :percent_with_farm_self,
      :percent_with_investment_income,
      :percent_with_social_security,
      :percent_with_public_assistant,
      :percent_with_retire,
      :med_fam_income,
      :per_capita_income,
      :white_per_capita,
      :black_per_capita,
      :indian_per_capita,
      :asian_per_capita,
      :other_per_capita,
      :hisp_per_capita,
      :num_under_pov,
      :percent_pop_under_pov,
      :percent_less9th_grade,
      :percent_not_hs_grad,
      :percent_b_sor_more,
      :percent_unemployed,
      :percent_employ,
      :percent_empl_manu,
      :percent_empl_prof_serv,
      :percent_occup_manu,
      :percent_occup_mgmt_prof,
      :male_percent_divorce,
      :male_percent_nev_marr,
      :female_percent_div,
      :total_percent_div,
      :pers_per_fam,
      :percent_fam2_par,
      :percent_kids2_par,
      :percent_young_kids2_par,
      :percent_teen2_par,
      :percent_work_mom_young_kids,
      :percent_work_mom,
      :num_illeg,
      :percent_illeg,
      :num_immig,
      :percent_immig_recent,
      :percent_immig_rec5,
      :percent_immig_rec8,
      :percent_immig_rec10,
      :percent_recent_immig,
      :percent_rec_immig5,
      :percent_rec_immig8,
      :percent_rec_immig10,
      :percent_speak_engl_only,
      :percent_not_speak_engl_well,
      :percent_larg_house_fam,
      :percent_larg_house_occup,
      :pers_per_occup_hous,
      :pers_per_own_occ_hous,
      :pers_per_rent_occ_hous,
      :percent_pers_own_occup,
      :percent_pers_dense_hous,
      :percent_hous_less3_br,
      :med_num_br,
      :hous_vacant,
      :percent_hous_occup,
      :percent_hous_own_occ,
      :percent_vacant_boarded,
      :percent_vac_more6_mos,
      :med_yr_hous_built,
      :percent_hous_no_phone,
      :percent_wo_full_plumb,
      :own_occ_low_quart,
      :own_occ_med_val,
      :own_occ_hi_quart,
      :rent_low_q,
      :rent_median,
      :rent_high_q,
      :med_rent,
      :med_rent_percent_hous_income,
      :med_own_cost_percent_income,
      :med_own_cost_percent_income_no_mtg,
      :num_in_shelters,
      :num_street,
      :percent_foreign_born,
      :percent_born_same_state,
      :percent_same_house85,
      :percent_same_city85,
      :percent_same_state85,
      :lemas_sworn_ft,
      :lemas_sw_ft_per_pop,
      :lemas_sw_ft_field_ops,
      :lemas_sw_ft_field_per_pop,
      :lemas_total_req,
      :lemas_tot_req_per_pop,
      :polic_req_per_offic,
      :polic_per_pop,
      :racial_match_comm_pol,
      :percent_polic_white,
      :percent_polic_black,
      :percent_polic_hisp,
      :percent_polic_asian,
      :percent_polic_minor,
      :offic_assgn_drug_units,
      :num_kinds_drugs_seiz,
      :polic_ave_ot_worked,
      :land_area,
      :pop_dens,
      :percent_use_pub_trans,
      :polic_cars,
      :polic_oper_budg,
      :lemas_percent_polic_on_patr,
      :lemas_gang_unit_deploy,
      :lemas_percent_offic_drug_un,
      :polic_budg_per_pop,
      :violent_crimes_per_pop
    )

    def initialize
      super()
      @metadata.id = "communities"
      @metadata.name = "Communities"
      @metadata.url = "http://archive.ics.uci.edu/ml/datasets/communities+and+crime"
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
              column = Float(column) unless i == 3
              column
            end
          end
          record = Record.new(*row)
          yield(record)
        end
      end
    end

    private

    def open_data
      data_path = cache_dir_path + "agaricus-lepiota.data"
      unless data_path.exist?
        data_url = "http://archive.ics.uci.edu/ml/machine-learning-databases/communities/communities.data"
        download(data_path, data_url)
      end
      CSV.open(data_path) do |csv|
        yield(csv)
      end
    end

    def read_names
      names_path = cache_dir_path + "communities.names"
      unless names_path.exist?
        names_url = "http://archive.ics.uci.edu/ml/machine-learning-databases/communities/communities.names"
        download(names_path, names_url)
      end
      names_path.read
    end
  end
end
