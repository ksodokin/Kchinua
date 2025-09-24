




/*This do-file estimates regressions :

  1) Robustness TEST for MSP - Hetero effects by Land holding 
 
 */

	
*****************************
***	HETERO BY LANDHOLDING ***
*****************************
est clear
		
		
	gen small_farmer=1 if land_qtl==1|land_qtl==2
	replace small_farmer=0 if land_qtl==3|land_qtl==4
	

	eststo: ivreghdfe stunting (c.lagyr_grain_subs =c.lagyr_grain_subs_tg) if age<=5, absorb("$indv_fe") cluster (vill) 	
	eststo: ivreghdfe stunting (c.lagyr_grain_subs#small_farmer =c.lagyr_grain_subs_tg#small_farmer) if age<=5, absorb("$indv_fe") cluster (vill) 

	

		esttab  using "$table_anthro_dir/rob_msp_land.csv", replace ///
		label b(3) se     ///
		star(* 0.10 ** 0.05 *** 0.01)    ///
		stats( N , labels("Observations") fmt(%9.0f))

		
		
		
		
	
	
