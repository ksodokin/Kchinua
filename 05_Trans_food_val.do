



/*This do-file cleans Food Consumption Files 
	and creates Value Variables */




*************************************************				   
*****     CONSUMPTION VALUE VARIBALES    ********			   
*************************************************	

*All food items
	gen food_tot_val=tot_val
	
	gen food_purc_val=qty_pur*price_unit
		replace food_purc_val=qty_pur if item_unit=="Rs"&price_unit==.
		
	gen food_home_val=qty_home_prod*price_unit
		replace food_home_val=qty_home_prod if item_unit=="Rs"&price_unit==.
		
	gen food_oth_val=qty_ot*price_unit
			replace food_oth_val=qty_ot if item_unit=="Rs"&price_unit==.

*Rice
	gen rice_tot_val=tot_qty*price_unit if item_name=="rice"|item_name=="pdsrice"
		replace rice_tot_val=tot_qty  if (item_name=="rice"|item_name=="pdsrice") & (item_unit=="Rs"&price_unit==.)
		
	gen rice_tot_nonpds_val=tot_qty*price_unit if item_name=="rice"
		replace rice_tot_nonpds_val=tot_qty if (item_name=="rice") & (item_unit=="Rs"&price_unit==.)
	
	gen rice_purc_val=qty_pur*price_unit if item_name=="rice"|item_name=="pdsrice"
		replace rice_purc_val=qty_pur if (item_name=="rice"|item_name=="pdsrice") & (item_unit=="Rs"&price_unit==.)

	
	gen rice_nonpdspurc_val=qty_pur*price_unit if item_name=="rice"
		replace rice_nonpdspurc_val=qty_pur if (item_name=="rice") & (item_unit=="Rs"&price_unit==.)

	gen rice_home_val=qty_home_prod*price_unit if item_name=="rice"|item_name=="pdsrice"
		replace rice_home_val=qty_home_prod if (item_name=="rice"|item_name=="pdsrice") &(item_unit=="Rs"&price_unit==.)
	

*Wheat
	gen wheat_tot_val=tot_qty*price_unit if item_name=="wheat"|item_name=="pdswheat"
		replace wheat_tot_val=tot_qty if (item_name=="wheat"|item_name=="pdswheat")  &(item_unit=="Rs"&price_unit==.)
	
	
	gen wheat_tot_nonpds_val=tot_qty*price_unit if item_name=="wheat"
		replace wheat_tot_nonpds_val=tot_qty if item_name=="wheat"  &(item_unit=="Rs"&price_unit==.)
		
	gen wheat_purc_val=qty_pur*price_unit if item_name=="wheat"|item_name=="pdswheat"
		replace wheat_purc_val=qty_pur if (item_name=="wheat"|item_name=="pdswheat")  &(item_unit=="Rs"&price_unit==.)
	
	gen wheat_nonpdspurc_val=qty_pur*price_unit if item_name=="wheat"
		replace wheat_nonpdspurc_val=qty_pur if item_name=="wheat"  &(item_unit=="Rs"&price_unit==.)
	
	gen wheat_home_val=qty_home_prod*price_unit if item_name=="wheat"|item_name=="pdswheat"
		replace wheat_home_val=qty_home_prod if (item_name=="wheat"|item_name=="pdswheat")  &(item_unit=="Rs"&price_unit==.)

*Grain Consumption value
	gen st_cereal_val=tot_qty*price_unit if strmatch(item_name,"*rice")|strmatch(item_name,"*wheat")
		replace st_cereal_val=tot_qty if (strmatch(item_name,"*rice")|strmatch(item_name,"*wheat")) &(item_unit=="Rs"&price_unit==.)
	
	
	gen st_cereal_nonpds_val=tot_qty*price_unit if item_name=="rice"|item_name=="wheat"
		replace st_cereal_nonpds_val=tot_qty if (item_name=="rice"|item_name=="wheat") &(item_unit=="Rs"&price_unit==.)
	
	
	gen st_cereal_purc_val=qty_pur*price_unit if (strmatch(item_name,"*rice")|strmatch(item_name,"*wheat")) 
		replace st_cereal_purc_val=qty_pur if (strmatch(item_name,"*rice")|strmatch(item_name,"*wheat")) &(item_unit=="Rs"&price_unit==.)
	
	gen st_cereal_nonpds_purc_val=qty_pur*price_unit if item_name=="rice"|item_name=="wheat"
		replace st_cereal_nonpds_purc_val=qty_pur if (item_name=="rice"|item_name=="wheat") &(item_unit=="Rs"&price_unit==.)
	
	
	gen st_cereal_home_val=qty_home_prod*price_unit  if item_name=="rice"|item_name=="wheat"
		replace st_cereal_home_val=qty_home_prod  if (item_name=="rice"|item_name=="wheat") & (item_unit=="Rs"&price_unit==.)
	
	
*Non-staple consumption value
	gen non_staple_val=tot_val if st_cereal_dum==0
	
	gen non_staple_purc_val=qty_pur*price_unit if st_cereal_dum==0
		replace non_staple_purc_val = qty_pur if st_cereal_dum==0 & item_unit=="Rs"&price_unit==.
		
	gen non_staple_home_val=qty_home_prod*price_unit if st_cereal_dum==0
		replace non_staple_home_val = qty_home_prod if st_cereal_dum==0 & item_unit=="Rs"&price_unit==.
	

*Consumption value of major food groups items by source of each food group
	local mylist cereals eggs fruits meal_out meat milkandproducts milk_liq oils otherfooditems pulses sugar vegetables  
	foreach x of local mylist {

	gen `x'_val=tot_val if item_type=="`x'"

	*Create source of food variable - Home or purchased - for each food group
	gen `x'_home_val=qty_home_prod*price_unit if item_type=="`x'"
	replace `x'_home_val=qty_home_prod if item_unit=="Rs"&item_type=="`x'"

	gen `x'_purc_val=qty_pur*price_unit if item_type=="`x'"
	replace `x'_purc_val=qty_pur if item_unit=="Rs"&item_type=="`x'"
	}

	
*Include Coarse cereals and Staple cereals as a separate food group
	gen cr_cereal_val=cereals_val if item_type=="cereals"&st_cereal_dum==0
	gen cr_cereal_home_val=cereals_home_val if item_type=="cereals"&st_cereal_dum==0
	gen cr_cereal_purc_val=cereals_purc_val if item_type=="cereals"&st_cereal_dum==0

