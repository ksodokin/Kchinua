




preserve



**********************
*** QUANTITY GRPAH ***	
**********************
	



use "$analysis_data_dir/hh_mon_agg",replace

cd "$analysis_code_dir/Graphs_hh"


gen state_dum=state

***************
*** FIGURES ***
***************

graph set window fontface "Times New Roman"	

*State-level variation in PDS prices (Entitlement and Instrument)
*do A1_hh_graph_price

replace pdsgrain_alloc_qty = 25.5 if state_dum=="MH"&card=="BPL"&mon_yr<tm(2014m2)
replace pdsgrain_alloc_qty = 22.5 if state_dum=="KN"&card=="BPL"&mon_yr<tm(2013m7)



replace pdsgrain_alloc_qty_tg= pdsgrain_alloc_qty if state_dum=="MH"&card=="BPL"&mon_yr<tm(2013m3)
replace pdsgrain_alloc_qty_tg= pdsgrain_alloc_qty if state_dum=="KN"&card=="BPL"&mon_yr<tm(2013m3)


*Quantity is in per-household -- convert to per-capita based on HH-census

			*HH-size based on Census 2001 data - as calculated by Center(FCI)
			gen hh_size_census=0
			replace hh_size_census=3.4 if state_dum=="AP"
			replace hh_size_census=5.95 if state_dum=="BH"
			replace hh_size_census=5.1 if state_dum=="GJ"
			replace hh_size_census=5.8 if state_dum=="JH"
			replace hh_size_census=5.17 if state_dum=="KN"
			replace hh_size_census=4.95   if state_dum=="MP"
			replace hh_size_census=5.1   if state_dum=="MH"
			replace hh_size_census=5.3 if state_dum=="OR"
			
			
			
replace pdsgrain_alloc_qty = 5*hh_size_census if state_dum=="MH"&card=="BPL"&mon_yr>=tm(2014m2)
	

*Convert to per-capita

gen control_st=state_dum=="OR"|state_dum=="JH"

replace pdsgrain_alloc_qty=pdsgrain_alloc_qty/hh_size_census

replace pdsgrain_alloc_qty_tg=pdsgrain_alloc_qty_tg/hh_size_census if control_st==1
replace pdsgrain_alloc_qty_tg=pdsgrain_alloc_qty_tg/hh_size_census if mon_yr<tm(2013m3) & control_st==0
replace pdsgrain_alloc_qty_tg=pdsgrain_alloc_qty_tg/hh_size_m  if mon_yr>=tm(2013m3) & control_st==0


*Statewise-average of quantity 

local qtylist pdsgrain_alloc_qty_tg pdsgrain_alloc_qty
foreach x of local qtylist {
local statelist AP BH GJ JH KN MP MH OR
foreach y of local statelist {
bys mon_yr: egen `x'_mon_`y'=mean(`x') if state_dum=="`y'"&(card=="BPL")
}
}

*lgraph pdsgrain_alloc_qty mon_yr if state_dum=="AP"	& card=="BPL" 

	
** NFSA Target Quantity	

gen pdsrice_alloc_qty_target_post=5 if mon_yr>=tm(2013m3)		
		

*(line pdsgrain_alloc_qty_mon_MH mon_yr, lc(gs8)) 		
		
