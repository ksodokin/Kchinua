



/*This do-file :

  Master-file for all VILLAGE level analysis: 
  Cleans, merge PDS transfer, transforms, etc 
  Impacts on village outcomes : prices

 */

cap log close
log using "$log_dir/4_PDSPrice_vill_$date_string", replace  

//////////////////////////////////////////////////// 
*Bring in VILLAGE-level monthly VDSA data on prices*
////////////////////////////////////////////////////


use "$stata_data_dir/Aggregate/mprice_agg",replace


cd "$analysis_code_dir/Price_vill"

*******************************
***	MERGE PDS TRANSFER DATA ***
*******************************

tempfile pds_trans_vill

*Aggregates PDS transfer to village-level 
include "$analysis_code_dir/Price_vill/G1_vill_pdsval"

		
	**Merge PDS transfer data***	
	merge 1:1 village sur_mon_yr using 	`pds_trans_vill'
	keep if _merge==3
	drop _merge
	
	

**************************************
***	TRANSFORM AND CLEAN PRICE DATA ***
**************************************

*This do-file creates logs and first differences of prices
do G2_vill_transvars



**************************
***	HETEROGENEITY VARS ***
**************************


*This do-file avrs used for hetero estimations
do G3_vill_heterovars




/////////////////////////////////////////////////////////
///////****** VILLAGE level ESTIMATIONS ********/////////	
/////////////////////////////////////////////////////////




************************
** MAIN PRICE EFFECTS **
************************

* Main effects on village prices
do H1_vill_price_impacts



********************
** HETERO EFFECTS **
********************

* Hetero effects on village prices
do H2_vill_price_heteroimpacts




*Change directory back to source		
cd "$analysis_code_dir"	


		
		


	
	
	
