


/*This do-file  :

	Creates variables for Heterogeneity analysis
   1) Measure of Development: Village-level expenditures
   2) Measure of Opennes/Price integration : Correlation with National India prices
   
*/




*********************
* Price Integration *
*********************


	*Merge retail price data
	merge m:1 mon_yr  using "$data_dir/Analysis/AnalysisAuxData/Price_data", nogen	

	*correlation co-efficient with India prices
	tempfile price_corr
	statsby corr_coeff_vill=r(rho) , sa(`price_corr',replace) by(vill) verbose nodots :  pwcorr grain_price grain_retail_ind_avg 
	merge m:1 vill using `price_corr',nogen						


	
*Below Median dummy	
sum corr_coeff_vill,detail
gen corr_coeff_vill_below=corr_coeff_vill<=.7
	
	
	
***********************
* Village Expenditure *
***********************	
	
gen exp_base =exp if pan_year<2013
		
bys vill: egen exp_vill=mean(exp_base)
replace exp_vill = round(exp_vill)

sum exp_vill,detail

*Below Median dummy
gen exp_vill_below_median= exp_vill<5858



	

		
	
