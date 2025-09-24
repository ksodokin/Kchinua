/***********************************************************************************************
Project:    Food transfers and Child Nutrition: Evidence from India's Public Distribution System
File Name:  0_main.do
Purpose:    Master File

Do File Structure:
- Numbers show the absolute order of do-files and do-files are order-specific. 
- Previous do-files have to be run first.
************************************************************************************************/

*IN THE LINE BELOW REPLACE THE DIRECTORIES IN WHICH THE DATA FILES HAVE BEEN COPIED
global main_dir  "/Users/Adi/Dropbox/PDSNutrition/Replication_SBC"


clear all


** install user-written SSC commands
local commands  winsor2  estout ivreg2 ranktest coefplot boottest require
foreach c of local commands {
	capture  which `c'
	if _rc == 111 {
		dis "Installing `c' to label data..."
		ssc install `c', replace
	}
}


*Install Z-score package
*net search dm0004_1
net install dm0004_1,from("http://www.stata-journal.com/software/sj13-2")
net get dm0004_1


*Install REGHDFE 
	cap ado uninstall ftools
	net install ftools, from("https://raw.githubusercontent.com/sergiocorreia/ftools/master/src/")

	cap ado uninstall reghdfe
	net install reghdfe, from("https://raw.githubusercontent.com/sergiocorreia/reghdfe/master/src/")

	cap ado uninstall ivreghdfe
	cap ssc install ivreg2
	net install ivreghdfe, from("https://raw.githubusercontent.com/sergiocorreia/ivreghdfe/master/src/")

	*If connection is unstable/timed out: You have to MANUAL INSTALL (remove comment)
		
		//Download these zip files by hand and extract them on your local drive:
		*ftools(https://codeload.github.com/sergiocorreia/ftools/zip/master)
		*reghdfe(https://codeload.github.com/sergiocorreia/reghdfe/zip/master)
		*ivreghdfe(https://codeload.github.com/sergiocorreia/ivreghdfe/zip/master)
	
		*Then, run the following, replacing the folder names to your local drive src folder of each package (remove comment)
		/*
		cap ado uninstall ftools
		cap ado uninstall reghdfe
		cap ado uninstall ivreghdfe
		net install ftools, from(/Users/Adi/Dropbox/Mac/Downloads/ftools-master/src)
		net install reghdfe, from(/Users/Adi/Dropbox/Mac/Downloads/reghdfe-master/src)
		net install ivreghdfe, from(/Users/Adi/Dropbox/Mac/Downloads/ivreghdfe-master/src)
		*/

*Ensure STATA packages are version compatible		
require ftools >=2.49.1
require reghdfe>=6.12.5
require ivreghdfe>=1.1.3
require boottest>=4.4.11




****************************************************************************************************************************************************************

clear all
capture log close _all
drop _all
macro drop _all
local drop _all
set varabbrev off 
clear matrix
clear mata 
cap estimates drop _all
cap eststo drop _all 
set matsize 11000 
set maxvar 32767  
set more off
set mem 1g

set seed 12345
set sortseed 12345
version 18


*DEFINE GLOBAL FILE PATHS
global data_dir 		 "$main_dir/Data"
global xl_data_dir 		 "$data_dir/Raw/RawXLData"
global stata_data_dir 	 "$data_dir/Raw/RawStataData"
global analysis_data_dir "$data_dir/Analysis"

global code_dir 		 "$main_dir/Code"
global raw_code_dir 	 "$code_dir/RawCode"
global analysis_code_dir "$code_dir/AnalysisCode"

global table_dir 		 "$main_dir/Output/Tables"
global table_anthro_dir  "$table_dir/Anthro_indv"
global table_nutri_dir 	 "$table_dir/Nutri_hh"
global table_price_dir 	 "$table_dir/Price_vill"

global graph_dir 		"$main_dir/Output/Graphs"
global log_dir			"$main_dir/Output/Logs"

local date: dis %td_NN_DD_CCYY date(c(current_date), "DMY")
global date_string = subinstr(trim("`date'"), " " , "_", .)



************************************
***  RAW DATA to ANALYSIS DATA  ****
************************************
cd "$raw_code_dir"

do 1_excel2dta     				  /// Convert Excel files into dta files

do 2_append		   				  /// Clean and Aggregate Excel files ; Append data by years and Region

do 3_indvdetails	   			  /// Individual anthro and age details

  *Individual-year analysis data*
  save "$analysis_data_dir/indv_details_agg", replace

 
do 4_sch_agg					   /// Schedule Aggregates: GES_agg, Trans_agg, etc

do 5_pdstransfer 			 	   /// PDS transfer data

do 6_merge_all					   /// Merge all household-level data for analysis

	*Household-month analysis data* 
	save "$analysis_data_dir/hh_mon_agg", replace 		


do 7_rf							   /// Transform rainfall data	
	
	*Rainfall data* 
	save "$analysis_data_dir/AnalysisAuxData/RF_VDSAVill",replace
	
	


***********************
***  MAIN ANALYSIS ****
***********************
cd "$analysis_code_dir"

do 1_PDSAnthro_ind			/// Individual-level anthro impacts

do 2_PDSNutri_hh			/// Household-level consumption impacts

do 3_PDSGraphs_hh			/// Graphs on policy variation

do 4_PDSPrice_vill			/// Village-level price impacts 


clear
