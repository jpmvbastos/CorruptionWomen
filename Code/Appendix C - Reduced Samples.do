cd "/Users/jpmvbastos/Documents/GitHub/CorruptionWomen/"

use "CorruptionWomen_Final.dta", clear

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

gen eligible = (pop<200000 & corruption3_full==.)

label var corruption3_full "Corruption"
label var gdp_pc "GDP per capita"
label var density "Pop. Density"
label var size_informal "% Informal"
label var college "% College"
label var male "% Male"
label var workage "% Working Age"
label var urban "% Urban"

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
	