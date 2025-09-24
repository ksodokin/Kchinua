



/*This do-file  :

	1) Groups food consumption items into animal proteins, fruits and veg, etc 
	2) Budget shares and calorie shares
	
*/



*Milk and milk products value and quantity
egen milk_val     =rowtotal(milkandproducts_val milk_liq_val)
egen milk_tot_qty =rowtotal(milkandproducts_tot_qty milk_liq_tot_qty)
egen milk_kcal    =rowtotal(milkandproducts_kcal milk_liq_kcal)
egen milk_prot    =rowtotal(milkandproducts_prot milk_liq_prot)
egen milk_fat    =rowtotal( milkandproducts_fat milk_liq_fat)



*Animal proteins -- Milk and milk products + Meat and Fish + Eggs
	*Value
	egen animalprot_val=rowtotal(milkandproducts_val milk_liq_val meat_val eggs_val)
	
	*Nutrient intake
	egen animalprot_kcal=rowtotal(milkandproducts_kcal milk_liq_kcal meat_kcal eggs_kcal)
	egen animalprot_prot=rowtotal(milkandproducts_prot milk_liq_prot meat_prot eggs_prot)
	egen animalprot_fat=rowtotal(milkandproducts_fat milk_liq_fat meat_fat eggs_fat)
	
	*Animal protein purchase
	egen animalprot_purc_kcal=rowtotal(milkandproducts_purc_kcal milk_liq_purc_kcal meat_purc_kcal eggs_purc_kcal)
	egen animalprot_purc_prot=rowtotal(milkandproducts_purc_prot milk_liq_purc_prot meat_purc_prot eggs_purc_prot)
	egen animalprot_purc_fat=rowtotal(milkandproducts_purc_fat milk_liq_purc_fat meat_purc_fat eggs_purc_fat)
	
	
*Vegan proteins -- Pulses -- pulses pulses_kcal pulses_prot pulses_fat

	*AnimalandVegan
	egen animalveganprot_val=rowtotal(animalprot_val pulses_val)
	
	*calorie
	egen animalveganprot_kcal=rowtotal(animalprot_kcal pulses_kcal)

*Fruits and Veg -- Fruits + Vegetables

	*Value
	egen fruitsveg_val=rowtotal(fruits_val vegetables_val)

	*Nutrient intake
	egen fruitsveg_kcal=rowtotal(fruits_kcal vegetables_kcal)
	egen fruitsveg_prot=rowtotal(fruits_prot vegetables_prot)
	egen fruitsveg_fat=rowtotal(fruits_fat vegetables_fat)

*Sugar and Oils
	
	*Value
	egen sugaroil_val=rowtotal(sugar_val oils_val)

	*Nutrient intake
	egen sugaroil_kcal=rowtotal(sugar_kcal oils_kcal)
	egen sugaroil_prot=rowtotal(sugar_prot oils_prot)
	egen sugaroil_fat=rowtotal(sugar_fat oils_fat)
	
	*Fruits Vegetables and Oils
	egen fruitsvegoils_val=rowtotal(fruitsveg_val oils_val)
	

*Cereals

	*Value
	*egen cereals_val=rowtotal(st_cereal_val cr_cereal_val)
	egen cereals_kcal=rowtotal(st_cereal_kcal cr_cereal_kcal)
	
	
*Non-staple 	
	egen noncereal_kcal=rowtotal(animalveganprot_kcal fruitsveg_kcal)


	
*Non-PDS staple cereals -- 	st_cereal_nonpds_purc st_cereal_nonpds_kcal st_cereal_nonpds_prot st_cereal_nonpds_fat



*********************
****Budget Shares****
*********************


	*Budget Share
	gen animalprot_bs=animalprot_val/food_tot_val
	gen milk_bs=milkandproducts_val/food_tot_val
	gen meat_bs=meat_val/food_tot_val	
	gen eggs_bs=eggs_val/food_tot_val

	gen pulses_bs=pulses_val/food_tot_val
	gen cereals_bs=cereals_val/food_tot_val
	gen animalveganprot_bs=animalveganprot_val/food_tot_val
	gen fruitsveg_bs=fruitsveg_val/food_tot_val
	gen fruits_bs=fruits_val/food_tot_val
	gen vegetables_bs=vegetables_val/food_tot_val
	
	gen fruitsvegoils_bs=fruitsvegoils_val/food_tot_val
	
	
	gen st_cereal_nonpds_bs=st_cereal_nonpds_val/food_tot_val
	gen st_cereal_bs=st_cereal_val/food_tot_val
	gen sugaroil_bs= sugaroil_val/food_tot_val
	gen sugar_bs=sugar_val/food_tot_val
	gen oils_bs=oils_val/food_tot_val
	gen otherfooditems_bs=otherfooditems_val/food_tot_val
	gen meal_out_bs=meal_out_val/food_tot_val
	
	
	gen food_tot_bs=food_tot_val/exp
	*gen food_tot_nopds_bs=food_tot_nopds_val/exp
	gen nf_tot_val_bs=nf_tot_val/exp
	
	
local foodgrouplist animalprot pulses  fruitsveg st_cereal_nonpds




	

**********************
****Calorie Shares****
**********************


	gen cereal_cs=cereals_kcal/food_tot_kcal
	gen milk_cs=milkandproducts_kcal/food_tot_kcal
	gen meat_cs=meat_kcal/food_tot_kcal
	
	gen animalprot_cs=animalprot_kcal/food_tot_kcal
	gen allprot_cs=animalveganprot_kcal/food_tot_kcal
	gen fveg_cs=fruitsveg_kcal/food_tot_kcal
	gen sugar_cs=sugaroil_kcal/food_tot_kcal
	gen oil_cs=oils_kcal/food_tot_kcal

	gen noncereal_cs=noncereal_kcal/food_tot_kcal