******************************	
***Pre and Post Price Graph***
******************************	
		
	
***Combined Graph***
	twoway  (line pdsgrain_alloc_qty_mon_AP mon_yr, lc(gs8))  (line pdsgrain_alloc_qty_mon_BH mon_yr, lc(gs0))    (line pdsgrain_alloc_qty_mon_KN mon_yr,  lc(gs8))      ///
		  (line pdsgrain_alloc_qty_mon_MP mon_yr,  lc(gs8))    (line pdsgrain_alloc_qty_mon_GJ mon_yr, lc(gs8) )   (line pdsgrain_alloc_qty_mon_MH mon_yr, lc(gs8))    ///
		  (line pdsgrain_alloc_qty_mon_JH mon_yr, lc(gs0))  (line pdsgrain_alloc_qty_mon_OR mon_yr, lc(gs8))          ///
		(line pdsrice_alloc_qty_target_post mon_yr, lpattern(shortdash) lwidth(0.8) lc(gs0))        /// 
		if card=="BPL"&mon_yr>=tm(2012m1), title("Actual Entitlement",margin(medium)) ytitle("Kg./person") xtitle("") name(grain_qty, replace) ylabel(3(1)6.5)          ///
		legend(off)        ///
		tline(2013m3,lwidth(2) lc(gs14)) ttext(6.5 2013m3 "NFSA", color(gs8))       ///
		ttext(4.15 2012m1 "Bihar", color(gs0) place(e))  ttext(5.1 2012m1 "Maharashtra", color(gs8) place(e))	 ttext(5.8 2012m1 "Orissa", color(gs8) place(e))          ///
		ttext(3.9 2012m1  "AP, MP", color(gs8) place(e)) ttext(6.2 2012m1 "Jharkhand", color(gs0) place(e))  ttext(4.45 2012m1 "Karnataka", color(gs8) place(e)) ttext(3.4 2012m1 "Gujarat", color(gs8) place(e))        ///
		 ttext(5.15 2015m3 "{it:Target}", color(gs0)) graphregion(color(white)) ylabel(,glc(none) ) nodraw

		
	twoway  (line pdsgrain_alloc_qty_tg_mon_AP mon_yr, lc(gs8)) (line pdsgrain_alloc_qty_tg_mon_BH mon_yr,  lc(gs0))  (line pdsgrain_alloc_qty_tg_mon_GJ mon_yr, lc(gs8) )      ///
		(line pdsgrain_alloc_qty_tg_mon_JH mon_yr, lc(gs0)) (line pdsgrain_alloc_qty_tg_mon_KN mon_yr,  lc(gs8)) (line pdsgrain_alloc_qty_tg_mon_MP mon_yr,  lc(gs8))         ///
		(line pdsgrain_alloc_qty_tg_mon_MH mon_yr, lc(gs8))  (line pdsgrain_alloc_qty_tg_mon_OR mon_yr,  lc(gs8))         ///
		(line pdsrice_alloc_qty_target_post mon_yr, lpattern(shortdash) lwidth(0.8) lc(gs0))        /// 
		if card=="BPL"&mon_yr>=tm(2012m1),  title("NFSA Target - Instrument",margin(medium))  ytitle("Kg./person") xtitle("") name(nfsa_qty, replace) ylabel(3(1)6.5)          ///
		legend(off)        ///
		tline(2013m3,lwidth(2) lc(gs14)) ttext(6.5 2013m3 "NFSA", color(gs8))       ///
		ttext(4.15 2012m1 "Bihar", color(gs0) place(e)) ttext(5.1 2012m1 "Maharashtra", color(gs8) place(e))  ttext(5.8 2012m1 "Orissa", color(gs8) place(e))          ///
		ttext(3.9 2012m1  "AP, MP", color(gs8) place(e)) ttext(6.2 2012m1 "Jharkhand", color(gs0) place(e))  ttext(4.5 2012m1 "Karnataka", color(gs8) place(e)) ttext(3.4 2012m1 "Gujarat", color(gs8) place(e))     ///
		 ttext(5.15 2015m3 "{it:Target}", color(gs0))   graphregion(color(white)) ylabel(,glc(none) ) nodraw



		 
graph combine grain_qty nfsa_qty ,     ///
		  	  xsize(20) ysize(9) rows(1)   ///
			  title("PDS Rice and Wheat Quantity")   ///
			  graphregion(color(white)) name(pds_qty, replace) 

			  
graph export "$graph_dir/PDSQty_Entl_Inst.pdf",as(pdf) replace
	
graph close	 
	
restore
			  
			  

	  
			  
			  
			  
