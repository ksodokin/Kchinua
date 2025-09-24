
/*This do-file estimates regressions :

  1) Effects on other outcomes of children 0 to 5 years 
 
 */

		

	


****************************************
* Effect on OTHER OUTCOMES FOR CHILDREN 
****************************************



est clear
		
	local oth_list ln_weight  waz_w97 underweight whz_w97 wasting ln_arm_circum caz_w97
	foreach x of local oth_list {

		eststo: ivreghdfe `x' (lagyr_grain_subs =lagyr_grain_subs_tg ) if age<=5, absorb("$indv_fe") cluster (vill) 
		
		
	}


			
**Baseline means of dependent vars**
tabstat arm_circum ln_weight  waz_w97 underweight whz_w97 wasting ln_arm_circum caz_w97 if age<=5 &pan_year<=2013

					  
	
		esttab  using "$table_anthro_dir/impacts_othchild.csv", replace ///
		label b(3) se     ///
		star(* 0.10 ** 0.05 *** 0.01)    ///
		stats( N , labels("Observations") fmt(%9.0f))


				 
				 			   				   

