*******************************************************
**** THIS FILE ASSIGNS RATION CARDS FOR EACH HHID *****
*******************************************************
 
/*For EI : Ration Card data is available in GES - Govt Dev Programs
*For SAT: Ration Card data is for 2009 and not available in the public domain,
	- This data was collected from ICRISAT Office
*/

/*THIS DO-FILE does the following steps: 
Step 1: Get ration card data for EI
Step 2: Get ration card data for SAT 
Step 3: Append EI and SAT 
*/


tempfile  ei_rationcard
tempfile sat_rationcard


***************************************
****	  	  East India   			***
****  	(GES Govt Dev Programs)   	***	
***************************************
		
use "$stata_data_dir/GES/Aggregate/Govt_dev_agg",replace


**Keep only PDS Program*
keep if strmatch(program,"Public*")

*** Card edits***

*Label Ration Card types
	label define card_type 0 "No card" 1 "Red/Pink" 2 "White" 3 "Orange" 4 "Yellow-A" 5 "Yellow-B"  ///
						   6 "Annapurna" 7 "AAY" 8 "Others"
	
	label value card1 card_type

*Drop HHs that have multiple ration cards (about 5)
	duplicates drop vds_id,force

*Create a time-invariant HH id
	gen new_id=substr(vds_id,1,3)+substr(vds_id,6,10)
		
	
sort new_id sur_yr card1

		*Generate 2010,2011 and 2012 card status
		gen card_temp10=card1 if sur_yr==2010
		bys new_id: egen card_2010=min(card_temp10)
		
		gen card_temp11=card1 if sur_yr==2011
		bys new_id: egen card_2011=min(card_temp11)

		gen card_temp12=card1 if sur_yr==2012
		bys new_id: egen card_2012=min(card_temp12)

		gen card_temp13=card1 if sur_yr==2013
		bys new_id: egen card_2013=min(card_temp13)



*Consider only 2012 ration card status
gen card_ei=card_2012
	
*If card for 2012 is missing, then caonsider 2011 status
replace card_ei=card_2011 if card_ei==.

*If card is still missing, then consider 2010 status
replace card_ei=card_2010 if card_ei==.

*If card is still missing, then consider 2013 status
replace card_ei=card_2013 if card_ei==.

	

		label values card_ei card_type 
		
	*Collapse data to new_id level
		bys new_id: gen counterid=_n
		keep if counterid==1
		
	*Decode card into string variable
		decode card_ei, gen(card)
	
		keep new_id card


save `ei_rationcard'



	
***************************************
****	  	  	SAT    				***
****  (HCS Household Census Survey  ***	
***************************************

	
	
/* SAT ration card data from 2009*/
import excel using "$data_dir/Raw/RawAuxData/Proprietarydata/BPL_Card_2009.xlsx", firstrow case(lower) clear



	/*Note: There are 8 ration card types:

	 bpl_card1: 
		0 - No card
		1 - Red/Pink
		2 - White
		3 - Orange
		4 - Yellow-A
		5 - Yellow-B
		6 - Annapurna
		7 - Anthyodaya
		8 - Others
	We need to combine the above 8 categories into the following 3 main ration card types :
	  card:			
		0 - No card
		1 - APL
		2 - BPL
		3 - AAY
				
	*/

	gen state=substr(vds_id,2,2)
	gen village=substr(vds_id,6,1)

	*Create a ration card variable
	gen card=.


	***Following ration card color codes are collected from fieldwork


	*AP and GJ:

		*Red/Pink is APL
		replace card=1 if (state=="AP"|state=="GJ")&bpl_card1==1

		*White is BPL
		replace card=2 if (state=="AP"|state=="GJ")&bpl_card1==2
		
		*AAY is AAY
		replace card=3 if (state=="AP"|state=="GJ")&bpl_card1==7
		
		*Others 
		replace card=0 if vds_id=="IAP09C0002"
		replace card=3 if vds_id=="IAP09C0009"
		
	*KN: 
		*Note: All ration cards are recorded as Others
		
		*Others - Akshaya (Green) is BPL
		replace card=2 if state=="KN"&strmatch(bpl_card_ot,"*AKSHAY*")|strmatch(bpl_card_ot,"*AKASHAY*")|strmatch(bpl_card_ot,"*TATKALIK*")
		
		*Others - Red is APL
		replace card=1 if state=="KN"&((strmatch(bpl_card_ot,"*RED*")|strmatch(bpl_card_ot,"*ONLY*"))|bpl_card1==2)
		
		*AAY 
		replace card=3 if state=="KN"&bpl_card1==7
		
		*Yellow-A and Yellow-B is BPL
		replace card=2 if state=="KN"&(bpl_card1==4|bpl_card1==5)


	*MH: 
		*Yellow-A is BPL 
		replace card=2 if state=="MH"&bpl_card1==4
		
		*Orange or White is APL
		replace card=1 if state=="MH"&(bpl_card1==3|bpl_card1==1)
		
		*Yellow-B is AAY
		replace card=3 if state=="MH"&(bpl_card1==5|bpl_card1==7)			
		
		
	*MP: 
		*Yellow-A is AAY
		replace card=3 if state=="MP"&(bpl_card1==4|bpl_card1==5)
		
		*Others (BLUE) is BPL
		replace card=2 if state=="MP"&bpl_card1==8
		
		*White is APL
		replace card=1 if state=="MP"&bpl_card1==2
		

	*Combine Annapurna and AAY
	replace card=3 if bpl_card1==6

	*No card
	replace card=0 if bpl_card1==0

	*Label ration card values
	label define cardtype 0 "No card" 1 "APL" 2 "BPL" 3 "AAY"
						  
	label values card cardtype		  

	*Create a time-invariant HH id
	gen new_id=substr(vds_id,1,3)+substr(vds_id,6,10)


	*Decode card into string variable
	decode card, gen(card_str)

	drop card
	rename card_str card 

	keep new_id card 


save `sat_rationcard'




	
********************************************
**** APPEND EI AND SAT RATION CARD DATA ****
********************************************
	
	
use `ei_rationcard',replace
append using `sat_rationcard'
	

	
	
	
	
	
		

		
		
		