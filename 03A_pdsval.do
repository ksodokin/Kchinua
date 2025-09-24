



*******************************
*Parent file :  anthrochild.do*
*******************************

/*This do-file gets :
  1) HH-baseline data from trans_agg 
  2) PDS transfer data from pds_agg 
  3) Collapses data to HH-panel year
  4) Creates a tempfile `pds_trans' */


preserve



use "$analysis_data_dir/hh_mon_agg", replace


	
	
*Change the transfer to per-capita real value
local pclist grain_subs grain_subs_tg 
foreach x of local pclist  {	

	*Deflate to 2010 rupees 
	qui: replace `x'=(`x'/cpi_generalindex)*100			
	
	replace `x'=`x'/wt_nhh
	
	}	
	

	
egen exp=rowtotal(food_tot_val nf_tot_val),missing	
	
*Also change expenditures to per-capita real value
local pclist food_tot_val nf_tot_val exp
foreach x of local pclist  {	

	*Deflate to 2010 rupees 
	qui: replace `x'=(`x'/cpi_generalindex)*100			
	
	replace `x'=`x'/wt_nhh
	
	}		
	

**Parallel Trends
	
local laborlist grain_subs grain_subs_tg 
	foreach x of local laborlist  {

	*Pre Mean
	gen `x'_pre=`x' if mon_yr<tm(2013m3)
	bys new_id: egen `x'_pre_mean=mean(`x'_pre)

	*Post Mean
	gen `x'_post=`x' if mon_yr>tm(2013m3)
	bys new_id: egen `x'_post_mean=mean(`x'_post)
	
	*Treatment Intensity	
	gen ch_`x'_int= `x'_post_mean - `x'_pre_mean
	
	}	




	
****HH-year level*******	
	
*Get data to household-year level	

collapse (mean)  grain_subs grain_subs_tg  ///
				food_tot_val nf_tot_val exp   ///
         (mean) hh_size_m  educ_hh_head  /// 
				ch_grain_subs_int ch_grain_subs_tg_int   ///
				labor_work    land_area_tot      ///	
		(firstnm) card main_occp_hh_head caste_group  lclass  ///
		     , by(state village vds_id)	



drop if state==""
	

*Create individual-id (panel id) *Note: pre_mem_id - present VDS ID
gen new_id=substr(vds_id,1,3)+substr(vds_id,6,10)	
gen pan_year="20"+substr(vds_id, 4, 2)
destring pan_year,replace

encode village, gen(vill)
encode state,gen(st)

bys new_id: gen counter=_n
bys new_id: egen counter2=max(counter)



*For SAT villages, caste is missing for 2010 year, fill with 2011
	gen region="EI"
	replace region="SAT" if st==1|st==3|st==5|st==6|st==7

	bys new_id: egen caste_group_m=mode(caste_group),max

	*Fill 2011 caste group for SAT villages
	replace caste_group=caste_group_m if region=="SAT"&pan_year==2010

	drop caste_group_m region
	


***HH baseline characteristics***

*Time-invariant HH characteristic
*HH-head characteristics - Occupation, Education and caste

gen main_occp_hh_head_0=main_occp_hh_head if pan_year==2012
bys new_id: egen main_occp_hh_head_0_m=mode(main_occp_hh_head),maxmode
		
			
gen educ_hh_head_012=educ_hh_head if pan_year<2013
bys new_id: egen educ_hh_head_012_m=mean(educ_hh_head_012)	
replace educ_hh_head_012_m=round(educ_hh_head_012_m)


*(Because the land classification in lclass does not exactly match)
gen land_area_tot_pre=land_area_tot if pan_year<=2013
bys new_id: egen land_area_tot_pre_012_m=mean(land_area_tot_pre)
replace land_area_tot_pre_012_m=round(land_area_tot_pre_012_m,0.1)
replace land_area_tot_pre_012_m=0 if land_area_tot_pre_012_m==.
gen missing_land=land_area_tot_pre_012_m==.


xtile land_qtl=land_area_tot_pre_012_m,n(4)


encode caste_group,gen(caste_group_num)

*Lag subsidy
sort new_id pan_year
bys new_id : gen lagyr_grain_subs=grain_subs[_n-1]
bys new_id : gen lagyr_grain_subs_tg=grain_subs_tg[_n-1]



save `pds_trans'
restore
