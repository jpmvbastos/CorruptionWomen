*------------------------------------------------------------------------------*
* Table E1: Load Data and Setup
*------------------------------------------------------------------------------*

cd "/Users/jpmvbastos/Documents/GitHub/CorruptionWomen/"

use "CorruptionWomen_Final.dta", clear


global share_outcomes = "share_female_employer share_female_manager_priv share_female_leaders"

global share_outcomes_corrupt = "femployer fmgmt fleaders"

global pct_outcomes = "female_lfp_census pct_female_employer pct_female_managers pct_female_leaders"

global pct_outcomes_corrupt = "female femployer fmgmt fleader"

global controls = "log_gdppc log_density size_informal college workage male urban"

global sectors = "agriculture extractive manufacturing electric construction rw transportation accomodation finance profserv education health publicadmin dservices"

global fixedef = "_Isorteio_f_23 _Isorteio_f_24 _Isorteio_f_25 _Isorteio_f_26 _Isorteio_f_27 _Isorteio_f_28 _Isorteio_f_29 _Isorteio_f_30 _Isorteio_f_31 _Isorteio_f_32 _Isorteio_f_33 _Isorteio_f_34 _Isorteio_f_35 _Isorteio_f_36 _Isorteio_f_37 _Isorteio_f_38 _Iuf_code_2 _Iuf_code_3 _Iuf_code_4 _Iuf_code_5 _Iuf_code_6 _Iuf_code_7 _Iuf_code_8 _Iuf_code_9 _Iuf_code_10 _Iuf_code_11 _Iuf_code_12 _Iuf_code_13 _Iuf_code_14 _Iuf_code_15 _Iuf_code_16 _Iuf_code_17 _Iuf_code_18 _Iuf_code_19 _Iuf_code_20 _Iuf_code_21 _Iuf_code_22 _Iuf_code_23 _Iuf_code_24 _Iuf_code_25 _Iuf_code_26 _Iuf_code_27"


*------------------------------------------------------------------------------*
* Table 3, Panel C: 2SLS Results with Baseline Controls (Full Sample) 
*------------------------------------------------------------------------------*

eststo clear 

foreach k in $share_outcomes {
    
    * Run the 2SLS regression and store the results
    eststo: ivreg2 `k' $controls  _I* ///
	(corruption3_full = councils councils_installed management judge), ///
	first cluster(uf_code) partial(_cons $fixedef)
    
}

*------------------------------------------------------------------------------*
* Table 3, Panel D: 2SLS Results with Baseline Controls (Corrupt Sectors)
*------------------------------------------------------------------------------*

eststo clear 

foreach k in $share_outcomes_corrupt {
		
		* Run the 2SLS regression and store the results
		eststo: ivreg2 share_`k'_c $controls $fixedef ///
		(corruption3_full = councils councils_installed management judge), ///
		first cluster(uf_code) partial(_cons $fixedef)
	
	}
	
*------------------------------------------------------------------------------*
* Table 4, Panel C: 2SLS Results with Baseline Controls (Full Sample)
*------------------------------------------------------------------------------*

eststo clear 

foreach k in $pct_outcomes {
    
    * Run the 2SLS regression and store the results
    eststo: ivreg2 `k' $controls $fixedef ///
	(corruption3_full = councils councils_installed management judge), ///
	first cluster(uf_code) partial(_cons $fixedef)
    
}
	
*------------------------------------------------------------------------------*
* Table 4, Panel D: 2SLS Results with Baseline Controls (Corrupt Sectors)
*------------------------------------------------------------------------------*
eststo clear
	
foreach k in $pct_outcomes_corrupt {
		
	* Run the 2SLS regression and store the results
    eststo: ivreg2 pct_`k'_c $controls $fixedef ///
	(corruption3_full = councils councils_installed management judge), ///
	first cluster(uf_code) partial(_cons $fixedef)
		
	}
	
*==============================================================================*
*==============================================================================*
* Just-Identified IV's 
*==============================================================================*

*------------------------------------------------------------------------------*
* Replicating Table 3 - Panel C
*------------------------------------------------------------------------------*

global share_outcomes = "share_female_employer share_female_manager_priv share_female_leaders"

foreach v in councils councils_installed management judge {

	eststo clear 

	foreach k in $share_outcomes {
		
		* Run the 2SLS regression and store the results
		qui eststo: ivreg2 `k' $controls  _I* ///
		(corruption3_full = `v'), ///
		first cluster(uf_code) partial(_cons $fixedef)
	
		* Add statistics for the current model
		estadd scalar F_Statistic = e(widstat)   // Weak identification test
	}

	* Export the results for all models in a single table
	esttab using "Results/TableE5_`v'.tex", replace b(%9.3f) keep(corruption3_full $controls) ///
	star(* 0.10 ** 0.05 *** 0.01) stats(N F_Statistic J_Statistic J_Statistic_pvalue) se 

		
	}

*------------------------------------------------------------------------------*
* Replicating Table 4 - Panel C
*------------------------------------------------------------------------------*

global pct_outcomes = "female_lfp_census pct_female_employer pct_female_managers pct_female_leaders"

foreach v in councils councils_installed management judge {

	eststo clear 

	foreach k in $pct_outcomes {
		
		* Run the 2SLS regression and store the results
		qui eststo: ivreg2 `k' $controls  _I* ///
		(corruption3_full = `v'), ///
		first cluster(uf_code) partial(_cons $fixedef)
	
		* Add statistics for the current model
		estadd scalar F_Statistic = e(widstat)   // Weak identification test

	}

	* Export the results for all models in a single table
	esttab using "Results/TableE6_`v'.tex", replace b(%9.3f) keep(corruption3_full $controls) ///
	star(* 0.10 ** 0.05 *** 0.01) stats(N F_Statistic J_Statistic J_Statistic_pvalue) se 

		
	}

