***** Corruption Women - Robustness Checks

***** ESTIMATES 

global share_outcomes = "share_female_employer share_female_manager_priv share_female_leaders"

global pct_outcomes = "female_lfp_census pct_female_employer pct_female_managers pct_female_leaders"

global controls = "log_gdppc log_density size_informal college workage male urban"

global sectors = "agriculture extractive manufacturing electric construction rw transportation accomodation finance profserv education health publicadmin dservices"


***************** TABLE B1 - Robustness Checks for TABLE 2

cd "/Users/jpmvbastos/Documents/GitHub/CorruptionWomen/"

* PANEL A: OLS with Baseline Controls, Weighted by Population 

eststo clear 

foreach k in  $share_outcomes {
	
	eststo: reg `k' corruption3_full $controls i.sorteio_full i.uf_code [aweight=population], cluster(uf_code)
	
}

esttab using "Results/TableB1A.tex", replace b(%9.3f) keep(corruption3_full $controls) star(* 0.10 ** 0.05 *** 0.01) se ar2

eststo clear 

* PANEL A: OLS with Baseline Controls - Pre-2010 Data

eststo clear 

foreach k in  $share_outcomes {
	
	eststo: reg `k' corruption3 $controls i.sorteio_full i.uf_code, cluster(uf_code)
	
}

esttab using "Results/TableB1B.tex", replace b(%9.3f) keep(corruption3 $controls) star(* 0.10 ** 0.05 *** 0.01) se ar2

* PANEL B: OLS with Baseline Controls -  Ferraz and Finan (2011)

eststo clear 

foreach k in  $share_outcomes {
	
	eststo: reg `k' pcorrupt $controls i.uf_code i.nsorteio, cluster(uf_code)
	
}

esttab using "Results/TableB1C.tex", replace b(%9.3f) keep(pcorrupt $controls) star(* 0.10 ** 0.05 *** 0.01) se ar2



***************** TABLE B2 - Robustness Checks for TABLE 3

cd "/Users/jpmvbastos/Documents/GitHub/CorruptionWomen/"


* PANEL A: OLS with Baseline Controls, Weighted by Population 

eststo clear 

foreach k in  $pct_outcomes {
	
	eststo: reg `k' corruption3_full $controls i.sorteio_full i.uf_code [aweight=population], cluster(uf_code)
	
}

esttab using "Results/TableB2A.tex", replace b(%9.3f) keep(corruption3_full $controls) star(* 0.10 ** 0.05 *** 0.01) se ar2

eststo clear 

* PANEL A: OLS with Baseline Controls - Pre-2010 Data

eststo clear 


foreach k in  $pct_outcomes {
	
	eststo: reg `k' corruption3 $controls i.sorteio_full i.uf_code, cluster(uf_code)
	
}

esttab using "Results/TableB2B.tex", replace b(%9.3f) keep(corruption3 $controls) star(* 0.10 ** 0.05 *** 0.01) se ar2

* PANEL B: OLS with Baseline Controls -  Ferraz and Finan (2011)

eststo clear 


foreach k in  $pct_outcomes {
	
	eststo: reg `k' pcorrupt $controls i.uf_code i.nsorteio, cluster(uf_code)
	
}

esttab using "Results/TableB2C.tex", replace b(%9.3f) keep(pcorrupt $controls) star(* 0.10 ** 0.05 *** 0.01) se ar2



