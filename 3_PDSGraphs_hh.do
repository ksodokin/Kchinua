


/*This do-file :

  Master-file for all GRAPHS : 

 */


cap log close
log using "$log_dir/3_PDSGraphs_hh_$date_string", replace 

/////////////////////////////////////////////////////////////////
**Bring in the HOUSEHOLD-level monthly VDSA data on consumption**
/////////////////////////////////////////////////////////////////



use "$analysis_data_dir/hh_mon_agg",replace

cd "$analysis_code_dir/Graphs_hh"


gen state_dum=state

***************
*** FIGURES ***
***************

graph set window fontface "Times New Roman"	

*State-level variation in PDS prices (Entitlement and Instrument)
do A1_hh_graph_price


*State-level variation in PDS quantity (Entitlement and Instrument)
do A2_hh_graph_qty


*Within-state variation in PDS quantity  by Household-size (Entitlement and Instrument)
do A3_hh_graph_qtyhhsize


*All Variation graph (Entitlement and Instrument)
do A4_hh_graph_variation


*Change directory back to source		
cd "$analysis_code_dir"	





