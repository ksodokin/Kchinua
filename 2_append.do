


/*This do-file :

  Append the individual dta files into File aggregates (aggregates region+year) 
  Cleans and corrects for panel-years  
 
 */



******************************************
*** 	AGGREGATE FILES FOR ALL YEARS  ***
*** 	   AGGREGATE 2010 to 2014	   ***
******************************************

clear

cap log close
log using "$log_dir/2_append_$date_string", replace 


**Save the Schedule names (or questionnaires) in a local macro
local schedulelist Employment GES MPrice Transaction

**Save the common filenames in each schedule in a local macro
local Employmentfileslist 	Employment
local GESfileslist 			Gen_info Govt_dev Household_details Landholding_det
 		
local MPricefileslist       Commodities M_gen_info Others
local Transactionfileslist  Ben_govt_prog Exp_food_non_food Food_items Non_food_items 



**Aggregate Files for each commonfilename in each schedule 
**For instance - Employment_agg is the aggreagte of years 2010 to 2014 of all villages in SAT and EI
foreach schedule of local schedulelist {
	cd "$stata_data_dir/`schedule'"
	*mkdir "$stata_data_dir/`schedule'/Aggregate" 
	foreach schedulefile of local `schedule'fileslist {
		local filelist : dir . files "`schedulefile'*",respectcase
		local filelist : subinstr local filelist ".dta" "" , all
		foreach dtafile of local filelist {
		 qui: append using `dtafile',force
	    }
		*Trim String variables
		foreach var of varlist _all {
			local vartype: type `var'
			if substr("`vartype'",1,3)=="str" { 
			qui: replace `var'=trim(`var')
			qui: replace `var'=subinstr(`var'," ","",.)
			}
		}
		
	*compress
	save "$stata_data_dir/`schedule'/Aggregate/`schedulefile'_agg",replace
	clear
	}
}



*************************************
**** ERASE INDIVIDUAL DTA FILES  ****
*************************************

foreach schedule of local schedulelist {
	cd "$stata_data_dir/`schedule'" 
	foreach schedulefile of local `schedule'fileslist {
		local filelist : dir . files "`schedulefile'*",respectcase
		local filelist : subinstr local filelist ".dta" "" , all
		foreach dtafile of local filelist {
		 qui: erase "$stata_data_dir/`schedule'/`dtafile'.dta" 
	    }
	}
}




*********************************************
**** Correct for Panel-years in vds_ids  ****
*********************************************
/*Note: Transaction, Cultivation and Employment Schedules have some obervations that predate the panel year. Ex: sur_mon_yr=06/11 for panel_yr=11. 
		Most of these double counts are in the June-July bracket*/

**Save the common filenames in each schedule in a local macro
local schedulelist_corr  Employment Transaction

local Employmentfileslist 	Employment
local Transactionfileslist  Exp_food_non_food  Food_items  Non_food_items

foreach schedule of local schedulelist_corr {	
	foreach schedulefile of local `schedule'fileslist {
		use "$stata_data_dir/`schedule'/Aggregate/`schedulefile'_agg",replace
		*Create panel year from sur_mon_yr - the correct panel year
			gen year_sur=substr(sur_mon_yr,-2,2)
				*Errors
				replace year_sur=subinstr(year_sur,"/","",.)
			gen month_sur=substr(sur_mon_yr,1,2)
			destring year_sur month_sur,replace

			gen pan_year_sur = year_sur if month_sur>=7
			replace pan_year_sur= year_sur-1 if month_sur<7
			tostring pan_year_sur,replace
			
		*If Panel-year on vds_id is wrong, then replace the correct panel year
		replace vds_id=substr(vds_id,1,3)+pan_year_sur+substr(vds_id,6,.) if substr(vds_id,4,2)!=pan_year_sur

		drop year_sur month_sur pan_year_sur
		
	save "$stata_data_dir/`schedule'/Aggregate/`schedulefile'_agg",replace
	
	}
}


	
*Change directory back to source		
cd "$raw_code_dir"	

