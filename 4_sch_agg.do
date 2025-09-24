



/* This do-file prepares 3 aggregate datasets (schedule aggregates) that are used in Analysis: 
1) Household  monthly    (Employ and Trans) : labor supply wages, consumption food/nonfood (Employement and Transactions Schedule)
2) Household  yearly     (GES) 			    : household size, caste, land area (GES Schedule)
3) Village    monthly    (Monthly Price)    : market prices
*/	

 
cap log close
log using "$log_dir/4_sch_agg_$date_string", replace 
 
cd "$raw_code_dir"


********************************************
*		  HOUSEHOLD MONTHLY DATA		   *			  
*  Household consumption and Employment    *
********************************************


///////////////////////////////
***  EMPLOYMENT SCHEDULE	***
///////////////////////////////

	*High-frequency individual-month (by occcupation) data on employment 
	do Employment/employment


*Aggregate Cultivation data at the vds_id-month level (HHid-month level)	
save "$stata_data_dir/Aggregate/employment_hh_agg",replace

	
	
///////////////////////////////
***  TRANSACTION SCHEDULE	***
///////////////////////////////


	
	cd "$raw_code_dir"
	*Loop through each Transaction file and clean and collapse data to (HHid-month level) 	
	local transfilelist govt_ben nonfood food  
	foreach t of local transfilelist {
		 
		*Clean GES files
		include Transaction/Trans_`t' 
		
		*Save in tempfiles
		tempfile trans_`t'
		save `trans_`t'' 
	
		 
		}
		

	*Merge Monthly data from Transaction files 	
	use `trans_nonfood',replace
	local transfilelist govt_ben food  
		foreach t of local transfilelist {
		merge 1:1 vds_id sur_mon_yr using `trans_`t'',nogen
		}

	
drop if vds_id=="."	

	

	

*Aggregate Transactions (Food and Non-food) data at the vds_id-month level
save "$stata_data_dir/Aggregate/trans_agg",replace	
	
	
		


	

	
	
	
*********************************************
*	    	HOUSEHOLD YEARLY DATA	     	*			  
*      Caste, HHsize, Land area, etc.       *
*********************************************

	
	
///////////////////////
***  GES SCHEDULE   ***
///////////////////////



	*Loop through each GES file and clean and collapse data to (HHid-panel year level) 	
	local gesfilelist hhinfo land_det caste 
	foreach g of local gesfilelist {
		 
		*Clean GES files
		include GES/GES_`g' 
		
		*Save in tempfiles
		tempfile ges_`g'
		save `ges_`g'' 
		
		 
		}
		
		
	*Merge Annual data from GES files and Cultivation Output file 
	*Start with hhinfo	and Merge remaining files

	use `ges_hhinfo',replace
	local gesfilelist land_det caste 
				foreach g of local gesfilelist {
				merge 1:1 vds_id using `ges_`g'',nogen
				}

drop if vds_id==""

rename state state_str
				
*Aggregate GES data at the vds_id-year level (HHid-panel year level)		
save "$stata_data_dir/Aggregate/ges_agg",replace	
	
	
	

	
	

	
*********************************************
*	    	VILLAGE MONTHLY DATA	     	*			  
*    			Market prices               *
*********************************************
	
	
		
////////////////////////////////
***  MONTHLY PRICE SCHEDULE	 ***
////////////////////////////////


	/* Commodities and Food Prices  */ 
	*Cleans the high-frequency Monthly Commodity Price files (Village-Commodity-month)  
	*Collapses to village-month level (VillageID-month level)
	include Mprice/Mprice_commodities

	
	
*Aggregate MPrice data at the village-month level
save "$stata_data_dir/Aggregate/mprice_agg",replace	
	
	

