



/*This do-file cleans Food Consumption Files 
	and creates Quantity Variables */



/* Unit of measurement for each consumption category in the raw dataset:
1) Cereals - Kg
2) Eggs - No
3) Fruits - Kg,Noand Rs
4) Meal_out- Rs.
5) Milk - Kg,Lt and Rs 
   Milk and Curd in Lt.
   Ghee/Butter in Kg
   Few obs in Rs.
6) Oils - Kg and Lt
7) Otherfooditems - Kg and Rs
8) Pulses - Kg
9) Sugar_spice - Kg and Rs
10) Vegetables - Kg, No. and Rs.
11) Meat - Kg and Rs.
*/

/* Converts into Kgs ---> all consumption food group quantity units 
except Eggs, Vegetables, Fruits, Spices, Otherfoods 

All food categories, except vegetables and fruits are measured in Kgs or Lts
Before 2013, its was measured in Rs. value. After 2013, they were measured in Kg. 
*/


	
******************************************				   
****  CONSUMPTION QUANTITY VARIBALES  ****			   
******************************************		



gen st_cereal_dum= strmatch(item_name,"*rice")|strmatch(item_name,"*wheat*")




*Rice consumption quantity
	gen rice_tot_qty=tot_qty if item_name=="rice"|item_name=="pdsrice"
	gen rice_tot_nonpds_qty=tot_qty if item_name=="rice"
	gen rice_purc_qty=qty_pur if item_name=="rice"|item_name=="pdsrice"
	gen rice_nonpds_purc_qty=qty_pur if item_name=="rice"
	gen rice_home_qty=qty_home_prod if item_name=="rice"

*Wheat Consumption quantity
	gen wheat_tot_qty=tot_qty if item_name=="wheat"|item_name=="pdswheat"
	gen wheat_tot_nonpds_qty=tot_qty if item_name=="wheat"
	gen wheat_purc_qty=qty_pur if item_name=="wheat"|item_name=="pdswheat"
	gen wheat_nonpds_purc_qty=qty_pur if item_name=="wheat"
	gen wheat_home_qty=qty_home_prod if item_name=="wheat"

*Grain Consumption quantity
	gen st_cereal_tot_qty=tot_qty if strmatch(item_name,"*rice")|strmatch(item_name,"*wheat")
	gen st_cereal_nonpds_qty=tot_qty if item_name=="rice"|item_name=="wheat"
	gen st_cereal_purc_qty=qty_pur if strmatch(item_name,"*rice")|strmatch(item_name,"*wheat")
	gen st_cereal_nonpds_purc_qty=qty_pur if item_name=="rice"|item_name=="wheat"
	gen st_cereal_home_qty=qty_home_prod if item_name=="rice"|item_name=="wheat"


*Pulses Consumption quantity
	gen pulses_tot_qty=tot_qty if item_type=="pulses"
	gen pulses_purc_qty=qty_pur if item_type=="pulses"
	gen pulses_home_qty=qty_home_prod if item_type=="pulses"


*Coarse Cereal Consumption quantity
	gen cr_cereal_tot_qty=tot_qty if item_type=="cereals"&st_cereal_dum==0
	gen cr_cereal_purc_qty=qty_pur if item_type=="cereals"&st_cereal_dum==0
	gen cr_cereal_home_qty=qty_home_prod if item_type=="cereals"&st_cereal_dum==0



*Eggs consumption in Numbers
	gen eggs_tot_qty=tot_qty if item_type=="eggs"
	gen eggs_purc_qty=qty_pur if item_type=="eggs"
	gen eggs_home_qty=qty_home_prod if item_type=="eggs"
	


*Total Milk/Curd consumption in Litres
	gen milkandproducts_tot_qty=tot_qty if item_type=="milkandproducts"&(item_unit=="Lt"|item_unit=="Kg")
	gen milkandproducts_purc_qty=qty_pur if item_type=="milkandproducts"&(item_unit=="Lt"|item_unit=="Kg")
	gen milkandproducts_home_qty=qty_home_prod if item_type=="milkandproducts"&(item_unit=="Lt"|item_unit=="Kg")

	//Change the unit of Milk from Litres to Kg (Conversion factor : 1 litre = 1.03 Kg)
	replace milkandproducts_tot_qty=milkandproducts_tot_qty*1.03 if item_unit=="Lt"
	replace milkandproducts_purc_qty=milkandproducts_purc_qty*1.03 if item_unit=="Lt"
	//Change price unit from Rs/lt to Rs/kg
	replace price_unit=price_unit*0.968 if item_unit=="Lt"&item_type=="milkandproducts"
	replace item_unit="Kg" if item_unit=="Lt"&item_type=="milkandproducts"
	

	gen milk_liq_tot_qty=tot_qty if item_type=="milk_liq"&(item_unit=="Lt"|item_unit=="Kg")
	gen milk_liq_purc_qty=qty_pur if item_type=="milk_liq"&(item_unit=="Lt"|item_unit=="Kg")
	gen milk_liq_home_qty=qty_home_prod if item_type=="milk_liq"&(item_unit=="Lt"|item_unit=="Kg")

	//Change the unit of Milk from Litres to Kg (Conversion factor : 1 litre = 1.03 Kg)
	replace milk_liq_tot_qty=milk_liq_tot_qty*1.03 if item_unit=="Lt"
	replace milk_liq_purc_qty=milk_liq_purc_qty*1.03 if item_unit=="Lt"
	//Change price unit from Rs/lt to Rs/kg
	replace price_unit=price_unit*0.968 if item_unit=="Lt"&item_type=="milk_liq"
	replace item_unit="Kg" if item_unit=="Lt"&item_type=="milk_liq"
	
	
*Total Oils conusmption
	gen oils_tot_qty=tot_qty if item_type=="oils"
	gen oils_purc_qty=qty_pur if item_type=="oils"
	gen oils_home_qty=qty_home_prod if item_type=="oils"

	//Change the unit of Oils from Litres to Kg (Conversion factor : 1 litre = 0.96 Kgs) 
	replace oils_tot_qty=oils_tot_qty*0.96 if item_type=="oils"&item_unit=="Lt"
	replace oils_purc_qty=oils_purc_qty*0.96 if item_type=="oils"&item_unit=="Lt"
	//Change price unit from Rs/lt to Rs/kg
	replace price_unit=price_unit*1.042 if item_type=="oils"&item_unit=="Lt"
	replace item_unit="Kg" if item_type=="oils"&item_unit=="Lt"
	

*Total Sugar consumption
	gen sugar_tot_qty=tot_qty if item_unit=="Kg"&item_type=="sugar"
	gen sugar_purc_qty=qty_pur if item_unit=="Kg"&item_type=="sugar"
	gen sugar_home_qty=qty_home_prod if item_unit=="Kg"&item_type=="sugar"
	
	

*Total Meat consumption
	gen meat_tot_qty=tot_qty if item_unit=="Kg"&item_type=="meat"
	gen meat_purc_qty=qty_pur if item_unit=="Kg"&item_type=="meat"
	gen meat_home_qty=qty_home_prod if item_unit=="Kg"&item_type=="meat"

		
