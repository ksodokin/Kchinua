


/*This do-file estimates regressions :

  1) ROBUSTNESS TEST on other welfare programs using SAT data 
 
 */


				  
	  
local benefit_val_list  middaybenefit_val nrega_wages healthbenefit_val otherbenefit_val  
foreach x of local benefit_val_list  {
	
	*Deflate to 2010 rupees 
	qui: replace `x'=(`x'/cpi_generalindex)*100	
	
	*Change to per-capita 
	qui: replace `x'=`x'/wt_nhh


}


	
est clear 		
local benefit_val_list  middaybenefit_val nrega_wages  healthbenefit_val  otherbenefit_val 
foreach x of local benefit_val_list  {

	eststo: ivreghdfe `x' (c.grain_subs=grain_subs_tg) if region=="SAT" , absorb(new_id1 mon_yr ) cluster(vill)

	}

	

	esttab  using "$table_nutri_dir/rob_othben.csv", replace ///
		label b(3) se   noconstant  nonumb     ///
		star(* 0.10 ** 0.05 *** 0.01)   ///
		stats( N , labels("Observations") fmt(%9.0f ))
	
