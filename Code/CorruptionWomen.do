cd "/Users/jpmvbastos/Documents/GitHub/CorruptionWomen/"

* use "CorruptionWomen.dta", clear 

use "CorruptionWomen_census_master.dta", clear 

rename cityofjob ibge_code
rename total_infomal total_informal

tostring(ibge_code), replace

replace ibge_code = substr(ibge_code, 1, 6) 

destring ibge_code, replace

merge 1:1 ibge_code using "/Users/jpmvbastos/Documents/GitHub/CorruptionRentSeeking/Data/Full_Data_August2023.dta"

drop _merge

gen munic_code = ibge_code

merge 1:1 ibge_code using "/Users/jpmvbastos/Documents/GitHub/CorruptionWomen/juizados.dta"

destring jecivel jec_n jecriminal jecriminal_n delegaciamulher delegaciamulher_n, replace force

gen judge = (jecivel==1 | jecriminal==1)

drop _merge

merge 1:1 munic_code using "/Users/jpmvbastos/Documents/GitHub/CorruptionEntrepreneurs/Data/municipality_level.dta"

cap drop _merge

merge 1:1 cod_munic using "/Users/jpmvbastos/Documents/GitHub/CorruptionWomen/audits.dta"

tab capital

drop _merge

replace total_female = (1-male) * population 

gen log_gdppc = log(gdp_pc)

gen log_density = log(density)

gen log_population = log(population)

***** OUTCOME VARIABLES 

***** AS A % OF FEMALE LABOR FORCE

* % of Females that are self-employed
gen pct_female_self = total_female_self / total_female_employed

* % of Females that are employers
gen pct_female_employer = total_female_employer / total_female_employed

* % of Females that are managers in private sector
gen pct_female_managers_priv = female_manager_priv_t / total_female_employed

* % of Females in leadership positions
gen pct_female_leaders = (female_manager_priv_t + total_female_employer) / total_female_employed

* % of Female that in informal jobs
gen pct_female_informal = total_female_informal / total_female_employed


***** SHARE OF THAT CATEGORY THAT IS FEMALE

* Share of Labor force that is female
gen share_female_lf = total_female_employed / total_employees

* % of Self-Employed that are female
gen share_female_self = total_female_self / total_selfemployed

* % of Employers that are female
gen share_female_employer = total_female_employer / total_employer

* % of Total Managers that are female
gen share_female_manager_priv = female_manager_priv_t / manager_priv_t

* % of leadership positions that are female
gen share_female_leaders = (female_manager_priv_t + total_female_employer) / (manager_priv_t + total_employer)

* % of informal workers that are female 
gen share_female_informal = total_female_informal / total_informal

xi i.uf_code i.sorteio_full

***** CORRUPT SECTORS ONLY

foreach v in extractive manufacturing construction transportation {
	
***** AS A % OF FEMALE LABOR FORCE

* % of Females that are employers
gen pct_femployer_`v' = `v'_femployer / `v'_female 

* % of Females that are managers in private sector
gen pct_fmgmt_`v' = `v'_fmanager / `v'_female 

* % of Females in leadership positions
gen pct_fleaders_`v' = (`v'_fmanager + `v'_femployer) / `v'_female 


***** SHARE OF THAT CATEGORY THAT IS FEMALE

* Share of that Sector 
*gen share_female_`v' = `v'_female / `v'_count

* % of Employers that are female
gen share_femployer_`v' = `v'_femployer / `v'_employer

* % of Total Managers that are female
gen share_fmgmt_`v' = `v'_fmanager / `v'_manager

* % of leadership positions that are female
gen share_fleaders_`v' = (`v'_fmanager + `v'_femployer) / (`v'_manager + `v'_employer)
}


* Group the corrupt sectors together 
gen pct_femployer_c = pct_femployer_extractive + pct_femployer_manufacturing +	  ///
	pct_femployer_construction + pct_femployer_transportation
	
gen pct_fmgmt_c = pct_fmgmt_extractive + pct_fmgmt_manufacturing + ///
	pct_fmgmt_construction + pct_fmgmt_transportation
	
gen pct_fleader_c = pct_fleaders_extractive + pct_fleaders_manufacturing + ///
	pct_fleaders_construction + pct_fleaders_transportation
	
gen pct_female_c = (extractive_female + manufacturing_female + ///
	construction_female + transportation_female) / (extractive_count + ///
	manufacturing_count + construction_count + transportation_count) 
	
*******
	
