



/*This do-file cleans Food Consumption Files 
	and creates Nutrient Intake Variables */


*************************************************				   
*****     NUTRIENT INTAKE VARIABLES      ********			   
*************************************************		
	
*Calorie, Protein and Fat intake from all Food items
	gen food_tot_kcal=kcal
	gen food_tot_prot=protein
	gen food_tot_fat=fat
	
*Total staple cereals
	gen st_cereal_kcal=kcal if strmatch(item_name,"*rice")|strmatch(item_name,"*wheat")
	gen st_cereal_prot=protein if strmatch(item_name,"*rice")|strmatch(item_name,"*wheat")
	gen st_cereal_fat=fat if strmatch(item_name,"*rice")|strmatch(item_name,"*wheat")
	
*PDS grains
	gen pds_kcal=kcal if item_name=="pdsrice"|item_name=="pdswheat"
	gen pds_prot=protein if item_name=="pdsrice"|item_name=="pdswheat"
	gen pds_fat=fat if item_name=="pdsrice"|item_name=="pdswheat"

*Non-PDS staple cereals			
	gen st_cereal_nonpds_kcal=kcal if item_name=="rice"|item_name=="wheat"
	gen st_cereal_nonpds_prot=protein if item_name=="rice"|item_name=="wheat"
	gen st_cereal_nonpds_fat=fat if item_name=="rice"|item_name=="wheat"

*Non-staples			
	gen non_staple_kcal=kcal if st_cereal_dum==0
	gen non_staple_prot=protein if st_cereal_dum==0
	gen non_staple_fat=fat if st_cereal_dum==0
	
	
*Pulses
	gen pulses_kcal=kcal if item_type=="pulses"
	gen pulses_prot=protein if item_type=="pulses"
	gen pulses_fat=fat if item_type=="pulses"
	
*Coarse cereals 
	gen cr_cereal_kcal=kcal if item_type=="cereals"&st_cereal_dum==0
	gen cr_cereal_prot=protein if item_type=="cereals"&st_cereal_dum==0
	gen cr_cereal_fat=fat if item_type=="cereals"&st_cereal_dum==0

*Eggs
	gen eggs_kcal=kcal if item_type=="eggs"
	gen eggs_prot=protein if item_type=="eggs"
	gen eggs_fat=fat if item_type=="eggs"
	
*Milk
	gen milkandproducts_kcal=kcal if item_type=="milkandproducts"
	gen milkandproducts_prot=protein if item_type=="milkandproducts"
	gen milkandproducts_fat=fat if item_type=="milkandproducts"
	
	gen milk_liq_kcal=kcal if item_type=="milk_liq"
	gen milk_liq_prot=protein if item_type=="milk_liq"
	gen milk_liq_fat=fat if item_type=="milk_liq"
	

*Oil
	gen oils_kcal=kcal if item_type=="oils"
	gen oils_prot=protein if item_type=="oils"
	gen oils_fat=fat if item_type=="oils"


*Sugar
	gen sugar_kcal=kcal if item_type=="sugar"
	gen sugar_prot=protein if item_type=="sugar"
	gen sugar_fat=fat if item_type=="sugar"
	
*Vegetables 
	gen vegetables_kcal=kcal if item_type=="vegetables"
	gen vegetables_prot=protein if item_type=="vegetables"
	gen vegetables_fat=fat if item_type=="vegetables"

*Fruits
	gen fruits_kcal=kcal if item_type=="fruits"
	gen fruits_prot=protein if item_type=="fruits"
	gen fruits_fat=fat if item_type=="fruits"

*Meat
	gen meat_kcal=kcal if item_type=="meat"
	gen meat_prot=protein if item_type=="meat"
	gen meat_fat=fat if item_type=="meat"
	
	
*Otherfoods
	gen otherfooditems_kcal=kcal if item_type=="otherfooditems"
	gen otherfooditems_prot=protein if item_type=="otherfooditems"
	gen otherfooditems_fat=fat if item_type=="otherfooditems"	


*Meals outside
	gen meal_out_kcal=kcal if item_type=="meal_out"
	gen meal_out_prot=protein if item_type=="meal_out"
	gen meal_out_fat=fat if item_type=="meal_out"


	
**********************************************				   
*****     NUTRIENT VALUE VARIBALES    ********			   
**********************************************			

*Nutrient value of major food groups items by source of each food group
local mylist food cereals eggs fruits meal_out meat milkandproducts milk_liq oils otherfooditems pulses sugar vegetables cr_cereal non_staple st_cereal
foreach x of local mylist {

*Create source of food variable - Home or purchased - for each food group
gen `x'_home_kcal=kcal if `x'_home_val!=.
gen `x'_home_prot=protein if `x'_home_val!=.
gen `x'_home_fat=fat if `x'_home_val!=.

gen `x'_purc_kcal=kcal if `x'_purc_val!=.
gen `x'_purc_prot=protein if `x'_purc_val!=.
gen `x'_purc_fat=fat if `x'_purc_val!=.

}			


gen st_cereal_nonpds_purc_kcal= kcal if st_cereal_nonpds_purc_val!=.
gen st_cereal_nonpds_purc_prot= protein if st_cereal_nonpds_purc_val!=.
gen st_cereal_nonpds_purc_fat= fat if st_cereal_nonpds_purc_val!=.
