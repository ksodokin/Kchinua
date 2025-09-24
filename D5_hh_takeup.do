


/*This do-file estimates regressions :

  1)TAKE UP regressions at the household level 
	Regression of PDS Quantity and Price entilements on Instrument
 
 */




*Convert quantities to per-capita 
local namelist pdsgrain_alloc_qty pdsgrain_alloc_qty_tg pdsgrain_qty grain_subs grain_subs_tg grain_subs_rec
foreach y of local namelist {

		*Change to per-capita 
		replace `y'=`y'/wt_nhh
		


	}




replace pdsgrain_alloc_price=0 if pdsgrain_alloc_price==.&pdsgrain_alloc_price_tg==.
replace pdsgrain_alloc_price_tg=0 if pdsgrain_alloc_price_tg==.&pdsgrain_alloc_price==0
replace pdsgrain_price=0 if pdsgrain_price==.&pdsgrain_alloc_price==0




***ESTIMATION OF FIRST STAGE:: VALIDATION OF PDS TAKE UP*****	
est clear	


*************************
**Target on Entitlement**
*************************

	*Quantity
	eststo: reghdfe pdsgrain_alloc_qty pdsgrain_alloc_qty_tg, absorb(new_id1 mon_yr ) vce(cluster vill)

	
	*Price
	eststo: reghdfe pdsgrain_alloc_price pdsgrain_alloc_price_tg, absorb(new_id mon_yr ) vce(cluster vill)
	

	*Value
	eststo: reghdfe grain_subs grain_subs_tg, absorb(new_id mon_yr ) vce(cluster vill)	


	
******************************
**Entitlement on Consumption**
******************************


	*Quantity
	eststo: reghdfe pdsgrain_qty pdsgrain_alloc_qty, absorb(new_id mon_yr) vce(cluster vill)

	*Price
	eststo: reghdfe pdsgrain_price pdsgrain_alloc_price, absorb(new_id mon_yr ) vce(cluster vill)

	*Value
	eststo: reghdfe grain_subs_rec grain_subs, absorb(new_id mon_yr ) vce(cluster vill)
	


	

	
	
	
**Replace quantities back to HH-level 
local namelist pdsgrain_alloc_qty pdsgrain_alloc_qty_tg pdsgrain_qty grain_subs grain_subs_tg grain_subs_rec
foreach y of local namelist {

		*Change back to per-household
		replace `y'=`y'*wt_nhh
		


	}

	
			
		esttab  using "$table_nutri_dir/takeup_hh.csv", replace ///
		label b(3) se drop(_cons)  nonumb    ///
		star(* 0.10 ** 0.05 *** 0.01)    ///
		stats( N F, labels("Observations" "F-stat") fmt(%9.0f %9.1f))


	
	
	
	
	
	
	
	
