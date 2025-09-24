

/*This do-file cleans Transaction Non-food  Files  
  and collapses the data to household-month level  */

  

////// TRANSACTION  Non Food expenditure //////

*First: Get Non-Food consumption data from EI
use "$stata_data_dir/Transaction/Aggregate/Exp_food_non_food_agg",replace
	replace item_name=lower(item_name)
	drop if item_category=="Food"&item_name!="Grinding/millingcharges"
	replace item_category="nonfood" if strmatch(item_category,"Non*")
	replace item_name=item_category if item_category!="nonfood"
	drop item_category

*Second: Get Non-Food data from SAT
append using "$stata_data_dir/Transaction/Aggregate/Non_food_items_agg",force


	*Clean duplicate variables
	replace nf_item_name=item_name if nf_item_name==""
	drop item_name

	egen nf_tot = rowtotal(tot_val nf_tot_val),missing
	drop nf_tot_val
	rename nf_tot nf_tot_val

	/*
	Non-Food items types defined in the dataset: Grinding/Milling Charges; Toddy & Alcohol; HH articles and Small durables;
	Charcoal, LPG, firewood, kerosene & dung cakes; Electricity and Water charges; All Cosmetics (oils, face powder & creams);
	Cigarettes, Pan, Ganja, tobacco; Clothes, shoes, socks etc; Medical (domestic & hospital); Taxes (house, land, vehicle);
	Education (Fee, books, stationary, transport, uniform) ; Travel, petrol, diesel, vehicle maintenance and repairs ;
	Ceremonies, marriage expenses excluding dowry ; Entertainment, TV, cable exp ; Cell and land line phone bill ; Others specify
	*/

*Third: Create Non-food item variables	
replace nf_item_name=lower(nf_item_name)

	gen nf_grindmill=nf_tot_val if strmatch(nf_item_name,"grind*") 
	gen nf_med=nf_tot_val if strmatch(nf_item_name,"med*")
	gen nf_educ=nf_tot_val if strmatch(nf_item_name,"edu*")
	gen nf_cellphone=nf_tot_val if strmatch(nf_item_name,"cell*")
	gen nf_cosmetics=nf_tot_val if strmatch(nf_item_name,"allcos*")
	
		*Consider only purchased expenditures for energy (not home produced firewood)
		gen nf_energy=qty_pur if strmatch(nf_item_name,"charcoal*")|strmatch(nf_item_name,"elec.and*")|strmatch(nf_item_name,"electricity*")

	gen nf_drugs=nf_tot_val if strmatch(nf_item_name,"cigar*")|strmatch(nf_item_name,"*alcohol*")|strmatch(nf_item_name,"*tod*")
	gen nf_travel=nf_tot_val if strmatch(nf_item_name,"*travel*")
	gen nf_entertainment=nf_tot_val if strmatch(nf_item_name,"*tv*")
	gen nf_clothes = nf_tot_val if strmatch(nf_item_name,"*clot*")
	gen nf_smalldurables= nf_tot_val if strmatch(nf_item_name,"*small*")
	gen nf_ceremonies= nf_tot_val if strmatch(nf_item_name,"*marri*")
	
	gen nf_tot_val_nocer=nf_tot_val if nf_ceremonies==.
			
	order vds_id sur_mon_yr nf_item_name nf_tot_val nf_grindmill-nf_ceremonies nf_tot_val_nocer

collapse (sum) nf_tot_val nf_grindmill-nf_ceremonies nf_tot_val_nocer, by(vds_id sur_mon_yr) 

	label variable nf_tot_val "Non-food expenditure (Total=Home+Purchase+Gifts)"
	label variable nf_grindmill "Grinding and Milling expenditure"
	label variable nf_med "Medical domestic & hospital expenditure "
	label variable nf_educ "Education (Fee books stationary transport uniform)"
	label variable nf_cellphone "Cell and land line phone bill"
	label variable nf_cosmetics "Cosmetics oils powders"
	label variable nf_energy "Energy expenditure (Water LPG Charcoal Kerosene Electicity)"
	label variable nf_drugs "Drugs expenditure (Alcohol  Toddy  Tobacco)"
	label variable nf_travel "Travel  petrol vehicle etc"
	label variable nf_entertainment "TV cable expenses"
	label variable nf_clothes "Clothes shoes socks"
	label variable nf_smalldurables "HH articles and small durables"
	label variable nf_ceremonies "Marriage expenses exxept dowry" 
