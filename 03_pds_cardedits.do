*******************************************************
****		  THIS FILE EDITS RATION CARDS 	   	  	***
****   	  			BASED ON FIELDWORK      		***
*******************************************************


*******************	
*** State : AP ****
*******************


*Village AP A
	replace card="AAY" if new_id=="IAPA0034"
	replace card="AAY" if new_id=="IAPA0307"
	replace card="No card" if new_id=="IAPA0058"
	replace card="BPL" if new_id=="IAPA0058"&mon_yr>=tm(2014m2)
	
	
*Village AP B
	replace hh_size=6 if new_id =="IAPB0038"
	replace hh_size=4 if new_id=="IAPB0276"	
	replace card="AAY" if new_id=="IAPB0303"|new_id=="IAPB0257"
	replace card="No card" if new_id=="IAPB0043"|new_id=="IAPB0047"|new_id=="IAPB0054"|new_id=="IAPB0201"|   ////
						   new_id=="IAPB0207"|new_id=="IAPB0288"|new_id=="IAPB0291"|new_id=="IAPB0290" 
							


*Village AP C
	replace card="AAY" if new_id=="IAPC0008"&mon_yr>=tm(2012m3)&mon_yr<=tm(2013m12)
	replace card="AAY" if new_id=="IAPC0009"&mon_yr<tm(2011m6)
	replace card="BPL" if new_id=="IAPC0010"&mon_yr<tm(2011m6)	
	replace card="AAY" if new_id=="IAPC0030"&mon_yr<tm(2012m1)
	replace card="BPL" if new_id=="IAPC0030"&mon_yr>=tm(2012m1)&mon_yr<=tm(2013m11)
	replace card="No card" if new_id=="IAPC0045"|new_id=="IAPC0052"|new_id=="IAPC0053"|new_id=="IAPC0055"



*Village AP D
	replace hh_size=6 if new_id=="IAPD0031"	
	replace card="No card" if new_id=="IAPD0050"|new_id=="IAPD0053"



*******************	
*** State : KN ****
*******************	

*Vill KN A


	replace card="APL" if new_id=="IKNA0003"|new_id=="IKNA0050"|new_id=="IKNA0051"
	replace card="BPL" if new_id=="IKNA0007"
	replace card="AAY" if new_id=="IKNA0001"|new_id=="IKNA0005"|new_id=="IKNA0009"|   ////
						new_id=="IKNA0006"|new_id=="IKNA0034"|new_id=="IKNA0059"


*Vill KN B 

	replace card="APL" if new_id=="IKNB0050"|new_id=="IKNB0058"
	replace card="No card" if new_id=="IKNB0054"|new_id=="IKNB0055"
	replace card="BPL" if new_id=="IKNB0057"
	

*Vill KN D
	replace card="APL" if new_id=="IKND0040"



replace card="APL" if card=="No card"&state=="KN"

*******************	
*** State : MH ****
*******************	



* Vill MH A

	replace card="BPL" if new_id=="IMHA0036"
	replace card="No card" if new_id=="IMHA0042"|new_id=="IMHA0043"|new_id=="IMHA0268"|new_id=="IMHA0281"|new_id=="IMHA0282"
	replace card="BPL" if new_id=="IMHA0049"
	replace card="APL" if new_id=="IMHA0270"|new_id=="IMHA0283"
	replace card="BPL" if new_id=="IMHA0202"|new_id=="IMHA0206"|new_id=="IMHA0280"|new_id=="IMHA0284"

* Vill MH B

replace card="APL" if new_id=="IMHB0222"|new_id=="IMHB0223"|new_id=="IMHB0236"|new_id=="IMHB0240"|new_id=="IMHB0242"
replace card="BPL" if new_id=="IMHB0032"|new_id=="IMHB0231"
replace card="No card" if new_id=="IMHB0040"|new_id=="IMHB0051"|new_id=="IMHB0055"|new_id=="IMHB0057"|new_id=="IMHB0234"
replace card="APL" if new_id=="IMHB0053"


* Vill MH C

replace card="AAY" if new_id=="IMHC0001"|new_id=="IMHC0033"|new_id=="IMHC0035"|new_id=="IMHC0203"|new_id=="IMHC0206"
replace card="No card" if new_id=="IMHC0047"|new_id=="IMHC0049"|new_id=="IMHC0052"|new_id=="IMHC0058"|new_id=="IMHC0200"|new_id=="IMHC0221"
replace card="APL" if new_id=="IMHC0051"

* Vill MH D

