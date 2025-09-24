


*******************************
*Parent file :  anthrochild.do*
*******************************

/*This do-file calculates 

   z-scores for children :
   
   1) Calculates z-scores for children ages 0-19yrs --- remaining are missing
   2) Dicotomous variables (dummy variables for stunting,etc)
   3) Adult Nutrition
   
*/


	*BMI
	winsor2 height weight, cuts(0.5 99.5) trim
	gen height_mts=height_tr/100		
	gen bmi=weight_tr/(height_mts*height_mts)

	*Log transformation
	local loglist height weight age arm_circum bmi
	foreach x of local loglist {
		gen ln_`x'=ln(`x')
		}



 	
**************
***Z-score ***
**************
  

*Calculates z-scores for children ages 0-19yrs --- remaining are missing
	
	*Stunting (Height for age)
	egen haz = zanthro(height,ha,WHO), xvar(age) gender(gender_dum) gencode(male=2,female=1) ageunit(year) nocutoff

	*Thinness (BMI for age)
	egen baz = zanthro(bmi,ba,WHO), xvar(age) gender(gender_dum) gencode(male=2,female=1) ageunit(year) nocutoff
		
	*Wasting (Weight for height) /*Note : WHO reference is available only for 0-5 years : Height range is 65-120cms) */
	egen whz = zanthro(weight,wh,WHO), xvar(height) gender(gender_dum) gencode(male=2,female=1) nocutoff
	
	
	*Wasting (Weight for length) /*Note : WHO reference is available only for 0-5 years : Height range is 45-110cms) */
	egen wlz = zanthro(weight,wl,WHO), xvar(height) gender(gender_dum) gencode(male=2,female=1) nocutoff
		
	*Underweight (Weight for age)
	egen waz = zanthro(weight,wa,WHO), xvar(age) gender(gender_dum) gencode(male=2,female=1) ageunit(year) nocutoff

			/*Note : From WHO website: Weight-for-age reference data are not available beyond age 10 
					because this indicator does not distinguish between height and body mass in an age period 
					where many children are experiencing the pubertal growth spurt and may appear as having 
					excess weight (by weight-for-age) when in fact they are just tall.
			*/

	
	*Armcircumference by age
	egen caz = zanthro(arm_circum,aca,WHO), xvar(age) gender(gender_dum) gencode(male=2,female=1) ageunit(year) nocutoff


	

*Zscore in months
	
	*Stunting (Height for age)
	egen haz_mon = zanthro(height,ha,WHO), xvar(age_mon) gender(gender_dum) gencode(male=2,female=1) ageunit(month) nocutoff

	*Thinness (BMI for age)
	egen baz_mon = zanthro(bmi,ba,WHO), xvar(age_mon) gender(gender_dum) gencode(male=2,female=1) ageunit(month) nocutoff

	*Underweight (Weight for age)
	egen waz_mon = zanthro(weight,wa,WHO), xvar(age_mon) gender(gender_dum) gencode(male=2,female=1) ageunit(month) nocutoff

	*Armcircumference by age
	egen caz_mon = zanthro(arm_circum,aca,WHO), xvar(age_mon) gender(gender_dum) gencode(male=2,female=1) ageunit(month) nocutoff



*Replace the (year) z-scores with more accurate (month) z-scores - only for the inviduals where month age is available.
local zalist haz waz baz  caz
foreach x of local zalist {
	replace `x'=`x'_mon if `x'_mon!=.  
}

	
	***Invalid data***

	/*Note: From WHo website and DHS website: Children with 
	  height-for-age z-scores below -5 SD or above +5 SD, 
	  weight-for-age z-scores below -6 SD or above +5 SD, 
	  weight for height z-scores below -5 SD or above +5 SD 
	  are flagged as having invalid data.
	  Website reference : https://dhsprogram.com/data/Guide-to-DHS-Statistics/Nutritional_Status.htm	  
	*/

	
	*Count outliers:
	count if haz!=.
	count if (haz<-6|haz>6)&haz!=.
	count if (haz<-5|haz>5)&haz!=.

	*Drop outliers/invalid data:
	replace haz=. if haz<-5|haz>5
	
	
	replace baz=. if baz<-6|baz>6	
	replace waz=. if waz<-6|waz>6	
	replace whz=. if whz<-5|whz>5	
	replace caz=. if caz<-5|caz>5	


	
	
	
	
