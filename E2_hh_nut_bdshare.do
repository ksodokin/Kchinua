

/*This do-file estimates regressions :

  1)Effects on budget shares 
 
 */



**********************		
*****Budget Share*****
**********************		

*Rpelace budget share -- multiply by 100
*Budget Share	

est clear

local foodgrouplist  animalprot st_cereal_nonpds st_cereal fruitsveg   oils cereals 
foreach y of local foodgrouplist {

	replace `y'_bs=`y'_bs*100
	
	}

	
	

*Budget Share	

local foodgrouplist  animalprot st_cereal_nonpds fruitsveg   oils  
foreach y of local foodgrouplist {

	eststo `y'_bs_mod: ivreghdfe `y'_bs (c.grain_subs=grain_subs_tg) if child_hh_dum==1,  absorb("$hh_nut_fe") cluster (vill)
	
	
	**Table Notes**
	scalar ch_`y'_level = 30*_b[grain_subs]
	summarize `y'_bs if  child_hh==1&pan_year<2013, meanonly
	scalar mean_`y' =r(mean)
	scalar ch_`y'_perc =(ch_`y'_level/mean_`y')*100
	eststo `y'_bs_mod, add(base_mean mean_`y' ch_level ch_`y'_level ch_perc ch_`y'_perc) 

	
	}

	
	
	
*Baseline mean
tabstat animalprot_bs  	if child_hh==1&pan_year<2013
tabstat st_cereal_nonpds_bs 	if child_hh==1&pan_year<2013
tabstat fruitsveg_bs 	if child_hh==1&pan_year<2013
tabstat oils_bs 	if child_hh==1&pan_year<2013



	
	
	esttab  using "$table_nutri_dir/impacts_cons_budgetshare.csv", replace ///
		label b(3) se noconstant  nonumb    ///
		star(* 0.10 ** 0.05 *** 0.01)   ///
		stats( N base_mean ch_level ch_perc,    ///
			labels("Observations"  "Baseline-mean"    ///
			       "Change from PDS expansion (in level)"      ///
				   "Change from PDS expansion (in %)" )      ///
				   fmt(%9.0f %9.1f %9.3f %9.1f))		


		