*APL Anna Suraksha (Convert APl Annasuraksha cards to BPL)
replace card="BPL" if new_id=="IMHD0002"|new_id=="IMHD0033"|new_id=="IMHD0034"|new_id=="IMHD0035"|new_id=="IMHD0036"|new_id=="IMHD0038"|    ////
					new_id=="IMHD0045"|new_id=="IMHD0049"|new_id=="IMHD0050"|new_id=="IMHD0051"|new_id=="IMHD0054"|new_id=="IMHD0071"|       ////     
					new_id=="IMHD0206"|new_id=="IMHD0224"|new_id=="IMHD0227"|new_id=="IMHD0228" |new_id=="IMHD0229"|new_id=="IMHD0275"|        ////
					new_id=="IMHD0308"|new_id=="IMHD0311"|new_id=="IMHD0313"|new_id=="IMHD0332"|new_id=="IMHD0333"|new_id=="IMHD0335"|			////
					new_id=="IMHD0279"|new_id=="IMHD0282"|new_id=="IMHD0286"|new_id=="IMHD0288"|new_id=="IMHD0289"								

replace card="BPL" if new_id=="IMHD0003"
replace card="APL" if new_id=="IMHD0003"|new_id=="IMHD0052"|new_id=="IMHD0312"
replace card="BPL" if new_id=="IMHD0310"


replace card="No card" if new_id=="IMHD0056"|new_id=="IMHD0059"|new_id=="IMHD0070"|new_id=="IMHD0081"|new_id=="IMHD0301"|new_id=="IMHD0309"



*******************	
*** State : MP ****
*******************

*Vill MP A


replace card="BPL" if new_id=="IMPA0030"|new_id=="IMPA0034"

*Vill MP B

replace card="APL" if new_id=="IMPB0001"|new_id=="IMPB0004"|new_id=="IMPB0057"|new_id=="IMPB0031"|new_id=="IMPB0039"|new_id=="IMPB0040"|new_id=="IMPB0045"|    ////
					  new_id=="IMPB0046"|new_id=="IMPB0052"|new_id=="IMPB0053"|new_id=="IMPB0054"


replace card="AAY" if new_id=="IMPB0005"|new_id=="IMPB0006"|new_id=="IMPB0007"|new_id=="IMPB0009"|new_id=="IMPB0035"|   ////
					  new_id=="IMPB0041"|new_id=="IMPB0049"|new_id=="IMPB0059"



*******************	
*** State : OR ****
*******************

*Rename Cards IN ORISSA
replace card="BPL" if (card=="Red/Pink"|card=="White"|card=="Others"|card=="Annapurna")&state=="OR"

* Vill OR A
	replace card="AAY" if new_id=="IORA0002"&mon_yr<tm(2012m5)
	replace card="AAY" if new_id=="IORA0044"	
	replace card="BPL" if new_id=="IORA0036"
	replace card="No card" if new_id=="IORA0003"&mon_yr<tm(2012m8)
	replace card="No card" if new_id=="IORA0041"&mon_yr<tm(2012m8)	
	replace card="No card" if new_id=="IORA0057"&mon_yr<tm(2012m8)
	
	
	
* Vill OR B
	
	replace card="BPL" if new_id=="IORB0002"&mon_yr<=tm(2012m8)
	replace card="BPL" if new_id=="IORB0007"&mon_yr>tm(2012m6)
	replace card="BPL" if new_id=="IORB0009"
	
	replace card="BPL" if new_id=="IORB0053"&mon_yr>=tm(2012m9)
	replace card="BPL" if new_id=="IORB0205"&mon_yr>=tm(2012m9)
		
* Vill OR C
	
	replace card="AAY" if new_id=="IORC0005"|new_id=="IORC0035"|new_id=="IORC0039"|new_id=="IORC0042"
	
	*Rename Yellow-A cards as BPL
	replace card="BPL" if new_id=="IORC0044"|new_id=="IORC0056"
	
	



*********************	
*** Double Cards ****
*********************

	*Double card
	replace card="AAY" if new_id=="IAPC0030"&mon_yr<=tm(2011m12)
	replace card="BPL" if new_id=="IAPC0030"&mon_yr>tm(2011m12)


*KN
	replace card="BPL" if new_id=="IKNB0059"
	replace card="BPL" if new_id=="IKNC0010"

*MH		

	replace card="BPL" if new_id=="IMHD0058"	
	
*MP
	replace card="BPL" if new_id=="IMPB0044"
	

	
	
	
	
******************************
*** Consistent Card Names ****
******************************	
	
*Rename Cards, so that SAT and EI data have consistent card names
	*Bihar
	replace card="AAY" if (card=="Yellow-A"|card=="Orange")&state=="BH"
	replace card="BPL" if card=="Red/Pink"&state=="BH"
	replace card="APL" if card=="Others"&state=="BH"

	*Jharkhand
	replace card="BPL" if (card=="Red/Pink"|card=="Yellow-A"|card=="Orange")&state=="JH"
	replace card="APL" if (card=="Others"|card=="No card"|card=="White")&state=="JH"

	*Orissa
	replace card="BPL" if (card=="Red/Pink"|card=="White"|card=="Others"|card=="Annapurna"|card=="Yellow-A"|card=="Orange")&state=="OR"
	replace card="APL" if (card=="No Card")&state=="OR"

	replace card="BPL" if card=="APL"&state=="AP"
	