gen share_femployer_c = (extractive_femployer + manufacturing_femployer + ///
	construction_femployer + transportation_femployer) / (extractive_employer + ///
	manufacturing_employer + construction_employer + transportation_employer) 
	
gen share_fmgmt_c = (extractive_fmanager + manufacturing_fmanager + ///
	construction_fmanager + transportation_fmanager) / (extractive_manager + ///
	manufacturing_manager + construction_manager + transportation_manager) 
	
gen share_fleaders_c = (extractive_femployer + manufacturing_femployer + ///
	construction_femployer + transportation_femployer + extractive_fmanager + ///
	manufacturing_fmanager + construction_fmanager + transportation_fmanager) ///
	/ (extractive_employer + manufacturing_employer + construction_employer + ///
	transportation_employer + extractive_manager + manufacturing_manager + ///
	construction_manager + transportation_manager) 


save "CorruptionWomen_Final.dta", replace 

cd "/Users/jpmvbastos/Documents/GitHub/CorruptionWomen/"

use "CorruptionWomen_Final.dta", clear

**** SUMMARY STATS

sum share_female_employer share_female_manager_priv share_female_leaders share_female_self if corruption3_full!=.

sum female_lfp pct_female_employer pct_female_managers pct_female_leaders pct_female_self if corruption3_full!=.

sum gdp_pc density size_informal college male workage urban if corruption3_full!=.

sum agriculture extractive manufacturing electric construction rw transportation accomodation finance profserv education health publicadmin dservices if corruption3_full!=.

***** ESTIMATES 

global share_outcomes = "share_female_employer share_female_manager_priv share_female_leaders"

global pct_outcomes = "female_lfp_census pct_female_employer pct_female_managers pct_female_leaders"

global controls = "log_gdppc log_density size_informal college workage male urban"

global sectors = "agriculture extractive manufacturing electric construction rw transportation accomodation finance profserv education health publicadmin dservices"

global fixedef = "_Isorteio_f_23 _Isorteio_f_24 _Isorteio_f_25 _Isorteio_f_26 _Isorteio_f_27 _Isorteio_f_28 _Isorteio_f_29 _Isorteio_f_30 _Isorteio_f_31 _Isorteio_f_32 _Isorteio_f_33 _Isorteio_f_34 _Isorteio_f_35 _Isorteio_f_36 _Isorteio_f_37 _Isorteio_f_38 _Iuf_code_2 _Iuf_code_3 _Iuf_code_4 _Iuf_code_5 _Iuf_code_6 _Iuf_code_7 _Iuf_code_8 _Iuf_code_9 _Iuf_code_10 _Iuf_code_11 _Iuf_code_12 _Iuf_code_13 _Iuf_code_14 _Iuf_code_15 _Iuf_code_16 _Iuf_code_17 _Iuf_code_18 _Iuf_code_19 _Iuf_code_20 _Iuf_code_21 _Iuf_code_22 _Iuf_code_23 _Iuf_code_24 _Iuf_code_25 _Iuf_code_26 _Iuf_code_27"


***************** TABLE 2 - SHARES OF LEADERSHIP THAT IS FEMALE ****************

cd "/Users/jpmvbastos/Documents/GitHub/CorruptionWomen/"

* PANEL A: OLS with Baseline Controls

eststo clear 

foreach k in  $share_outcomes {
	
	eststo: reg `k' corruption3_full $controls $fixedef, cluster(uf_code)
	
}

esttab using "Results/Table2A.tex", replace b(%9.3f) keep(corruption3_full $controls) star(* 0.10 ** 0.05 *** 0.01) se ar2
esttab using "Results/Table2A.csv", replace b(%9.3f) keep(corruption3_full $controls) star(* 0.10 ** 0.05 *** 0.01) se ar2

* PANEL B: OLS with Baseline Controls plus Industry Shares

eststo clear 

foreach k in  $share_outcomes {
	
	eststo: reg `k' corruption3_full $controls $sectors $fixedef, cluster(uf_code)
	
}

esttab using "Results/Table2B.tex", replace b(%9.3f) keep(corruption3_full $controls $sectors) star(* 0.10 ** 0.05 *** 0.01) se ar2
esttab using "Results/Table2B.csv", replace b(%9.3f) keep(corruption3_full $controls $sectors) star(* 0.10 ** 0.05 *** 0.01) se ar2


* PANEL C: 2SLS Results with Baseline Controls 
eststo clear 

