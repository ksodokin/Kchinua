

/*This do-file cleans GES General Files (Caste and lclass)
  and collapses the data to household-panelyear level  */
  

/////// GES General Details ///////  	
use "$stata_data_dir/GES/Aggregate/Gen_info_agg",replace

		*Clean village variable*
		replace village="Aurepalle" if village=="Aurepalli"
		replace village="JCAgraharam" if village=="J.C.Agraharam"
		replace village="Kapanimbargi" if village=="Kappanimbargi"
		replace village="Karamdichingariya" if village=="KaramdiChingariya"
		replace village="Kinkhed" if village=="Kinkheda"
		replace village="Tharati" if village=="Tharati/Ajjihalli"
		replace village="Bhagakole" if village=="Baghakole"
		
		replace state="AndhraPradesh" if state=="Telangana"

		gen lclass=0
		replace lclass=1 if pre_farm_size=="LB"
		replace lclass=2 if pre_farm_size=="SM"
		replace lclass=3 if pre_farm_size=="MD"
		replace lclass=4 if pre_farm_size=="LA"

		label define class 1 "Landless" 2 "Small" 3 "Medium" 4 "Large"
		label values lclass class
		drop if lclass==0


	** Caste names **
	
	**There are some errors/missing caste names for some hosuehold/in some years
	**Choose the most frequenty occuring caste name for a household**
	
	*Clean caste variables 
	gen caste_p=proper(caste)
	gen caste_group_p=proper(caste_group)
	gen sub_caste_p=proper(sub_caste)
	
		*Clean caste names
		replace caste_p="Kunbhi" if sub_caste_p=="Kunbhi"&caste_p=="Maratha"&caste_group_p=="Obc"
		replace caste_p="Teli" if strmatch(sub_caste,"Sah*")|caste_p=="Oilman"
		replace caste_p="Bhumihar" if caste_p=="Bhimihar"
		replace caste_p="Dushadh" if caste_p=="Dusadh"
		replace caste_p="Haldiyateli" if caste_p=="Haladiyateli"
		replace caste_p="Kamara" if caste_p=="Kamar"
		replace caste_p="Kulta" if caste_p=="Kilta"
		replace caste_p="Khaira" if caste_p=="Kharia"
		replace caste_p="Kshetriya" if caste_p=="Kshatriya"|caste_p=="Khetriya"	
		replace caste_p="Panda" if caste_p=="Pana"
		replace caste_p="Patel" if (caste_p=="Pateliya"&caste_group_p=="Obc")|caste_p=="Patil"
		replace caste_p="Bhahman" if caste_p=="Bhaman"
		replace caste_p="Harijan" if caste_p=="Harizen"|caste_p=="Harizan"
		replace caste_p="Carpenter" if caste_p=="Carpentar"
		replace caste_p="Kurmi" if caste_p=="Kurami"
		replace caste_p="Mutharasi" if caste_p=="Mutrasi"|caste_p=="Muttirasi"
		replace caste_p="Vishwabrahmin" if caste_p=="Viswabrahman"
		replace caste_p="Shepherd" if caste_p=="Shepard"|caste_p=="Shephard"
		replace caste_p="Navboudha" if caste_p=="Nav-Boudha"|caste_p=="Navboudh"
		replace caste_p="Potter" if strmatch(caste_p,"Potter*")
		replace caste_p="Waddar" if caste_p=="Madar"
		replace caste_p="Gopal" if caste_p=="Gopala"|caste_p=="Milkman"
		replace caste_p="Gosawi" if caste_p=="Gosavi"
		replace caste_p="Bajantri" if caste_p=="Bajanthri"	
		replace caste_p="Bhatraju" if caste_p=="Batrajulu"
		replace caste_p="Vaddera" if caste_p=="Vadde"|caste_p=="Vadderaj"
		replace caste_p="Gowda" if caste_p=="Goud"
		replace caste_p="Gonda" if caste_p=="Gouda"|caste_p=="Goudo"	
		replace caste_p="Dhobi" if caste_p=="Washerman"
		replace caste_p="Khaibarta" if caste_p=="Kaibarta"
		replace caste_p="Dushadh" if caste_p=="Dubhadh"
		
	

	**Most frequently occuring (Mode) of caste name for a household
	gen new_id=substr(vds_id,1,3)+substr(vds_id,6,10)
	bys new_id : egen caste_freq=mode(caste_p)

	
	**59 missing observations -- errors in caste name reporting -- caste names change every year, particularly in JH Village A

		
	**Count the number of HHs in each Village-caste category
		preserve
		gen pan_year="20"+substr(vds_id, 4, 2)
		destring pan_year,replace	
		bys village  caste_freq pan_year new_id: gen counter3 =_n
		gen hh_count=1 if counter3==1
		*Total number of hh in each village-caste category in each panel_year
		collapse (sum) hh_count, by(village  caste_freq pan_year)
		*Take the mean of the previous over all years
		collapse (mean) hh_count, by(village  caste_freq)
		replace hh_count=round(hh_count)
		
		rename hh_count caste_hhcount
		
		tempfile caste_hh
		save `caste_hh'
		restore
	
	*Merge # of HHs variable : caste_hhcount
	merge m:m village caste_freq using `caste_hh'	
		
	
	*Drop and rename caste variables
	drop new_id caste caste_p caste_group sub_caste 


		rename caste_freq caste
		rename caste_group_p caste_group
		rename sub_caste_p sub_caste
			
			
	*Clean Caste grouping
	replace caste_group="Obc" if strmatch(caste_group,"*Ebc*")|strmatch(caste_group,"*Sbc*")
	replace caste_group=upper(caste_group)

			*Group Backwardclass and Otherbakcward class together
			replace caste_group="BC/OBC" if caste_group=="BC"|caste_group=="OBC"
			*Group Scheduled Caste, Scheduled Tribe and Nomadic Tribe together
			replace caste_group="SC/ST/NT" if caste_group=="ST"|caste_group=="NT"|caste_group=="SC"						
	
	
	*Caste group replacing missing variable
	replace caste_group="SC/ST/NT" if caste=="Amaliyar"&village=="Babrol"
	replace caste_group="SC/ST/NT" if caste=="Tadavi"&village=="Babrol"
	replace caste_group="SC/ST/NT" if caste=="Chamatha"&village=="Chatha"
	replace caste_group="BC/OBC" if caste=="Patel"&village=="Chatha"
	replace caste_group="SC/ST/NT" if caste=="Santhal"&village=="Durgapur"
	replace caste_group="FC" if caste=="Lohara"&village=="Sogar"
	
	
	*Keep only Landholding class and Caste names
	keep vds_id lclass village teh_man_blo district state caste caste_group sub_caste caste_hhcount
	order vds_id village teh_man_blo district state lclass

		

