require "csv"

require_relative "dataset"

module Datasets
  class AmesHousing < Dataset
    Record = Struct.new(:order,
                        :pid,
                        :ms_sub_class,
                        :ms_zoning,
                        :lot_frontage,
                        :lot_area,
                        :street_alley,
                        :lot_shape,
                        :land_contour,
                        :utilities, 
                        :lot_config,
                        :land_slope,
                        :neighborhood,
                        :condition_1,
                        :condition_2,
                        :bldg_type,
                        :house_style,
                        :overall_qual,
                        :overall_cond,
                        :year_built,
                        :year_remod_add,
                        :roof_style,
                        :roof_matl,
                        :exterior_1st,
                        :exterior_2nd,
                        :mas_vnr_type,
                        :mas_vnr_area,
                        :exter_qual,
                        :exter_cond,
                        :foundation,
                        :bsmt_qual, 
                        :bsmt_cond,
                        :bsmt_exposure,
                        :bsmt_fin_type_1,
                        :bsmt_fin_sf_1,
                        :bsmt_fin_type_2,
                        :bsmt_fin_sf_2,
                        :bsmt_unf_sf,
                        :total_bsmt_sf,
                        :heating,
                        :heating_qc,
                        :central_air,
                        :electrical,
                        :first_flr_sf,
                        :second_flr_sf,
                        :low_qual,
                        :fin_sf,
                        :gr_liv_area,
                        :bsmt_full_bath,
                        :bsmt_half_bath,      
                        :full_bath,
                        :half_bath,
                        :bedroom_abv_gr,
                        :kitchen_abv_gr,
                        :kitchen_qual,
                        :tot_rms_abv_grd,
                        :functional,
                        :fireplaces,
                        :fireplace_qu,
                        :garage_type,
                        :garage_yr_blt,
                        :garage_finish,
                        :garage_cars,
                        :garage_area,
                        :garage_qual,
                        :garage_cond,
                        :paved_drive,
                        :wood_deck_sf,
                        :open_porch_sf,
                        :enclosed_porch,
                        :three_ssn_porch,
                        :screen_porch,
                        :pool_area,
                        :pool_qc,
                        :fence,
                        :misc_feature,
                        :misc_val,
                        :mo_sold, 
                        :yr_sold,
                        :sale_type,
                        :sale_condition,
                        :sale_price)
      

    def initialize
      super()
      @metadata.id = "ames-housing"
      @metadata.name = "Ames Housing"
      @metadata.url = "http://jse.amstat.org/v19n3/decock/DataDocumentation.txt"
      @metadata.licenses = ["Unknown"]
      @metadata.description = <<-DESCRIPTION
Data set contains information from the Ames Assessor’s Office
used in computing assessed values for individual residential
properties sold in Ames, IA from 2006 to 2010.
De Cock, D.,
"Ames, Iowa: Alternative to the Boston Housing Data as an
End of Semester Regression Project",
Journal of Statistics Education, 19(3) (2011) 1-15.
Available from http://jse.amstat.org/v19n3/decock.pdf.
      DESCRIPTION
    end

    def each
      return to_enum(__method__) unless block_given?

      open_data do |input|
        input.each do |row|
          next if row[0].nil?
          record = Record.new(*row)
          yield(record)
        end
      end
    end

    private
    def open_data
      data_path = cache_dir_path + "AmesHousing.txt"
      data_url = "http://jse.amstat.org/v19n3/decock/AmesHousing.txt"
      download(data_path, data_url)
      CSV.open(data_path, converters: [:numeric]) do |csv|
        yield(csv)
      end
    end
  end
end
