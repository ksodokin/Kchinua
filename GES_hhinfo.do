



/*This do-file cleans GES Household-Member Individual Files 
  and collapses the data to household-panelyear level  */

  

/////// GES Individual member Details ///////
use "$stata_data_dir/GES/Aggregate/Household_details_agg",replace


	*Drop missing observations
		drop if pre_mem_id==.&age==.
		replace pre_mem_id=old_mem_id if pre_mem_id==.

		format %14.0f pre_mem_id
	
	
		
*Convert Age in year fractions to equivalent months (Around 306 observations in fraction years)
	gen age_frac_yr=age*12 if mod(age,1)!= 0

	replace age_frac_yr=round(age_frac_yr)
	
	
	*save to age in months variable
	replace age_mon=age_frac_yr if mod(age,1)!= 0
	
	drop age_frac_yr
	
	*For year variable, round off year in fractions 
	replace age=round(age)
		
	
*Gender variable
	replace gender="F" if gender=="Female"
	replace gender="M" if gender=="Male"
	
	rename gender gender_str 
	label define gender 1 "F" 2 "M"
	
	encode gender_str,gen(gender_dum) label(gender)	
	

	
*Residency variable
	replace liv_wf_os=proper(liv_wf_os)
	replace liv_wf_os=trim(liv_wf_os)
	
		replace liv_wf_os="Family" if liv_wf_os=="Withfamily"

	label define resid_hh 0 "Outside"
	encode liv_wf_os,gen(resid_hh)	
	
		
*Main Occupation variable
	replace main_occp=2 if main_occp==20
	label define occup 1 "Farming" 2 "Farm Labor" 3 "Non-farm Labor" 4 "Regular farm servant" 5 "Livestock"  ///
			   6 "Business" 7 "Caste occupation" 8 "Salaried Job" 9 "Education" 10 "Domestic work"   ///
			   11 "No work (Child/Old age)" 12 "Others"
	label values main_occp occup

	/*
	*Subsidiary occupation variable
		*Merge variables
		replace subs_occp=subs_occcp if subs_occp==.&subs_occcp!=.
		drop subs_occcp
		drop if subs_occp==0
		
		label values subs_occp occup
	*/
	



*Assume missing residence as residing in HH
	replace resid_hh=1 if resid_hh==.
	
	
*Household Size Variables 	
	gen hh_size= resid_hh==1
	
	gen n_am= gender_dum==2&age>18&age<60&resid_hh==1
	gen n_af= gender_dum==1&age>18&age<60&resid_hh==1
	gen n_tm= gender_dum==2&age>12&age<19&resid_hh==1
	gen n_tf= gender_dum==1&age>12&age<19&resid_hh==1
	gen n_7_12= age>6&age<13&resid_hh==1
	gen n_2_6= age>1&age<7&resid_hh==1
	gen n_infant= age<=1&resid_hh==1
	gen n_elderly_60= age>59&age!=.&resid_hh==1
	
	gen n_hh_out= resid_hh==0
	
	

	
*HH head characteristics variable
		*Drop duplicate
		replace rel=relation if rel==. 
		drop relation 
	
	gen educ_hh_head=yrs_edu if rel==1
	gen gender_hh_head=gender_dum if rel==1 
	gen age_hh_head=age if rel==1
	gen resid_hh_head=resid_hh if rel==1 
	gen main_occp_hh_head=main_occp if rel==1
	



*Member Organization of Credit society - SHG/PACS/CHITFUND
gen mem_org= strmatch(mem_org_name,"*SHG*")|strmatch(mem_org_name,"*PACS*")|        ///
			 strmatch(mem_org_name,"CHITFUND")|strmatch(mem_org_name,"CO-OPERATIVE*")|strmatch(mem_org_name,"SRISH*")
 
	
	

	
***********************************************	
*Collapse the data from individual to Hh level*
***********************************************	


		
collapse (sum) hh_size-n_hh_out    ////
		 (firstnm) educ_hh_head- mem_org, by(vds_id)
	
	
	
	*Age-sex weight (an equivalence weight) 
	
		/*
		From Townsend (1994) foot note 12: 
		"The educated guesses for age-sex weights are: for adult males, 1.0; for adult females, 0.9. For
		males and females aged 13-18, 0.94, and 0.83, respectively; for children aged 7-12, 0.67 regardless
		of gender; for children 4-6, 0.52; for toddlers 1-3, 0.32; and for infants 0.05"

		Weigths
		Adult male				1
		Adult female			0.9
		Teenage male (13-18)	0.94
		Teenage female (13-18) 	0.83
		child 7 to 12 			0.67
		child 4 to 6			0.52
		child 1 to 3			0.32
		Elderly>60				0.83
		*/

	gen wt_nhh=(1*n_am)+(0.9*n_af)+(0.94*n_tm)+(0.83*n_tf)+(0.67*n_7_12)+   ///
	   (0.52*n_2_6)+(0.32*n_infant)+(0.83*n_elderly_60) 
	   
	label variable wt_nhh "Number of HH in Adult Equivalent"
	
	
	*Label variables 
		*Assign Label values 
		label values gender_hh_head gender
		label values resid_hh_head resid_hh
		label values main_occp_hh_head occup

		*Label different Number of Members in the HH variable
		label variable n_am "Number of Adult Male in HH"
		label variable n_af "Number of Adult Female in HH"
		label variable n_tm "Number of Teenage Male (13-18) in HH"
		label variable n_tf "Number of Teenage Female (13-18) in HH"
		label variable n_7_12 "Number of Children 7 to 12 Yrs in HH"
		label variable n_2_6 "Number of Children 2 to 6 Yrs in HH"
		label variable n_infant "Number of Infants 0 to 2 yrs in HH"
		label variable n_elderly_60  "Number of Adults older than 60 in HH"
		label variable n_hh_out "Number of members outside the HH"
		label variable hh_size "Number of members in the HH"

		*Label HH head characteristics 
		label variable educ_hh_head "Education of Head in years"
		label variable resid_hh_head "Residence of Head" 
		label variable main_occp_hh_head "Main occupation of Head"
		label variable age_hh_head "Age of Head"
		label variable gender_hh_head "Gender of Head"
		
			

				
				