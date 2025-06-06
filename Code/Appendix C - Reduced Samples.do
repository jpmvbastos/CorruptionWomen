cd "/Users/jpmvbastos/Documents/GitHub/CorruptionWomen/"

use "CorruptionWomen_Final.dta", clear

*------------------------------------------------------------------------------*
* Define eligible but not audited municipalities
*------------------------------------------------------------------------------*
cap drop _merge

merge 1:1 cod_munic using "/Users/jpmvbastos/Documents/GitHub/CorruptionWomen/audits.dta"

tab capital

gen n_audits = 0
forvalues year=2003/2012 {
	
	replace n_audits = n_audits + audited_`year'

}

gen audited = (n_audits>0)

gen multiple = (n_audits>1)

gen eligible = (pop<500000 & capital==0 & audited==0 & corruption3_full==.)

gen audited_eligible = 0 if eligible==1
replace audited_eligible = 1 if corruption3_full!=.

*------------------------------------------------------------------------------*
* Summary stats for different samples
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
    female_lfp pct_female_employer pct_female_managers pct_female_leaders /// Female Participation
    share_femployer_c share_fmgmt_c share_fleaders_c /// Female Control
    share_female_corrupt pct_femployer_c pct_fmgmt_c pct_fleader_c /// Corruption Measures
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
	
