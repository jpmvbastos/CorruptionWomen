cd "/Users/jpmvbastos/Documents/GitHub/CorruptionWomen/"

use "CorruptionWomen.dta", clear 

tostring(ibge_code), replace

replace ibge_code = substr(ibge_code, 1, 6) 

destring ibge_code, replace

merge 1:1 ibge_code using "/Users/jpmvbastos/Documents/GitHub/CorruptionRentSeeking/Data/Full_Data_August2023.dta"

gen munic_code = ibge_code

merge 1:1 munic_code using "/Users/jpmvbastos/Documents/GitHub/CorruptionEntrepreneurs/Data/municipality_level.dta"


replace total_female = (1-male) * population 

gen log_gdppc = log(gdpppc)
gen log_pop = log(population)

***** OUTCOME VARIABLES 

* Female Labor Force participation
gen female_lfp = total_female_emp / total_female

***** AS A % OF FEMALE LABOR FORCE

* % of Females that are self-employed
gen pct_female_self = total_female_self / total_female_emp 

* % of Employers that are female
gen pct_female_employer = total_female_employer / total_female_emp

* % of Females that are managers 
gen pct_female_managers = female_manager_t / total_female_emp

* % of Females in leadership positions
gen pct_female_leaders = (female_manager_t + total_female_employer) / total_female_emp 


***** SHARE OF THAT CATEGORY THAT IS FEMALE

* Share of Labor force that is female
gen share_female_lf = total_female_emp / total_employees

* % of Self-Employed that are female
gen share_female_self = total_female_self / total_selfemployed

* % of Employers that are female
gen share_female_employer = total_female_employer / total_employer

* % of Total Managers that are female
gen share_female_manager = female_manager_t / manager_t

* % of leadership positions that are female
gen share_female_leaders = (female_manager_t + total_female_employer) / (manager_t + total_employer)


save "CorruptionWomen_Final.dta", replace 



global pct_outcomes = "female_lfp pct_female_self pct_female_employer pct_female_managers pct_female_leaders"

global share_outcomes = "share_female_lf share_female_self share_female_employer share_female_manager share_female_leaders"

global controls = "log_gdppc population density size_informal college dist_capital"

global fixedef = "i.sorteio_full i.uf_code"

* Results

eststo clear 

foreach k in  $pct_outcomes {
	
	eststo: reg `k' corruption3_full $controls $fixedef , cluster(uf_code)

	
}

esttab using "Results/Table1.tex", replace b(%9.3f) keep(corruption3_full $controls) star(* 0.10 ** 0.05 *** 0.01) se ar2
esttab using "Results/Table1.csv", replace b(%9.3f) keep(corruption3_full $controls) star(* 0.10 ** 0.05 *** 0.01) se ar2

eststo clear 

foreach k in $share_outcomes {
	
	eststo: reg `k' corruption3_full  $controls $fixedef , cluster(uf_code)

	
}

esttab using "Results/Table2.tex", replace b(%9.3f) keep(corruption3_full $controls) star(* 0.10 ** 0.05 *** 0.01) se ar2
esttab using "Results/Table2.csv", replace b(%9.3f) keep(corruption3_full $controls) star(* 0.10 ** 0.05 *** 0.01) se ar2



reg share_female_leaders corruption1_full $controls $fixedef , cluster(uf_code)
reg share_female_leaders corruption2_full $controls $fixedef , cluster(uf_code)
reg share_female_leaders corruption4_full $controls $fixedef , cluster(uf_code) // This one is significant 
reg share_female_leaders pcorrupt $controls $fixedef , cluster(uf_code)