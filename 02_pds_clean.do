


/*
This do-file prepares and cleans Time variables, baseline HHsize and market price
*/



********************
**** Time Vars *****
********************
**Convert sur_mon_yr to STATA month format
gen mon_yr=monthly(sur_mon_yr,"M20Y")
drop if mon_yr<606|mon_yr>665
format mon_yr %tm

gen year= "20"+substr(sur_mon_yr,-2,2)
gen month=substr(sur_mon_yr,1,2)

destring month year,replace	
	
	
*Data cleaning before editing
sort new_id year month 


gen state = substr(vds_id, 2, 2)
gen vill = substr(vds_id, 6, 1)
	
		
	
**********************************
**** Baseline Household Size *****
**********************************

*Replace HH-size to a constant pre-2013
gen hh_size_012=hh_size if year==2010|year==2011|year==2012
bys new_id: egen hh_size_012_m=mean(hh_size_012)


gen hh_size_m=hh_size_012_m
replace hh_size_m=round(hh_size_m)




**********************************
**** Baseline Market Price   *****
**********************************

	
	*Merge market price data
	merge m:1 village sur_mon_yr using "$stata_data_dir/Aggregate/mprice_agg",keepusing(rice_price wheat_price)
	drop if _merge==2
	drop _merge


****Fill missing market price data for certain villages, with the state mean for that month
bys state mon_yr: egen rice_st_mon_mean = mean(rice_price)
bys state mon_yr: egen wheat_st_mon_mean=mean(wheat_price)

*replace rice_price = rice_st_mon_mean if rice_price==.
*replace wheat_price = wheat_st_mon_mean if wheat_price==.


		*Market price in 2010-11
		gen rice_price_012=rice_price if year==2010|year==2011|year==2012
		gen wheat_price_012=wheat_price if year==2010|year==2011|year==2012
		
		
		egen rice_price_avg=mean(rice_price_012)
		egen wheat_price_avg=mean(wheat_price_012)
		
			*Grain price (Rice+Wheat)
			egen grain_price2=rowtotal(rice_price wheat_price)
			gen grain_price=grain_price2/2
