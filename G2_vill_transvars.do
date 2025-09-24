


/*This do-file  :
	Cleans and transforms price variables
	
	1) Generates Grain price (average of rice and wheat)
	2) Log and first differences of prices 
   
*/






*Grain price (avergae of rice and wheat)
gen grain_price=(rice_fine_price+wheat_price)/2
	
	
	*Grain price (No-missing values)
	gen grain_nom_price=grain_price
	replace grain_nom_price=rice_fine_price if wheat_price==.&grain_nom_price==.
	replace grain_nom_price=wheat_price if rice_fine_price==.&grain_nom_price==.





*******************************************
*LOG and First difference of all variables*
*******************************************

local pricelist  grain grain_nom rice_fine wheat  

foreach x of local pricelist {
	sort vill mon_yr
	
	*First difference
	bys vill: gen ch_`x'_price=`x'_price-`x'_price[_n-1]
	
		
	*Log
	gen ln_`x'_price=(ln(`x'_price))*100	
		
	*First difference of Logs
	bys vill : gen ch_ln_`x'_price=ln_`x'_price-ln_`x'_price[_n-1]	
	

	}
	
	
	

la var 	ch_ln_rice_fine_price "Rice Price"
la var 	ch_ln_wheat_price "Wheat Price"
la var 	ch_ln_grain_nom_price "Grain Price"


la var 	grain_subs "PDS Transfer value"


