


/*This do-file HH-level estimates regressions :

  Main consumption effects (for HHs with children)
  1) Value
  2) Quantity
  3) Energy, Protein and Fat intake
  4) Total food intake (aggregate)
 
 */


	

* FE COntrols for nutrition effects
global hh_nut_fe "new_id1 mon_yr  i.st#i.pan_year i.hh_size_m#i.pan_year i.card_dum#i.pan_year"    ///
			"i.main_occp_hh_head_0_m#i.pan_year  i.educ_hh_head_012_m#i.pan_year   i.caste_group_num#i.pan_year"

				
est clear
		
************
*	Value  *
************

local foodgrouplist  pdsgrain  st_cereal_nonpds   milk meat eggs pulses   fruitsveg     oils  cr_cereal sugar  otherfooditems meal_out
foreach y of local foodgrouplist {

	eststo `y'_val: ivreghdfe `y'_val (c.grain_subs=grain_subs_tg) if child_hh_dum==1, absorb("$hh_nut_fe") cluster (vill) 
	
	}
	
	

***************
*	Quantity  *
***************
	
*est clear
local foodgrouplist  pdsgrain  st_cereal_nonpds   milk_tot meat_tot eggs_tot pulses_tot oils_tot cr_cereal_tot  sugar_tot       
foreach y of local foodgrouplist {

	eststo `y'_qty: ivreghdfe `y'_qty (c.grain_subs=grain_subs_tg) if child_hh_dum==1 , absorb("$hh_nut_fe") cluster (vill)
	
	}

	

*************
*	Energy  *
*************
	
*est clear
local foodgrouplist  pds  st_cereal_nonpds   milk meat eggs pulses fruitsveg oils cr_cereal  sugar otherfooditems meal_out
foreach y of local foodgrouplist {

	eststo `y'_kcal: ivreghdfe `y'_kcal (c.grain_subs=grain_subs_tg) if child_hh_dum==1, absorb("$hh_nut_fe") cluster (vill)
	
	}

	
	
**************
*	Protein  *
**************
local foodgrouplist  pds  st_cereal_nonpds   milk meat eggs pulses fruitsveg oils cr_cereal  sugar otherfooditems meal_out
foreach y of local foodgrouplist {

	eststo `y'_prot: ivreghdfe `y'_prot (c.grain_subs=grain_subs_tg) if child_hh_dum==1, absorb("$hh_nut_fe") cluster (vill)
	
	}
	

***********
*	FAT  *
***********
local foodgrouplist  pds  st_cereal_nonpds   milk meat eggs pulses fruitsveg oils cr_cereal   otherfooditems meal_out
foreach y of local foodgrouplist {

	eststo `y'_fat: ivreghdfe `y'_fat (c.grain_subs=grain_subs_tg) if child_hh_dum==1, absorb("$hh_nut_fe") cluster (vill)
	
	}

			
************************
*	TOTAL FOOD INTAKE  *
************************


local foodgrouplist food_tot_val food_tot_kcal food_tot_prot food_tot_fat
foreach y of local foodgrouplist {

eststo `y'_tot: ivreghdfe `y' (c.grain_subs=grain_subs_tg) if child_hh_dum==1, absorb("$hh_nut_fe") cluster (vill)

	}


	

	esttab  using "$table_nutri_dir/impacts_cons_hh.csv", replace ///
		label b(3) se     ///
		mtitle  nonumb    ///
		star(* 0.10 ** 0.05 *** 0.01)   ///
		stats( N , labels("Observations") fmt(%9.0f ))

	
	



		


	
	
	
