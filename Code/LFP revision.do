* Female LFP

gen share_female_corrupt_lfp = share_female_corrupt * 0.330 if corruption3_full!=.
gen share_female_non_corrupt_lfp = share_female_non_corrupt * 0.330 if corruption3_full!=.

global pct_outcomes = "female_lfp_census pct_female_employer pct_female_managers pct_female_leaders"

global controls = "log_gdppc log_density size_informal college workage male urban"

global sectors = "agriculture extractive manufacturing electric construction rw transportation accomodation finance profserv education health publicadmin dservices"

global fixedef = "_Isorteio_f_23 _Isorteio_f_24 _Isorteio_f_25 _Isorteio_f_26 _Isorteio_f_27 _Isorteio_f_28 _Isorteio_f_29 _Isorteio_f_30 _Isorteio_f_31 _Isorteio_f_32 _Isorteio_f_33 _Isorteio_f_34 _Isorteio_f_35 _Isorteio_f_36 _Isorteio_f_37 _Isorteio_f_38 _Iuf_code_2 _Iuf_code_3 _Iuf_code_4 _Iuf_code_5 _Iuf_code_6 _Iuf_code_7 _Iuf_code_8 _Iuf_code_9 _Iuf_code_10 _Iuf_code_11 _Iuf_code_12 _Iuf_code_13 _Iuf_code_14 _Iuf_code_15 _Iuf_code_16 _Iuf_code_17 _Iuf_code_18 _Iuf_code_19 _Iuf_code_20 _Iuf_code_21 _Iuf_code_22 _Iuf_code_23 _Iuf_code_24 _Iuf_code_25 _Iuf_code_26 _Iuf_code_27"


***************** TABLE 3 - SHARES OF FEMALE LFP ****************

cd "/Users/jpmvbastos/Documents/GitHub/CorruptionWomen/"

* PANEL B: OLS with Baseline Controls, Corrupt Sectors Only

reg share_female_corrupt corruption3_full $controls $fixedef, cluster(uf_code)

* PANEL D: 2SLS with Baseline Controls, Corrupt Sectors Only
ivreg2 share_female_corrupt $controls _I* ///
	(corruption3_full = councils councils_installed management judge), ///
	first cluster(uf_code) partial(_cons $fixedef)
	
* PANEL D: 2SLS with Baseline Controls, Corrupt Sectors Only
ivreg2 share_female_non_corrupt $controls _I* ///
	(corruption3_full = councils councils_installed management judge), ///
	first cluster(uf_code) partial(_cons $fixedef)

	
***************** TABLE B2 - SHARES OF FEMALE LFP ****************
	
* PANEL B: OLS with Baseline Controls, Corrupt Sectors Only
reg share_female_corrupt corruption3_full $controls $sectors $fixedef, cluster(uf_code)



* Table D3

reg share_female_corrupt corruption3_full $controls $fixedef, cluster(uf_code)

reg share_female_non_corrupt corruption3_full $controls $fixedef, cluster(uf_code)


	
* PANEL D: 2SLS with Baseline Controls, Corrupt Sectors Only
ivreg2 share_female_corrupt $controls _I* ///
	(corruption3_full = councils councils_installed management judge), ///
	first cluster(uf_code) partial(_cons $fixedef)
	
* PANEL D: 2SLS with Baseline Controls, Corrupt Sectors Only
ivreg2 share_female_non_corrupt $controls _I* ///
	(corruption3_full = councils councils_installed management judge), ///
	first cluster(uf_code) partial(_cons $fixedef)
	
cd "/Users/jpmvbastos/Documents/GitHub/CorruptionWomen/"


*------------------------------------------------------------------------------*
* TABLE 4 - AS A SHARE OF FEMALE EMPLOYMENT
*------------------------------------------------------------------------------*

* PANEL B: OLS with Baseline Controls, Corrupt Sectors Only

eststo clear

eststo: reg female_lfp_c corruption3_full $controls $fixedef, cluster(uf_code)
eststo: reg pct_femployer_c corruption3_full $controls $fixedef, cluster(uf_code)
eststo: reg pct_fmgmt_c corruption3_full $controls $fixedef, cluster(uf_code)
eststo: reg pct_fleader_c corruption3_full $controls $fixedef, cluster(uf_code)

