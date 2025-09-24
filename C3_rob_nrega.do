



/*This do-file estimates regressions :

  1) ROBUSTNESS TEST on stunting to NREGA changes
 
 */

 
*Create Fiscal year - April to March
gen fis_year=pan_year

 
merge m:1 st fis_year using "$data_dir/Analysis/AnalysisAuxData/PDSvsNREGA"
drop _merge	
	
	
	
*************************
**** 1) NREGA TESTS	*****
*************************		
est clear		

	*Baseline
	eststo: ivreghdfe stunting        ///
			(lagyr_grain_subs =lagyr_grain_subs_tg ) if age<=5 , absorb("$indv_fe") cluster(vill)	

	*Fiscal expenditures
	eststo: ivreghdfe stunting c.lagyr_exp_tot#i.pds_card         ///
			(lagyr_grain_subs =lagyr_grain_subs_tg ) if age<=5 , absorb("$indv_fe") cluster(vill)	
	

	
	*Funds Allocated from center to state
	eststo: ivreghdfe stunting c.lagyr_exp_tot#i.pds_card   c.lagyr_funds_rel#i.pds_card        ///
			(lagyr_grain_subs =lagyr_grain_subs_tg ) if age<=5 , absorb("$indv_fe") cluster(vill)
		
	

	*Number of HHs provided employement
	eststo: ivreghdfe stunting c.lagyr_exp_tot#i.pds_card   c.lagyr_funds_rel#i.pds_card   c.lagyr_hh_prov_employ#i.pds_card     ///
			(lagyr_grain_subs =lagyr_grain_subs_tg ) if age<=5 , absorb("$indv_fe") cluster(vill)

	

	*Number of person days
	eststo: ivreghdfe stunting c.lagyr_exp_tot#i.pds_card   c.lagyr_funds_rel#i.pds_card   c.lagyr_hh_prov_employ#i.pds_card   c.lagyr_per_days#i.pds_card   ///
			(lagyr_grain_subs =lagyr_grain_subs_tg ) if age<=5 , absorb("$indv_fe") cluster(vill)


			
			
	esttab  using "$table_anthro_dir/nrega_test.csv", replace ///
		label b(3) se  keep(*lagyr_grain_subs*)   ///
		star(* 0.10 ** 0.05 *** 0.01)    ///
		stats( N , labels("Observations") fmt(%9.0f))


		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
