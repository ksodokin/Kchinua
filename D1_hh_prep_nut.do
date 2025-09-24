


/*This do-file  :

   1) Sets HH-Month Panel data
   2) Selection of Panel HHs
   3) Creates Panel variables
   4) Fill in Caste names for SAT villages
   5) Get Number of children in HH from Indv-level data
   6) Generate variables for baseline HH characteristics (For FE)
   
*/



*********************************************************		   
*********      		 SET PANEL DATA                 *****
*********************************************************


***Create a time-invariant vds_id
	//Remove the "year" string in vds_id, so that vds_id for a particular HH in a village is common for all the years
	drop new_id 
	gen new_id=substr(vds_id,1,3)+substr(vds_id,6,10)
	
	
***Selection of Households***
	
	//Discard HHs whose HH head does not live in the village 
	drop if resid_hh_head==0|resid_hh_head==.
	drop resid_hh_head


	//Drop HHs with obsevrations less than 4 years
	bys new_id: gen counter=_n
	bys new_id: egen counter2=max(counter)

	drop if counter2<50



***Create Panel year - June to June 
gen pan_year="20"+substr(vds_id, 4, 2)
destring pan_year,replace
sort new_id year month


/**************/
*Set Panel data*
/**************/
encode new_id, gen(new_id1)
xtset new_id1 mon_yr



	*Initialise and clean variables

		*Encode village and state
		encode village, gen(vill)
		encode state,gen(st)
		
		*Region variable
		gen region="EI"
		replace region="SAT" if st==1|st==3|st==5|st==6|st==7
		tab st region
		encode region, gen(reg_dum)


		*Data error -- AP & JH PDS Rice price reported as 11 or 10 instead of 1 
		replace pdsrice_price=1 if (st==1|st==4)&(pdsrice_price>2)
		replace pdsrice_price=1 if pdsrice_price==11
	
		
		*Landholding - Vill cluster (may be used to cluster standard errors at the village landholding level)
		egen vill_lclass=group(vill lclass), label

		gen village_year=village+string(pan_year)
		encode village_year, gen(vill_yr)

		
		
		*Create Dummy variables
		egen vill_year=concat(village pan_year)
		egen st_panyear=concat(state pan_year)
		egen vill_month=concat(village mon_yr)
		egen st_month=concat(state mon_yr)
		
		egen vill_card=concat(village card)
		egen st_card=concat(state card)		
		
		*Encode them 
		encode vill_year,gen(vill_yr_num)
		encode st_panyear,gen(st_panyr_num)
		encode st_month,gen(st_month_num)
		encode vill_month,gen(vill_month_num)
		
		encode st_card,gen(st_card_num)
		encode vill_card,gen(vill_card_num)

		
		**Lean Season dummy**		
		gen lean_season=month==1|month==2|month==3|month==4|month==5|month==6
		label define season_bin_lab  1 "Lean" 0 "Peak" 
		label values  lean_season season_bin_lab


		gen season_str=string(pan_year)+"Rab" if lean_season==1
		replace season_str=string(pan_year)+"Kha" if lean_season==0
		encode season_str,gen(season_month)		
							
		
		*Create time trend variable
		sort new_id year month
		bys new_id: gen time=_n

		
		*Nominal Expenditure
		gen food_tot_val_nom=food_tot_val
		gen nf_tot_val_nom=nf_tot_val

		*Migrant Households
		bys new_id: egen migrant_hh=mean(migrant)
		replace migrant_hh=round(migrant_hh)


		

/*******************/
* Consumption Variables *
/*******************/	 

*Total Expenditure variable
egen exp=rowtotal(food_tot_val nf_tot_val),missing
egen exp_nom=rowtotal(food_tot_val_nom nf_tot_val_nom),missing







/****************************************/
*Clean and fill in CASTE names for SAT **
/****************************************/	

*For SAT villages, caste is missing for 2010 year, fill with 2011
	bys new_id: egen caste_group_m=mode(caste_group),max

	*Fill 2011 caste group for SAT villages
	replace caste_group=caste_group_m if region=="SAT"&pan_year==2010
	drop caste_group_m 



		


/*******************************/
*Get Number of children in HH **
/*******************************/	

	preserve
	
	use "$analysis_data_dir/indv_details_agg",replace
	
	
	*BMI of hh-head
	gen weight_hh_head=weight if rel==1
	gen height_hh_head=height if rel==1
	
	
	*Child and adolescent dummy
	gen child_n=1 if age<=19
	gen child_05_n=1 if age<=5
	
	collapse (mean) weight_hh_head height_hh_head (sum) child_n child_05_n ,by(vds_id)
	
	winsor2 weight_hh_head height_hh_head, cuts(0.5 99.5) trim replace 
	
	gen height_hh_head_mts=height_hh_head/100		
	gen bmi_hh_head=weight_hh_head/(height_hh_head_mts*height_hh_head_mts)

	winsor2 bmi_hh_head , cuts(0.5 99.5) trim replace 
	

	keep vds_id bmi_hh_head child_n child_05_n
	
	tempfile bmi_head
	save `bmi_head'

	restore
	

merge m:m vds_id using `bmi_head'	
keep if _merge==3
drop _merge
	
	
/**************************************/
*	DUMMY for HOUSEHOLDs WITH CHILDREN **
/**************************************/		


***HH dummy for households with children (age 1-19)
gen child_hh=child_n>0
gen child_05_hh=child_05_n>0


bys new_id: egen temp=mean(child_05_hh)
gen child_hh_dum=temp>0
drop temp	
	

	
**********************************************
*Create  Baseline HH characteristics (For FE)*
**********************************************

	**Main Occupation of HH head in 2010
	gen main_occp_hh_head_0=main_occp_hh_head if pan_year==2012
	bys new_id: egen main_occp_hh_head_0_m=mode(main_occp_hh_head)

	**Education of HH_head at baseline	(mean of 2010,2011 and 2012)		
	gen educ_hh_head_012=educ_hh_head if pan_year==2010|pan_year==2011|pan_year==2012
	bys new_id: egen educ_hh_head_012_m=mean(educ_hh_head_012)	
	replace educ_hh_head_012_m=round(educ_hh_head_012_m)

	
	encode caste,gen(caste_num)
	encode caste_group,gen(caste_group_num)
			
	
	encode card, gen(card_dum)
	
	gen pds_card=card=="BPL"|card=="AAY"
	
	
	*Household-size categories
	gen hh_size_cat=1 if hh_size_m<=4
	replace hh_size_cat=2 if hh_size_m>=5&hh_size_m<=9
	replace hh_size_cat=3 if hh_size_m>=10&hh_size_m<30
	
	

*******************
* Label Variables *
*******************

la var pdsgrain_alloc_qty "PDS Grain Entitlement Qty"
la var pdsgrain_alloc_qty_tg "PDS Grain Target Qty"

la var pdsgrain_alloc_price "PDS Grain Entitlement Price"
la var pdsgrain_alloc_price_tg "PDS Grain Target Price"

la var grain_subs "PDS Transfer Value "
la var grain_subs_tg "PDS Target Value"

