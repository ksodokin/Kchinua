

/*This do-file :
   
   Graphs for anthro data: 
   
   1) Z-score graphs of HAZ

   */

  

		
		
*** Z-score graphs ***


	 
				 
***HAZ only****				 
			 
	twoway (kdensity haz if gender_str=="F") (kdensity haz if gender_str=="M")  if pan_year==2013,     ///
	        xtitle("Z-score") ytitle("Density")     /// 
			title("Distribution of Height-for-age z-scores", height(5) margin(b=5))   ///
				 graphregion(color(white))  ylabel(,glc(none) )   xlabel(-5(1)5,glp(blank))      ///		 
				yline(0,lp(solid)) xline(-2,lcolor(gs10) lpattern(dash))    ///
				legend(size(small)  symxsize(4)  cols (1) position(2)  ring(0)    ///
						bmargin("0 20 0 6")  order (1 "Girl" 2 "Boy") region(lcolor(black)))
				
				
			
graph export "$graph_dir/HAZ_dist.pdf",as(pdf) replace
	
  
graph close	 
	 		
						 
				
				
	
