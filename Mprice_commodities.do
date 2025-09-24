



/*This do-file cleans Mprice of Commodites Files 
  and collapses the data to village-month level  */
  


/////// Mprice - Commodities and Food  ///////

use "$stata_data_dir/MPrice/Aggregate/Commodities_agg",replace
		
		*First, create a market price variable for each commodity  
			local mylist type_com name_com unit_com
			foreach x of local mylist {
			replace `x'=lower(`x')
			}

			
			gen rice_fine= name_com=="finerice"|name_com=="rice-fine"
			gen rice_avgqual= name_com=="rice-avg.quality"|name_com=="averagequalityrice"
			gen rice_superfine= name_com=="superfinerice"|name_com=="rice-superfine"|name_com=="super-finerice"
			gen rice_all= rice_fine==1|rice_avgqual==1|rice_superfine==1
			
			gen paddy=strmatch(name_com,"*padd*")
			gen wheat= name_com=="wheat"|name_com=="wheat-localmarket"|name_com=="wheat(localmarket)"
			gen sugar= name_com=="sugar"|name_com=="sugar-marketprice"
			gen oils= name_com=="palmoil"
			
				*Pulses
				gen pulse=strmatch(name_com,"*chick*")|strmatch(name_com,"pigeonpea*")|strmatch(name_com,"*gram*")|strmatch(name_com,"lentil*")
				gen pulse_all=type_com=="pulses"|type_com=="splitdals"
				gen pigeonpea= strmatch(name_com,"pigeonpea*")
				gen chickpea=strmatch(name_com,"*chick*")
				gen grams=strmatch(name_com,"*gram*")
				
				*Coarse
				gen coarse=strmatch(name_com,"*maize*")|strmatch(name_com,"*sorghum*")|strmatch(name_com,"*millet*")
			
			
			
		
		**Merge Price of Milk, chicken and meat  
		append using "$stata_data_dir/MPrice/Aggregate/Others_agg",force

		
			local mylist type_ot name_ot  unit_ot
			foreach x of local mylist {
			replace `x'=lower(`x')
			}
		
			
			gen milk_cow= name_ot=="cowmilk"
			gen milk_buffalo=name_ot=="buffalomilk"
			gen chicken=name_ot=="chicken"
			gen eggs=name_ot=="eggs"
			gen fish=name_ot=="fish"
			gen mutton=name_ot=="mutton"
			
			
			*Milk is in Lt; Chicken,Fish and mutton is in Kg ; Eggs is in Dozen and some are in numbers
						
		
		***Combine price_com_a and price_ot_a
			local mylist a b c d e 
			foreach x of local mylist {
			gen price_`x'=price_com_`x' if price_ot_`x'==.
				replace price_`x'= price_ot_`x' if price_com_`x'==.
			}
	
		
		
		keep if rice_fine==1| rice_avgqual==1|rice_superfine==1|rice_all==1|paddy==1|       ///
				wheat==1|oils==1|sugar==1|pigeonpea==1|pulse==1|pulse_all==1|chickpea==1|grams==1|coarse==1|     ///
				milk_cow==1|milk_buffalo==1|chicken==1|eggs==1|fish==1|mutton==1
		
				/*Note: To get the market price of rice, consider the average of the following two prices
				price_com_d: Price by village trader
				price_com_e: Price by trader from nearest market
				If both are missing, then replace by 
				price_com_a: Price by large farmer
				price_com_b: Price by medium farmer
				price_com_c: Price by landless farmer
				*/
				gen price=(price_d+price_e)/2
				replace price= price_e if price==.
				replace price= price_d if price==.
				replace price= price_a if price==.
				replace price= price_b if price==.
				replace price= price_c if price==.


				*Change unit from quintal to Kg. 
				replace price=price/100 if unit_com=="qt"
				replace unit_com="kg" if unit_com=="qt"
				
				*Change price unit of Oils from Rs/lt to Rs/kg
				replace price=price*1.042 if unit_com=="lt"&oils==1
				replace unit_com="kg" if unit_com=="lt"&oils==1
				
				*Change price unit of Eggs from Rs/number to Rs/dozen
				replace price =price*12 if unit_ot=="no"&eggs==1
				replace unit_ot="dozen" if unit_ot=="no"&eggs==1
				
			/*Market price of each commodity */
			local mylist rice_fine rice_avgqual rice_superfine rice_all paddy wheat pigeonpea pulse pulse_all chickpea grams oils coarse sugar milk_cow  milk_buffalo  chicken eggs fish mutton
			foreach x of local mylist {
			gen `x'_price=price if `x'==1
			}
			
		*Second, convert the Mp-id format to "village - sur_mon_yr" format
			*First, clean village names and then clean sur_mon_yr
			*Clean village names:
				*(Only SAT has village name data in Gen_info file)
				*For SAT: Merge Info-file to get the village names associated with mp-ids 
					merge m:1 mp_id using "$stata_data_dir/MPrice/Aggregate/M_gen_info_agg.dta"
					drop if _merge==2
					drop _merge
				
					*Clean village variable for SAT
					replace village="Aurepalle" if village=="Aurepalli"
					replace village="JCAgraharam" if village=="J.C.Agraharam"
					replace village="Kapanimbargi" if village=="Kappanimbargi"
					replace village="Karamdichingariya" if village=="KaramdiChingariya"
					replace village="Kinkhed" if village=="Kinkheda"
					replace village="Tharati" if village=="Tharati/Ajjihalli"

					replace state="AndhraPradesh" if state=="Telangana"
				
				*For EI: Convert village_ids to village names
					replace village="Dubaliya" if village_id=="INJHDUB"
					replace village="Hesapiri" if village_id=="INJHHES"
					replace village="Dumariya" if village_id=="INJHDUM"
					replace village="Durgapur" if village_id=="INJHDUR"
					replace village="Arap" if village_id=="INBHARA"
					replace village="Bhagakole" if village_id=="INBHBAG"
					replace village="Inai" if village_id=="INBHINA"
					replace village="Susari" if village_id=="INBHSUS"
					replace village="Sogar" if village_id=="INORSOG"
					replace village="Chandrasekharpur" if village_id=="INORCSK"|village_id=="INORCHA"|village_id=="INORCSP"
					replace village="Ainlatunga" if village_id=="INORAIN"|village_id=="INORAIL"|village_id=="INORANL"
					replace village="Bilaikani" if village_id=="INORBIL"
					
					*Clean state variable for EI
					replace mp_id=subinstr(mp_id,"N","",1) if strlen(mp_id)==11
					
					gen state2=substr(mp_id,2,2)
					replace state="Jharkhand" if state2=="JH"
					replace state="Bihar" if state2=="BH"
					replace state="Orissa" if state2=="OR"
															
			*Clean sur_mon_yr
				*Create year and month variable
					drop month
					gen year = substr(mp_id, 4, 2)
					gen month = substr(mp_id, -3, 3)

					destring year,replace

					*Survey starts every July.
					*The digits for year 13 in mp_id, represents survey year from July 2013 to June 2014  
					*For example mp_id=IAP10A-JAN the digits for year=10 means Jan 2011 and not Jan 2010
					*For example mp_id=IAP10A-NOV the digits for year=10 means Nov 2010 
					*For example mp_id=IAP10A-JUN the digits for year=10 means June 2011 and not June 2010
					*For example mp_id=IAP10A-JUL the digits for year=10 means July 2010

					*Increment year by 1 for months Jan to June
					replace year=year+1 if month=="JAN"|month=="FEB"|month=="MAR"|month=="APR"|month=="MAY"|month=="JUN"
			
					gen mon=1 if month=="JAN"
					replace mon=2 if month=="FEB"
					replace mon=3 if month=="MAR"
					replace mon=4 if month=="APR"
					replace mon=5 if month=="MAY"
					replace mon=6 if month=="JUN"
					replace mon=7 if month=="JUL"
					replace mon=8 if month=="AUG"
					replace mon=9 if month=="SEP"
					replace mon=10 if month=="OCT"
					replace mon=11 if month=="NOV"
					replace mon=12 if month=="DEC"

				*Create sur_mon_yr so that its easy to match with Food Consumption data
					tostring mon year,replace
					gen lg=length(mon)
					replace mon="0"+mon if lg==1
					drop lg

					gen sur_mon_yr=mon+"/"+year
					
								
		collapse (mean) rice_fine_price-mutton_price,by(state village sur_mon_yr)

		
		gen rice_price=rice_fine_price
		

			replace pigeonpea_price=. if pigeonpea_price>1000
			replace pulse_price=. if pulse_price>150
			replace chickpea_price=. if chickpea_price>150
			replace grams_price=. if grams_price>150
			