foreach k in $share_outcomes {
    
    * Run the 2SLS regression and store the results
    eststo: ivreg2 `k' $controls  _I* ///
	(corruption3_full = councils councils_installed management judge), ///
	first cluster(uf_code) partial(_cons $fixedef)
    
    * Add statistics for the current model
    estadd scalar F_Statistic = e(widstat)   // Weak identification test
    estadd scalar J_Statistic = e(j)         // Over-identification test
    estadd scalar J_Statistic_pvalue = e(jp) // J-statistic p-value
}

* Export the results for all models in a single table
esttab using "Results/Table2C.tex", replace b(%9.3f) keep(corruption3_full $controls) ///
star(* 0.10 ** 0.05 *** 0.01) stats(N F_Statistic J_Statistic J_Statistic_pvalue) se 

* PANEL D: 2SLS Results with Baseline Controls and Industry Shares
eststo clear 

foreach k in $share_outcomes {
    
    * Run the 2SLS regression and store the results
    eststo: ivreg2 `k' $controls $sectors _I* (corruption3_full = councils councils_installed management), first cluster(uf_code) partial(_cons $fixedef)
    
    * Add statistics for the current model
    estadd scalar F_Statistic = e(widstat)   // Weak identification test
    estadd scalar J_Statistic = e(j)         // Over-identification test
    estadd scalar J_Statistic_pvalue = e(jp) // J-statistic p-value
}

* Export the results for all models in a single table
esttab using "Results/Table2D.tex", replace b(%9.3f) keep(corruption3_full $controls) ///
star(* 0.10 ** 0.05 *** 0.01) stats(N F_Statistic J_Statistic J_Statistic_pvalue) se 




******************** TABLE 3 - PERCENT OF FEMALE LABOR FORCE *******************

cd "/Users/jpmvbastos/Documents/GitHub/CorruptionWomen/"

* PANEL A: OLS with Baseline Controls

eststo clear 

foreach k in  $pct_outcomes {
	
	eststo: reg `k' corruption3_full $controls $fixedef, cluster(uf_code)
	
}

esttab using "Results/Table3A.tex", replace b(%9.3f) keep(corruption3_full $controls) star(* 0.10 ** 0.05 *** 0.01) se ar2
esttab using "Results/Table3A.csv", replace b(%9.3f) keep(corruption3_full $controls) star(* 0.10 ** 0.05 *** 0.01) se ar2

* PANEL B: OLS with Baseline Controls plus Industry Shares

eststo clear 

foreach k in  $pct_outcomes {
	
	eststo: reg `k' corruption3_full $controls $sectors $fixedef, cluster(uf_code)
	
}

esttab using "Results/Table3B.tex", replace b(%9.3f) keep(corruption3_full $controls $sectors) star(* 0.10 ** 0.05 *** 0.01) se ar2
esttab using "Results/Table3B.csv", replace b(%9.3f) keep(corruption3_full $controls $sectors) star(* 0.10 ** 0.05 *** 0.01) se ar2


* PANEL C: 2SLS Results with Baseline Controls 

eststo clear 

foreach k in $pct_outcomes {
    
    * Run the 2SLS regression and store the results
    eststo: ivreg2 `k' $controls _I* ///
	(corruption3_full = councils councils_installed management judge), ///
	first cluster(uf_code) partial(_cons $fixedef)
    
    * Add statistics for the current model
    estadd scalar F_Statistic = e(widstat)   // Weak identification test
    estadd scalar J_Statistic = e(j)         // Over-identification test
    estadd scalar J_Statistic_pvalue = e(jp) // J-statistic p-value
}


* Export the results for all models in a single table
esttab using "Results/Table3C.tex", replace b(%9.3f) keep(corruption3_full $controls) ///
star(* 0.10 ** 0.05 *** 0.01) stats(N F_Statistic J_Statistic J_Statistic_pvalue) se

* PANEL D: 2SLS Results with Baseline Controls plus Industry Shares

eststo clear 

foreach k in $pct_outcomes {
    
    * Run the 2SLS regression and store the results
    eststo: ivreg2 `k' $controls $sectors _I* (corruption3_full = councils councils_installed management), first cluster(uf_code) partial(_cons $fixedef)
    
    * Add statistics for the current model
    estadd scalar F_Statistic = e(widstat)   // Weak identification test
    estadd scalar J_Statistic = e(j)         // Over-identification test
    estadd scalar J_Statistic_pvalue = e(jp) // J-statistic p-value
}

* Export the results for all models in a single table
esttab using "Results/Table3D.tex", replace b(%9.3f) keep(corruption3_full $controls) ///
star(* 0.10 ** 0.05 *** 0.01) stats(N F_Statistic J_Statistic J_Statistic_pvalue) se 


