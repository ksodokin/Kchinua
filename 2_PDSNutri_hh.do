


/*This do-file :

  Master-file for all HOUSEHOLD level analysis: 
  Cleans, take-up, transforms, etc 
  Impacts on household outcomes : consumption and labor market

 */


cap log close
log using "$log_dir/2_PDSNutri_hh_$date_string", replace
 
/////////////////////////////////////////////////////////////////
**Bring in the HOUSEHOLD-level monthly VDSA data on consumption**
/////////////////////////////////////////////////////////////////


use "$analysis_data_dir/hh_mon_agg",replace

cd "$analysis_code_dir/Nutri_hh"

***********************************
*** SET PANEL AND DATA CLEANING ***
***********************************

* Set panel data, data cleaning, creates variables for baseline HH characteristics (for FE)
do D1_hh_prep_nut 



***************************
** TAKE UP - ESTIMATIONS **
***************************

*Validation of PDS take-up of quantity and price entitlements
do D5_hh_takeup



******************************************
*** TRANSFORM HH CONSUMPTION VARIABLES ***
******************************************	

*Convert Consumption items to per-capita real, and replace units from kgs to gms 
do D2_hh_transvars	



************************************
**CLASSIFY FOOD ITEMS INTO GROUPS **
************************************

*Groups food item into Animal proteins, Fruits and Veg, etc. AND create budget shares
do D3_hh_consgroups	




*Summary stats of children
do D6_hh_sumstat	






//////////////////////////////////////////////////////////////
//////////////****** HH level ESTIMATIONS ********////////////	
//////////////////////////////////////////////////////////////



*****************
** FIRST STAGE **
*****************

do D4_hh_rob_firststage




****************************
** MAIN NUTRITION EFFECTS **
****************************
	
* Main effects on household consumption
do E1_hh_nut_impacts





	***************************************
	** APPENDIX TABLES ON NUTRI EFFECTS  **
	***************************************

	*Effects on budget shares
		do E2_hh_nut_bdshare

	
	*Elasticities
		do E3_hh_nut_elast
		
		
	**Robustness to Other welfare programs
		do E4_hh_rob_othwelf  

	
**************************
** LABOR MARKET EFFECTS **
**************************
	
	
* Main effects on household consumption
do F1_hh_lab_impacts	




*Change directory back to source		
cd "$analysis_code_dir"	



