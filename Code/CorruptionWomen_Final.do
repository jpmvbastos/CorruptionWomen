*------------------------------------------------------------------------------*
* Load Data and Setup
*------------------------------------------------------------------------------*

cd "/Users/jpmvbastos/Documents/GitHub/CorruptionWomen/"

* Load Data
* use "CorruptionWomen_Final.dta", clear

* Defin globals 

global share_outcomes = "share_female_employer share_female_manager_priv share_female_leaders"

global share_outcomes_c = "share_femployer_c share_fmgmt_c share_fleaders_c"

global share_outcomes_nc = "share_femployer_nc share_fmgmt_nc share_fleaders_nc"

global pct_outcomes = "female_lfp_census pct_female_employer pct_female_managers pct_female_leaders"

global pct_outcomes_c = "female_lfp_c pct_femployer_c pct_fmgmt_c pct_fleader_c"

global pct_outcomes_nc = "female_lfp_nc pct_femployer_nc pct_fmgmt_nc pct_fleader_nc"

global controls = "log_gdppc log_density size_informal college workage male urban"

global sectors = "agriculture extractive manufacturing electric construction rw transportation accomodation finance profserv education health publicadmin dservices"

global fixedef = "_Isorteio_f_23 _Isorteio_f_24 _Isorteio_f_25 _Isorteio_f_26 _Isorteio_f_27 _Isorteio_f_28 _Isorteio_f_29 _Isorteio_f_30 _Isorteio_f_31 _Isorteio_f_32 _Isorteio_f_33 _Isorteio_f_34 _Isorteio_f_35 _Isorteio_f_36 _Isorteio_f_37 _Isorteio_f_38 _Iuf_code_2 _Iuf_code_3 _Iuf_code_4 _Iuf_code_5 _Iuf_code_6 _Iuf_code_7 _Iuf_code_8 _Iuf_code_9 _Iuf_code_10 _Iuf_code_11 _Iuf_code_12 _Iuf_code_13 _Iuf_code_14 _Iuf_code_15 _Iuf_code_16 _Iuf_code_17 _Iuf_code_18 _Iuf_code_19 _Iuf_code_20 _Iuf_code_21 _Iuf_code_22 _Iuf_code_23 _Iuf_code_24 _Iuf_code_25 _Iuf_code_26 _Iuf_code_27"

*==============================================================================*
*==============================================================================*
* Main Results
*==============================================================================*

*------------------------------------------------------------------------------*
* Table 1: Summary stats for outcome measures
*------------------------------------------------------------------------------*

* All Sectors 
sum share_female_employer share_female_manager_priv share_female_leaders ///
	if corruption3_full!=.

sum female_lfp_census

sum pct_female_employer pct_female_managers pct_female_leader if corruption3_full!=.

* Corrupt Sectors only

sum share_femployer_c share_fmgmt_c share_fleaders_c if corruption3_full!=.

sum female_lfp_c pct_femployer_c pct_fmgmt_c pct_fleader_c if corruption3_full!=.

*------------------------------------------------------------------------------*
* Table 2: Summary stats for outcome measures
*------------------------------------------------------------------------------*

* Municipality 
sum gdp_pc density size_informal college male workage urban if corruption3_full!=.

* Sectors
sum agriculture extractive manufacturing electric construction rw transportation ///
	accomodation finance profserv education health publicadmin dservices poorlydefined ///
	if corruption3_full!=.
	

*------------------------------------------------------------------------------*
* Table 3: Main Results, as a share of that category
*------------------------------------------------------------------------------*

* PANEL A: OLS with Baseline Controls

eststo clear 

foreach k in  $share_outcomes {
	
	eststo: reg `k' corruption3_full $controls $fixedef, cluster(uf_code)
	
}

esttab using "Results/Table3A.tex", replace b(%9.3f) ///
	keep(corruption3_full $controls) star(* 0.10 ** 0.05 *** 0.01) se ar2
	
	
	
* PANEL B: OLS with Baseline Controls - Corrupt Sectors only 

eststo clear 

foreach k in  $share_outcomes_c {
	
	eststo: reg `k' corruption3_full $controls $fixedef, cluster(uf_code)
	
}

