****************************************************
*** THIS FILE CREATES PDS ALLOCATION  VARIABLES  ***
***       2010, 2011, 2012, 2013, 2014           ***
***			30 VILLAGES IN SAT AND EI 			 ***
****************************************************

*Entitlements are assigned state-wise


*Create PDS allocation variables
gen pdsrice_alloc_price=.
gen pdsrice_alloc_qty=.
gen pdswheat_alloc_qty=.
gen pdswheat_alloc_price=.


	*No PDS for HHs with no ration card
	replace pdsrice_alloc_qty=0 if card=="No card"
	replace pdsrice_alloc_price=. if card=="No card"
	
	replace pdswheat_alloc_qty=0 if card=="No card"
	replace pdswheat_alloc_price=. if card=="No card"


****************************
/////// STATE - AP /////////
****************************


	//Rice policy
		*Price change for everyone
			replace pdsrice_alloc_price=2 if state=="AP"&mon_yr<=tm(2011m10)
			replace pdsrice_alloc_price=1 if state=="AP"&mon_yr>=tm(2011m11)

		*Quota change
			*AAY (No change for AAY)
				replace pdsrice_alloc_qty=35 if state=="AP"&card=="AAY"

			*BPL & APL
				*Before : 4kg/member (Max ceiling of 20 kg/HH)
				replace pdsrice_alloc_qty=hh_size_m*4 if state=="AP"&card=="BPL"
				replace pdsrice_alloc_qty=20 if state=="AP"&(card=="BPL")&pdsrice_alloc_qty>20
				
				*After Nov 2014 (In Telangana only) : 6kg/member(No ceiling)
				replace pdsrice_alloc_qty=hh_size_m*6 if state=="AP"&(card=="BPL")&(village=="Aurepalle"|village=="Dokur")&mon_yr>=tm(2014m11)

				*After April 2015 (In AP only) : 5kg/member(No ceiling)
				replace pdsrice_alloc_qty=hh_size_m*5 if state=="AP"&(card=="BPL")&(village=="Pamidipadu"|village=="JCAgraharam")&mon_yr>=tm(2015m4)


				
	//Wheat policy
		replace pdswheat_alloc_qty=0 if state=="AP"
		replace pdswheat_alloc_price=. if state=="AP"

		
****************************		
/////// STATE - BH /////////		
****************************


	//Rice policy
	
		*AAY
			replace pdsrice_alloc_price = 3 if state=="BH"&card=="AAY"
			replace pdsrice_alloc_qty = 21 if state=="BH"&card=="AAY"
			replace pdsrice_alloc_qty = 20 if state=="BH"&vill=="A"&card=="AAY"

		*BPL
			*Before NFSA
			replace pdsrice_alloc_price = 7 if state=="BH"&card=="BPL"
			replace pdsrice_alloc_qty = 15 if state=="BH"&card=="BPL"
					
			*After Feb 2014 - NFSA entitlements (Rice is 3 kg/member) 
			replace pdsrice_alloc_qty = 3*hh_size_m if state=="BH"&card=="BPL"&mon_yr>=tm(2014m2)
			replace pdsrice_alloc_price = 3 if state=="BH"&card=="BPL"&mon_yr>=tm(2014m2)
			
		*APL (No PDS for APL in BH)
			replace pdsrice_alloc_qty=0 if state=="BH"&card=="APL"
			replace pdsrice_alloc_price=. if state=="BH"&card=="APL"
		
	//Wheat policy
	
		*AAY
			replace pdswheat_alloc_price = 2 if state=="BH"&card=="AAY"
			replace pdswheat_alloc_qty = 14 if state=="BH"&card=="AAY"
			replace pdswheat_alloc_qty = 15 if state=="BH"&card=="AAY"&vill=="A"

		*BPL
			*Before NFSA
			replace pdswheat_alloc_price = 5 if state=="BH"&card=="BPL"
			replace pdswheat_alloc_qty = 10 if state=="BH"&card=="BPL"
					
			*After Feb 2014 - NFSA entitlements (Wheat is 2 kg/member)
			replace pdswheat_alloc_qty = 2*hh_size_m if state=="BH"&card=="BPL"&mon_yr>=tm(2014m2)
			replace pdswheat_alloc_price = 2 if state=="BH"&card=="BPL"&mon_yr>=tm(2014m2)
 
		*APL (No PDS for APL in BH)
			replace pdswheat_alloc_qty=0 if state=="BH"&card=="APL"
			replace pdswheat_alloc_price=. if state=="BH"&card=="APL"
 
