

/*This do-file estimates regressions :

  1) Main effects on Height 
 
 */



///////////////////////////
* Height -- MAIN OUTCOMES *
///////////////////////////

 


est clear

 
	local heightlist   stunting stunting_moderate stunting_severe haz_w97
	foreach x of local heightlist {

	eststo `x'_mod: ivreghdfe `x' (lagyr_grain_subs =lagyr_grain_subs_tg ) if age<=5, absorb("$indv_fe") cluster (vill) 
	
			
	**Table Notes**
	scalar ch_`x'_level = .33*_b[lagyr_grain_subs]
	summarize `x' if age<=5 &pan_year<=2013, meanonly
	scalar mean_`x' =r(mean)
	scalar ch_`x'_perc =(ch_`x'_level/mean_`x')*100
	di "variable is `x'" 
	if "`x'"=="haz_w97" scalar ch_`x'_perc =-(ch_`x'_level/mean_`x')*100
	eststo `x'_mod, add(base_mean mean_`x' ch_level ch_`x'_level ch_perc ch_`x'_perc) 

		}

	
		esttab  using "$table_anthro_dir/impacts_height.csv", replace ///
		label b(3) se      ///
		star(* 0.10 ** 0.05 *** 0.01)    ///
		stats( N base_mean ch_level ch_perc,    ///
			labels("Observations"  "Baseline-mean"    ///
			       "Change from PDS expansion (in level)"      ///
				   "Change from PDS expansion (in %)" )      ///
				   fmt(%9.0f %9.3f %9.3f %9.1f))	
		







		
		
				
		
		
		
