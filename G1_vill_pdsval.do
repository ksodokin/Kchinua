

/*This do-file  :

	1) Gets data from HH-monthly level to Village-Month level
  
   
*/


preserve

use "$analysis_data_dir/hh_mon_agg", replace


egen exp=rowtotal(food_tot_val nf_tot_val),missing
		

*Change the transfer to per-capita real value
local pclist grain_subs grain_subs_tg 
foreach x of local pclist  {	

	*Deflate to 2010 rupees 
	qui: replace `x'=(`x'/cpi_generalindex)*100			
	
	replace `x'=`x'/wt_nhh
	
	}	
	

	
		
*Get data to village-Month level	

	
collapse (mean)  grain_subs grain_subs_tg   exp   ///
                 , by(state village sur_mon_yr)
	

	
	

drop if village==""
	
**REGENERATE PANEL VARIABLES**	
encode village, gen(vill)
encode state,gen(st)
	


		**Convert sur_mon_yr to STATA month format
		gen mon_yr=monthly(sur_mon_yr,"M20Y")
		drop if mon_yr<606|mon_yr>665
		format mon_yr %tm
		
		gen year= "20"+substr(sur_mon_yr,-2,2)
		gen month=substr(sur_mon_yr,1,2)
		destring year month, replace
		
		
		
*Create Crop year - June to June variables
gen pan_year=year if month>=7
replace pan_year=year-1 if month<7

				
				
				
save `pds_trans_vill'
restore				
				
				
				
