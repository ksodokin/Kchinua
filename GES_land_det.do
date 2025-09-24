


/*This do-file cleans GEs Landholding Files 
  and collapses the data to household-panelyear level  */
  
 
 
/////// GES Landholding Details ///////

use "$stata_data_dir/GES/Aggregate/Landholding_det_agg",replace


	gen tot_area_own=tot_area if ow_stat=="OW"
	
		

collapse (sum)  tot_area tot_area_own irri_area ,by(vds_id)
	
	
	rename tot_area land_area_tot
	rename tot_area_own land_area_own
	rename irri_area land_area_irri
	
	gen land_area_irri_prop=land_area_irri/land_area_tot
	replace land_area_irri_prop=0 if land_area_irri_prop==.

	label variable land_area_tot "Total Area of landholding in acres (Total=Own+Leasedin/Out+Shared+MortgagedIn/Out)"
	label variable land_area_own "Area of own landholding in acres"
	label variable land_area_irri "Irrigated area total"
	label variable land_area_irri_prop " Proportion of Irrigated area"
