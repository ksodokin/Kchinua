

/*This do-file cleans GES Household-Member Files 
  and collapses the data to individual-panelyear level  */
/*
  
* This do-file prepares aggregate individual dataset that is used in Analysis: 
1) Individual panel-year (GES) 		   	    : individual characteristics and anthropometrics (age, height, weight, etc)* (GES Schedule)
*/

cap log close
log using "$log_dir/3_indvdetails_$date_string", replace 


/////// GES Household member Details ///////
use "$stata_data_dir/GES/Aggregate/Household_details_agg",replace

	*Drop missing observations
		drop if pre_mem_id==.|age==.
		replace pre_mem_id=old_mem_id if pre_mem_id==.

		format %14.0f pre_mem_id
	
	
		
*Convert Age in year fractions to equivalent months (Around 306 observations in fraction years)
	gen age_frac_yr=age*12 if mod(age,1)!= 0

	replace age_frac_yr=round(age_frac_yr)
	
	
	*save to age in months variable
	replace age_mon=age_frac_yr if mod(age,1)!= 0
	
	drop age_frac_yr
	
	*For year variable, round off year in fractions 
	replace age=round(age)
		
	
*Gender variable
	replace gender="F" if gender=="Female"
	replace gender="M" if gender=="Male"
	
	rename gender gender_str 
	label define gender 1 "F" 2 "M"
	
	encode gender_str,gen(gender_dum) label(gender)	
	
	

	
*Residency variable
	replace liv_wf_os=proper(liv_wf_os)
	replace liv_wf_os=trim(liv_wf_os)
	
	replace liv_wf_os="Family" if liv_wf_os=="Withfamily"

	label define resid_hh 0 "Outside"
	encode liv_wf_os,gen(resid_hh)	



*Assume missing residence as residing in HH
	replace resid_hh=1 if resid_hh==.

	 
	 
	 