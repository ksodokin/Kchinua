





/*This do-file estimates regressions :

  1) Robustness TEST for ATTRITION 
 
 */




	
*****************
***	ATTRITION ***
*****************


est clear


gen pre_data_2011= 1 if (stunting!=.)&(pan_year==2011)
gen pre_data_2012= 1 if (stunting!=.)&(pan_year==2012)
gen pre_data_2013= 1 if (stunting!=.)&(pan_year==2013)
gen post_data_2014= 1 if (stunting!=.)&(pan_year==2014)

bys indv_id: egen pre_data_2011_mean=mean(pre_data_2011)
bys indv_id: egen pre_data_2012_mean=mean(pre_data_2012)
bys indv_id: egen pre_data_2013_mean=mean(pre_data_2013)
bys indv_id: egen post_data_2014_mean=mean(post_data_2014)




gen attrition=pre_data_2013_mean==1&post_data_2014_mean==. &pan_year==2014 
replace attrition=. if pre_data_2011_mean==.&pre_data_2012_mean==.&pre_data_2013_mean==.
gen attrition_2=pre_data_2012_mean==1&pre_data_2013_mean==1&post_data_2014_mean==. &pan_year==2014 


eststo: ivreghdfe attrition_2 (lagyr_grain_subs =lagyr_grain_subs_tg) if age<20 &pan_year>2010, absorb("$indv_fe") cluster (vill) 
eststo:  ivreghdfe attrition (lagyr_grain_subs =lagyr_grain_subs_tg) if age<20, absorb("$indv_fe") cluster (vill) 



		
					
	esttab  using "$table_anthro_dir/rob_attrit.csv", replace ///
		label b(3) se     ///
		star(* 0.10 ** 0.05 *** 0.01)    ///
		stats( N , labels("Observations") fmt(%9.0f))


		
		
		
		


