




/*This do-file cleans Food Consumption Files 
	and Cleans Quantity Units */

	
	


	replace price_unit=unit_price if price_unit==.
	drop unit_price

	replace item_type=lower(item_type)
	replace item_name=lower(item_name)
	replace item_unit=proper(item_unit)
	replace item_unit="No" if item_unit=="No."
		


***Clean Quantity units of food items ***

*Convert all of them in terms of Kilograms (kg.)


*Bananas (convert from Kgs to Numbers) (10 bananas in 1 kg)
replace tot_qty=tot_qty*10 if item_name=="banana"&item_unit=="Kg"    
replace item_unit="No" if item_name=="banana"&item_unit=="Kg"

*Oils(convert from lt to kg)
replace tot_qty=tot_qty*0.96 if item_type=="oils"&item_unit=="Lt"
replace item_unit="Kg" if item_type=="oils"&item_unit=="Lt"
replace item_name="mustardoil" if item_name=="mustard"&item_type=="oils"

*Midday meal (convert from Rs to Numbers) Rs 7 per meal is the sample avg)
replace tot_qty=tot_qty/7   if item_name=="middaymeal"&item_unit=="Rs" 
replace item_unit="No" if item_name=="middaymeal"&item_unit=="Rs"

*Spices - Chillies, Garlic, Ginger, Turmeric, etc (Convert from Kg to gms)
local gramlist 	chillies garlic ginger turmeric mixedspices spices:turmeric spices:chillies saltedrefreshments mustard coriander     ///
				otherspices(mixspices) spices:coriander turmuric otherspices(cuminseed) cuminseed blackpepper	coriender	      ///
				cumineseed	otherspices	otherspices(blackpepper)	otherspices(cuminseedandblackpepper)	otherspices(mixspice)     ///
				otherspices(mustard)	pickles	spices:garlic
foreach g of local gramlist {
replace tot_qty=tot_qty*1000 if item_name=="`g'"&item_unit=="Kg"
replace item_unit="Gram" if item_name=="`g'"&item_unit=="Kg"						
}

*Meat (Convert from Rs to Kg) Rs 173 per kg is the sample avg)
replace tot_qty=tot_qty/173 if item_name=="meat(goat,chicken,sheep)"&item_unit=="Rs"  
replace item_unit="Kg" if item_name=="meat(goat,chicken,sheep)"&item_unit=="Rs"

*CorianderLeaves (Convert from Nums to Kg) 10 Nos == 1 Kg from sample avg)
replace tot_qty=tot_qty/10 if (item_name=="corianderleaves"|item_name=="fenugreekleaves")&item_unit=="No"    
replace item_unit="Kg" if (item_name=="corianderleaves"|item_name=="fenugreekleaves")&item_unit=="No" 


*Coconut (Convert Kgs to Numbers)  Average Price unit for 1 kg and 1 number is the same in the sample 
replace item_unit="No" if item_name=="coconut"&item_unit=="Kg"     

*Processed food (Consider the expenditure value rather than the quantity)*
replace item_unit="Rs" if item_name=="biscuits"|item_name=="otherprocessedfood"|item_name=="others(bread,khara,sagu,sweets,etc.)"|item_name=="preparedsweets"

*Curd* (Convert from Lt to Kg)
replace tot_qty=tot_qty*0.96 if item_name=="curd"&item_unit=="Lt"
replace item_unit="Kg" if item_name=="curd"&item_unit=="Lt"

*Oranges (Convert from Kg to Numbers)  Approx 8 oranges = 1 kg from the average price unit in the sample 
replace tot_qty=tot_qty/8 if item_name=="orange"&item_unit=="Kg"   
replace item_unit="No" if item_name=="orange"&item_unit=="Kg"

*Social meals (Convert Rs to Numbers)  Approx the average value of social meals are Rs. 250 in the sample 
replace item_name="soc.meal" if strmatch(item_name,"*soc.meal*")
replace tot_qty=tot_val/250 if item_name=="soc.meal"&item_unit=="Rs"   
replace item_unit="No" if item_name=="soc.meal"&item_unit=="Rs"

*ColdBeverages (Convert Kg to Lt)
replace tot_qty=1.03*tot_qty if item_name=="coldbeverages:bottled/canned"&item_unit=="Kg"
replace item_unit="Lt" if item_name=="coldbeverages:bottled/canned"&item_unit=="Kg"

*Processed Food and spice (Convert Kg to Rs)
local othfoodlist mixture cake,pastry pdssalt babyfood othervegitables samosa othervegetables otherfreshfruits
foreach ofd of local othfoodlist {
replace item_unit="Rs" if item_name=="`ofd'"					
}

*Standardize units
replace item_unit="Kg" if item_unit=="Kg/Lt"|item_unit=="No/Kg"
		

