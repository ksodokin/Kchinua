



/*This do-file :

  Prepares Analysis data aggregate
  Merges all the data to the household-month aggregate
 
 */

 

cap log close
log using "$log_dir/6_merge_all_$date_string", replace 

	
*******************************************
***  AGGREGATE HOUSEHOLD-MONTHLY DATA   ***
*******************************************



use "$stata_data_dir/Aggregate/trans_agg",replace


*Merge PDS Transfer Variables 	
merge 1:1 vds_id sur_mon_yr using "$stata_data_dir/Aggregate/pds_agg"
*keep if _merge==3
drop _merge


*Merge Employement schedule	
merge 1:1 vds_id sur_mon_yr using "$stata_data_dir/Aggregate/employment_hh_agg"
drop if _merge==2
drop _merge





*Merge GES agg data (Household-year level) 	
	merge m:1 vds_id using "$stata_data_dir/Aggregate/ges_agg"
	drop _merge
	
	
	
	
	
	*************************
	**** Merge CPI data *****
	*************************

	merge m:m year month using "$data_dir/Raw/RawAuxData/CPI", keepusing(cpi_generalindex)


	*Drop >July 2015 - post-dates sample
	drop if _merge==2

	*Replace Index=100 for 2010 year
	replace cpi_generalindex=100 if _merge==1

	drop _merge

	
 