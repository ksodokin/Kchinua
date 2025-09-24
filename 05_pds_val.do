



/*
This do-file creates PDS transfer value
*/


*******************************************
/////// Calculate PDS Subsidy Value ///////
*******************************************

			
****Price Discount*****
gen rice_dis=rice_price_avg-pdsrice_alloc_price
gen wheat_dis=wheat_price_avg-pdswheat_alloc_price


egen grain_dis=rowmean(rice_dis wheat_dis)

	replace rice_dis=0 if rice_dis==.
	replace wheat_dis=0 if wheat_dis==.
	replace grain_dis=0 if grain_dis==.
		

/////////////////////////////
*Transfer Entitlement Value *		
/////////////////////////////

gen rice_subs=pdsrice_alloc_qty*rice_dis
gen wheat_subs=pdswheat_alloc_qty*wheat_dis
egen grain_subs=rowtotal(rice_subs wheat_subs)
	
	label variable grain_subs "pds grain subsidy amount in Rs"
	
	
	
///////////////////////////
*Transfer Received  Value *		
///////////////////////////

*Note : current market prices, instead of constant average 

*Calculate price discount 
	*(Note: pdsrice_price=0 if pdsrice_price==., so you can subtract)
	gen rice_dis_rec=rice_price-pdsrice_price
	replace rice_dis_rec=pdsrice_price if rice_price<pdsrice_price
	
	gen wheat_dis_rec=wheat_price-pdswheat_price
	replace wheat_dis_rec=pdswheat_price if wheat_price_avg<pdswheat_price

	gen grain_dis_rec=(rice_dis_rec+wheat_dis_rec)/2 

		
		****Received Implicit Subsidy Value *****
		
		*Rice subsidy received (Consumption*Received price)
		gen rice_subs_rec=pdsrice_qty*rice_dis_rec

		*Wheat subsidy
		gen wheat_subs_rec=pdswheat_qty*wheat_dis_rec

		*Staple cereal (Rice+Wheat) subsidy
		egen grain_subs_rec=rowtotal(rice_subs_rec wheat_subs_rec)




	

