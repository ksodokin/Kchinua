





/*This do-file calculates :
  1) Prepares panel variables - HH id, Individual ID, Panel year, etc
  2) Descriptive stats for study population */


	*Create individual-id (panel id) 
	gen new_id=substr(vds_id,1,3)+substr(vds_id,6,10)	
	gen indv_id=new_id+"_"+string(pre_mem_id)
	encode indv_id,gen(indv_id1)			
	encode new_id,gen(new_id1)			
	
	*Create Panel year - June to June 
	gen pan_year="20"+substr(vds_id, 4, 2)
	destring pan_year,replace
	


*Number of individuals

	*Drop repeat observations
	bys indv_id pan_year: gen counter=_n 
	bys indv_id pan_year: egen counter2=max(counter)
	drop if counter2==2
	drop counter*

	*Count number of individuals
	sort indv_id pan_year	
	bys indv_id: gen counter=_n
	bys indv_id: egen counter2=max(counter)

	
	drop counter*
	

**Formatting**

	*Format numeric variables
	format %14.0f ch_stat sl_no rel old_mem_id pre_mem_id spouse_m_id spouse_f_id child_m_id child_f_id mari_stat edu_level yrs_edu
	
	
	
	**Format variable : change of status of individuals***	
	replace ch_stat=0 if ch_stat==.

		label define stat 0 "Present in HH"    ///
						  1 "Left the HH due to marriage" 2 "Left the HH due to separation (family division)"   ///
						  3 "Death" 4 "Left the HH due to other reason"       ///
						  5 "Joined the HH due to birth"   6 "Joined the HH due to marriage" 7 "Rejoined the family" 8 "Joined the HH due to other reason 
				   
		label values ch_stat stat



***1) Births in dataset  ***

	gen birth_child= ch_stat==5&age<3

	**Repetitive recording of birth status 
	bys indv_id birth_child : gen counter=_n if birth_child==1
		
		*Replace, for a repetitive recording of birth for the same child
		replace birth_child=0 if counter==2
		drop counter*
	
	*Count
	count if birth_child==1
	count if height!=.&weight!=.&arm_circum!=. & birth_child==1
	tab birth_child pan_year
	
	

	
***2) Birth-Mothers in dataset  ***	
	
	
*Identify mothers (indv_id) corresponding to birth children	
	gen mom_id=child_f_id if birth_child==1
	bys new_id pan_year: egen mom_id_hh=mean(mom_id)	
	gen mother=1 if mom_id_hh==pre_mem_id

		*Drop errors
		replace mother=. if age<15

	drop mom_id mom_id_hh 	

	bys indv_id: egen mother_dum=max(mother)
	replace mother_dum=0 if mother_dum==.	
	

 	

***3) Children (0-5 yrs) in dataset  ***		

	gen child=age<=5
	tab child
		
	count if height!=.&weight!=.&arm_circum!=. & child==1

	tab  child pan_year
	


***4) Adolescents (10-19 yrs) in dataset  ***
  
	gen adolescent=age>=10&age<=19
	tab adolescent
  
  	count if height!=.&weight!=.&arm_circum!=. & adolescent==1

  
  tab  adolescent pan_year
  
  
 
