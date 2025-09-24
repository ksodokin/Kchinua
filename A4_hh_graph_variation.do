



preserve 



***************************************
*** GET DATA TO STATE-HH-SIZE LEVEL ***
***************************************

	
	*Convert String to numeric
	encode state,gen(st)


		*Assume NFSA targets for Jharkhand and Orissa continued as they are (No wheat in JH and OR, so assign rice)
		replace pdsgrain_alloc_qty_tg=35 if mon_yr>=tm(2013m6)&(state=="Jharkhand"&card=="BPL")
		replace pdsgrain_alloc_qty_tg=30 if mon_yr>=tm(2013m6)&(state=="Orissa"&card=="BPL")

		replace grain_subs_tg= pdsgrain_alloc_qty_tg*rice_dis_tg if mon_yr>=tm(2013m6)&(state=="Orissa"&card=="BPL")|(state=="Jharkhand"&card=="BPL")
		

	*Bring quantity entitlements to per-capita (from per-household)
	local qtylist pdsgrain_alloc_qty_tg pdsgrain_alloc_qty grain_subs grain_subs_tg
	foreach x of local qtylist {
	replace `x'=`x'/hh_size_m
		}

	*Post-NFSA dummy		
	gen post_NFSA=mon_yr>=tm(2013m6)	



	*Get the Data to State-HHsize-(prepost-NFSA) level
				
	collapse (mean) pdsgrain_alloc_qty_tg pdsgrain_alloc_qty        ///
					pdsgrain_alloc_price_tg   pdsgrain_alloc_price  pdsrice_alloc_price_tg pdsrice_alloc_price   pdswheat_alloc_price_tg pdswheat_alloc_price        ///
					grain_subs grain_subs_tg            /// 
					 if card=="BPL", by(st hh_size_m post_NFSA)
				
	drop if hh_size_m==0|hh_size_m==.
		
	*Calculate the Change in entitlements post-NFSA for each State-HH-size cell	
	local grainlist pdsgrain_alloc_qty_tg pdsgrain_alloc_qty pdsgrain_alloc_price_tg pdsgrain_alloc_price         ///
					pdsrice_alloc_price_tg pdsrice_alloc_price pdswheat_alloc_price_tg pdswheat_alloc_price       ///
					grain_subs grain_subs_tg
		foreach x of local grainlist  {

		*Pre Mean
		gen `x'_pre=`x' if post_NFSA==0
		gen `x'_post=`x' if post_NFSA==1
		
		bys st hh_size_m : egen `x'_pre_m=mean(`x'_pre)
		bys st hh_size_m : egen `x'_post_m=mean(`x'_post)

		gen ch_`x'= `x'_post_m - `x'_pre_m
		
		}	

	replace pdsrice_alloc_price_pre=round(pdsrice_alloc_price_pre)


	*Get the Data to State-HHsize - level	
	collapse (mean) pdsrice_alloc_price_pre ch_*  , by(st hh_size_m)





************************	
*        GRAPH         *
*Entitlements vs Target*
************************
		   		   
*This graph shows the Change-in-actual entitlements by changes in target entitlements (quantity and value)




	
gen price_noncompl=st==2|st==7|st==6
gen qty_noncompl=st==1|st==2|st==3|st==5|st==6|st==7

**Household-size categories
	gen hh_size_cat=1 if hh_size_m<=4
	replace hh_size_cat=2 if hh_size_m>4&hh_size_m<=7
	replace hh_size_cat=3 if hh_size_m>7


separate ch_grain_subs,by(hh_size_cat) veryshortlabel

*Category:

twoway (scatter  ch_grain_subs? ch_grain_subs_tg if (hh_size_m>3&hh_size_m<15)&price_noncompl==0&qty_noncompl==0, mcolor(green...) msymbol(X diamond_hollow circle))   ///
	   (scatter  ch_grain_subs? ch_grain_subs_tg if (hh_size_m>3&hh_size_m<15)&price_noncompl==0&qty_noncompl==1, mcolor(blue...) msymbol(X diamond_hollow circle))   ///
	   (scatter  ch_grain_subs? ch_grain_subs_tg if (hh_size_m>3&hh_size_m<15)&price_noncompl==1&qty_noncompl==0, mcolor(purple...) msymbol(X diamond_hollow circle))  ///
	   (scatter  ch_grain_subs? ch_grain_subs_tg if (hh_size_m>3&hh_size_m<15)&price_noncompl==1&qty_noncompl==1, mcolor(red...) msymbol(X diamond_hollow circle))  ///	   
	   (lfit ch_grain_subs ch_grain_subs_tg if (hh_size_m>3&hh_size_m<15),lcolor(gs10) lwidth(vthin) lpattern(dash) )  ,      ///
	   text(47 55 "Out-of-attainment with" "price and quantity mandate", place(e) color(red) j(left) size(vsmall))     ///
	   text(10 55 "Out-of-attainment with" "quantity mandate only", place(e) color(blue) j(left) size(vsmall))        /// 
	   text(18 -1 "In-attaintment with" "price and quantity" "mandate", place(e) color(green) j(left) size(vsmall))      ///
	   text(37 62 "Linear fit", place(e) color(gs10) j(left) size(vsmall))      ///
	   legend(colgap(0)  cols (3) symxsize(1)   size(small)  region(fcolor(none)  )     ///   
			  position(2)  ring(0) bmargin("0 0 0 3")       ///
			  order (1 "" 4 "" 10 "Small HHs (<4)" 2 "" 5 "" 11 "Medium HHs (4 to 7)" 3 "" 6 "" 12 "Large HHs (>7)" ) )      ///				 
	   xtitle("Change in NFSA target (IV) entitlement value") ytitle("Change in actual entitlement value")     ///
	    title("PDS Transfer Value") subtitle("Per-capita")         ///
		graphregion(color(white)) ylabel(,glc(none) ) xlabel(0(20)80,glc(none) ) 
		
		
		
graph export "$graph_dir/ActualbyTarget.pdf",as(pdf) replace

graph close	 	
	
restore
