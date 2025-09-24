


/*This do-file cleans Food Consumption Files 
	and converts all food items into calories, proteins and fats */


*Note: Food Consumption table for Conversion is from NSSO 



***********************************				   
******  CONVERT TO CALORIES  ******			   
***********************************	



***Merge FCT to get calorie data (per unit of each food item) ****
merge m:m item_name item_unit using "$data_dir/Raw/RawAuxData/fct_nsso"
drop _merge




***Calculate the total nutrients in each food item ****

gen kcal=kcal_per_unit*tot_qty 
gen protein=protein_per_unit*tot_qty 
gen fat=fat_per_unit*tot_qty

*Redo replacement of tot_qty as tot_val for en for item_unit=Rs, tot_qty has been replaced by tot_val
replace kcal=kcal_per_unit*tot_val if item_unit=="Rs"
replace protein=protein_per_unit*tot_val if item_unit=="Rs"
replace fat=fat_per_unit*tot_val if item_unit=="Rs"

*Convert to per-day terms (This is monthly expenditure data - so just divide by 30)
replace kcal=kcal/30
replace protein=protein/30
replace fat=fat/30