****************************
/////// STATE - GJ /////////	
****************************


	//Rice policy

		*AAY
		replace pdsrice_alloc_qty = 16 if state=="GJ"&card=="AAY"
		replace pdsrice_alloc_price = 3 if state=="GJ"&card=="AAY"
		
		*BPL
		replace pdsrice_alloc_qty = 5 if state=="GJ"&card=="BPL"
		replace pdsrice_alloc_price = 3 if state=="GJ"&card=="BPL"
		
		*APL
		replace pdsrice_alloc_qty=0 if state=="GJ"&card=="APL"
		replace pdsrice_alloc_price=. if state=="GJ"&card=="APL"

	//Wheat policy

		*AAY
		replace pdswheat_alloc_qty = 19 if state=="GJ"&card=="AAY"
		replace pdswheat_alloc_price = 2 if state=="GJ"&card=="AAY"
		
		*BPL
		replace pdswheat_alloc_qty = 13 if state=="GJ"&card=="BPL"
		replace pdswheat_alloc_price = 2 if state=="GJ"&card=="BPL"

		*APL
		replace pdswheat_alloc_qty=0 if state=="GJ"&card=="APL"
		replace pdswheat_alloc_price=. if state=="GJ"&card=="APL"
		

		
****************************
/////// STATE - JH /////////
****************************
	

	//Rice policy 
	replace pdsrice_alloc_price=1 if state=="JH"&(card=="BPL"|card=="AAY")
	replace pdsrice_alloc_qty=35 if state=="JH"&(card=="BPL"|card=="AAY")
	
	//Wheat policy
	replace pdswheat_alloc_price=. if state=="JH"
	replace pdswheat_alloc_qty=0 if state=="JH"
	
	*APL
	replace pdsrice_alloc_qty=0 if state=="JH"&card=="APL"
	replace pdsrice_alloc_price=. if state=="JH"&card=="APL"
	
	replace pdswheat_alloc_qty=0 if state=="JH"&card=="APL"
	replace pdswheat_alloc_price=. if state=="JH"&card=="APL"
		

	
****************************
/////// STATE - KN /////////
****************************

	//Rice policy

		*AAY
			*Quota remained same
				replace pdsrice_alloc_qty = 29 if state=="KN"&card=="AAY"
			*Price
				*Before ABS
				replace pdsrice_alloc_price = 3 if state=="KN"&card=="AAY"&mon_yr<tm(2013m7)

				*After ABS
				replace pdsrice_alloc_price = 1 if state=="KN"&card=="AAY"&mon_yr>=tm(2013m7)
		*BPL
		
			*Before ABS
				*Quota (4kg/member upto 20 kg/HH)
				replace pdsrice_alloc_qty = 4*hh_size_m if state=="KN"&card=="BPL"&mon_yr<tm(2013m7)
				replace pdsrice_alloc_qty=20 if state=="KN"&mon_yr<tm(2013m7)&card=="BPL"&pdsrice_alloc_qty>20

				*Price
				replace pdsrice_alloc_price = 3 if state=="KN"&card=="BPL"&mon_yr<tm(2013m7)
					
			*After ABS
				*Quota (30kg rice per HH)
				replace pdsrice_alloc_qty=10*hh_size_m if state=="KN"&card=="BPL"&mon_yr>=tm(2013m7)
				replace pdsrice_alloc_qty=27 if state=="KN"&card=="BPL"&mon_yr>=tm(2013m7)&pdsrice_alloc_qty>27
				
				
				*Price 
				replace pdsrice_alloc_price = 1 if state=="KN"&card=="BPL"&mon_yr>=tm(2013m7)

		*APL
			replace pdsrice_alloc_qty=0 if state=="KN"&card=="APL"
			replace pdsrice_alloc_price=. if state=="KN"&card=="APL"
			
	//Wheat policy

		*AAY
			*Quota remained same
				replace pdswheat_alloc_qty = 6 if state=="KN"&card=="AAY"
			*Price
				*Before ABS
				replace pdswheat_alloc_price = 2 if state=="KN"&card=="AAY"

				*After ABS
				replace pdswheat_alloc_price = 1 if state=="KN"&card=="AAY"&mon_yr>=tm(2013m10)
		*BPL
		
			*Before ABS
				*Quota (1kg/member upto 3 kg/HH)
				replace pdswheat_alloc_qty = 1*hh_size_m if state=="KN"&card=="BPL"&mon_yr<tm(2013m7)
				replace pdswheat_alloc_qty=3 if state=="KN"&mon_yr<tm(2013m7)&card=="BPL"&pdswheat_alloc_qty>3

				*Price
				replace pdswheat_alloc_price = 3 if state=="KN"&card=="BPL"
					
			*After ABS
				*Quota (30kg rice per HH)
				replace pdswheat_alloc_qty=3 if state=="KN"&card=="BPL"&mon_yr>=tm(2013m7)
				
				
				
				*Price 
				replace pdswheat_alloc_price = 1 if state=="KN"&card=="BPL"&mon_yr>=tm(2013m10)
				
		*APL
			replace pdswheat_alloc_qty=0 if state=="KN"&card=="APL"
			replace pdswheat_alloc_price=. if state=="KN"&card=="APL"
			
