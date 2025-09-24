


/*This do-file  estimates HH-level regressions :

  1) Elasticities w.r.t PDS transfer value and Expenditure

 */





**********************		
*****Elasticities*****
**********************	


est clear

local foodlist grain_subs grain_subs_tg food_tot_val nf_tot_val food_tot_kcal food_tot_prot food_tot_fat exp
foreach x of local foodlist {

 gen ln_`x'=ln(`x')
	
	}



la var ln_food_tot_kcal "Log of Total KiloCalorie"
la var ln_food_tot_prot "Log of Total Proteins"
la var ln_food_tot_fat "Log of Total Fats"


la var ln_grain_subs "Log of PDS Transfer"
la var ln_grain_subs_tg "Log of NFSA Target Value"
la var ln_exp "Log of Expenditure Value"

	
	
est clear
	
eststo :ivreghdfe ln_food_tot_kcal (c.ln_grain_subs=c.ln_grain_subs_tg) if pds_card==1, absorb(new_id1 mon_yr) cluster (vill) 	
eststo :ivreghdfe ln_food_tot_prot (c.ln_grain_subs=c.ln_grain_subs_tg) if pds_card==1, absorb(new_id1 mon_yr) cluster (vill) 	
eststo :ivreghdfe ln_food_tot_fat (c.ln_grain_subs=c.ln_grain_subs_tg) if pds_card==1, absorb(new_id1 mon_yr) cluster (vill) 	


	
eststo :reghdfe ln_food_tot_kcal ln_exp if pds_card==1, absorb(new_id1 mon_yr) cluster (vill) 	
eststo :reghdfe ln_food_tot_prot ln_exp if pds_card==1, absorb(new_id1 mon_yr) cluster (vill) 	
eststo :reghdfe ln_food_tot_fat ln_exp if pds_card==1 , absorb(new_id1 mon_yr) cluster (vill) 	




	esttab  using "$table_nutri_dir/impacts_elast.csv", replace ///
		label b(3) se noconstant  nonumb    ///
		star(* 0.10 ** 0.05 *** 0.01)   ///
		stats( N , labels("Observations") fmt(%9.0f ))

	
