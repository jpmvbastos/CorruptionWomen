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

merge 1:1 munic_code using "/Users/jpmvbastos/Documents/GitHub/CorruptionEntrepreneurs/Data/municipality_level.dta"

drop _merge

replace total_female = (1-male) * population 

gen log_gdppc = log(gdp_pc)

gen log_density = log(density)

gen log_population = log(population)

***** OUTCOME VARIABLES 

* Female Labor Force participation
gen female_lfp = total_female_employed / total_female_workage

***** AS A % OF FEMALE LABOR FORCE

* % of Females that are self-employed
gen pct_female_self = total_female_self / total_female_employed

* % of Females that are employers
gen pct_female_employer = total_female_employer / total_female_employed

* % of Females that are managers 
gen pct_female_managers = female_manager_t / total_female_employed

* % of Females in leadership positions
gen pct_female_leaders = (female_manager_t + total_female_employer) / total_female_employed

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
gen share_female_manager = female_manager_t / manager_t

* % of leadership positions that are female
gen share_female_leaders = (female_manager_t + total_female_employer) / (manager_t + total_employer)

* % of informal workers that are female 
gen share_female_informal = total_female_informal / total_informal


save "CorruptionWomen_Final.dta", replace 


use "CorruptionWomen_Final.dta", clear

**** SUMMARY STATS

sum female_lfp pct_female_self pct_female_employer pct_female_managers pct_female_leaders pct_female_informal if corruption3_full!=.

sum share_female_lf share_female_self share_female_employer share_female_manager share_female_leaders  share_female_informal if corruption3_full!=.

sum log_gdppc population log_density size_informal college dist_capital male workage urban if corruption3_full!=.

global pct_outcomes = "female_lfp pct_female_self pct_female_employer pct_female_managers pct_female_leaders pct_female_informal"

global share_outcomes = "share_female_lf share_female_self share_female_employer share_female_manager share_female_leaders share_female_informal"

global controls = "log_gdppc population log_density size_informal college workage male urban"

global sectors = "agriculture extractive manufacturing electric construction rw transportation accomodation finance profserv education health publicadmin dservices international"

global fixedef = "i.sorteio_full i.uf_code"

* Results

eststo clear 

foreach k in  $pct_outcomes {
	
	eststo: reg `k' corruption3_full $controls $fixedef, cluster(uf_code)

	
}

esttab using "Results/Table1.tex", replace b(%9.3f) keep(corruption3_full $controls) star(* 0.10 ** 0.05 *** 0.01) se ar2
esttab using "Results/Table1.csv", replace b(%9.3f) keep(corruption3_full $controls) star(* 0.10 ** 0.05 *** 0.01) se ar2

eststo clear 

foreach k in $share_outcomes {
	
	eststo: reg `k' corruption3_full  $controls $fixedef , cluster(uf_code)

	
}

esttab using "Results/Table2.tex", replace b(%9.3f) keep(corruption3_full $controls) star(* 0.10 ** 0.05 *** 0.01) se ar2
esttab using "Results/Table2.csv", replace b(%9.3f) keep(corruption3_full $controls) star(* 0.10 ** 0.05 *** 0.01) se ar2


global controls = "log_gdppc log_population log_density size_informal college workage male urban"

eststo clear 

foreach k in  $pct_outcomes {
	
	eststo: reg `k' corruption3_full $controls $fixedef, cluster(uf_code)

	
}

esttab using "Results/Table3.tex", replace b(%9.3f) keep(corruption3_full $controls) star(* 0.10 ** 0.05 *** 0.01) se ar2
esttab using "Results/Table3.csv", replace b(%9.3f) keep(corruption3_full $controls) star(* 0.10 ** 0.05 *** 0.01) se ar2

eststo clear 

foreach k in $share_outcomes {
	
	eststo: reg `k' corruption3_full  $controls $fixedef , cluster(uf_code)

	
}

