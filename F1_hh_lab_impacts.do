



/*This do-file  estimates HH-level regressions :

  1) Prepares data for Labor market effects estimations
  2) Drops individuals with business occupation 
  3) Estimate Labor market effects 

 */

drop if migrant_hh==1
drop if main_occp_hh_head==6

gen wages_net_inc_nobusi=wages_net_inc-wages_net_inc_nf_bus


local wglist  wages_net_inc  wages_net_inc_nobusi wages_income
foreach x of local wglist  {	

	*Deflate to 2010 rupees 
	qui: replace `x'=(`x'/cpi_generalindex)*100			
	
	replace `x'=`x'/wt_nhh
}



winsor2 wages_income wages_net_inc  wages_net_inc_nobusi , cuts(0 95)  trim  suffix(_tr95) 
winsor2 wage_day , cuts(0 95)      trim  suffix(_tr95) 




* HH-COntrols for labor market effects
global hh_lab_fe "new_id1 mon_yr  i.st#i.pan_year i.hh_size_cat#i.pan_year  "    ///
			"i.main_occp_hh_head_0_m#i.pan_year  i.educ_hh_head_012_m#i.pan_year   i.caste_group_num#i.pan_year"

				  
est clear 		  
local wglist wages_income_tr95  wage_day_tr95  labor_work  
foreach x of local wglist  {
	
	eststo `x'_mod: ivreghdfe `x'  (c.grain_subs=c.grain_subs_tg) , absorb("$hh_lab_fe") cluster (vill) 
	
	**Table Notes**
	summarize `x' if pan_year<2013 , meanonly
	if `x'==labor_work summarize `x' if pan_year<2013 &labor_work>0, meanonly
	eststo `x'_mod, add(base_mean r(mean) )
	
}



tabstat wages_income_tr95   wage_day_tr95  if pan_year<2013
tabstat labor_work  if pan_year<2013 &labor_work>0 




	esttab  using "$table_nutri_dir/impacts_labor.csv", replace ///
		label b(3) se  noconstant  nonumb      ///
		star(* 0.10 ** 0.05 *** 0.01)   ///
		stats( N base_mean, labels("Observations" "Baseline-mean") fmt(%9.0f %9.0f))



		
		
***SUMMARY STAT of Labor Market Outcomes***


gen labor_work_int=labor_work if labor_work>0


label variable wages_income_tr95 	"Wage income "
label variable wage_day_tr95 	    "Daily wages"
label variable labor_work_int	        "Market labor supply"

 

est clear

	
estpost tabstat wages_income_tr95 wage_day_tr95 labor_work_int   ///
		if pan_year<2013 & child_hh_dum==1, by(pds_card) statistics(mean sd) columns(statistics) 

				


	esttab using  "$table_nutri_dir/hh_lab_sumstat.csv", replace ///
	   main(mean) aux(sd) nostar unstack nonote label b(1) 			

				
		
		
		
		
		
