




/*This do-file estimates :

  1) Summary stats of Household consumption and HH characteristics 

 
 */





label define card_label 1 "Beneficiaries" 0 "Non-Beneficiaries"
label values pds_card card_label



*Replace proteins and fat back to grams
replace food_tot_prot=food_tot_prot/1000
replace food_tot_fat=food_tot_fat/1000

replace 	st_cereal_nonpds_qty=st_cereal_nonpds_qty/1000
replace 	pdsgrain_qty=pdsgrain_qty/1000



label variable food_tot_kcal 	"Total energy Kcal intake per capita"
label variable food_tot_prot 	"Total protein intake per capita"
label variable food_tot_fat	    "Total fat intake per capita"
label variable exp			 	"Total expenditures (Food+Non-food) per capita"
label variable food_tot_val 	"Food expenditures per capita"
label variable nf_tot_val 		"Non-food expenditures per capita"
label variable st_cereal_nonpds_qty "Rice and Wheat quantity (excluding PDS)"
label variable pdsgrain_qty "Rice and Wheat quantity (from PDS)"


est clear

	
estpost tabstat food_tot_kcal food_tot_prot food_tot_fat exp food_tot_val nf_tot_val st_cereal_nonpds_qty  pdsgrain_qty    ///
		hh_size  land_area_own educ_hh_head    ///
		if pan_year<2013 & child_hh_dum==1, by(pds_card) statistics(mean sd) columns(statistics) 

		


	esttab using  "$table_nutri_dir/hh_sumstat.csv", replace ///
	   main(mean) aux(sd) nostar unstack nonote label b(1) 			

		

	
		
				


		
*Replace proteins and fat back to milligram	
replace food_tot_prot=food_tot_prot*1000
replace food_tot_fat=food_tot_fat*1000

replace 	st_cereal_nonpds_qty=st_cereal_nonpds_qty*1000
replace 	pdsgrain_qty=pdsgrain_qty*1000

