




/*This do-file :

  Generates PDS transfer value data
 
 */

cap log close
log using "$log_dir/5_pdstransfer_$date_string", replace 
 
	
///////////////////////////////
***   PDS Transfer Value	***
///////////////////////////////	
	

cd $raw_code_dir
		
		
		/////// PDS RationCards ///////
		tempfile pds_cardgen
		include PDS/01_pds_cardgen.do
		save `pds_cardgen'
			
				
				
				
		/////// Get Household-month Data ///////

		*Start with Transactions aggregate dataset (hh-month level)
			use "$stata_data_dir/Aggregate/trans_agg",replace

		
		*Merge GES  
			merge m:1 vds_id using "$stata_data_dir/Aggregate/ges_agg"
			keep if _merge==3
			drop _merge
			


			keep vds_id sur_mon_yr hh_size state_str village pds*   


		*Create a time-invariant HH id
			gen new_id=substr(vds_id,1,3)+substr(vds_id,6,10)
			 
				
				
		*Merge Ration card data
			merge m:1 new_id using `pds_cardgen'
			drop _merge

	

		/////// Prepare and clean data ///////		
		*Cleans: Time variables, baseline HHsize and market price
		include PDS/02_pds_clean.do	

			
		/// PDS RationCard Edits ////
		include PDS/03_pds_cardedits.do		

				

		/// RationCard Allocations ///
		include PDS/04_pds_alloc.do		

				
		/// PDS Entitlement transfer value ///
		include PDS/05_pds_val.do		
				

				
		/// NFSA TARGETS ///
		include PDS/06_pds_NFSA_tg.do		
				
				
drop vill 



save "$stata_data_dir/Aggregate/pds_agg",replace

		
	
	

	
	
	
