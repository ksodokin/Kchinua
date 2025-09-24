




graph set window fontface "Times New Roman"	
	
	
	
***State-by-State graphs****	
	
	
	
*******************
*** PRICE GRPAH ***	
*******************


		
*Statewise-average of prices 
	local pricelist pdsrice_alloc_price pdsrice_alloc_price_tg
	foreach x of local pricelist {
	local statelist AP BH GJ JH KN MP MH OR
	foreach y of local statelist {
	bys mon_yr: egen `x'_mon_`y'=mean(`x') if state_dum=="`y'"&card=="BPL"
	}
	}

	
** NFSA Target Price	
	gen pdsrice_alloc_price_target=3	
		
	gen pdsrice_alloc_price_target_post=3 if mon_yr>=tm(2013m3)	
	replace pdsrice_alloc_price_target_post=pdsrice_alloc_price_target_post+0.01	
	
**Central Issue price (for older graphs)
	
	gen pdsrice_alloc_cip=5.65
	replace pdsrice_alloc_cip=3 if mon_yr>=tm(2013m3)

	gen pdsrice_alloc_cip_post=pdsrice_alloc_cip if mon_yr>=tm(2013m3)	
	
	
	
** Avoid Overlaping*** 
** Note: Some prices overlap -- Lines overlap in grapsh - so prices for each state becomes difficult to distinguish in the graphs
**       Add some epsilon value over overlapping prices, just to differentiate them in the graph 
		
	replace pdsrice_alloc_price_mon_KN=pdsrice_alloc_price_mon_KN+0.02
	replace pdsrice_alloc_price_mon_GJ=pdsrice_alloc_price_mon_GJ-0.02

	replace pdsrice_alloc_price_tg_mon_KN=pdsrice_alloc_price_tg_mon_KN+0.02
	replace pdsrice_alloc_price_tg_mon_GJ=pdsrice_alloc_price_tg_mon_GJ-0.02


	replace pdsrice_alloc_price_mon_AP=pdsrice_alloc_price_mon_AP-0.02
	replace pdsrice_alloc_price_mon_JH=pdsrice_alloc_price_mon_JH+0.02

	replace pdsrice_alloc_price_tg_mon_AP=pdsrice_alloc_price_tg_mon_AP-0.02
	replace pdsrice_alloc_price_tg_mon_JH=pdsrice_alloc_price_tg_mon_JH+0.02

	
	
	
	
	
******************************	
***Pre and Post Price Graph***
******************************	
	
twoway  (line pdsrice_alloc_price_mon_AP mon_yr,lpattern(solid) lc(gs6)) (line pdsrice_alloc_price_mon_BH mon_yr, lpattern(solid) lc(gs2))  (line pdsrice_alloc_price_mon_GJ mon_yr,lpattern(solid) lc(gs8) )      ///
		(line pdsrice_alloc_price_mon_JH mon_yr,lpattern(solid) lc(gs12)) (line pdsrice_alloc_price_mon_KN mon_yr, lpattern(solid) lc(gs2)) (line pdsrice_alloc_price_mon_MP mon_yr, lpattern(solid) lc(gs12))         ///
		(line pdsrice_alloc_price_mon_MH mon_yr,lpattern(solid) lc(gs8))  (line pdsrice_alloc_price_mon_OR mon_yr, lpattern(solid) lc(gs2))         ///
		(line pdsrice_alloc_price_target_post mon_yr, lpattern(shortdash) lwidth(0.8) lc(gs0))        ///
		if card=="BPL"&year>=2012,  title("Actual Entitlement", margin(medium)) ytitle("Rs./kg") xtitle("") name(rice_price, replace) ylabel(0(1)8)         ///
		tline(2013m3,lwidth(2) lc(gs14)) ttext(8 2013m3 "NFSA", color(gs8)) ttext(3.4 2015m3 "Target", color(gs0))		   ///
		ttext(7.3 2012m1 "Bihar", color(gs2) place(e)) ttext(6.3 2012m1 "Maharashtra", color(gs8) place(e)) ttext(4.8 2012m1 "Madhya Pradesh", color(gs12) place(e))  ttext(2.2 2012m1 "Orissa", color(gs2) place(e))          ///
		ttext(1.25 2012m1 "Andhra Pradesh", color(gs6) place(e)) ttext(0.8 2012m1 "Jharkhand", color(gs12) place(e))  ttext(3.3 2012m1 "Karnataka", color(gs2) place(e)) ttext(2.8 2012m1 "Gujarat", color(gs8) place(e))   ///
		legend(off) graphregion(color(white)) ylabel(,glc(none) )  nodraw
		
	
twoway  (line pdsrice_alloc_price_tg_mon_AP mon_yr,lpattern(solid) lc(gs6)) (line pdsrice_alloc_price_tg_mon_BH mon_yr, lpattern(solid) lc(gs2))  (line pdsrice_alloc_price_tg_mon_GJ mon_yr,lpattern(solid) lc(gs8) )      ///
		(line pdsrice_alloc_price_tg_mon_JH mon_yr,lpattern(solid) lc(gs12)) (line pdsrice_alloc_price_tg_mon_KN mon_yr, lpattern(solid) lc(gs2)) (line pdsrice_alloc_price_tg_mon_MP mon_yr, lpattern(solid) lc(gs12))         ///
		(line pdsrice_alloc_price_tg_mon_MH mon_yr,lpattern(solid) lc(gs8))  (line pdsrice_alloc_price_tg_mon_OR mon_yr, lpattern(solid) lc(gs2))         ///
		(line pdsrice_alloc_price_target_post mon_yr, lpattern(shortdash) lwidth(0.8) lc(gs0))        ///
		if card=="BPL"&year>=2012,  title("NFSA Target - Instrument",margin(medium)) ytitle("Rs./kg") xtitle("") name(NFSA_price, replace) ylabel(0(1)8)         ///
		tline(2013m3,lwidth(2) lc(gs14)) ttext(8 2013m3 "NFSA", color(gs8)) ttext(3.4 2015m3 "Target", color(gs0))		   ///
		ttext(7.3 2012m1 "Bihar", color(gs2) place(e)) ttext(6.3 2012m1 "Maharashtra", color(gs8) place(e)) ttext(4.8 2012m1 "Madhya Pradesh", color(gs12) place(e))  ttext(2.2 2012m1 "Orissa", color(gs2) place(e))          ///
		ttext(1.25 2012m1 "Andhra Pradesh", color(gs6) place(e)) ttext(0.8 2012m1 "Jharkhand", color(gs12) place(e))  ttext(3.3 2012m1 "Karnataka", color(gs2) place(e)) ttext(2.8 2012m1 "Gujarat", color(gs8) place(e))   ///
		legend(off) graphregion(color(white)) ylabel(,glc(none) ) nodraw
		
			

graph combine rice_price NFSA_price , ///
              xsize(20) ysize(9) rows(1) title("PDS Rice Price")      ///
              graphregion(color(white)) name(pds_price, replace)    
			  
			  
graph export "$graph_dir/PDSPrice_Entl_Inst.pdf",as(pdf) replace			  

graph close	 

	
