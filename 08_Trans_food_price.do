





/*This do-file cleans Food Consumption Files 
	and creates Price Variables */


	

*******************************			   
****  PDS PRICE VARIBALES  ****			   
*******************************		


****PDS price*****

gen pdsrice_price=price_unit if item_name=="pdsrice"
gen pdswheat_price=price_unit if item_name=="pdswheat"
gen pdspigeonpea_price=price_unit if item_name=="pdspigeonpea"
gen pdssugar_price=price_unit if item_name=="pdssugar"&item_unit=="Kg"
gen pdsoil_price=price_unit if item_name=="pdsoil"

//Replace pds price reported as market prices
replace pdsrice_price=. if pdsrice_price>10


**********************************				   
****  MARKET PRICE VARIBALES  ****			   
**********************************	

gen rice_purc_price=price_unit if item_name=="rice"&qty_pur!=.
gen wheat_purc_price=price_unit if item_name=="wheat"&qty_pur!=.
gen st_cereal_purc_price=price_unit if (item_name=="rice"|item_name=="wheat")&qty_pur!=.
gen pulse_purc_price=price_unit if item_type=="pulses"&qty_pur!=.
gen cr_cereal_purc_price=price_unit if  item_type=="cereals"&st_cereal_dum==0



	