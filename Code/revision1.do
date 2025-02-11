use "CorruptionWomen_Final.dta", clear

***** ESTIMATES 

global share_outcomes = "share_female_employer share_female_manager_priv share_female_leaders"

global pct_outcomes = "female_lfp_census pct_female_employer pct_female_managers pct_female_leaders"

global controls = "log_gdppc log_density size_informal college workage male urban"

global sectors = "agriculture extractive manufacturing electric construction rw transportation accomodation finance profserv education health publicadmin dservices"

global fixedef = "_Isorteio_f_23 _Isorteio_f_24 _Isorteio_f_25 _Isorteio_f_26 _Isorteio_f_27 _Isorteio_f_28 _Isorteio_f_29 _Isorteio_f_30 _Isorteio_f_31 _Isorteio_f_32 _Isorteio_f_33 _Isorteio_f_34 _Isorteio_f_35 _Isorteio_f_36 _Isorteio_f_37 _Isorteio_f_38 _Iuf_code_2 _Iuf_code_3 _Iuf_code_4 _Iuf_code_5 _Iuf_code_6 _Iuf_code_7 _Iuf_code_8 _Iuf_code_9 _Iuf_code_10 _Iuf_code_11 _Iuf_code_12 _Iuf_code_13 _Iuf_code_14 _Iuf_code_15 _Iuf_code_16 _Iuf_code_17 _Iuf_code_18 _Iuf_code_19 _Iuf_code_20 _Iuf_code_21 _Iuf_code_22 _Iuf_code_23 _Iuf_code_24 _Iuf_code_25 _Iuf_code_26 _Iuf_code_27"


* PANEL C: 2SLS Results with Baseline Controls 
eststo clear 

foreach k in $share_outcomes {
    
    * Run the 2SLS regression and store the results
    eststo: ivreg2 `k' $controls  _I* (corruption3_full = councils councils_installed management judge), first cluster(uf_code) partial(_cons $fixedef)
    
    * Add statistics for the current model
    estadd scalar F_Statistic = e(widstat)   // Weak identification test
    estadd scalar J_Statistic = e(j)         // Over-identification test
    estadd scalar J_Statistic_pvalue = e(jp) // J-statistic p-value
}

* Export the results for all models in a single table
esttab using "Results/revision1/Table2C.tex", replace b(%9.3f) keep(corruption3_full $controls) ///
star(* 0.10 ** 0.05 *** 0.01) stats(N F_Statistic J_Statistic J_Statistic_pvalue) se 

* PANEL D: 2SLS Results with Baseline Controls and Industry Shares
eststo clear 

foreach k in $share_outcomes {
    
    * Run the 2SLS regression and store the results
    eststo: ivreg2 `k' $controls $sectors _I* (corruption3_full = councils councils_installed management judge), first cluster(uf_code) partial(_cons $fixedef)
    
    * Add statistics for the current model
    estadd scalar F_Statistic = e(widstat)   // Weak identification test
    estadd scalar J_Statistic = e(j)         // Over-identification test
    estadd scalar J_Statistic_pvalue = e(jp) // J-statistic p-value
}

* Export the results for all models in a single table
esttab using "Results/revision1/Table2D.tex", replace b(%9.3f) keep(corruption3_full $controls) ///
star(* 0.10 ** 0.05 *** 0.01) stats(N F_Statistic J_Statistic J_Statistic_pvalue) se 


* PANEL C: 2SLS Results with Baseline Controls 

eststo clear 

foreach k in $pct_outcomes {
    
    * Run the 2SLS regression and store the results
    eststo: ivreg2 `k' $controls _I* (corruption3_full = councils councils_installed management judge), first cluster(uf_code) partial(_cons $fixedef)
    
    * Add statistics for the current model
    estadd scalar F_Statistic = e(widstat)   // Weak identification test
    estadd scalar J_Statistic = e(j)         // Over-identification test
    estadd scalar J_Statistic_pvalue = e(jp) // J-statistic p-value
}

* Export the results for all models in a single table
esttab using "Results/revision1/Table3C.tex", replace b(%9.3f) keep(corruption3_full $controls) ///
star(* 0.10 ** 0.05 *** 0.01) stats(N F_Statistic J_Statistic J_Statistic_pvalue) se

* PANEL D: 2SLS Results with Baseline Controls plus Industry Shares

eststo clear 

foreach k in $pct_outcomes {
    
    * Run the 2SLS regression and store the results
    eststo: ivreg2 `k' $controls $sectors _I* (corruption3_full = councils councils_installed management judge), first cluster(uf_code) partial(_cons $fixedef)
    
    * Add statistics for the current model
    estadd scalar F_Statistic = e(widstat)   // Weak identification test
    estadd scalar J_Statistic = e(j)         // Over-identification test
    estadd scalar J_Statistic_pvalue = e(jp) // J-statistic p-value
}

* Export the results for all models in a single table
esttab using "Results/revision1/Table3D.tex", replace b(%9.3f) keep(corruption3_full $controls) ///
star(* 0.10 ** 0.05 *** 0.01) stats(N F_Statistic J_Statistic J_Statistic_pvalue) se 
