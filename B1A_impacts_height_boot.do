 




/*This do-file estimates regressions :

  1) Main effects on Height - with bootstrap std. errors clustered at state-level
 
 */
	



	
	
*Set of FE without Individual - For Bootstrap command*
global indv_fe_Nid "i.pan_year i.age#i.pan_year i.st#i.pan_year i.hh_size_cat#i.pan_year i.card_dum#i.pan_year i.main_occp_hh_head_0_m#i.pan_year  i.educ_hh_head_012_m#i.pan_year   i.caste_group_num#i.pan_year"


	
///////////////////////////
* Height -- MAIN OUTCOMES *
///////////////////////////

est clear


local heightlist   stunting stunting_moderate stunting_severe haz_w97
foreach x of local heightlist {

eststo `x': ivreghdfe `x'  $indv_fe_Nid (lagyr_grain_subs =lagyr_grain_subs_tg) if age<=5, absorb(indv_id1) vce(cluster st) 
boottest lagyr_grain_subs, bootcluster(st) weight(webb) boot(wild) stat(t)  svmat nograph reps(999)
eststo `x', add(p_boot r(p))

}



esttab  using "$table_anthro_dir/impacts_height_boot.csv", replace ///
	label b(3) se    ///
	keep(lagyr_grain_subs*)    ///
	star(* 0.10 ** 0.05 *** 0.01)    ///
	stats( N F p_boot, labels("Observations" "F-stat" "P-value") fmt(%9.0f %9.1f %9.3f))	




	



	
