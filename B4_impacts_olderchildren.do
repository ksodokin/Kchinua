	

/*This do-file estimates regressions :

  1) Effects on Older children and adolescents 
 
 */


				 
				 
				 
//////////////////////////////
* OLDER CHILDREN AGE 5 to 19 *
/////////////////////////////

 

*Age categories
gen age_cat_child=1 if age>5&age<=10
replace age_cat_child=2 if age>10&age<=19



			
****Interaction***

est clear
		
	local oth_list stunting  ln_weight underweight bmi_w97 ln_arm_circum
	foreach x of local oth_list {

	eststo: ivreghdfe `x' (c.lagyr_grain_subs#i.age_cat_child = c.lagyr_grain_subs_tg#i.age_cat_child ) if age>5&age<=19, absorb("$indv_fe") cluster (vill) 
		
		
	}

						  
	
		esttab  using "$table_anthro_dir/impacts_oldchild.csv", replace ///
		label b(3) se     ///
		star(* 0.10 ** 0.05 *** 0.01)    ///
		stats( N , labels("Observations") fmt(%9.0f))



	
		
				
	
