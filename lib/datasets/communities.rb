require "csv"

require_relative "dataset"
module Datasets
  class Communities < Dataset
    Record = Struct.new(
      :state,
      :county,
      :community,
      :communityname,
      :fold,
      :population,
      :householdsize,
      :racepctblack,
      :race_pct_white,
      :race_pct_asian,
      :race_pct_hisp,
      :age_pct12t21,
      :age_pct12t29,
      :age_pct16t24,
      :age_pct65up,
      :numb_urban,
      :pct_urban,
      :med_income,
      :pct_w_wage,
      :pct_w_farm_self,
      :pct_w_inv_inc,
      :pct_w_soc_sec,
      :pct_w_pub_asst,
      :pct_w_retire,
      :med_fam_inc,
      :per_cap_inc,
      :white_per_cap,
      :black_per_cap,
      :indian_per_cap,
      :asian_per_cap,
      :other_per_cap,
      :hisp_per_cap,
      :num_under_pov,
      :pct_pop_under_pov,
      :pct_less9th_grade,
      :pct_not_hs_grad,
      :pct_b_sor_more,
      :pct_unemployed,
      :pct_employ,
      :pct_empl_manu,
      :pct_empl_prof_serv,
      :pct_occup_manu,
      :pct_occup_mgmt_prof,
      :male_pct_divorce,
      :male_pct_nev_marr,
      :female_pct_div,
      :total_pct_div,
      :pers_per_fam,
      :pct_fam2_par,
      :pct_kids2_par,
      :pct_young_kids2_par,
      :pct_teen2_par,
      :pct_work_mom_young_kids,
      :pct_work_mom,
      :num_illeg,
      :pct_illeg,
      :num_immig,
      :pct_immig_recent,
      :pct_immig_rec5,
      :pct_immig_rec8,
      :pct_immig_rec10,
      :pct_recent_immig,
      :pct_rec_immig5,
      :pct_rec_immig8,
      :pct_rec_immig10,
      :pct_speak_engl_only,
      :pct_not_speak_engl_well,
      :pct_larg_house_fam,
      :pct_larg_house_occup,
      :pers_per_occup_hous,
      :pers_per_own_occ_hous,
      :pers_per_rent_occ_hous,
      :pct_pers_own_occup,
      :pct_pers_dense_hous,
      :pct_hous_less3_br,
      :med_num_br,
      :hous_vacant,
      :pct_hous_occup,
      :pct_hous_own_occ,
      :pct_vacant_boarded,
      :pct_vac_more6_mos,
      :med_yr_hous_built,
      :pct_hous_no_phone,
      :pct_wo_full_plumb,
      :own_occ_low_quart,
      :own_occ_med_val,
      :own_occ_hi_quart,
      :rent_low_q,
      :rent_median,
      :rent_high_q,
      :med_rent,
      :med_rent_pct_hous_inc,
      :med_own_cost_pct_inc,
      :med_own_cost_pct_inc_no_mtg,
      :num_in_shelters,
      :num_street,
      :pct_foreign_born,
      :pct_born_same_state,
      :pct_same_house85,
      :pct_same_city85,
      :pct_same_state85,
      :lemas_sworn_ft,
      :lemas_sw_ft_per_pop,
      :lemas_sw_ft_field_ops,
      :lemas_sw_ft_field_per_pop,
      :lemas_total_req,
      :lemas_tot_req_per_pop,
      :polic_req_per_offic,
      :polic_per_pop,
      :racial_match_comm_pol,
      :pct_polic_white,
      :pct_polic_black,
      :pct_polic_hisp,
      :pct_polic_asian,
      :pct_polic_minor,
      :offic_assgn_drug_units,
      :num_kinds_drugs_seiz,
      :polic_ave_ot_worked,
      :land_area,
      :pop_dens,
      :pct_use_pub_trans,
      :polic_cars,
      :polic_oper_budg,
      :lemas_pct_polic_on_patr,
      :lemas_gang_unit_deploy,
      :lemas_pct_offic_drug_un,
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
          next if row[0].nil?
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
