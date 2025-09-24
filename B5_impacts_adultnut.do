


/*This do-file estimates regressions :

  1) Effects on Women of child bearing age (18 to 30)
  2) Effects on Adult women (Age 18 to 49)
  3) Effects on Adult Men (Age 18 to 49)
 
 */




	

*TRIM BMI
winsor2  bmi if age>18, cuts(2.5 97.5) trim replace

	
	
///////////////////
* WOMEN NUTRITION *
///////////////////
				

est clear
local anthrolist bmi underweight_adult overweight_adult overweight_adult_sev
foreach x of local anthrolist {

*Women (excluding mothers) Of Child bearing age

	*Child Bearing age 
	eststo `x'_modwc: ivreghdfe `x' (c.lagyr_grain_subs=c.lagyr_grain_subs_tg) if age>=18&age<30&gender_str=="F"&mother!=1,    ///
				absorb("$indv_fe") cluster (vill) 
				
	**Table Notes**
	summarize `x' if pan_year<2013 & age>=18&age<30&gender_str=="F"&mother!=1, meanonly
	eststo `x'_modwc, add(base_mean r(mean) )


}




tabstat bmi underweight_adult overweight_adult overweight_adult_sev if  pan_year<2013 & age>=18&age<30&gender_str=="F"&mother!=1


	
///////////////////
* ADULT NUTRITION *
///////////////////


*All Women (excluding mothers) Adult women

local anthrolist bmi underweight_adult overweight_adult overweight_adult_sev
foreach x of local anthrolist {


	eststo `x'_modw : ivreghdfe `x' (c.lagyr_grain_subs=c.lagyr_grain_subs_tg) if age>=18&age<49&gender_str=="F"&mother!=1,     ///
				absorb("$indv_fe") cluster (vill) 						   

	**Table Notes**
	summarize `x' if pan_year<2013 & age>=18&age<49&gender_str=="F"&mother!=1, meanonly
	eststo `x'_modw, add(base_mean r(mean) )
	
}


*All men

local anthrolist bmi underweight_adult overweight_adult overweight_adult_sev
foreach x of local anthrolist {



	eststo `x'_modm: ivreghdfe `x' (c.lagyr_grain_subs=c.lagyr_grain_subs_tg) if age>=18&age<49&gender_str=="M",     ///
					absorb("$indv_fe") cluster (vill) 		
	
	**Table Notes**
	summarize `x' if pan_year<2013 & age>=18&age<49&gender_str=="M", meanonly
	eststo `x'_modm, add(base_mean r(mean) )
					

}


	


			
			
*Baseline means
tabstat bmi underweight_adult overweight_adult overweight_adult_sev if  pan_year<2013 & age>=18&age<30&gender_str=="F"&mother!=1
tabstat bmi underweight_adult overweight_adult overweight_adult_sev if  pan_year<2013 & age>=18&age<49&gender_str=="F"&mother!=1
tabstat bmi underweight_adult overweight_adult overweight_adult_sev if  pan_year<2013 & age>=18&age<49&gender_str=="M"




					  
	
		esttab  using "$table_anthro_dir/impacts_adultnut.csv", replace ///
		label b(3) se     ///
		star(* 0.10 ** 0.05 *** 0.01)    ///
		stats( N base_mean, labels("Observations" "Baseline-mean" ) fmt(%9.0f %9.2f))




