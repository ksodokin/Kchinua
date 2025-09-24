

/*This do-file :

  Transforms raw rainfall data to Analysis data 
 
 */

 

cap log close
log using "$log_dir/7_rf_$date_string", replace 





/////////////////////////////
***** IMD RAINFALL DATA *****
/////////////////////////////

use "$data_dir/Raw/RawAuxData/INDrf",replace


	tostring Date,replace

	gen year= substr(Date, 1, 4)
	gen month= substr(Date, 5, 2)
	gen day= substr(Date, 7, 2)

	order year month day 

	destring year month day, replace

	drop Date

	***********************************************
	*Reshape Rainfall data to Panel data structure*
	***********************************************
	/*
	Step1: Rename villages to villnumbers
	Step2: Use reshape command
	Step3: Rename villnumbers back to villages
	*/


	*display strtoname("1Var name")
	*Step 1:Rename villages to villnumbers
		local i=1
		local villist Tharati Belladamadugu JCAgraharam Pamidipadu Dokur Markabbinahalli ////
					  Aurepalle Kapanimbargi Shirapur Kalman Bilaikani Kanzara Kinkhed   ////
					  Ainlatunga Sogar Chandrasekharpur Karamdichingariya Makhiyala Papda ////
					  Chatha Babrol RampurKalan Hesapiri Dubaliya Durgapur Dumariya      ////
					  Bhagakole Arap Inai Susari	
		foreach x of local villist {
		rename `x' vill`i'
		local i=`i'+1
		}

	*Step2: Use reshape command
		reshape long vill, i(year month day) j(vill_num)
		rename vill rf


	*Step3:Rename villnumbers back to villages
		gen village=""
		local i=1
		local villist Tharati Belladamadugu JCAgraharam Pamidipadu Dokur Markabbinahalli  ////
					  Aurepalle Kapanimbargi Shirapur Kalman Bilaikani Kanzara Kinkhed    ////
					  Ainlatunga Sogar Chandrasekharpur Karamdichingariya Makhiyala Papda  ////
					  Chatha Babrol RampurKalan Hesapiri Dubaliya Durgapur Dumariya       ////
					  Bhagakole Arap Inai Susari
		foreach x of local villist {
		replace village="`x'" if vill_num==`i'
		local i=`i'+1
		}

		drop vill_num

		order village year month day
		sort village year month day

		rename rf rf_imd
		
	
		
	
/*Calculate the Seasonal rainfall measures at the annual level:*/


	*Create Crop year - June to June variables
	gen cr_year=year if month>=6
	replace cr_year=year-1 if month<6


	gen mon_per = 1 if month>=6&month<=9
	sort village cr_year mon_per month day

	gen rf_sea_imd=rf_imd if mon_per==1
	
	




///////////////////////////////////
* Bring the data to crop year level 
///////////////////////////////////


collapse (sum) rf_imd rf_sea_imd,by(village cr_year)

	

	bys village: egen rf_sea_imd_mean=mean(rf_sea_imd)
	bys village: egen rf_sea_imd_sd=sd(rf_sea_imd)
		
		gen z1_rf_sea_imd=(rf_sea_imd-rf_sea_imd_mean)/rf_sea_imd_sd
 
	drop rf_sea_imd_mean rf_sea_imd_sd
	
		*Create lag variables
		sort village cr_year
		local mylist  rf_imd rf_sea_imd  z1_rf_sea_imd
		foreach x of local mylist { 
		bys village: gen l_`x'=`x'[_n-1]
		}

	
		
		
		keep if cr_year>=2009&cr_year<=2014

		



