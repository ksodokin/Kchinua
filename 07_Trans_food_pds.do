




/*This do-file cleans Food Consumption Files 
	and creates PDS Variables */

	

********************************************			   
******     CREATE PDS VARIBALES    *********			   
********************************************

gen middaymeal_val=tot_val if item_name=="middaymeal"

****PDS quantity*****

//Rice
gen pdsrice_qty=qty_pur if item_name=="pdsrice"
replace pdsrice_qty=qty_ot if item_name=="pdsrice"&qty_pur==.

*Data error (new_id=="IKNA0048"
replace pdsrice_qty=24 if pdsrice_qty==74

//Wheat
gen pdswheat_qty=qty_pur if item_name=="pdswheat"

//Pigeonpea
gen pdspigeonpea_qty=qty_pur if item_name=="pdspigeonpea"

//Sugar
gen pdssugar_qty=qty_pur if item_name=="pdssugar"&item_unit=="Kg"

//Oil
gen pdsoil_qty=qty_pur if item_name=="pdsoil"


	
****PDS Value*****
	
gen pdsrice_val=pdsrice_qty*price_unit if item_name=="pdsrice"
gen pdswheat_val=pdswheat_qty*price_unit if item_name=="pdswheat_price"
gen pdspigeonpea_val=pdspigeonpea_qty*price_unit if item_name=="pdspigeonpea"
gen pdssugar_val = pdssugar_qty*price_unit if item_name=="pdssugar"
gen pdsoil_val=pdsoil_qty*price_unit if item_name=="pdsoil"



	
		