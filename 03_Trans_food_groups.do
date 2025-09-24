



/*This do-file cleans Food Consumption Files 
	and creates 11 Food Groups */


*Note: Food Groups: cereals, pulses, milk and milk products, meat, eggs, etc 




**********************************				   
******  CREATE FOOD GROUPS  ******			   
**********************************	

	
	*Clean Food Item_type - Aggregate them into 11 Main Food types

	*Pulses
		replace item_type="pulses" if item_name=="groundnut" 				

	**ADDING THIS LINE OF CODE TO DISTINGUISH BETWEEN LIQUID MILK AND MILK PRODUCTS
		
	*Milk and milk products
		replace item_type="milkandproducts" if strmatch(item_type,"milk*")
					
	*Milk only 
		replace item_type="milk_liq" if item_name=="milk:liquid"|item_name=="milk"|item_name=="milk/curd"			
		
	*Meat: Chicken, pork, beef, fish
		replace item_type="meat" if strmatch(item_name,"meat*")|item_type=="seafood"|item_name=="chicken"|item_name=="fish"|strmatch(item_type,"*meat*")

	*Eggs
		replace item_type="eggs" if strmatch(item_name,"egg*")

	*Fruits
		*Note: Fruits and Veg are mixed up in EI data*
		gen ft_dum=0
		local fruitlist apple	banana	blackberry	dates	drydates	grapes	guava	litchi	mango	mousambi	pomogranate pomegranate	watermelon
		foreach f of local fruitlist {
		replace ft_dum=1 if item_name=="`f'"
		}

		replace item_type="fruits" if ft_dum==1|strmatch(item_type,"*fruits")|strmatch(item_name,"*ruit*")|strmatch(item_name,"orange*")|strmatch(item_name,"plantain*")|strmatch(item_name,"raisin*")
		drop ft_dum

	*Vegetables
		replace item_type="vegetables" if strmatch(item_name,"*vegetables")|strmatch(item_type,"*vegetable*")|item_name=="chillies"

	*Sugar
		replace item_type="sugar" if strmatch(item_name,"*sugar*")|strmatch(item_name,"jaggery")

	*Mealsoutside
		replace item_type="meal_out" if strmatch(item_name,"soc*")|strmatch(item_name,"meal*")

		
	*Otherfooditems and spices
		replace item_type="otherfooditems" if strmatch(item_type,"*beverage*")|strmatch(item_name,"tea*")|strmatch(item_name,"biscuits*")|strmatch(item_name,"cookedmeals*")|strmatch(item_name,"preparedsweets*")|strmatch(item_name,"gur")
		replace item_type="otherfooditems" if strmatch(item_name,"*spice*")|strmatch(item_name,"salt*")|strmatch(item_type,"*spice*")|strmatch(item_name,"turm*")|strmatch(item_name,"coriender*")

	*Otherfoods - Government Subsidies
		replace item_type="otherfooditems_subs" if strmatch(item_name,"angan*")|strmatch(item_name,"icds*")|strmatch(item_name,"middaymeal*")|strmatch(item_name,"pdssugar")

		/*Note: 
		otherfooditems include : Beverages, others(bread,sagu,khara,buscuits,etc.)
		otherfood_subs include : Government subsidies like Middaymeal, Anganwadi, ICDS schemes are included under otherfooditems category
		So group them under "otherfood_misc"
		*/


					   

**********************************				   
******  DATA CLEANING  ******			   
**********************************	
			   
*Clean Data and errors: 
	*1)Extra zero for wheat price
		replace price_unit=price_unit/10 if vds_id=="IMP10A0031"&sur_mon_yr=="10/10"&item_name=="wheat"
		replace tot_val=tot_val/10 if vds_id=="IMP10A0031"&sur_mon_yr=="10/10"&item_name=="wheat"

	*2)Change the Price unit value for egg for vds_id=="IKN11B0057"
		replace price_unit=3 if item_type=="eggs"&item_unit=="Rs"
		replace tot_val=60 if item_type=="eggs"&item_unit=="Rs"
		replace item_unit="No" if item_type=="eggs"&item_unit=="Rs"

	*3) Create pds itemnames if mentioned under remarks 
		replace item_name="pds"+item_name if strmatch(remarks,"*PDS*")

	*4) Clean pds item_names 
		replace item_name="pdsrice" if item_name=="pdspdsrice"
		replace item_name="pdswheat" if item_name=="pdspdswheat"
		replace item_name="pdspigeonpea" if strmatch(item_name,"pdspigeon*")
		replace item_name="pdssugar" if strmatch(item_name,"pds*sugar*")
		replace item_name="pdsoil" if strmatch(item_name,"pds*oil*")
		replace item_name="pdssalt" if strmatch(item_name,"pdsspices*") 


		*replace item_name="Tea/Coffee" if strmatch(item_name,"Tea*")
		drop remarks


	*4) Drop errors (Only 18 observations for a single HH in Bihar)
		drop if (item_type=="cereals"|item_type=="pulses")&item_unit!="Kg"

