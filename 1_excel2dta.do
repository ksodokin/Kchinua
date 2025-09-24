


/*This do-file :

  Converts Excel files into dta files (separate files by region-year-schedule-file)
  Cleans the dta files for easy appending 
 
 */
  
cap log close
log using "$log_dir/1_excel2dta_$date_string", replace 

/*
*Create Stata Data Folders
local dirlist Employment GES MPrice Transaction Aggregate
	foreach d of local dirlist {
	mkdir "$stata_data_dir/`d'"			
	}
*/


***********************************************************
***       Convert Excel files into dta files           ****
***********************************************************



local reglist SAT EI 
foreach r of local reglist { 
	local yearlist 10 11 12 13 14
	foreach y of local yearlist { 
		local dirlist Employment GES MPrice Transaction
		foreach d of local dirlist {
			cd "$xl_data_dir/`r'/20`y'/`d'"
			*Save the filenames with extensions in a local macro filelist 
			local filelist : dir . files "*",respectcase
			*Remove the file extension ".xlsx"
			local filelist : subinstr local filelist ".xlsx" "" , all
			*Loop over files in the each schedule
			foreach filename of local filelist {
				import excel "`filename'.xlsx",  firstrow case(lower) clear
				
				
					***DATA	CLEANING***
				*Change VDS ids for Telanga (TS) to AP	
				if `y'==14 & "`r'"=="SAT"&"`d'"!="MPrice"	replace vds_id=subinstr(vds_id,"TS","AP",.) 
				if `y'==14 &"`r'"=="SAT"&"`d'"=="MPrice" replace mp_id=subinstr(mp_id,"TS","AP",.) 				
				
				*Change vds_id variable name in EI
				if `y'!=14 & "`r'"=="EI"&"`d'"!="MPrice" rename *vds*id vds_id
				if `y'==14 & "`r'"=="EI"&"`d'"!="MPrice" rename *vdsid vds_id
				
					*Rename file names for easy appending of SAT and EI files into Aggregate file
					if `y'==13 & "`r'"=="EI"&"`d'"=="GES" &"`filename'"=="Gov_dev_prog"      local filename "Govt_dev_prog" 
					
					
					if (`y'==10|`y'==11) & "`r'"=="SAT"&"`d'"=="MPrice"  &"`filename'"=="Gen_info" local filename "M_gen_info" 
					if `y'==14 & "`r'"=="EI"&"`d'"=="MPrice" &"`filename'"=="Other"      local filename "Others" 
					
					*GES
					if "`r'"=="EI"&"`d'"=="GES" &"`filename'"=="Family_comp" 			local filename "Household_details"  
					if "`r'"=="EI"&"`d'"=="GES" &"`filename'"=="Govt_dev_prog" 	        local filename "Govt_dev_Prog"   										
					
					*MPrice
					if `y'==13 & "`r'"=="EI"&"`d'"=="MPrice" &"`filename'"=="Comodity"      local filename "Commodities"  
					if `y'==14 & "`r'"=="EI"&"`d'"=="MPrice" &"`filename'"=="Commodity"      local filename "Commodities"  
					
					
					
					
				*Destring numeric variables
				 qui: destring, replace
				
				*Save as a STATA Dataset
				if "`r'"=="EI" save "$stata_data_dir/`d'/`filename'_`r'_`y'.dta",replace
				if "`r'"=="SAT" save "$stata_data_dir/`d'/`filename'`y'.dta",replace
			}
		}
	}
}



********************************
***       DATA CLEANING     ****
********************************


*Append TS and AP Food items data - So that all AP and TS are the same 
	*(Fooditems for TS and AP are in separate files - So combine them)
	use "$stata_data_dir/Transaction/Food_items_AP14",clear
	append using "$stata_data_dir/Transaction/Food_items_TS14"
	sort vds_id 
	save "$stata_data_dir/Transaction/Food_items_AP14",replace
	erase "$stata_data_dir/Transaction/Food_items_TS14.dta"


*Rename variables (Exchange variable names): 
		
	* EI, GES Module : Govt. dev
	
		local yearlist 13 14
		foreach y of local yearlist {
			use "$stata_data_dir/GES/Govt_dev_prog_EI_`y'",clear
			rename (sur_yr vds_id) (vds_id sur_yr)
			save "$stata_data_dir/GES/Govt_dev_prog_EI_`y'",replace
		}
	
	
*Destring Migrant variable
	*EI, Employment
	local yearlist 10 11 12 13 14
	foreach y of local yearlist {
		use "$stata_data_dir/Employment/Employment_EI_`y'",clear
		tostring migrant,replace
		replace migrant="Y" if migrant=="1"
		replace migrant="N" if migrant=="2"
		replace migrant="" if migrant=="."
		save "$stata_data_dir/Employment/Employment_EI_`y'",replace
		}
		
		
*Tostring Subcaste variable in GES general info 10 in SAT
	use "$stata_data_dir/GES/Gen_info10",replace
	tostring sub_caste, replace 
	replace sub_caste="" if sub_caste=="."
	save "$stata_data_dir/GES/Gen_info10",replace
	


*Destring Age variable in GES Household details 13 and 14
*(Age is coded as strings in "months" for a few observations, so destring does not work)  
	local yearlist 13 14 
	foreach y of local yearlist {
	
	use "$stata_data_dir/GES/Household_details`y'",clear
	
	*Clean string
	replace age=trim(age)
	replace age="" if age=="."	
	drop if age==""

	/*Note: Age is measured in years and months - (in 2013 and 14 panel year for age<1)
		Age is also measured in fractions of year ... 1.5, 2.7 etc.  in EI*/
		
	*Month variable*
	*Create 2 age variables : age (in year) and age_mon (in months)
	split age, p("M" "D")  destring

	gen age_mon=age1 if age2!=""&strmatch(age2,"*ONTH*")
	*For days, convert to 1 month
	replace age_mon=1 if strmatch(age2,"*AY*")

	replace age_mon=age1 if age2==""&strmatch(age,"*M*")

	*For year variable, assume age=1yr if age is less than 1 yr (for those obs in months)
	replace age="0" if age_mon!=.


	destring age, replace
			
	save "$stata_data_dir/GES/Household_details`y'",replace
	
	}

*For East India 2014, Unit and variety_o is interchanged for year 2014
	use "$stata_data_dir/MPrice/Others_EI_14",replace
	
	rename (variety_ot unit_ot price_ot_a price_ot_b price_ot_c price_ot_d price_ot_e)    ///
			(unit_ot price_ot_a price_ot_b price_ot_c price_ot_d price_ot_e variety_ot )
			
	save "$stata_data_dir/MPrice/Others_EI_14",replace		
		 		
		

*Change directory back to source		
cd "$raw_code_dir"		
