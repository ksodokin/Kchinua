




/*This do-file cleans Transaction Food Consumption Files  
  and collapses the data to household-month level  */


  
*****************************************				   
******  GET FOOD CONSUMPTION DATA  ******			   
*****************************************

	*First get Food consumption data from EI
	use "$stata_data_dir/Transaction/Aggregate/Exp_food_non_food_agg",replace
		keep if item_category=="Food"
		replace item_name=lower(item_name)
		drop if item_name=="grinding/millingcharges"
		drop item_category remarks

	*Include Food consumption data from SAT
	append using "$stata_data_dir/Transaction/Aggregate/Food_items_agg"




		
*Create total consumption quantity = Home produced+ Purchased + Others/Gifts
egen tot_qty=rowtotal(qty_home_prod qty_pur qty_ot)



/*THIS FOR-LOOP does the following steps: 
Trans_food_clean  : Cleans quantity units
Trans_food_kcal   : Convert to Calories, Proteins, Fat
Trans_food_groups : Aggregate food items into 11 Main Food types
Trans_food_qty	  : Consumption Quantity variables for each food type
Trans_food_val	  : Consumption Value variables for each food type
Trans_food_nut	  : Nutrient Intake variables for each food type
Trans_food_pds	  : PDS consumption variables - quantity 
Trans_food_price  : Price variables
*/
  

cd $raw_code_dir
*Loop through each Food Consumption steps 	
local i=1
local foodfilelist clean kcal groups qty val nut pds price
foreach f of local foodfilelist {
	 
	*Clean GES files
	include Transaction/Trans_food/0`i'_Trans_food_`f' 
	
	local ++i
	 
	}
	  		

			

	
******************************************			   
*  Bring the Data to panel-month level ***			   
******************************************

collapse (sum) *_qty *_val *_kcal *_prot *_fat		///
		 (mean) *_price, by(vds_id sur_mon_yr)


		 

	*PDS grain = rice+wheat
	egen pdsgrain_val=rowtotal(pdswheat_val pdsrice_val)
	egen pdsgrain_qty = rowtotal (pdsrice_qty pdswheat_qty)
	gen pdsgrain_price=(pdsgrain_val)/pdsgrain_qty



	*********************************			   
	****     LABEL VARIABLES    *****
	*********************************
		
		label variable middaymeal_val "Value of Middaymeal received in Rs."

		label variable food_tot_val "Food consumption total (Home+Purchase+gifts)"
		label variable food_home_val "Food consumption from home production"
		label variable food_purc_val "Food consumption from purchase"

		
		local mylist grain rice wheat
		foreach x of local mylist {
		label variable pds`x'_qty "Quantity of pds `x' consumed in Kg"
		label variable pds`x'_price "Price (Subsidised) of pds `x' in Rs."
		label variable pds`x'_val "Value (Subsidised) of pds `x' consumed"
		}




