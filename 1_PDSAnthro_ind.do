


/*This do-file :

  Master-file for all INDIVIDUAL level analysis: 
  Clean, z-scores, merge PDS transfer, transforms, etc 
  Impacts on individul outcomes : children and adutls

 */

set seed 12345
set sortseed 12345

cap log close
log using "$log_dir/1_PDSAnthro_ind_$date_string", replace 

/////////////////////////////////////////////////////////////////////////////
**Bring in the INDIVIDUAL-level yearly VDSA data on anthropometrics and age**
/////////////////////////////////////////////////////////////////////////////

use "$analysis_data_dir/indv_details_agg.dta",replace


cd "$analysis_code_dir/Anthro_indv"
	
	
**********************************************************
***Clean and Descriptive stats of individual population***
**********************************************************

*Identify births, birth-mothers, children(0-5) etc.
do 01_descpstats_child

	

*************************
***Z-score and Graphs ***
*************************
*drop bmi
*Calculate Z-scores based on WHO and graph the distribution
do 02A_zscore_child

*Z-scores distribution graphs 
do 02B_zscore_graphs




*******************************
***	MERGE PDS TRANSFER DATA ***
*******************************

tempfile pds_trans

*Clean PDS transfer value and HH data - gets it to HH-panel-year
include "$analysis_code_dir/Anthro_indv/03A_pdsval"

		
	**Merge PDS transfer data***	
	merge m:m vds_id using 	`pds_trans'
	tab _merge
		*99% of observations are matched -- Individual anthro is matched to PDS transfer at HH-level -- all at annual level
	keep if _merge==3
	drop _merge
	

**********************************************
*Tranform and clean variables for estimations*
**********************************************

do 03B_transvar

			
*Summary stats of children
do 02C_child_sumstat	




*********************************
*Baseline fixed effects controls*
*********************************



global indv_fe "indv_id1 pan_year i.age#i.pan_year i.st#i.pan_year i.hh_size_cat#i.pan_year i.card_dum#i.pan_year"        /// 
                "i.main_occp_hh_head_0_m#i.pan_year  i.educ_hh_head_012_m#i.pan_year   i.caste_group_num#i.pan_year"


la var lagyr_grain_subs "PDS transfer value"
la var lagyr_grain_subs_tg "NFSA target value"

	
//////////////////////////////////////////////////////////////
//////////////********ESTIMATIONS***********//////////////////	
//////////////////////////////////////////////////////////////

*

				
**********************
***	CHILD STUNTING ***
**********************


* Main effects on child stunting
do B1_impacts_height



	*Bootstrap std. errors clustered at state
	do B1A_impacts_height_boot


	
	
*Hetero effects by age and gender
do B2_impacts_height_hetero


********************************
***	EVENTS STUDY ESTIMATIONS ***
********************************

*Parallel trends graphs
do C1_rob_trends


*LEADS test
do C2_rob_leads


*************************************************
***	OTHER OUTCOMES, OLDER CHILDREN AND ADULTS ***
*************************************************

*Effect on child weight indicators and MUAC
do B3_impacts_othanthro


*Effect on older children and adolescents
do B4_impacts_olderchildren



*Effect on adult women and men
do B5_impacts_adultnut



****************************
***	RAINFALL INTERACTION ***
****************************

*Effect on stunting with RF interaction
do B6_rfinteraction


************************************************
***	APPENDIX TABLES : MORE ROBUSTNESS TESTS  ***
************************************************

*First stage at Individual-level 
do C8_rob_firststage_ind


*Robustness to village-by-time FE
do C10_rob_villbytimeFE


*Robustness of Reduced form estimates
do C11_rob_reducedform


*Robustness to NREGA test
do C3_rob_nrega


*Robustness to MSP - Hetero effects by landholding
do C9_rob_heterobyland


*Robustness to Attrition
do C7_rob_attrition



*Change directory back to source		
cd "$analysis_code_dir"	










