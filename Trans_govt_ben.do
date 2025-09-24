

/*This do-file cleans Transaction Govt Benefit Files  
  and collapses the data to household-month level  */

  


////// TRANSACTION  Govt Benefits  //////
use "$stata_data_dir/Transaction/Aggregate/Ben_govt_prog_agg",replace

	
		gen pds_dum=strmatch(prog_name,"*wheat*") 

		gen middaybenefit_val=amt_ben if strmatch(prog_name,"*Midday*")
		
		gen pdsbenefit_val=amt_ben if pds_dum==1
		gen nonpdsbenefit_val=amt_ben if pds_dum==0
		
		*Cash given as pensions*
		gen pensionbenefit_val=amt_ben if strmatch(prog_name,"Pension*")
		gen otherbenefit_val=amt_ben if strmatch(prog_name,"SCHOLAR*")|strmatch(prog_name,"*Cropinsurance*")|strmatch(prog_name,"*package*")
		gen cashbenefit_val=amt_ben if strmatch(prog_name,"Pension*")|strmatch(prog_name,"SCHOLAR*")|      ///
									   strmatch(prog_name,"*Cropinsurance*")|strmatch(prog_name,"*package*")
		
		gen healthbenefit_val=amt_ben if strmatch(prog_name,"*health*")
		
		collapse (sum) middaybenefit_val-cashbenefit_val healthbenefit_val , by(vds_id sur_mon_yr) 
				
		
