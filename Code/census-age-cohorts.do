cd "/Users/jpmvbastos/Library/CloudStorage/OneDrive-TexasTechUniversity/Personal/Projects/Data/Census/"

use "CENSO10_BRASIL.dta", clear

drop total_* *_t
drop *_count *_female

keep if age >= 18 & age <= 30

* Totals
egen total_pop = count(cityofjob), by(cityofjob)
egen total_employees = total(employed), by(cityofjob)
egen total_selfemployed = total(selfemployed), by(cityofjob)
egen total_formal = total(formal), by(cityofjob)
egen total_infomal = total(informal), by(cityofjob)
egen total_employer = total(employer), by(cityofjob)
egen total_workage = total(workage_census), by(cityofjob)

* Manager Totals 
egen manager_t = total(manager), by(cityofjob)
egen manager_priv_t = total(manager_priv), by(cityofjob)
egen manager_public_t = total(manager_public), by(cityofjob)

* Female Manager Totals 
egen female_manager_t = total(female_manager), by(cityofjob)
egen female_manager_priv_t = total(female_manager_priv), by(cityofjob)
egen female_manager_public_t = total(female_manager_public), by(cityofjob)

egen total_female = total(female), by(cityofjob)
egen total_female_informal = total(female_informal), by(cityofjob)
egen total_female_self = total(female_self), by(cityofjob)
egen total_female_employer = total(female_employer), by(cityofjob)
egen total_female_employed = total(female_employed), by(cityofjob)
egen total_female_workage = total(female_workage), by(cityofjob)

* Counts per Category

foreach k in agriculture extractive manufacturing electric construction rw transportation accomodation finance profserv education health publicadmin dservices international poorlydefined {

    // Display the current iteration
    display "Processing sector: `k'"
     
    egen `k'_count = total(employed * (`k' == 1)), by(cityofjob)
    egen `k'_female = total(employed * (`k' == 1) * female), by(cityofjob)
    
}

* Female Leadership by Industry

foreach k in agriculture extractive manufacturing electric construction rw transportation accomodation finance profserv education health publicadmin dservices international poorlydefined {
	
	// Display the current iteration
    display("Processing sector: `k'")

	egen `k'_fmanager = total((`k' == 1) * female_manager), by(cityofjob) // Number of female manager in that industry
	egen `k'_femployer = total((`k' == 1) * female_employer), by(cityofjob) // Number of female employer in that industry
	egen `k'_manager = total((`k' == 1) * manager), by(cityofjob) // Number of managers in that industry
	egen `k'_employer = total((`k' == 1) * employer), by(cityofjob) // Number of employers in that industry
}


local vars "urban gender age foreigner inschool publicschool neverschool educationlevel manager manager_public manager_priv employed multiplejobs informal formal selfemployed employer  agriculture extractive manufacturing electric construction rw transportation accomodation finance profserv education health publicadmin dservices international poorlydefined worksincity total_employees total_selfemployed total_formal total_infomal female_manager_public female_manager_priv total_female_employed manager_t manager_priv_t manager_public_t female_manager_t female_manager_priv_t female_manager_public_t female total_female_informal workage_census female_informal female_workage total_female_self total_female_workage *_count *_female female_lfp_census *_fmanager *_manager *_femployer *_employer"

keep `vars' cityofjob

collapse (mean) `vars', by(cityofjob)

* Derived Variables of Female Leadership by Industry

foreach k in agriculture extractive manufacturing electric construction rw transportation accomodation finance profserv education health publicadmin dservices international poorlydefined {
	
	// Display the current iteration
    display("Processing sector: `k'")

	gen share_fmanager_`k' = `k'_fmanager / `k'_manager
}

save "/Users/jpmvbastos/Documents/GitHub/CorruptionWomen/CorruptionWomen_Under30-master.dta", replace 

use "CENSO10_BRASIL.dta", clear

drop total_* *_t
drop *_count *_female

keep if age > 40 & age <= 65

* Totals
egen total_pop = count(cityofjob), by(cityofjob)
egen total_employees = total(employed), by(cityofjob)
egen total_selfemployed = total(selfemployed), by(cityofjob)
egen total_formal = total(formal), by(cityofjob)
egen total_infomal = total(informal), by(cityofjob)
egen total_employer = total(employer), by(cityofjob)
egen total_workage = total(workage_census), by(cityofjob)

* Manager Totals 
egen manager_t = total(manager), by(cityofjob)
egen manager_priv_t = total(manager_priv), by(cityofjob)
egen manager_public_t = total(manager_public), by(cityofjob)

* Female Manager Totals 
egen female_manager_t = total(female_manager), by(cityofjob)
egen female_manager_priv_t = total(female_manager_priv), by(cityofjob)
egen female_manager_public_t = total(female_manager_public), by(cityofjob)

egen total_female = total(female), by(cityofjob)
egen total_female_informal = total(female_informal), by(cityofjob)
egen total_female_self = total(female_self), by(cityofjob)
egen total_female_employer = total(female_employer), by(cityofjob)
egen total_female_employed = total(female_employed), by(cityofjob)
egen total_female_workage = total(female_workage), by(cityofjob)

* Counts per Category

foreach k in agriculture extractive manufacturing electric construction rw transportation accomodation finance profserv education health publicadmin dservices international poorlydefined {

    // Display the current iteration
    display "Processing sector: `k'"
     
    egen `k'_count = total(employed * (`k' == 1)), by(cityofjob)
    egen `k'_female = total(employed * (`k' == 1) * female), by(cityofjob)
    
}

* Female Leadership by Industry

foreach k in agriculture extractive manufacturing electric construction rw transportation accomodation finance profserv education health publicadmin dservices international poorlydefined {
	
	// Display the current iteration
    display("Processing sector: `k'")

	egen `k'_fmanager = total((`k' == 1) * female_manager), by(cityofjob) // Number of female manager in that industry
	egen `k'_femployer = total((`k' == 1) * female_employer), by(cityofjob) // Number of female employer in that industry
	egen `k'_manager = total((`k' == 1) * manager), by(cityofjob) // Number of managers in that industry
	egen `k'_employer = total((`k' == 1) * employer), by(cityofjob) // Number of employers in that industry
}

local vars "urban gender age foreigner inschool publicschool neverschool educationlevel manager manager_public manager_priv employed multiplejobs informal formal selfemployed employer  agriculture extractive manufacturing electric construction rw transportation accomodation finance profserv education health publicadmin dservices international poorlydefined worksincity total_employees total_selfemployed total_formal total_infomal female_manager_public female_manager_priv total_female_employed manager_t manager_priv_t manager_public_t female_manager_t female_manager_priv_t female_manager_public_t female total_female_informal workage_census female_informal female_workage total_female_self total_female_workage *_count *_female female_lfp_census *_fmanager *_manager *_femployer *_employer"

keep `vars' cityofjob

collapse (mean) `vars', by(cityofjob)

* Derived Variables of Female Leadership by Industry

foreach k in agriculture extractive manufacturing electric construction rw transportation accomodation finance profserv education health publicadmin dservices international poorlydefined {
	
	// Display the current iteration
    display("Processing sector: `k'")

	gen share_fmanager_`k' = `k'_fmanager / `k'_manager
}

save "/Users/jpmvbastos/Documents/GitHub/CorruptionWomen/CorruptionWomen_Over40-master.dta"
