

/*This do-file estimates regressions :

  1) Main effects on Village prices 
 
 */



/////////////////
* PRICE EFFECTS *
/////////////////


est clear		
local pricelist   ln_rice_fine ln_wheat  ln_grain_nom
	foreach x of local pricelist  {

	*Average effect
	eststo: ivreghdfe ch_`x'_price  (c.grain_subs =  c.grain_subs_tg) ,  absorb(vill i.year i.st#i.year i.st#i.month ) 	 cluster (vill)
	
		}
		
		

		
		
		esttab  using "$table_price_dir/impacts_price.csv", replace ///
		label b(3) se noconstant  nonumb    ///
		star(* 0.10 ** 0.05 *** 0.01)    ///
		stats( N , labels("Observations") fmt(%9.0f))


		
