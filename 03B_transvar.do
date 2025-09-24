

*This do-file transforms and cleans variables for estimations*



***Replace PDS transfer in 100 rupees ****
replace grain_subs=	grain_subs/100
replace grain_subs_tg=	grain_subs_tg/100

replace lagyr_grain_subs=	lagyr_grain_subs/100
replace lagyr_grain_subs_tg=	lagyr_grain_subs_tg/100	


*Drop individuals not residing in the HH thoroughout the panel
bys indv_id1: egen resid_hh_mean=mean(resid_hh)
replace resid_hh_mean=round(resid_hh_mean)
drop if resid_hh_mean==0


*Winsorize top and bottom 2.5%
winsor2 haz whz baz waz caz , cuts(2.5 97.5) suffix(_w97) 
winsor2 height weight arm_circum bmi, cuts(2.5 97.5) suffix(_w97) 


*Region variable
	gen region="EI"
	replace region="SAT" if st==1|st==3|st==5|st==6|st==7
	tab st region
	encode region, gen(reg_dum)

	
*Construct FE controls*		

gen hh_size_cat=1 if hh_size_m<=4
replace hh_size_cat=2 if hh_size_m>=5&hh_size_m<=9
replace hh_size_cat=3 if hh_size_m>=10&hh_size_m<30

encode card, gen(card_dum)
