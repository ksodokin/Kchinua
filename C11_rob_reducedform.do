


/*This do-file estimates regressions :

  1) Robustness of Reduced form estimates 

 
 */




	
****************************************
***	REDUCED FORM ESTIMATES ***
****************************************





est clear

 
	local heightlist   stunting  haz_w97 
	foreach x of local heightlist {

	eststo: ivreghdfe `x' lagyr_grain_subs_tg  if age<=5, absorb("$indv_fe") cluster (vill) 
	
		}

		
		
		esttab  using "$table_anthro_dir/rob_reducedform.csv", replace ///
		label b(3) se     ///
		star(* 0.10 ** 0.05 *** 0.01)    ///
		stats( N , labels("Observations") fmt(%9.0f))

		
