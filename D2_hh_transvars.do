



/*This do-file  :

	Tranforms all consumption items
   1) deflate expenditure values
   2) convert to per-capita
   3) Trims 1% for outliers
   4) Replaces Kgs to Grams; Gms of Protein and Fat to Milligrams, Gms Fat to Milligrams
   5) Transfer value to per-capita real value
   
*/




**********************************
*Tranform and clean hh variables *
**********************************

*All food items (expect PDS and middaymeal)
gen food_tot_val_nopds=food_tot_val-pdsgrain_val-middaymeal_val
*Food purchases (expect PDS)
gen food_purc_val_nopds=food_purc_val-pdsgrain_val


*Consumption quantity groups
global cons_qty_stcereal_list rice_tot_qty wheat_tot_qty st_cereal_tot_qty pdsrice_qty pdswheat_qty pdsgrain_qty rice_purc_qty wheat_purc_qty st_cereal_purc_qty rice_tot_nonpds_qty wheat_tot_nonpds_qty st_cereal_nonpds_qty  rice_nonpds_purc_qty wheat_nonpds_purc_qty  st_cereal_nonpds_purc_qty rice_home_qty  wheat_home_qty st_cereal_home_qty
global cons_qty_othfood_list pulses_tot_qty pulses_purc_qty pulses_home_qty cr_cereal_tot_qty cr_cereal_purc_qty cr_cereal_home_qty eggs_tot_qty eggs_purc_qty eggs_home_qty milkandproducts_tot_qty milkandproducts_purc_qty milkandproducts_home_qty milk_liq_tot_qty milk_liq_purc_qty milk_liq_home_qty oils_tot_qty oils_purc_qty oils_home_qty sugar_tot_qty sugar_purc_qty sugar_home_qty meat_tot_qty meat_purc_qty  meat_home_qty   ///


*Consumption Value
global cons_val_nf_list food_tot_val food_tot_val_nopds food_purc_val food_purc_val_nopds food_home_val food_oth_val  nf_tot_val exp
global cons_val_stcereal_list rice_tot_val wheat_tot_val st_cereal_val pdsrice_val pdswheat_val pdsgrain_val  rice_tot_nonpds_val wheat_tot_nonpds_val st_cereal_nonpds_val rice_purc_val wheat_purc_val st_cereal_purc_val rice_nonpdspurc_val wheat_nonpdspurc_val st_cereal_nonpds_purc_val rice_home_val wheat_home_val st_cereal_home_val 
global cons_val_othfood_list pulses_val cr_cereal_val  milkandproducts_val milk_liq_val fruits_val vegetables_val eggs_val   meat_val   sugar_val   oils_val   otherfooditems_val     meal_out_val 

*global benefit_val_list nrega_wages middaybenefit_val pdsbenefit_val pensionbenefit_val cashbenefit_val nonpdsbenefit_val otherbenefit_val

*Nutrient intake 
ds  *_kcal
global cons_kcal_list `r(varlist)' 

ds  *_prot
global cons_prot_list `r(varlist)' 

ds  *_fat
global cons_fat_list `r(varlist)' 



*Deflate Values to 2010 rupees
local namelist cons_val_nf_list cons_val_stcereal_list cons_val_othfood_list 
foreach x of local namelist {
	foreach y of global `x' {
	
	*Deflate to 2010 rupees 
	qui: replace `y'=(`y'/cpi_generalindex)*100			
	
	}
}
		
		

		
**** Change to all variables to per-capita and winsorize **

local namelist cons_kcal_list  cons_prot_list cons_fat_list cons_qty_stcereal_list cons_qty_othfood_list  ///
							   cons_val_nf_list cons_val_stcereal_list cons_val_othfood_list  
foreach x of local namelist {
	foreach y of global `x' {

		*Change to per-capita 
		qui: replace `y'=`y'/wt_nhh
		
		*Drop the top and bottom 1% observations with measurement errors **
		winsor2 `y', cuts(1 99) trim replace

	}
}





	*Convert Kgs to Grams; Gms of Protein and Fat to Milligrams, Gms Fat to Milligrams

	global cons_qty_stcereal_kg_list rice_tot_qty wheat_tot_qty st_cereal_tot_qty pdsrice_qty pdswheat_qty pdsgrain_qty rice_purc_qty wheat_purc_qty st_cereal_purc_qty rice_tot_nonpds_qty wheat_tot_nonpds_qty st_cereal_nonpds_qty  rice_nonpds_purc_qty wheat_nonpds_purc_qty  st_cereal_nonpds_purc_qty rice_home_qty  wheat_home_qty st_cereal_home_qty
	global cons_qty_othfood_kg_list pulses_tot_qty pulses_purc_qty pulses_home_qty cr_cereal_tot_qty cr_cereal_purc_qty cr_cereal_home_qty milkandproducts_tot_qty milkandproducts_purc_qty milkandproducts_home_qty milk_liq_tot_qty milk_liq_purc_qty milk_liq_home_qty oils_tot_qty oils_purc_qty oils_home_qty sugar_tot_qty sugar_purc_qty sugar_home_qty meat_tot_qty meat_purc_qty  meat_home_qty   

	/*Note: Unit of measurement for consumption quantities
	All consumption quantities have been converted to kgs in the pds_cons.do file
	Except eggs which are measured in numbers (Number of eggs)
	Staple cereals, Pulses, Coarse cereals are in kgs
	Milk and milk products are converted from lts to kgs
	Oil is convered from lts to kg
	Sugar is converted into kg
	Meat also is converted into kg (in some instances meat is only reported in values. Here, meat quantity (in kgs) is imputed from value. Interpret meat quantity carefully
	*/
	
	local unitlist cons_prot_list cons_fat_list cons_qty_stcereal_kg_list cons_qty_othfood_kg_list
	foreach x of local unitlist {
		foreach y of global `x' {

			qui: replace `y'=`y'*1000
			
		}
	}

	
	
	


**********************************************
*Change the transfer to per-capita real value*
**********************************************


local pclist grain_subs grain_subs_tg grain_subs_rec 
foreach x of local pclist  {	

	*Deflate to 2010 rupees 
	qui: replace `x'=(`x'/cpi_generalindex)*100			
	
	replace `x'=`x'/wt_nhh
}	