esttab using "Results/Table4B.tex", replace b(%9.3f) keep(corruption3_full $controls) star(* 0.10 ** 0.05 *** 0.01) se ar2

eststo clear

foreach k in  female_lfp_c pct_femployer_c pct_fmgmt_c pct_fleader_c {

* PANEL D: 2SLS with Baseline Controls, Corrupt Sectors Only
eststo: ivreg2 `k' $controls _I* ///
	(corruption3_full = councils councils_installed management judge), ///
	first cluster(uf_code) partial(_cons $fixedef)
	
* Add statistics for the current model
    estadd scalar F_Statistic = e(widstat)   // Weak identification test
    estadd scalar J_Statistic = e(j)         // Over-identification test
    estadd scalar J_Statistic_pvalue = e(jp) // J-statistic p-value
}

* Export the results for all models in a single table
esttab using "Results/Table4D.tex", replace b(%9.3f) keep(corruption3_full $controls) ///
star(* 0.10 ** 0.05 *** 0.01) stats(N F_Statistic J_Statistic J_Statistic_pvalue) se 

*------------------------------------------------------------------------------*
* TABLE B2 - AS A SHARE OF FEMALE EMPLOYMENT
*------------------------------------------------------------------------------*

global sectors = "agriculture extractive manufacturing electric construction rw transportation accomodation finance profserv education health publicadmin dservices"

* PANEL B: OLS with Baseline Controls, Corrupt Sectors Only

eststo clear

eststo: reg female_lfp_c corruption3_full $controls $fixedef $sectors, cluster(uf_code)
eststo: reg pct_femployer_c corruption3_full $controls $fixedef $sectors, cluster(uf_code)
eststo: reg pct_fmgmt_c corruption3_full $controls $fixedef $sectors, cluster(uf_code)
eststo: reg pct_fleader_c corruption3_full $controls $fixedef $sectors, cluster(uf_code)

esttab using "Results/TableB2_B.tex", replace b(%9.3f) keep(corruption3_full $controls) star(* 0.10 ** 0.05 *** 0.01) se ar2

eststo clear

*------------------------------------------------------------------------------*
* Table D3: Corrupt vs. Non-Corrupt Sector (replicating table 4)
*------------------------------------------------------------------------------*
	
	
* PANEL A: OLS with Baseline Controls - Corrupt
	
	eststo clear
	
	foreach k in female_lfp_c pct_femployer_c pct_fmgmt_c pct_fleader_c {
		
		eststo: reg `k' corruption3_full $controls $fixedef, cluster(uf_code)	
		
	}
	
	esttab using "Results/Appendix D/TableD3_A.tex", replace b(%9.3f) ///
	keep(corruption3_full $controls) star(* 0.10 ** 0.05 *** 0.01) se ar2


* PANEL B: OLS with Baseline Controls - Non-Corrupt
	eststo clear
	
	foreach k in female_lfp_nc pct_femployer_nc pct_fmgmt_nc pct_fleader_nc {
		
		eststo: reg `k' corruption3_full $controls $fixedef, cluster(uf_code)	
		
	}
	
	esttab using "Results/Appendix D/TableD3_B.tex", replace b(%9.3f) ///
	keep(corruption3_full $controls) star(* 0.10 ** 0.05 *** 0.01) se ar2
	

* PANEL C: SLS with Baseline Controls - Corrupt
	eststo clear 

	foreach k in female_lfp_c pct_femployer_c pct_fmgmt_c pct_fleader_c {
		
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
	esttab using "Results/Appendix D/TableD3_C.tex", replace b(%9.3f) ///
	keep(corruption3_full $controls) star(* 0.10 ** 0.05 *** 0.01) ///
	stats(N F_Statistic J_Statistic J_Statistic_pvalue) se 
	
* PANEL D: SLS with Baseline Controls - Non-Corrupt
	
	eststo clear
	
	foreach k in female_lfp_nc pct_femployer_nc pct_fmgmt_nc pct_fleader_nc {
		
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
	esttab using "Results/Appendix D/TableD3_D.tex", replace b(%9.3f) ///
	keep(corruption3_full $controls) star(* 0.10 ** 0.05 *** 0.01) ///
	stats(N F_Statistic J_Statistic J_Statistic_pvalue) se 

