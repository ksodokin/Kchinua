


/*This do-file estimates regressions :

  - Hetero effects by age and gender 
  
 */



//////////////////////
* HETERO - BY AGE *
//////////////////////

gen age_cat_group=1 if age<=2
replace age_cat_group=2 if age>=3&age<=5



est clear				   					  
	local heightlist   stunting  haz_w97 
	foreach x of local heightlist {

	eststo: ivreghdfe `x' (c.lagyr_grain_subs#i.age_cat_group =c.lagyr_grain_subs_tg#i.age_cat_group ) if age<=5, absorb("$indv_fe") cluster (vill) 
	
		}
					  
					  
	
		esttab  using "$table_anthro_dir/impacts_height_hetero_age.csv", replace ///
		label b(3) se     ///
		star(* 0.10 ** 0.05 *** 0.01)    ///
		stats( N , labels("Observations") fmt(%9.0f))



					  
				   


//////////////////////
* HETERO - BY GENDER *
//////////////////////

			   		

est clear				   					  
	local heightlist   stunting  haz_w97 
	foreach x of local heightlist {

	eststo: ivreghdfe `x' (c.lagyr_grain_subs#i.gender_dum =c.lagyr_grain_subs_tg#i.gender_dum ) if age<=5, absorb("$indv_fe") cluster (vill) 
	lincom _b[c.lagyr_grain_subs#1.gender_dum] - _b[c.lagyr_grain_subs#2.gender_dum]	
	eststo , add(effect_size r(estimate)  pval r(p) )
	
	}
					  

tabstat stunting haz_w97 if  (age<=5),by(gender_dum)


					  
					  
					  
	
		esttab  using "$table_anthro_dir/impacts_height_hetero_gender.csv", replace ///
		label b(3) se     ///
		star(* 0.10 ** 0.05 *** 0.01)    ///
		stats( N effect_size pval, labels("Observations" "Effect size: Girl-Boy" "H0: Girl=Boy (p-value)") fmt(%9.0f %9.3f %9.2f))