esttab using "Results/Table4.tex", replace b(%9.3f) keep(corruption3_full $controls) star(* 0.10 ** 0.05 *** 0.01) se ar2
esttab using "Results/Table4.csv", replace b(%9.3f) keep(corruption3_full $controls) star(* 0.10 ** 0.05 *** 0.01) se ar2

****** WITH POPULATION WEIGHTS

eststo clear 

foreach k in  $pct_outcomes {
	
	eststo: reg `k' corruption3_full $controls $fixedef [aweight=population], cluster(uf_code)

	
}

esttab using "Results/Table5.tex", replace b(%9.3f) keep(corruption3_full $controls) star(* 0.10 ** 0.05 *** 0.01) se ar2
esttab using "Results/Table5.csv", replace b(%9.3f) keep(corruption3_full $controls) star(* 0.10 ** 0.05 *** 0.01) se ar2

eststo clear 

foreach k in $share_outcomes {
	
	eststo: reg `k' corruption3_full  $controls $fixedef [aweight=population], cluster(uf_code)

	
}

esttab using "Results/Table6.tex", replace b(%9.3f) keep(corruption3_full $controls) star(* 0.10 ** 0.05 *** 0.01) se ar2
esttab using "Results/Table6.csv", replace b(%9.3f) keep(corruption3_full $controls) star(* 0.10 ** 0.05 *** 0.01) se ar2



****** WITH SECTOR SHARES 

eststo clear 

foreach k in  $pct_outcomes {
	
	eststo: reg `k' corruption3_full $controls $fixedef $sectors, cluster(uf_code)

	
}

esttab using "Results/Table7.tex", replace b(%9.3f) keep(corruption3_full $controls) star(* 0.10 ** 0.05 *** 0.01) se ar2
esttab using "Results/Table7.csv", replace b(%9.3f) keep(corruption3_full $controls) star(* 0.10 ** 0.05 *** 0.01) se ar2

eststo clear 

foreach k in $share_outcomes {
	
	eststo: reg `k' corruption3_full  $controls $fixedef $sectors, cluster(uf_code)

	
}

esttab using "Results/Table8.tex", replace b(%9.3f) keep(corruption3_full $controls) star(* 0.10 ** 0.05 *** 0.01) se ar2
esttab using "Results/Table8.csv", replace b(%9.3f) keep(corruption3_full $controls) star(* 0.10 ** 0.05 *** 0.01) se ar2



****** WITH POPULATION WEIGHTS

eststo clear 

foreach k in  $pct_outcomes {
	
	eststo: reg `k' corruption3_full $controls $fixedef $sectors [aweight=population], cluster(uf_code)

	
}

esttab using "Results/Table9.tex", replace b(%9.3f) keep(corruption3_full $controls) star(* 0.10 ** 0.05 *** 0.01) se ar2
esttab using "Results/Table9.csv", replace b(%9.3f) keep(corruption3_full $controls) star(* 0.10 ** 0.05 *** 0.01) se ar2

eststo clear 

foreach k in $share_outcomes {
	
	eststo: reg `k' corruption3_full  $controls $fixedef $sectors [aweight=population], cluster(uf_code)

	
}

esttab using "Results/Table10.tex", replace b(%9.3f) keep(corruption3_full $controls) star(* 0.10 ** 0.05 *** 0.01) se ar2
esttab using "Results/Table10.csv", replace b(%9.3f) keep(corruption3_full $controls) star(* 0.10 ** 0.05 *** 0.01) se ar2









eststo






reg pct_female_informal corruption3_full $controls $fixedef , cluster(uf_code)
reg share_female_leaders corruption1_full $controls $fixedef , cluster(uf_code)
reg share_female_leaders corruption2_full $controls $fixedef , cluster(uf_code)
reg share_female_leaders corruption4_full $controls $fixedef , cluster(uf_code) // This one is significant 
reg share_female_leaders pcorrupt $controls $fixedef , cluster(uf_code)
