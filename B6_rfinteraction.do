




/*This do-file estimates regressions :

  1) STUNTING effects interacted with Monsoon shock
 
 */



**********************************
**    RAINFALL INTERACTION     ***
**********************************


	gen cr_year=pan_year
	merge m:1 village cr_year using "$data_dir/Analysis/AnalysisAuxData/RF_VDSAVill"
	keep if _merge==3
	drop _merge

	
	
est clear
local rflist   l_z1_rf_sea_imd
foreach rf of local rflist { 

	*Main average effects of PDS and Rainfall on child height
	eststo : ivreghdfe stunting `rf' (c.lagyr_grain_subs=c.lagyr_grain_subs_tg) if age<=5 ,    ///
	absorb("$indv_fe")	cluster (vill) 
	
	eststo : ivreghdfe haz_w97 `rf' (c.lagyr_grain_subs=c.lagyr_grain_subs_tg) if age<=5 ,    ///
	absorb("$indv_fe")	cluster (vill) 
	
	
	*Interaction Effects	
	eststo : ivreghdfe stunting `rf' (c.lagyr_grain_subs c.lagyr_grain_subs#c.`rf'= c.lagyr_grain_subs_tg c.lagyr_grain_subs_tg#c.`rf')  if age<=5, ///
	absorb("$indv_fe") cluster (vill) 

	eststo : ivreghdfe haz_w97 `rf' (c.lagyr_grain_subs c.lagyr_grain_subs#c.`rf'= c.lagyr_grain_subs_tg c.lagyr_grain_subs_tg#c.`rf')  if age<=5, ///
	absorb("$indv_fe") cluster (vill) 

}



					  
	
		esttab  using "$table_anthro_dir/impacts_rfint.csv", replace ///
		label b(3) se     ///
		star(* 0.10 ** 0.05 *** 0.01)    ///
		stats( N , labels("Observations") fmt(%9.0f))


