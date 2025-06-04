cd "/Users/jpmvbastos/Documents/GitHub/CorruptionWomen/"

use "CorruptionWomen_Final.dta", clear

*------------------------------------------------------------------------------*
* Overall Setup: Corrupt vs. Non-Corrupt Sectors
*------------------------------------------------------------------------------*
gen size_formal = 1 - size_informal
replace total_emp = total_emp_rais / (1 - size_informal) // size of all employees

gen total_female_emp = 0

foreach k in agriculture extractive manufacturing electric construction rw transportation accomodation finance profserv education health publicadmin dservices international {
	
	 qui gen count_`k' = `k' * total_emp // counts of (all employees) by sector
	 
	 qui gen share_female_`k' = `k'_female / `k'_count // female shares by industry
	 
	 qui gen female_count_`k' = share_female_`k' * count_`k' // female counts by industry
	 
	 qui replace total_female_emp =  total_female_emp + (female_count_`k')
}

* Shares and counts for all employes
gen share_corrupt = (extractive + manufacturing + construction + transportation)

gen corrupt_count = share_corrupt * total_emp

gen share_non_corrupt = (1 - share_corrupt)
			
gen non_corrupt_count = share_non_corrupt * total_emp
	
* Share of female in each sectors
gen share_female_corrupt = (female_count_extractive + female_count_manufacturing ///
	+ female_count_construction + female_count_transportation) / total_female_emp
						
gen share_female_non_corrupt = (total_female_emp - female_count_extractive - /// 
	female_count_manufacturing - female_count_construction - ///
	female_count_transportation) / total_female_emp

*------------------------------------------------------------------------------*
* Corrupt vs. Non-Corrupt Sectors: As a share of female labor force
*------------------------------------------------------------------------------*

gen pct_female_c = (extractive_female + manufacturing_female + ///
	construction_female + transportation_female) / (extractive_count + ///
	manufacturing_count + construction_count + transportation_count) 
	
gen pct_female_nc = ///
    (agriculture_female + electric_female + rw_female + accomodation_female + ///
     finance_female + profserv_female + education_female + health_female + ///
     publicadmin_female + dservices_female + international_female) / ///
    (agriculture_count + electric_count + rw_count + accomodation_count + ///
     finance_count + profserv_count + education_count + health_count + ///
     publicadmin_count + dservices_count + international_count)
	
gen pct_female_nc = (extractive_female + manufacturing_female + ///
	construction_female + transportation_female) / (extractive_count + ///
	manufacturing_count + construction_count + transportation_count) 
	
gen pct_femployer_c = (extractive_femployer + manufacturing_femployer + ///
	construction_femployer + transportation_femployer) / (extractive_female + ///
	manufacturing_female + construction_female + transportation_female)
	
gen pct_femployer_nc = ///
    (agriculture_femployer + electric_femployer + rw_femployer + ///
     accomodation_femployer + finance_femployer + profserv_femployer + ///
     education_femployer + health_femployer + publicadmin_femployer + ///
     dservices_femployer + international_femployer) / ///
    (agriculture_female + electric_female + rw_female + ///
     accomodation_female + finance_female + profserv_female + ///
     education_female + health_female + publicadmin_female + ///
     dservices_female + international_female)
	
gen pct_fmgmt_c = (extractive_fmanager + manufacturing_fmanager + ///
	construction_fmanager + transportation_fmanager) / (extractive_female + ///
	manufacturing_female + construction_female + transportation_female)
	
gen pct_fmgmt_nc = ///
    (agriculture_fmanager + electric_fmanager + rw_fmanager + ///
     accomodation_fmanager + finance_fmanager + profserv_fmanager + ///
     education_fmanager + health_fmanager + publicadmin_fmanager + ///
     dservices_fmanager + international_fmanager) / ///
    (agriculture_female + electric_female + rw_female + ///
     accomodation_female + finance_female + profserv_female + ///
     education_female + health_female + publicadmin_female + ///
     dservices_female + international_female)
	
gen pct_fleader_c = pct_femployer_c + pct_fmgmt_c

gen pct_fleader_nc = pct_femployer_nc + pct_fmgmt_nc

*------------------------------------------------------------------------------*
* Corrupt vs. Non-Corrupt Sectors: As a share of leader positions
*------------------------------------------------------------------------------*
	
* Female Employers in Corrupt
gen share_femployer_c = (extractive_femployer + manufacturing_femployer + ///
	construction_femployer + transportation_femployer) / (extractive_employer + ///
	manufacturing_employer + construction_employer + transportation_employer) 
	

* Female Employers in Non-Corrupt
gen share_femployer_nc = (total_female_employer - (extractive_femployer + manufacturing_femployer + ///
	construction_femployer + transportation_femployer)) / (total_employer - (extractive_employer + ///
	manufacturing_employer + construction_employer + transportation_employer)) 

* Female managers in Corrupt	
gen share_fmgmt_c = (extractive_fmanager + manufacturing_fmanager + ///
	construction_fmanager + transportation_fmanager) / (extractive_manager + ///
	manufacturing_manager + construction_manager + transportation_manager) 

* Female managers in non-Corrupt	
gen share_fmgmt_nc = (female_manager_priv_t - (extractive_fmanager + manufacturing_fmanager + ///
	construction_fmanager + transportation_fmanager)) / (manager_priv_t - (extractive_manager + ///
	manufacturing_manager + construction_manager + transportation_manager)) 	
	
* Female Leaders in corrupt: 
gen share_fleaders_c = (extractive_femployer + manufacturing_femployer + ///
	construction_femployer + transportation_femployer + extractive_fmanager + ///
	manufacturing_fmanager + construction_fmanager + transportation_fmanager) ///
	/ (extractive_employer + manufacturing_employer + construction_employer + ///
	transportation_employer + extractive_manager + manufacturing_manager + ///
	construction_manager + transportation_manager) 

* Female Leaders in non corrupt
gen share_fleaders_nc = (((female_manager_priv_t + total_female_employer)) ///
	- (extractive_femployer + manufacturing_femployer + ///
	construction_femployer + transportation_femployer + extractive_fmanager + ///
	manufacturing_fmanager + construction_fmanager + transportation_fmanager)) ///
	/ ((manager_priv_t + total_employer) - (extractive_employer + ///
	manufacturing_employer + construction_employer + ///
	transportation_employer + extractive_manager + manufacturing_manager + ///
	construction_manager + transportation_manager))
	

*------------------------------------------------------------------------------*
* Table D1: Summary Statistics for Corrupt vs. Non-Corrupt Sectors
*------------------------------------------------------------------------------*
	
* Corrupt	
sum share_femployer_c share_fmgmt_c share_fleaders_c if corruption3_full!=.

sum share_female_corrupt pct_femployer_c pct_fmgmt_c pct_fleader_c ///
	if corruption3_full!=.
* In the paper, share_female_corrupt is currenty as pct_female_c

* Non-Corrupt
sum share_femployer_nc share_fmgmt_nc share_fleaders_nc if corruption3_full!=.

sum share_female_non_corrupt pct_femployer_nc pct_fmgmt_nc pct_fleader_nc ///
	if corruption3_full!=.

*------------------------------------------------------------------------------*
* Table D2 and D3: Setup
*------------------------------------------------------------------------------*

cd "/Users/jpmvbastos/Documents/GitHub/CorruptionWomen/"

***** ESTIMATES
global corrupt = "extractive manufacturing construction transportation c"

global share_outcomes = "femployer fmgmt fleaders"

global pct_outcomes = "female femployer fmgmt fleader"

global controls = "log_gdppc log_density size_informal college workage male urban"

global sectors = "agriculture extractive manufacturing electric construction rw transportation accomodation finance profserv education health publicadmin dservices"

global fixedef = "_Isorteio_f_23 _Isorteio_f_24 _Isorteio_f_25 _Isorteio_f_26 _Isorteio_f_27 _Isorteio_f_28 _Isorteio_f_29 _Isorteio_f_30 _Isorteio_f_31 _Isorteio_f_32 _Isorteio_f_33 _Isorteio_f_34 _Isorteio_f_35 _Isorteio_f_36 _Isorteio_f_37 _Isorteio_f_38 _Iuf_code_2 _Iuf_code_3 _Iuf_code_4 _Iuf_code_5 _Iuf_code_6 _Iuf_code_7 _Iuf_code_8 _Iuf_code_9 _Iuf_code_10 _Iuf_code_11 _Iuf_code_12 _Iuf_code_13 _Iuf_code_14 _Iuf_code_15 _Iuf_code_16 _Iuf_code_17 _Iuf_code_18 _Iuf_code_19 _Iuf_code_20 _Iuf_code_21 _Iuf_code_22 _Iuf_code_23 _Iuf_code_24 _Iuf_code_25 _Iuf_code_26 _Iuf_code_27"

*------------------------------------------------------------------------------*
* Table D2: Corrupt vs. Non-Corrupt Sector (replicating table 3)
*------------------------------------------------------------------------------*


* PANEL A: OLS with Baseline Controls - Corrupt
	
	eststo clear
	
	foreach k in $share_outcomes {
		
		eststo: reg share_`k'_c corruption3_full $controls $fixedef, cluster(uf_code)	
		
	}
	
	esttab using "Results/Appendix D/TableD2_A.tex", replace b(%9.3f) ///
	keep(corruption3_full $controls) star(* 0.10 ** 0.05 *** 0.01) se ar2


* PANEL B: OLS with Baseline Controls - Non-Corrupt
	eststo clear
	
	foreach k in $share_outcomes {
		
		eststo: reg share_`k'_nc corruption3_full $controls $fixedef, cluster(uf_code)	
		
	}
	
	esttab using "Results/Appendix D/TableD2_B.tex", replace b(%9.3f) ///
	keep(corruption3_full $controls) star(* 0.10 ** 0.05 *** 0.01) se ar2
	

* PANEL C: SLS with Baseline Controls - Corrupt
	eststo clear 

	foreach k in $share_outcomes {
		
		* Run the 2SLS regression and store the results
		eststo: ivreg2 share_`k'_c $controls $sectors $fixedef ///
		(corruption3_full = councils councils_installed management judge), ///
		first cluster(uf_code) partial(_cons $fixedef)
		
		* Add statistics for the current model
		estadd scalar F_Statistic = e(widstat)   // Weak identification test
		estadd scalar J_Statistic = e(j)         // Over-identification test
		estadd scalar J_Statistic_pvalue = e(jp) // J-statistic p-value
	}

	* Export the results for all models in a single table
	esttab using "Results/Appendix D/TableD2_C.tex", replace b(%9.3f) ///
	keep(corruption3_full $controls) star(* 0.10 ** 0.05 *** 0.01) ///
	stats(N F_Statistic J_Statistic J_Statistic_pvalue) se 
	
* PANEL D: SLS with Baseline Controls - Non-Corrupt
	
	eststo clear
	
	foreach k in $share_outcomes {
		
		* Run the 2SLS regression and store the results
		eststo: ivreg2 share_`k'_nc $controls $sectors _I* ///
		(corruption3_full = councils councils_installed management judge), ///
		first cluster(uf_code) partial(_cons $fixedef)
		
		* Add statistics for the current model
		estadd scalar F_Statistic = e(widstat)   // Weak identification test
		estadd scalar J_Statistic = e(j)         // Over-identification test
		estadd scalar J_Statistic_pvalue = e(jp) // J-statistic p-value
	}

	* Export the results for all models in a single table
	esttab using "Results/Appendix D/TableD2_D.tex", replace b(%9.3f) ///
	keep(corruption3_full $controls) star(* 0.10 ** 0.05 *** 0.01) ///
	stats(N F_Statistic J_Statistic J_Statistic_pvalue) se 
	
*------------------------------------------------------------------------------*
* Table D3: Corrupt vs. Non-Corrupt Sector (replicating table 4)
*------------------------------------------------------------------------------*
	
	
* PANEL A: OLS with Baseline Controls - Corrupt
	
	eststo clear
	
	foreach k in $pct_outcomes {
		
		eststo: reg pct_`k'_c corruption3_full $controls $fixedef, cluster(uf_code)	
		
	}
	
	esttab using "Results/Appendix D/TableD3_A.tex", replace b(%9.3f) ///
	keep(corruption3_full $controls) star(* 0.10 ** 0.05 *** 0.01) se ar2


* PANEL B: OLS with Baseline Controls - Non-Corrupt
	eststo clear
	
	foreach k in $pct_outcomes {
		
		eststo: reg pct_`k'_nc corruption3_full $controls $fixedef, cluster(uf_code)	
		
	}
	
	esttab using "Results/Appendix D/TableD3_B.tex", replace b(%9.3f) ///
	keep(corruption3_full $controls) star(* 0.10 ** 0.05 *** 0.01) se ar2
	

* PANEL C: SLS with Baseline Controls - Corrupt
	eststo clear 

	foreach k in $pct_outcomes {
		
		* Run the 2SLS regression and store the results
		eststo: ivreg2 pct_`k'_c $controls $sectors _I* ///
		(corruption3_full = councils councils_installed management judge), ///
		first cluster(uf_code) partial(_cons $fixedef)
		
		* Add statistics for the current model
		estadd scalar F_Statistic = e(widstat)   // Weak identification test
		estadd scalar J_Statistic = e(j)         // Over-identification test
		estadd scalar J_Statistic_pvalue = e(jp) // J-statistic p-value
	}

	* Export the results for all models in a single table
	esttab using "Results/Appendix D/TableD3_C.tex", replace b(%9.3f) ///
	keep(corruption3_full $controls) star(* 0.10 ** 0.05 *** 0.01) ///
	stats(N F_Statistic J_Statistic J_Statistic_pvalue) se 
	
* PANEL D: SLS with Baseline Controls - Non-Corrupt
	
	eststo clear
	
	foreach k in $pct_outcomes {
		
		* Run the 2SLS regression and store the results
		eststo: ivreg2 pct_`k'_nc $controls $sectors _I* ///
		(corruption3_full = councils councils_installed management judge), ///
		first cluster(uf_code) partial(_cons $fixedef)
		
		* Add statistics for the current model
		estadd scalar F_Statistic = e(widstat)   // Weak identification test
		estadd scalar J_Statistic = e(j)         // Over-identification test
		estadd scalar J_Statistic_pvalue = e(jp) // J-statistic p-value
	}

	* Export the results for all models in a single table
	esttab using "Results/Appendix D/TableD3_D.tex", replace b(%9.3f) ///
	keep(corruption3_full $controls) star(* 0.10 ** 0.05 *** 0.01) ///
	stats(N F_Statistic J_Statistic J_Statistic_pvalue) se 
































