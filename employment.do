

/*This do-file cleans Employment Files at the individual level
  and collapses the data to ii) household-panelyear level  */
  
  
  
 

use "$stata_data_dir/Employment/Aggregate/Employment_agg",replace

	
******************
* Data Cleaning  * 
******************
	
	*Drop Zero wage data
	drop if wages_cash==0&wages_kind==0		
	replace work_days=.  if work_days>31&work_days!=.
	replace avg_work_hrs=. if avg_work_hrs>24
		
	*Correct data entry error
	replace avg_work_hrs=avg_work_hrs*10 if vds_id=="IBH13D0053"&pre_mem_id==5&sur_mon_yr=="11/13"

	
***************
* Wage Income * 
***************

*Note: Wage income is net of transportation and transaction csots
gen nrega_wages=wages_net_inc if strmatch(co_nf_work_ot,"*NREG*")|co_nf_work==26

gen wages_net_inc_farm=wages_net_inc if work_type==1
gen wages_net_inc_non_farm=wages_net_inc if work_type==2

gen wages_net_inc_nf_lab=wages_net_inc if work_type==2&(co_nf_work==20|co_nf_work==15|co_nf_work==11)
gen wages_net_inc_nf_job=wages_net_inc if work_type==2&co_nf_work==1
gen wages_net_inc_nf_bus=wages_net_inc if work_type==2&co_nf_work==19
gen wages_net_inc_nf_oth=wages_net_inc if work_type==2&co_nf_work==25
	
		
	

		
	
**************
*Labor Supply* 
**************			
			
*Outside household - Labor Market*		
	
	gen tot_work_hrs=work_days*avg_work_hrs
	gen work_8hday=work_days
	gen labor_work=work_days
						
		
*************
* Wage-Rate * 
*************				
	
	
	egen tot_wages=rowtotal(wages_cash wages_kind)
	replace tot_wages=. if wages_cash==.&wages_kind==.
	
	* Wage per day *
	gen wage_day=(tot_wages/tot_work_hrs)*8
	
	gen wages_income=tot_wages
	
************
* Migrants *
************
	
	*(Only relavant for individuals who supply labor to the market)*
	
	rename migrant migrant_str
	gen migrant=1 if migrant_str=="Y"
	replace migrant=0 if migrant_str=="N"
	drop migrant_str

	

	
	collapse (sum)  nrega_wages wages_* seri_ill  labor_work    ///
			 (mean) wage_day  migrant    ///
					, by(vds_id sur_mon_yr)


replace migrant=1 if migrant>0&migrant!=.
label define mig 0 "No" 1 "Yes"
label values migrant mig
	
	*Drop missing
	drop if substr(vds_id,4,1)=="."
	