esttab using "Results/Table3B.tex", replace b(%9.3f) ///
	keep(corruption3_full $controls) star(* 0.10 ** 0.05 *** 0.01) se ar2

	
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
esttab using "Results/Table3C.tex", replace b(%9.3f) keep(corruption3_full $controls) ///
star(* 0.10 ** 0.05 *** 0.01) stats(N F_Statistic J_Statistic J_Statistic_pvalue) se 


* PANEL D: 2SLS Results with Baseline Controls - Corrupt Sectors Only
eststo clear 

foreach k in $share_outcomes_c {
    
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
esttab using "Results/Table3D.tex", replace b(%9.3f) keep(corruption3_full $controls) ///
star(* 0.10 ** 0.05 *** 0.01) stats(N F_Statistic J_Statistic J_Statistic_pvalue) se 


*------------------------------------------------------------------------------*
* Table 4: Main Results, as a share of female employment
*------------------------------------------------------------------------------*

* PANEL A: OLS with Baseline Controls

eststo clear 

foreach k in  $pct_outcomes {
	
	eststo: reg `k' corruption3_full $controls $fixedef, cluster(uf_code)
	
}

esttab using "Results/Table4A.tex", replace b(%9.3f) ///
	keep(corruption3_full $controls) star(* 0.10 ** 0.05 *** 0.01) se ar2
	
	
	
* PANEL B: OLS with Baseline Controls - Corrupt Sectors only 

eststo clear 

foreach k in  $pct_outcomes_c {
	
	eststo: reg `k' corruption3_full $controls $fixedef, cluster(uf_code)
	
}

esttab using "Results/Table4B.tex", replace b(%9.3f) ///
	keep(corruption3_full $controls) star(* 0.10 ** 0.05 *** 0.01) se ar2

	
* PANEL C: 2SLS Results with Baseline Controls 
eststo clear 

foreach k in $pct_outcomes {
    
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
esttab using "Results/Table4C.tex", replace b(%9.3f) keep(corruption3_full $controls) ///
star(* 0.10 ** 0.05 *** 0.01) stats(N F_Statistic J_Statistic J_Statistic_pvalue) se 


* PANEL D: 2SLS Results with Baseline Controls - Corrupt Sectors Only
eststo clear 

foreach k in $pct_outcomes_c {
    
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
esttab using "Results/Table4D.tex", replace b(%9.3f) keep(corruption3_full $controls) ///
star(* 0.10 ** 0.05 *** 0.01) stats(N F_Statistic J_Statistic J_Statistic_pvalue) se 

*==============================================================================*
*==============================================================================*
* Appendix A - Alternative Corruption Measures
*==============================================================================*

*------------------------------------------------------------------------------*
* Table A1: Alternative Corruption Measures, as a share of that category
*------------------------------------------------------------------------------*

* PANEL A: OLS with Analytic Weights

eststo clear 

foreach k in  $share_outcomes {
	
	eststo: reg `k' corruption3_full $controls $fixedef [aweight=population], ///
	cluster(uf_code)
	
}

esttab using "Results/TableA1_A.tex", replace b(%9.3f) ///
	keep(corruption3_full $controls) star(* 0.10 ** 0.05 *** 0.01) se ar2
	
* PANEL B: OLS - Pre 2010 Data

eststo clear 

foreach k in  $share_outcomes {
	
	eststo: reg `k' corruption3 $controls $fixedef, ///
	cluster(uf_code)
	
}

esttab using "Results/TableA1_B.tex", replace b(%9.3f) ///
	keep(corruption3 $controls) star(* 0.10 ** 0.05 *** 0.01) se ar2
	
* PANEL C: OLS - Ferraz and Finan Data

eststo clear 

foreach k in  $share_outcomes {
	
	eststo: reg `k' pcorrupt $controls i.uf_code i.nsorteio, ///
	cluster(uf_code)
	
}

esttab using "Results/TableA1_C.tex", replace b(%9.3f) ///
	keep(pcorrupt $controls) star(* 0.10 ** 0.05 *** 0.01) se ar2
	
* PANEL D: OLS - Controlling for Number of Audits

eststo clear 

foreach k in  $share_outcomes {
	
	qui eststo: reg `k' corruption3_full n_audits $controls $fixedef, cluster(uf_code)
	
}

esttab using "Results/TableA1_D.tex", replace b(%9.3f) ///
	keep(corruption3_full n_audits $controls) star(* 0.10 ** 0.05 *** 0.01) se ar2
	
	
* PANEL E: OLS - Dummy for Multiple Audits
eststo clear
	
foreach k in  $share_outcomes {
	
	qui eststo: reg `k' corruption3_full multiple $controls $fixedef, cluster(uf_code)
	
}

esttab using "Results/TableA1_E.tex", replace b(%9.3f) ///
	keep(corruption3_full multiple $controls) star(* 0.10 ** 0.05 *** 0.01) se ar2



*------------------------------------------------------------------------------*
* Table A2: Alternative Corruption Measures, as a share of female employment
*------------------------------------------------------------------------------*


* PANEL A: OLS with Analytic Weights

eststo clear 

foreach k in  $pct_outcomes {
	
	eststo: reg `k' corruption3_full $controls $fixedef [aweight=population], ///
	cluster(uf_code)
	
}

esttab using "Results/TableA2_A.tex", replace b(%9.3f) ///
	keep(corruption3_full $controls) star(* 0.10 ** 0.05 *** 0.01) se ar2
	
* PANEL B: OLS - Pre 2010 Data

eststo clear 

foreach k in  $pct_outcomes {
	
		eststo: reg `k' corruption3 $controls $fixedef, ///
	cluster(uf_code)
	
}

esttab using "Results/TableA2_B.tex", replace b(%9.3f) ///
	keep(corruption3 $controls) star(* 0.10 ** 0.05 *** 0.01) se ar2
	
* PANEL C: OLS - Ferraz and Finan Data

eststo clear 

foreach k in  $pct_outcomes {
	
	eststo: reg `k' pcorrupt $controls i.uf_code i.nsorteio, ///
	cluster(uf_code)
	
}

esttab using "Results/TableA2_C.tex", replace b(%9.3f) ///
	keep(pcorrupt $controls) star(* 0.10 ** 0.05 *** 0.01) se ar2
	
* PANEL D: OLS - Controlling for Number of Audits

eststo clear 

foreach k in  $pct_outcomes {
	
	qui eststo: reg `k' corruption3_full n_audits $controls $fixedef, cluster(uf_code)
	
}

esttab using "Results/TableA2_D.tex", replace b(%9.3f) ///
	keep(corruption3_full n_audits $controls) star(* 0.10 ** 0.05 *** 0.01) se ar2
	
	
* PANEL E: OLS - Dummy for Multiple Audits
eststo clear
	
foreach k in  $pct_outcomes {
	
	qui eststo: reg `k' corruption3_full multiple $controls $fixedef, cluster(uf_code)
	
}

esttab using "Results/TableA2_E.tex", replace b(%9.3f) ///
	keep(corruption3_full multiple $controls) star(* 0.10 ** 0.05 *** 0.01) se ar2

	
*==============================================================================*
*==============================================================================*
* Appendix B - Controlling for Industry Shares
*==============================================================================*
	
	
*------------------------------------------------------------------------------*
* Table B1: Results with Industry Shares, as a share of category
*------------------------------------------------------------------------------*
	
* PANEL A: OLS with Baseline Controls plus Industry Shares

eststo clear 

foreach k in  $share_outcomes {
	
	eststo: reg `k' corruption3_full $controls $sectors $fixedef, cluster(uf_code)
	
}

esttab using "Results/TableB1_A.tex", replace b(%9.3f) ///
	keep(corruption3_full $controls $sectors) star(* 0.10 ** 0.05 *** 0.01) se ar2

* PANEL B: OLS with Baseline Controls plus Industry Shares - Corrupt Sectors only

eststo clear 

foreach k in  $share_outcomes_c {
	
	eststo: reg `k' corruption3_full $controls $sectors $fixedef, cluster(uf_code)
	
}

esttab using "Results/TableB1_B.tex", replace b(%9.3f) ///
	keep(corruption3_full $controls $sectors) star(* 0.10 ** 0.05 *** 0.01) se ar2
	
*------------------------------------------------------------------------------*
* Table B2: Results with Industry Shares, as a share of female employment
*------------------------------------------------------------------------------*


* PANEL A: OLS with Baseline Controls plus Industry Shares

eststo clear 

foreach k in  $pct_outcomes {
	
	eststo: reg `k' corruption3_full $controls $sectors $fixedef, cluster(uf_code)
	
}

esttab using "Results/TableB2_A.tex", replace b(%9.3f) ///
	keep(corruption3_full $controls $sectors) star(* 0.10 ** 0.05 *** 0.01) se ar2

* PANEL B: OLS with Baseline Controls plus Industry Shares - Corrupt Sectors only

eststo clear 

foreach k in  $pct_outcomes_c {
	
	eststo: reg `k' corruption3_full $controls $sectors $fixedef, cluster(uf_code)
	
}

esttab using "Results/TableB2_B.tex", replace b(%9.3f) ///
	keep(corruption3_full $controls $sectors) star(* 0.10 ** 0.05 *** 0.01) se ar2
	
*==============================================================================*
*==============================================================================*
* Appendix C - Sample Consistency
*==============================================================================*
	
*------------------------------------------------------------------------------*
* Table C1: Summary stats for different samples
*------------------------------------------------------------------------------*


global controls = "log_gdppc log_density size_informal college workage male urban"

global controls_stats = "gdp_pc density size_informal college male workage urban"

eststo clear

**** SUMMARY STATS - 878 observations - Table 3, Panel A/C, Column 1

eststo: qui reg share_female_employer corruption3_full $controls $fixedef, cluster(uf_code)	

sum share_female_employer corruption3_full $controls_stats if _est_est1==1

**** SUMMARY STATS - 878 observations - Table 3, Panel B/D, Column 2

eststo: qui reg share_femployer_c corruption3_full $controls $fixedef, cluster(uf_code)	

sum share_femployer_c corruption3_full  $controls_stats if _est_est2==1

**** SUMMARY STATS - 878 observations - Table 3, Panel B/D, Column 3

eststo: qui reg share_fmgmt_c corruption3_full $controls $fixedef, cluster(uf_code)	

sum share_fmgmt_c corruption3_full  $controls_stats if _est_est3==1

**** SUMMARY STATS - 878 observations - Table 3, Panel B/D, Column 4

eststo: qui reg share_fleaders_c corruption3_full $controls $fixedef, cluster(uf_code)	

sum share_fleaders_c corruption3_full  $controls_stats if _est_est4==1


***** SUMMARY STATS -  TREATED VS. ELIGIBLE BUT NOT TREATED

// Open output LaTeX file
cap file close tab
file open tab using "Results/summary-stats.tex", write replace

foreach var in ///
    share_female_employer share_female_manager_priv share_female_leaders /// Female Employment Leadership
    female_lfp_census pct_female_employer pct_female_managers pct_female_leaders /// Female Participation
    share_femployer_c share_fmgmt_c share_fleaders_c /// Female Control
    female_lfp_c pct_femployer_c pct_fmgmt_c pct_fleader_c /// Corruption Measures
    gdp_pc density size_informal college male workage urban /// Municipality Characteristics
{
       quietly {
        // Run t-test by audited_eligible variable
        ttest `var', by(audited_eligible)

        local m1 = strtrim(string(r(mu_1), "%9.3f"))
        local m2 = strtrim(string(r(mu_2), "%9.3f"))
        local diff = strtrim(string(r(mu_2) - r(mu_1), "%9.3f"))
        local sd1 = strtrim(string(r(sd_1), "%9.3f"))
        local sd2 = strtrim(string(r(sd_2), "%9.3f"))
        local t = strtrim(string(r(t)*-1, "%9.2f"))
		
		scalar pval = r(p)
		if pval <= 0.1 & pval > 0.05 {
			local diff = "`diff'*"
		}
		else if pval <= 0.05 & pval > 0.01 {
			local diff = "`diff'**"
		}
		else if pval <= 0.01 {
			local diff = "`diff'***"
		}
    }

    file write tab "`var' & `m2' & (`sd2') & `m1' &  (`sd1') & `diff'  & [`t'] \\" _n
}

cap file close tab


*------------------------------------------------------------------------------*
* Plots
*------------------------------------------------------------------------------*

label var corruption3_full "Corruption"
label var gdp_pc "GDP per capita"
label var density "Pop. Density"
label var size_informal "% Informal"
label var college "% College"
label var male "% Male"
label var workage "% Working Age"
label var urban "% Urban"

global controls_stats = "gdp_pc density size_informal college male workage urban"

local i 1
foreach v in corruption3_full $controls_stats {
	display("Creating graph `i': `v'")
	local xlabel : variable label `v'
	qui twoway ///
		(kdensity `v' if eligible==1, color(black) lpattern(dash)) ///
		(kdensity `v' if corruption3_full!=., color(black)) ///
		(kdensity `v' if _est_est1==1, color(blue)) ///
		(kdensity `v' if _est_est2==1, color(red)) ///
		(kdensity `v' if _est_est3==1, color(green)) ///
		(kdensity `v' if _est_est4==1, color(orange)), ///
		legend(off) nodraw ///
		xtitle(`xlabel') ///
		ytitle("Kernel Density") ///
		name(h`i', replace)
	
		local ++i
}

graph combine h1 h2 h3 h4 h5 h6 h7 h8, ///
	cols(2) rows(4) ///
	xsize(5)       /// total width in inches
	ysize(7)        // total height in inches
	
graph export "Results/kdensities.png", as(png) replace

	
local i 1
foreach v in $controls_stats workage_census informal{
	
	display("Creating graph `i': `v'")
	local xlabel : variable label `v'
	qui twoway ///
		(kdensity `v' if audited_eligible==0, color(blue) lpattern(dash)) ///
		(kdensity `v' if audited_eligible==1, color(cranberry)), ///
		legend(off) nodraw ///
		xtitle(`xlabel') ///
		ytitle("Kernel Density") ///
		name(h`i', replace)
	
		local ++i
}

graph combine h1 h2 h3 h4 h5 h6 h7, ///
	cols(2) rows(4) ///
	xsize(5)       /// total width in inches
	ysize(7)        // total height in inches
	
graph export "Results/kdensities-eligible.png", as(png) replace

*==============================================================================*
*==============================================================================*
* Appendix D - Corrupt vs. Non-Corrupt Sectors
*==============================================================================*


*------------------------------------------------------------------------------*
* Table D1: Summary Statistics for Corrupt vs. Non-Corrupt Sectors
*------------------------------------------------------------------------------*
	
* Corrupt	
sum share_femployer_c share_fmgmt_c share_fleaders_c if corruption3_full!=.

sum female_lfp_c pct_femployer_c pct_fmgmt_c pct_fleader_c ///
	if corruption3_full!=.

* Non-Corrupt
sum share_femployer_nc share_fmgmt_nc share_fleaders_nc if corruption3_full!=.

sum female_lfp_nc pct_femployer_nc pct_fmgmt_nc pct_fleader_nc ///
	if corruption3_full!=.
	
	
*------------------------------------------------------------------------------*
* Table D2: Corrupt vs. Non-Corrupt Sector (replicating table 3)
*------------------------------------------------------------------------------*


* PANEL A: OLS with Baseline Controls - Corrupt
	
	eststo clear
	
	foreach k in $share_outcomes_c {
		
		eststo: reg `k' corruption3_full $controls $fixedef, cluster(uf_code)	
		
	}
	
	esttab using "Results/Appendix D/TableD2_A.tex", replace b(%9.3f) ///
	keep(corruption3_full $controls) star(* 0.10 ** 0.05 *** 0.01) se ar2


* PANEL B: OLS with Baseline Controls - Non-Corrupt
	eststo clear
	
	foreach k in $share_outcomes_nc {
		
		eststo: reg `k' corruption3_full $controls $fixedef, cluster(uf_code)	
		
	}
	
	esttab using "Results/Appendix D/TableD2_B.tex", replace b(%9.3f) ///
	keep(corruption3_full $controls) star(* 0.10 ** 0.05 *** 0.01) se ar2
	

* PANEL C: SLS with Baseline Controls - Corrupt
	eststo clear 

	foreach k in $share_outcomes_c {
		
		* Run the 2SLS regression and store the results
		eststo: ivreg2 share_`k'_c $controls $fixedef ///
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
	
	foreach k in $share_outcomes_nc {
		
		* Run the 2SLS regression and store the results
		eststo: ivreg2 share_`k'_nc $controls _I* ///
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
	
	
*==============================================================================*
*==============================================================================*
* Appendix E - Instrumental Variable Analysis
*==============================================================================*

*------------------------------------------------------------------------------*
* Table E1: First Stage for Table 3, Panel C
*------------------------------------------------------------------------------*

eststo clear 

foreach k in $share_outcomes {
    
    * Run the 2SLS regression and store the results
    eststo: ivreg2 `k' $controls  _I* ///
	(corruption3_full = councils councils_installed management judge), ///
	first cluster(uf_code) partial(_cons $fixedef)
    
}

*------------------------------------------------------------------------------*
* Table E2: First Stage for Table 3, Panel D
*------------------------------------------------------------------------------*

eststo clear 

foreach k in $share_outcomes_corrupt {
		
		* Run the 2SLS regression and store the results
		eststo: ivreg2 share_`k'_c $controls $fixedef ///
		(corruption3_full = councils councils_installed management judge), ///
		first cluster(uf_code) partial(_cons $fixedef)
	
	}
	
*------------------------------------------------------------------------------*
* Table E3: First Stage for Table 4, Panel C
*------------------------------------------------------------------------------*

eststo clear 

foreach k in $pct_outcomes {
    
    * Run the 2SLS regression and store the results
    eststo: ivreg2 `k' $controls $fixedef ///
	(corruption3_full = councils councils_installed management judge), ///
	first cluster(uf_code) partial(_cons $fixedef)
    
}
	
*------------------------------------------------------------------------------*
* Table E4: First Stage for Table 4, Panel D
*------------------------------------------------------------------------------*
eststo clear
	
foreach k in $pct_outcomes_corrupt {
		
	* Run the 2SLS regression and store the results
    eststo: ivreg2 pct_`k'_c $controls $fixedef ///
	(corruption3_full = councils councils_installed management judge), ///
	first cluster(uf_code) partial(_cons $fixedef)
		
	}
	
*------------------------------------------------------------------------------*
* Table E5: Just-Identified IV's  - Replicating Table 3, Panel C
*------------------------------------------------------------------------------*

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
* Table E6: Just-Identified IV's  - Replicating Table 4, Panel C
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


	
	