****************************
/////// STATE - MH /////////
****************************

				

	//Rice policy

		*AAY (No change)
			replace pdsrice_alloc_price = 3 if state=="MH"&card=="AAY"
			replace pdsrice_alloc_qty = 15 if state=="MH"&card=="AAY"

		*BPL
			*Before NFSA (Double check notes!!)
			replace pdsrice_alloc_price = 6 if state=="MH"&card=="BPL"&mon_yr<tm(2014m2)
			replace pdsrice_alloc_qty = 5 if state=="MH"&card=="BPL"&mon_yr<tm(2014m2)

			*After Feb 2014 - NFSA entitlements (Rice is 2 kg/member)
			replace pdsrice_alloc_qty = 2*hh_size_m if state=="MH"&card=="BPL"&mon_yr>=tm(2014m2)
			replace pdsrice_alloc_price = 3 if state=="MH"&card=="BPL"&mon_yr>=tm(2014m2)
			
		*APL
			replace pdsrice_alloc_qty = 6 if state=="MH"&card=="APL"
			replace pdsrice_alloc_price = 9.6 if state=="MH"&card=="APL"
		

	//Wheat Policy
	
		*AAY (No change)
			replace pdswheat_alloc_price = 2 if state=="MH"&card=="AAY"
			replace pdswheat_alloc_qty = 20 if state=="MH"&card=="AAY"

		*BPL
			*Before NFSA (Double check notes!!)
			replace pdswheat_alloc_price = 5 if state=="MH"&card=="BPL"&mon_yr<tm(2014m2)
			replace pdswheat_alloc_qty = 10 if state=="MH"&card=="BPL"&mon_yr<tm(2014m2)

			*After Feb 2014 - NFSA entitlements (Wheat is 3 kg/member)
			replace pdswheat_alloc_qty = 3*hh_size_m if state=="MH"&card=="BPL"&mon_yr>=tm(2014m2)
			replace pdswheat_alloc_price = 2 if state=="MH"&card=="BPL"&mon_yr>=tm(2014m2)
			
		*APL
			replace pdswheat_alloc_qty = 9 if state=="MH"&card=="APL"
			replace pdswheat_alloc_price = 7.2 if state=="MH"&card=="APL"
	
	
		replace card="APL" if card=="Others"&state=="MH"

