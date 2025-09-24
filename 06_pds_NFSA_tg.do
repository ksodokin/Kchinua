


/*
This do-file creates NFSA Target values (instrument)
*/


***********************
**** NFSA TARGETS *****
***********************

/*		
These calculations below assume you have isolated all the variation - Fixed ration cards and fixed HH-size

*Price targets should not exceed : (Under Schedule I in NFSA ACT)
*Rice: Rs. 3/kg
*Wheat: Rs. 2/kg

*Quantity targets should be atleast : (Under Section 3(1) of NFSA)
*5kg of grain per member- For HH-size of 5, 25kg/household
*Rice: Rs. 3/kg
*Wheat: Rs. 2/kg		
		
*/



	*Before 2013 : Assign the same entitlements before Sept 2013
		
		gen pdsrice_alloc_price_tg=pdsrice_alloc_price if mon_yr<tm(2013m3)
		gen pdswheat_alloc_price_tg=pdswheat_alloc_price if mon_yr<tm(2013m3)
		gen pdsrice_alloc_qty_tg=pdsrice_alloc_qty if mon_yr<tm(2013m3)
		gen pdswheat_alloc_qty_tg=pdswheat_alloc_qty if mon_yr<tm(2013m3)
		
		
	*After Sept 2013:

		*Price targets
		
			*BPL and AAY
			replace pdsrice_alloc_price_tg=3 if mon_yr>=tm(2013m3)&(card=="BPL"|card=="AAY")
			replace pdswheat_alloc_price_tg=2 if mon_yr>=tm(2013m3)&(card=="BPL"|card=="AAY")
						
			*If states had already overshot targets before NFSA, keep them as they are
			replace pdsrice_alloc_price_tg=1 if mon_yr>=tm(2013m3)&(state_str=="AndhraPradesh"|state_str=="Jharkhand"|state_str=="Orissa")&(card=="BPL"|card=="AAY")
			
			*No change in Orissa in Feb 2013
			replace pdsrice_alloc_price_tg = 2 if state_str=="Orissa"&(card=="AAY"|card=="BPL")
					
		
			*APL
			replace pdsrice_alloc_price_tg=. if mon_yr>=tm(2013m3)&(card=="APL"|card=="No card")
			replace pdswheat_alloc_price_tg=. if mon_yr>=tm(2013m3)&(card=="APL"|card=="No card")
			
			
		*Quantity targets

		
			*AAY households - remain the same
			replace pdsrice_alloc_qty_tg=pdsrice_alloc_qty if mon_yr>=tm(2013m3)&card=="AAY"
			replace pdswheat_alloc_qty_tg=pdswheat_alloc_qty if mon_yr>=tm(2013m3)&card=="AAY"
		
			**BPL households
			replace pdsrice_alloc_qty_tg=3*hh_size_m if mon_yr>=tm(2013m3)&card=="BPL"
			replace pdswheat_alloc_qty_tg=2*hh_size_m if mon_yr>=tm(2013m3)&card=="BPL"
		
		
			*If states had already overshot targets before NFSA, keep them as they are

			*** Retain the Split between rice and wheat ***	
				*AP, Jharkhand and Orissa 
				replace pdsrice_alloc_qty_tg=5*hh_size_m if mon_yr>=tm(2013m3)&(state_str=="AndhraPradesh"|state_str=="Jharkhand"|state_str=="Orissa")&(card=="BPL")
				replace pdswheat_alloc_qty_tg=0 if mon_yr>=tm(2013m3)&(state_str=="AndhraPradesh"|state_str=="Jharkhand"|state_str=="Orissa")&(card=="BPL")
				
				*GJ
				replace pdsrice_alloc_qty_tg=1*hh_size_m if mon_yr>=tm(2013m3)&(state_str=="Gujarat")&card=="BPL"
				replace pdswheat_alloc_qty_tg=4*hh_size_m if mon_yr>=tm(2013m3)&(state_str=="Gujarat")&card=="BPL"
				
				*MP
				replace pdsrice_alloc_qty_tg=1*hh_size_m if mon_yr>=tm(2013m3)&(state_str=="MadhyaPradesh")&card=="BPL"
				replace pdswheat_alloc_qty_tg=4*hh_size_m if mon_yr>=tm(2013m3)&(state_str=="MadhyaPradesh")&card=="BPL"

				*KN
				replace pdsrice_alloc_qty_tg=4*hh_size_m if mon_yr>=tm(2013m3)&(state_str=="Karnataka")&card=="BPL"
				replace pdswheat_alloc_qty_tg=1*hh_size_m if mon_yr>=tm(2013m3)&(state_str=="Karnataka")&card=="BPL"
				
				
				replace pdsrice_alloc_qty_tg=35 if mon_yr>=tm(2013m3)&(state_str=="Jharkhand"&card=="BPL")				
				replace pdsrice_alloc_qty_tg=30 if mon_yr>=tm(2013m3)&(state_str=="Orissa"&card=="BPL")
			
				*APL
				replace pdsrice_alloc_qty_tg=0 if mon_yr>=tm(2013m3)&(card=="APL"|card=="No card")
				replace pdswheat_alloc_qty_tg=0 if mon_yr>=tm(2013m3)&(card=="APL"|card=="No card")
			
					
		*For No-cards/APL and for AP,JH and OR -- No Wheat		
		replace pdsrice_alloc_price_tg=. if pdsrice_alloc_price==.				
		replace pdswheat_alloc_price_tg=. if pdswheat_alloc_price==.		
		replace pdsrice_alloc_qty_tg=0 if pdsrice_alloc_qty==0
		replace pdswheat_alloc_qty_tg=0 if pdswheat_alloc_qty==0
	
		

		
		
****************************
**PDS GRAIN SUBSIDY TARGET**
****************************

*PDS grain alloc qty
	egen pdsgrain_alloc_qty_tg= rowtotal(pdsrice_alloc_qty_tg pdswheat_alloc_qty_tg)
	egen pdsgrain_alloc_price_tg=rowmean(pdsrice_alloc_price_tg pdswheat_alloc_price_tg)

	
*Price Discount	

	gen rice_dis_tg=rice_price_avg-pdsrice_alloc_price_tg
	gen wheat_dis_tg=wheat_price_avg-pdswheat_alloc_price_tg

	egen grain_dis_tg=rowmean(rice_dis_tg wheat_dis_tg)				

			replace rice_dis_tg=0 if rice_dis_tg==.
			replace wheat_dis_tg=0 if wheat_dis_tg==.
			replace grain_dis_tg=0 if grain_dis_tg==.
			

*Subsidy transfer value
	
	gen rice_subs_tg=pdsrice_alloc_qty_tg*rice_dis_tg
	gen wheat_subs_tg=pdswheat_alloc_qty_tg*wheat_dis_tg
	egen grain_subs_tg=rowtotal(rice_subs_tg wheat_subs_tg)
	
		
		

