






preserve





replace pdsgrain_alloc_qty = 25.5 if state_dum=="MH"&card=="BPL"&mon_yr<tm(2014m2)
replace pdsgrain_alloc_qty = 22.5 if state_dum=="KN"&card=="BPL"&mon_yr<tm(2013m7)

replace pdsgrain_alloc_qty_tg= pdsgrain_alloc_qty if state_dum=="MH"&card=="BPL"&mon_yr<tm(2013m3)
replace pdsgrain_alloc_qty_tg= pdsgrain_alloc_qty if state_dum=="KN"&card=="BPL"&mon_yr<tm(2013m3)



	local qtylist pdsgrain_alloc_qty_tg pdsgrain_alloc_qty
	foreach x of local qtylist {
	replace `x'=`x'/hh_size_m
		
		}



*Household-size category

	gen hh_size_cat=1 if hh_size_m<=5
	replace hh_size_cat=2 if hh_size_m>5&hh_size_m<=9
	replace hh_size_cat=3 if hh_size_m>9
		
	encode state,gen(st)
	
*State-mean
		local qtylist pdsgrain_alloc_qty_tg pdsgrain_alloc_qty
		foreach x of local qtylist {
			local hhlist 1 2 3 
			foreach y of local hhlist {
			
			gen `x'_`y'=`x' if hh_size_cat==`y'&card=="BPL"&(st!=4&st!=8)
			bys st mon_yr: egen `x'_stmon_`y'=mean(`x'_`y'), 
			bys mon_yr : egen `x'_mon_`y'=mean(`x'_stmon_`y')
						
			}
		}
	

*NFSA Target		
gen pdsgrain_alloc_qty_target_post=5 if mon_yr>=tm(2013m3)
	
********************	
***Combined Graph***
********************	


	twoway  (line pdsgrain_alloc_qty_mon_1 mon_yr, lc(gs12)) (line pdsgrain_alloc_qty_mon_2 mon_yr, lc(gs8))  (line pdsgrain_alloc_qty_mon_3 mon_yr, lc(gs0) )      ///
			(line pdsgrain_alloc_qty_target_post mon_yr, lpattern(shortdash) lwidth(0.8) lc(gs0))        /// 
			if card=="BPL"&mon_yr>=tm(2012m1), title("Actual Entitlement",margin(medium)) ytitle("Kg./person",height(4)) xtitle("") name(grain_qty, replace) ylabel(2(1)7)          ///
			legend(off)        ///
			tline(2013m3,lwidth(2) lc(gs14)) ttext(7 2013m3 "NFSA", color(gs8)) ///
			ttext(6.4 2012m1 "Small HHs (<4)", color(gs12) place(e))  ttext(3.5 2012m1 "Medium HHs (4 to 8) ", color(gs8) place(e))  ttext(2.4 2012m1 "Large HHs (>8)", color(gs0) place(e))          ///
			ttext(5.2 2015m3 "{it:Target}", color(gs0)) graphregion(color(white)) ylabel(,glc(none) ) nodraw

	twoway  (line pdsgrain_alloc_qty_tg_mon_1 mon_yr, lc(gs12)) (line pdsgrain_alloc_qty_tg_mon_2 mon_yr, lc(gs8))  (line pdsgrain_alloc_qty_tg_mon_3 mon_yr, lc(gs0) )      ///
			(line pdsgrain_alloc_qty_target_post mon_yr, lpattern(shortdash) lwidth(0.8) lc(gs0))        /// 
			if card=="BPL"&mon_yr>=tm(2012m1), title("NFSA Target - Instrument",margin(medium)) ytitle("Kg./person",height(4)) xtitle("") name(nfsa_qty, replace) ylabel(2(1)7)           ///
			legend(off)        ///
			tline(2013m3,lwidth(2) lc(gs14)) ttext(7 2013m3 "NFSA", color(gs8)) ///
			ttext(6.4 2012m1 "Small HHs (<4)", color(gs12) place(e))  ttext(3.5 2012m1 "Medium HHs (4 to 8) ", color(gs8) place(e))  ttext(2.4 2012m1 "Large HHs (>8)", color(gs0) place(e))          ///
			ttext(5.2 2015m3 "{it:Target}", color(gs0))  graphregion(color(white)) ylabel(,glc(none) ) nodraw
		
		
graph combine grain_qty nfsa_qty ,   ///
			  xsize(20) ysize(9) rows(1)   ///
			  title("Within state-variation in PDS Quantity") subtitle("Per-capita ; Rice and Wheat")    ///
			  graphregion(color(white)) 
			  
			  
			  
graph export "$graph_dir/PDSQtyHHsize_Entl_Inst.pdf", as(pdf) replace
	
graph close	 

restore				
		
