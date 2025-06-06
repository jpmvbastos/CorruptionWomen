*------------------------------------------------------------------------------*
* Table A1: Panel D, Accounting For Multiple Audits
*------------------------------------------------------------------------------*

cap gen multiple = (n_audits>1) if corruption3_full!=.

global share_outcomes = "share_female_employer share_female_manager_priv share_female_leaders"

eststo clear

foreach k in  $share_outcomes {
	
	qui eststo: reg `k' corruption3_full n_audits $controls $fixedef, cluster(uf_code)
	
}

esttab using "Results/TableA1_D.tex", replace b(%9.3f) ///
	keep(corruption3_full n_audits $controls) star(* 0.10 ** 0.05 *** 0.01) se ar2
	
eststo clear
	
foreach k in  $share_outcomes {
	
	qui eststo: reg `k' corruption3_full multiple $controls $fixedef, cluster(uf_code)
	
}

esttab using "Results/TableA1_E.tex", replace b(%9.3f) ///
	keep(corruption3_full multiple $controls) star(* 0.10 ** 0.05 *** 0.01) se ar2




*------------------------------------------------------------------------------*
* Table A2: Panel D, Accounting For Multiple Audits
*------------------------------------------------------------------------------*
global pct_outcomes = "female_lfp_census pct_female_employer pct_female_managers pct_female_leaders"

eststo clear

foreach k in  $pct_outcomes {
	
	qui eststo: reg `k' corruption3_full n_audits $controls $fixedef, cluster(uf_code)
	
}

esttab using "Results/TableA2_D.tex", replace b(%9.3f) ///
	keep(corruption3_full n_audits $controls) star(* 0.10 ** 0.05 *** 0.01) se ar2

eststo clear
	
	foreach k in  $pct_outcomes {
	
	qui eststo: reg `k' corruption3_full multiple $controls $fixedef, cluster(uf_code)
	
}

esttab using "Results/TableA2_E.tex", replace b(%9.3f) ///
	keep(corruption3_full multiple $controls) star(* 0.10 ** 0.05 *** 0.01) se ar2

