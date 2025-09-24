



/*This do-file estimates regressions :

  Heterogeneous effects on Village prices by: 
	1) Degeree of openness / Price integration
	2) Degree of development / village poverty
 
 */

 
 
 
//////////////////////////////////
* HETEROGENEITY IN PRICE EFFECTS *
//////////////////////////////////


	*By developement 
	eststo : ivreghdfe ch_ln_grain_nom_price (c.grain_subs#exp_vill_below_median =  c.grain_subs_tg#exp_vill_below_median) ,  absorb(vill i.year i.st#i.month ) 	 cluster (vill)
	test _b[c.grain_subs#1.exp_vill_below_median] = _b[c.grain_subs#0.exp_vill_below_median]
	eststo: nlcom _b[c.grain_subs#1.exp_vill_below_median] - _b[c.grain_subs#0.exp_vill_below_median] ,post
	
	
	
	*Openess
	eststo : ivreghdfe ch_ln_grain_nom_price (c.grain_subs#corr_coeff_vill_below =  c.grain_subs_tg#corr_coeff_vill_below) ,  absorb(vill i.year i.st#i.month) 	 cluster (vill)
	test _b[c.grain_subs#1.corr_coeff_vill_below] =  _b[c.grain_subs#0.corr_coeff_vill_below] 
	eststo: nlcom _b[c.grain_subs#1.corr_coeff_vill_below] - _b[c.grain_subs#0.corr_coeff_vill_below], post
	
	
	
		
		esttab  using "$table_price_dir/impacts_price_hetero.csv", replace ///
		label b(3) se noconstant  nonumb    ///
		star(* 0.10 ** 0.05 *** 0.01)    ///
		stats( N , labels("Observations") fmt(%9.0f))


	