*******************************************
*** DUMMY VARIABLES --- CHILD NUTRITION ***
*******************************************
	
*Classification/Presence of malnutrition in data
	
*Dichotomous variables

	
	gen stunting=haz<-2
	replace stunting=. if haz==.

		gen stunting_moderate=haz<-2&haz>=-3
		replace stunting_moderate=. if haz==.
		
		gen stunting_severe=haz<-3
		replace stunting_severe=. if haz==.

		
	gen wasting=whz<-2
	replace wasting=. if whz==.

	
		gen wasting_moderate=whz<-2&whz>=-3
		replace wasting_moderate=. if whz==.
		
		gen wasting_severe=whz<-3
		replace wasting_severe=. if whz==.
	
	
	gen thinness=baz<-2
	replace thinness=. if baz==.

		gen thinness_moderate=baz<-2&baz>=-3
		replace thinness_moderate=. if baz==.
		
		gen thinness_severe=baz<-3
		replace thinness_severe=. if baz==.

		
	gen underweight=waz<-2
	replace underweight=. if waz==.

		gen underweight_moderate=waz<-2&waz>=-3
		replace underweight_moderate=. if waz==.
		
		gen underweight_severe=waz<-3
		replace underweight_severe=. if waz==.
		
		
	gen overweight=whz>2
	replace overweight=. if whz==.
	
		gen overweight_moderate=whz>2&whz<=3
		replace overweight_moderate=. if whz==.
		
		gen overweight_severe=whz>3
		replace overweight_severe=. if whz==.
	
	
	gen overweight_age=waz>2
	replace overweight_age=. if waz==.
		
	
	
	gen mamz=caz<-2
	replace mamz=. if caz==.
	
		gen mamz_moderate=caz<-2&caz>=-3
		replace mamz_moderate=. if caz==.

		gen mamz_sev=caz<-3
		replace mamz_sev=. if caz==.
		
	*winsor2 arm_circum if age<20, cuts(0 99.5) trim
	
	gen mam_dum=arm_circum<12.5 &age<=5
	replace mam_dum=. if arm_circum==. &age>5
	
	gen sam_dum=arm_circum<11.5 &age<=5
	replace sam_dum=. if arm_circum==. &age>5

	
	**In-built Stata function - zbmicat
	
	*Categorizes children and adolescents aged 2-18 years into three thinness grades -- normal weight, overweight, and obese -- by using international BMI  cutoffs
	egen bmi_cat = zbmicat(bmi), xvar(age) gender(gender_dum) gencode(male=2,female=1) ageunit(year) 
	

	
*******************************************
*** DUMMY VARIABLES --- ADULT NUTRITION ***
*******************************************	
	
	
*Underweight	
	gen underweight_adult= bmi<18.5
	replace underweight_adult=. if bmi==. 

		gen underweight_adult_mod= bmi<18.5&bmi>=17
		replace underweight_adult_mod=. if bmi==. 
		
		gen underweight_adult_sev= bmi<17
		replace underweight_adult_sev=. if bmi==. 
		
*Overweight	
	gen overweight_adult= bmi>=25
	replace overweight_adult=. if bmi==. 

		gen overweight_adult_mod= bmi>=25&bmi<30
		replace overweight_adult_mod=. if bmi==. 

		gen overweight_adult_sev= bmi>=30
		replace overweight_adult_sev=. if bmi==. 

	
  
	
