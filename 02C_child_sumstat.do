


/*This do-file estimates :

  1) Summary stats of children 0 to 5 years

 
 */





gen pds_card=card=="BPL"|card=="AAY"


label define card_label 1 "Beneficiaries" 0 "Non-Beneficiaries"
label values pds_card card_label

label variable haz_w97 "Height-for-age z-score"



estpost tabstat haz_w97 stunting       ///
		if age<=5 &pan_year<=2013,by(pds_card) statistics(mean sd) columns(statistics) 

		
		


	esttab using  "$table_anthro_dir/child_sumstat.csv", replace ///
	   main(mean) aux(sd) nostar unstack nonote label			

