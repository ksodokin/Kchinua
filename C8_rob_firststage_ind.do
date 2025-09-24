




/*This do-file estimates regressions :

  1) FIRST STAGE regression at the individual level 
		Regression of PDS Entitlement on Instrument
 
 */


	
/********************************/
*FIRST STAGE --- Individual level*
/********************************/		
		
		



est clear
								
eststo: reghdfe lagyr_grain_subs lagyr_grain_subs_tg if age<=5, absorb(indv_id1 pan_year ) vce(cluster vill)

eststo: reghdfe lagyr_grain_subs lagyr_grain_subs_tg if age<=5, absorb(indv_id1 pan_year i.st#i.pan_year ) vce(cluster vill)

eststo: reghdfe lagyr_grain_subs lagyr_grain_subs_tg if age<=5, absorb(indv_id1 pan_year i.st#i.pan_year i.hh_size_cat#i.pan_year ) vce(cluster vill)

eststo: reghdfe lagyr_grain_subs lagyr_grain_subs_tg if age<=5, absorb(indv_id1 pan_year i.st#i.pan_year i.hh_size_cat#i.pan_year i.card_dum#i.pan_year ) vce(cluster vill)

eststo: reghdfe lagyr_grain_subs lagyr_grain_subs_tg if age<=5, absorb(indv_id1 pan_year i.st#i.pan_year i.hh_size_cat#i.pan_year i.card_dum#i.pan_year       ///
     i.main_occp_hh_head_0_m#i.pan_year  i.educ_hh_head_012_m#i.pan_year  i.caste_group_num#i.pan_year  ) vce(cluster vill)

	
	
		esttab  using "$table_anthro_dir/firststage_ind.csv", replace ///
		label b(3) se     ///
		star(* 0.10 ** 0.05 *** 0.01)    ///
		stats( N F, labels("Observations" "F-stat") fmt(%9.0f %9.1f))

	