****************************
/////// STATE - MP /////////
****************************



	//Rice Policy
		*AAY 
			*Quota Remained same
				replace pdsrice_alloc_qty = 5 if state=="MP"&card=="AAY"

			*Price changed 2 times
				*Before June 2013
				replace pdsrice_alloc_price = 3 if state=="MP"&card=="AAY"

				*After June 2013 and before Feb 2014 - MAS 
				replace pdsrice_alloc_price = 2 if state=="MP"&card=="AAY"&mon_yr>=tm(2013m6)&mon_yr<tm(2014m2)

				*After Feb 2014 - Rice price changed to Re 1/kg
				replace pdsrice_alloc_price = 1 if state=="MP"&card=="AAY"&mon_yr>=tm(2014m2)
		*BPL
		
			*Quota
				*Before NFSA (April 2014)
				replace pdsrice_alloc_qty = 2 if state=="MP"&card=="BPL"
				
				*April 2014 - NFSA was introduced (Rice 1kg/member)
				replace pdsrice_alloc_qty = 1*hh_size_m if state=="MP"&card=="BPL"&mon_yr>=tm(2014m4)
			
			*Price changed 2 times
				*Before June 2013
				replace pdsrice_alloc_price = 4.5 if state=="MP"&card=="BPL"
				
				*After June 2013 and before Feb 2014 - MAS 
				replace pdsrice_alloc_price = 2 if state=="MP"&card=="BPL"&mon_yr>=tm(2013m6)&mon_yr<tm(2014m2)
				
				*After Feb 2014 - Rice price changed to Re 1/kg
				replace pdsrice_alloc_price = 1 if state=="MP"&card=="BPL"&mon_yr>=tm(2014m2)	
				
		*APL
			replace pdsrice_alloc_qty=0 if state=="MP"&card=="APL"
			replace pdsrice_alloc_price=. if state=="MP"&card=="APL"
			

				
	//Wheat Policy
		*AAY 
			*Quota Remained same
				replace pdswheat_alloc_qty = 30 if state=="MP"&card=="AAY"

			*Price changed once 
				*Before June 2013
				replace pdswheat_alloc_price = 2 if state=="MP"&card=="AAY"

				*After June 2013 - MAS - Wheat price was reduced to Rs 1/kg
				replace pdswheat_alloc_price = 1 if state=="MP"&card=="AAY"&mon_yr>=tm(2013m6)
				
		*BPL
		
			*Quota
				*Before NFSA (April 2014)
				replace pdswheat_alloc_qty = 18 if state=="MP"&card=="BPL"
				
				*April 2014 - NFSA was introduced (Wheat 4kg/member)
				replace pdswheat_alloc_qty = 4*hh_size_m if state=="MP"&card=="BPL"&mon_yr>=tm(2014m4)
			
			*Price changed once
				*Before June 2013
				replace pdswheat_alloc_price = 3 if state=="MP"&card=="BPL"
				
				**After June 2013 - MAS - Wheat price was reduced to Rs 1/kg 
				replace pdswheat_alloc_price = 1 if state=="MP"&card=="BPL"&mon_yr>=tm(2013m6)
	
		*APL
				replace pdswheat_alloc_qty=0 if state=="MP"&card=="APL"
				replace pdswheat_alloc_price=. if state=="MP"&card=="APL"
			
	


		
****************************
/////// STATE - OR /////////
****************************
		
	*Rice Policy

		*AAY 
			*Quota remained same
			replace pdsrice_alloc_qty = 35 if state=="OR"&card=="AAY"

			*Price changed 
				*Before Feb 2013
				replace pdsrice_alloc_price = 2 if state=="OR"&card=="AAY"
				*After Feb 2013
				replace pdsrice_alloc_price = 1 if state=="OR"&card=="AAY"&mon_yr>=tm(2013m2)

		*BPL
			*Quota remained same, except it changed in certain villages
				replace pdsrice_alloc_qty = 30 if state=="OR"&card=="BPL"
				replace pdsrice_alloc_qty = 30 if state=="OR"&card=="BPL"&vill=="C"&mon_yr>=tm(2011m1)&mon_yr<=tm(2012m4)
				
				
			*Price changed 
				*Before Feb 2013
				replace pdsrice_alloc_price = 2 if state=="OR"&card=="BPL"
				*After Feb 2013
				replace pdsrice_alloc_price = 1 if state=="OR"&card=="BPL"&mon_yr>=tm(2013m2)
				

				
		*APL (coded as No card) - NO PDS rice for APL in Orissa
			replace pdsrice_alloc_qty=0 if state=="OR"&card=="APL"
			replace pdsrice_alloc_price=. if state=="OR"&card=="APL"
			
			
	//Wheat policy (No Wheat for BPL and AAY)
	
		*BPL and AAY
			replace pdswheat_alloc_price=. if state=="OR"
			replace pdswheat_alloc_qty=0 if state=="OR"
			


			
		

			
******************************************************************
/////// Grain(Rice+wheat) Entitlement Quantity and Price /////////
******************************************************************



	*PDS grain alloc qty
	egen pdsgrain_alloc_qty= rowtotal(pdsrice_alloc_qty pdswheat_alloc_qty)
	egen pdsgrain_alloc_price=rowmean(pdsrice_alloc_price pdswheat_alloc_price)

	*PDS grain alloc value
	gen pdsrice_alloc_val=pdsrice_alloc_qty*pdsrice_alloc_price
	gen pdswheat_alloc_val=pdswheat_alloc_qty*pdswheat_alloc_price
	egen pdsgrain_alloc_val=rowtotal(pdsrice_alloc_val pdswheat_alloc_val)

			

			
			
			
