



/*This do-file estimates regressions :

  1) FIRST STAGE regression at the household level 
		Regression of PDS Entitlement on Instrument
 
 */


	
/********************************/
*FIRST STAGE --- Households level*
/********************************/		
est clear		
	

eststo: reghdfe grain_subs grain_subs_tg, absorb(new_id mon_yr ) vce(cluster vill)

eststo: reghdfe grain_subs grain_subs_tg, absorb(new_id mon_yr i.st#i.mon_yr ) vce(cluster vill)

eststo: reghdfe grain_subs grain_subs_tg, absorb(new_id mon_yr i.st#i.mon_yr  i.hh_size_m#i.mon_yr) vce(cluster vill)

eststo: reghdfe grain_subs grain_subs_tg, absorb(new_id mon_yr i.st#i.mon_yr  i.hh_size_m#i.mon_yr i.card_dum#i.mon_yr) vce(cluster vill)

eststo: reghdfe grain_subs grain_subs_tg, absorb(new_id mon_yr i.st#i.mon_yr  i.hh_size_m#i.mon_yr     ///
                i.main_occp_hh_head_0_m#i.pan_year  i.educ_hh_head_012_m#i.pan_year   i.caste_group_num#i.pan_year        ///                
								) vce(cluster vill)
			
	
	
		esttab  using "$table_nutri_dir/firststage_hh.csv", replace ///
		label b(3) se drop(_cons)      ///
		star(* 0.10 ** 0.05 *** 0.01)    ///
		stats( N F, labels("Observations" "F-stat") fmt(%9.0f %9.1f))

