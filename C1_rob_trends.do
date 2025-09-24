



/*This do-file estimates regressions :

  1) Event-study graphs on Stunting and HAZ 
 
 */



	
******************
*----------------*		
*  TREND GRAPHS  *
*----------------*		
******************	

	
*Trend graph with (base = 2013 - that represents 2013 July-June) 	

	  
	  
*************
**Stunting***
*************

***Reduced-form -- Instrument only***
	
reghdfe stunting c.ch_grain_subs_tg_int##ib2013.pan_year    if age<=5    ///
                 , absorb("$indv_fe" ) vce(cluster vill)  allbaselevels

	coefplot, vertical omitted baselevels     ///
		  keep(*grain_subs_tg_int*) drop(ch_grain_subs_tg_int )      ///
		  recast(scatter)  cirecast(rcap)          ///
		  yline(0, lc(gs0)) ytitle("Effect") xtitle("Years relative to NFSA",height(4))    ///
		  coeflabels(2010.pan_year#c.ch_grain_subs_tg_int = "2010"   ///
					2011.pan_year#c.ch_grain_subs_tg_int = "2011"   ///
					2012.pan_year#c.ch_grain_subs_tg_int = "2012"   ///
					2013.pan_year#c.ch_grain_subs_tg_int = "2013"   ///
					2014.pan_year#c.ch_grain_subs_tg_int = "2014" )  ///
			graphregion(color(white)) ylabel(,glc(none) )    xlabel(,angle(forty_five) )     ///
			title("Effect on Stunting",margin(b=2))   subtitle("(includes state-by-time FE + controls)" )  nodraw  generate(coef_stunt_) replace


	  
	 		**Stunting graph***		
		twoway    ///
		connected coef_stunt_b coef_stunt_at if coef_stunt_at <=4, mc(black)  lc(black) lp(dash) msize(small) /// 	  	
	 ||	connected coef_stunt_b coef_stunt_at if coef_stunt_at ==5, mc(black)  lc(black) lp(dash)  msize(small)  ///	
	 ||	rcap coef_stunt_ul1  coef_stunt_ll1 coef_stunt_at if coef_stunt_at ==1, mc(black)  lc(black)  msize(small) /// 	  	
	 ||	rcap coef_stunt_ul1  coef_stunt_ll1 coef_stunt_at if coef_stunt_at ==2, mc(black)   lc(black)  msize(small)  ///		
	 || rcap coef_stunt_ul1  coef_stunt_ll1 coef_stunt_at if coef_stunt_at ==3 , mc(black)  lc(black)  msize(small)  ///
	 || rcap coef_stunt_ul1  coef_stunt_ll1 coef_stunt_at if coef_stunt_at ==4 , lp(dash)  lc(gs10)   /// 
	 || rcap  coef_stunt_ul1  coef_stunt_ll1 coef_stunt_at if coef_stunt_at ==5, lc(black)  msize(small) mc(gs10)  ///		 
	 ||,  legend(off)     ///
	  title("Effect on Stunting", margin(b=10))    ///
	  xtick(0.5(1)5.5, tlength(*1.5) )        ///
	  yline(0, lc(gs5) lp(solid)) ytitle("Effect") xtitle("Years relative to NFSA",height(5))    ///
	  graphregion(color(white)) ylabel(-0.01(0.005)0.01,glc(none) )       ///
	  xlabel(1(1)5 1 "-3" 2 "-2" 3 "-1" 4 "0" 5 "1",noticks glp(blank) )     ///
	  xline(4, lc(red) ) name(stunt_trend, replace)     
	  
	 
	 
		
graph export "$graph_dir/Stunting_trend.pdf",as(pdf) replace
	

	
	


************
**  HAZ  ***
************

***Reduced-form -- Instrument only***	

	

reghdfe haz_w97 c.ch_grain_subs_tg_int##ib2013.pan_year    if age<=5    ///
                 , absorb("$indv_fe" ) vce(cluster vill)  allbaselevels		
				 
				 
				 
		coefplot, vertical omitted baselevels     ///
		  keep(*grain_subs_tg_int*) drop(ch_grain_subs_tg_int )      ///
		  recast(scatter)  cirecast(rcap)          ///
		  yline(0, lc(gs0)) ytitle("Effect") xtitle("Years relative to NFSA",height(4))    ///
		  coeflabels(2010.pan_year#c.ch_grain_subs_tg_int = "2010"   ///
					2011.pan_year#c.ch_grain_subs_tg_int = "2011"   ///
					2012.pan_year#c.ch_grain_subs_tg_int = "2012"   ///
					2013.pan_year#c.ch_grain_subs_tg_int = "2013"   ///
					2014.pan_year#c.ch_grain_subs_tg_int = "2014" )  ///
			graphregion(color(white)) ylabel(,glc(none) )    xlabel(,angle(forty_five) )     ///
			ylabel(-0.006 (0.003) 0.006 )     ///
			title("Effect on HAZ",margin(b=5))   subtitle("(includes age-by-time FE +HH_size-by-time FE + BPLcard-by-time FE)" ) nodraw  generate(coef_haz_)  replace


		
		**HAZ graph***		
		twoway    ///
		connected coef_haz_b coef_haz_at if coef_haz_at <=4, mc(black)  lc(black) lp(dash) msize(small) /// 	  	
	 ||	connected coef_haz_b coef_haz_at if coef_haz_at ==5, mc(black)  lc(black) lp(dash)  msize(small)  ///	
	 ||	rcap coef_haz_ul1  coef_haz_ll1 coef_haz_at if coef_haz_at ==1, mc(black)  lc(black)  msize(small) /// 	  	
	 ||	rcap coef_haz_ul1  coef_haz_ll1 coef_haz_at if coef_haz_at ==2, mc(black)   lc(black)  msize(small)  ///		
	 || rcap coef_haz_ul1  coef_haz_ll1 coef_haz_at if coef_haz_at ==3 , mc(black)  lc(black)  msize(small)  ///
	 || rcap coef_haz_ul1  coef_haz_ll1 coef_haz_at if coef_haz_at ==4 , lp(dash)  lc(gs10)   /// 
	 || rcap  coef_haz_ul1  coef_haz_ll1 coef_haz_at if coef_haz_at ==5, lc(black)  msize(small) mc(gs10)  ///		 
	 ||,  legend(off)     ///
	  title("Effect on HAZ", margin(b=10))    ///
	  xtick(0.5(1)5.5, tlength(*1.5))        ///
	  yline(0, lc(gs5) lp(solid) ) ytitle("Effect") xtitle("Years relative to NFSA",height(5))    ///
	  graphregion(color(white)) ylabel(-0.015(0.005)0.015,glc(none) )       ///
	  xlabel(1(1)5 1 "-3" 2 "-2" 3 "-1" 4 "0" 5 "1",noticks glp(blank))      ///
	  xline(4, lc(red) ) name(stunt_trend, replace)     
	  


		
graph export "$graph_dir/HAZ_trend.pdf",as(pdf) replace
	
  
graph close	 
	 
	 
