/* Recodes all relevant variables using the Census documentation*/ 

*Location Info and ID's 
rename v0001 state_id
rename v0002 munic_id
rename v0300 hh_id 
rename v1001 region_id
rename v1004 metroarea_id
egen ibge_code = concat(state_id munic_id)
destring ibge_code, replace

rename v1006 urban 
replace urban = 0 if urban == 2

* Basic Demographics
rename v0601 gender
rename v6033 age
rename v0606 race

gen female = 0
replace female = 1 if gender ==2

* Location of Birth
rename v0618 bornincity
rename v0619 borninstate
rename v6224 foreign_country

gen foreigner = 0 
replace foreigner = 1 if v0622==2

* Migration / Time living in country
rename v0624 yearsincity 
replace yearsincity = age if bornincity==1

* Schooling 
rename v0627 literate 
replace literate = 0 if literate == 2

/* v0628: Attends School or Pre-School?
1 - Yes, Public
2 - Yes, Private
3 - No, but attended in the past
4 - Never attended
*/

gen inschool=0 if v0628 !=.
replace inschool=1 if v0628==1 | v0628==2

gen publicschool = 0 if v0628 !=.
replace publicschool = 1 if v0628 == 1

gen neverschool = 0 if v0628 !=.
replace neverschool = 1 if v0628 == 4 

gen v6400_s = "" /* Transforms codes to string, to allow for encoding*/
replace v6400_s = "No schooling or incomplete primary education" if v6400==1
replace v6400_s = "Complete primary, incomplete secondary (high school)" if v6400==2
replace v6400_s = "Complete secondary, incomplete college" if v6400==3
replace v6400_s = "College Degree" if v0635==1
replace v6400_s = "Masters" if v0635==2
replace v6400_s = "Doctoral" if v0635==3
encode v6400_s, gen(educationlevel)


* Share population 25 or older with college
/* Share population 18 or older with high school 

rename v6352 major_code 
tostring(major_code), replace
gen major = "Other" if major_code !="." 
replace major = "Law" if substr(major_code,1,2)=="38"
replace major = "Arts" if substr(major_code,1,2)=="21"
replace major = "Education" if substr(major_code,1,2)=="14"
replace major = "Social Sciences" if major_code=="310" | major_code=="312" | major_code=="313" 
replace major = "Economics" if major_code =="314"
replace major = "Humanities" if substr(major_code,1,2)=="22"
replace major = "Business & Commerce" if substr(major_code, 1, 2)=="34" & major_code!="344"
replace major = "Accounting" if major_code=="344"
replace major = "Psychology" if major_code=="311"
replace major = "Science, Technology, & Engineering" if substr(major_code,1,2)=="42" | substr(major_code,1,2)=="44" ///
										| substr(major_code,1,2)=="46" | substr(major_code,1,2)=="48" ///
										| substr(major_code,1,2)=="52" 
replace major = "Services" if substr(major_code,1,1)=="8" 
replace major = "Health Sciences" if major_code=="311" | substr(major_code,1,2)=="72" 
replace major = "Construction (Architecture & Civil Engineering)" if substr(major_code,1,2)=="58"

*/ 

* Employment Characteristics
label define typeworkerlabel 1 "Formal Employee (Carteira Assinada)" 2 "Military or Police" /// 
3 "Statutary Public Employee" 4 "Informal Employee" 5 "Self-Employed" 6 "Employer" 7 "Unpaid Job"
label values v0648 typeworkerlabel
rename v0648 typeofworker


gen employed = 0 if v0641!=. | v0642!=. | typeofworker!=. | v6511==0 | v6471!=. /*v0641=Worked on reference week*/ 
replace employed = 1 if (v0641==1 | v0642==1 | typeofworker!=.) & typeofworker!=7 & v6511>0

gen multiplejobs = 0 if employed==1
replace multiplejobs = 1 if v0645 == 2

gen informal = 0 if employed==1
replace informal = 1 if typeofworker==4 & employed==1

gen formal = 0 if employed==1
replace formal = 1 if employed==1 & typeofworker!=4

gen selfemployed = 0 if employed==1
replace selfemployed = 1 if typeofworker==5 & employed==1

gen employer = 0 if employed==1
replace employer = 1 if typeofworker==6 & employed==1

gen n_employees = v0649 if typeofworker==6 /*How many employees did you have (conditional on being employer)*/ 

replace v0650 = 0 if v0650 == 3 /* No */ 
replace v0650 = 1 if v0650 == 1 | v0650 == 2
rename v0650 socialsecurity /*Contributed to social security dummy?*/

rename v0653 weeklyhours\

** OCCUPATIONS

tostring(v6461), gen(occupation)

* ALL MANAGERS

gen manager = 0
replace manager = 1 if substr(occupation, 1, 1)=="1" 

gen manager_public = 0
replace manager_public = 1 if substr(occupation, 1, 2) == "11"

gen manager_priv = 0
replace manager_priv = 1 if manager==1 & manager_public==0

**** FEMALE MANAGERS 

gen female_manager = 0
replace female_manager = 1 if manager==1 & gender==2

gen female_manager_public = 0
replace female_manager_public = 1 if manager_public==1 & gender==2

gen female_manager_priv = 0
replace female_manager_priv = 1 if manager_priv==1 & gender==2



*** INDUSTRIES 

tostring(v6471), gen(worksector)
gen work_code = substr(worksector,1,2) 

/* 
Because the industry codes are stored as integers, it omits first zero of the code. 
(e.g. 01101 is stored as 1101). Using numeric booleans for the codes < 10000

*/ 
gen agriculture = 0 if v6471!=. &  employed==1
replace agriculture = 1 if v6471 < 3003  & employed==1

gen extractive = 0 if v6471!=. &  employed==1
replace extractive = 1 if v6471 >= 5000 & v6471<10000 & employed==1

* now using strings

gen manufacturing = 0 if work_code!="." & employed==1
replace manufacturing = 1 if (work_code == "10" | work_code == "11" | work_code == "12" | work_code == "13" | work_code == "14" | work_code == "15" | work_code == "16" | work_code == "17" | work_code == "18" | work_code == "19" | work_code == "20" | work_code == "21" | work_code == "22" | work_code == "23" | work_code == "24" | work_code == "25" | work_code == "26" | work_code == "27" | work_code == "28" | work_code == "29" | work_code == "30" | work_code == "31" | work_code == "32" | work_code == "33"| work_code == "58"| work_code == "95") & employed==1 & agriculture!=1 & extractive!=1

gen electric = 0 if work_code!="." &  employed==1
replace electric = 1 if (work_code == "35"| work_code == "36"| work_code == "37" | work_code == "38" | work_code == "39") & employed==1 & agriculture!=1 & extractive!=1

gen construction = 0 if work_code!="." &  employed==1
replace construction = 1 if (work_code == "41" | work_code == "42" | work_code == "43") & employed==1 & agriculture!=1 & extractive!=1


gen rw = 0 if work_code!="." &  employed==1
replace rw = 1 if (work_code == "45" | work_code == "48") &  employed==1 & agriculture!=1 & extractive!=1

gen transportation = 0 if work_code!="." &  employed==1
replace transportation = 1 if (work_code == "49" |work_code == "50" | work_code == "51" | work_code == "52" | work_code == "53" | work_code == "61" |  work_code == "79") &  employed==1 & agriculture!=1 & extractive!=1

gen accomodation = 0 if work_code!="." &  employed==1 
replace accomodation = 1 if (work_code == "55" |work_code == "56" | work_code == "59" |work_code == "60"| work_code == "90" | work_code == "91" | work_code == "92" | work_code == "93" | work_code == "94") &  employed==1 & agriculture!=1 & extractive!=1

gen finance = 0 if work_code!="." &  employed==1
replace finance = 1 if (work_code == "64" | work_code == "65" | work_code == "66" | work_code == "77")  &  employed==1 & agriculture!=1 & extractive!=1

gen profserv = 0 if work_code!="." &  employed==1 
replace profserv = 1 if (work_code == "62"|  work_code == "63" |work_code == "68"|  work_code == "69" | work_code == "70" | work_code == "71" | work_code == "72" | work_code == "73" | work_code == "74" | work_code == "80" | work_code == "81" | work_code == "82") &  employed==1 & agriculture!=1 & extractive!=1


gen education =  0 if work_code!="." &  employed==1
replace education = 1 if work_code == "85" &  employed==1 & agriculture!=1 & extractive!=1

gen health = 0 if work_code!="." &  employed==1
replace health = 1 if (work_code == "75" | work_code == "86" | work_code == "87" | work_code == "88") &  employed==1 & agriculture!=1 & extractive!=1

gen publicadmin = 0 if work_code!="." &  employed==1
replace publicadmin = 1 if work_code == "84" &  employed==1 & agriculture!=1 & extractive!=1

gen dservices = 0 if work_code!="." &  employed==1
replace dservices = 1 if work_code == "97" &  employed==1 & agriculture!=1 & extractive!=1

gen international = 0 if work_code!="." &  employed==1
replace international = 1 if work_code == "99" &  employed==1 & agriculture!=1 & extractive!=1

gen poorlydefined = 0 if work_code!="." &  employed==1
replace poorlydefined = 1 if work_code == "00" &  employed==1 & agriculture!=1 & extractive!=1


gen worksincity = 0 if employed==1 & v0660!=. 
replace worksincity = 1 if (v0660==1 | v0660==2) & employed==1

rename v6604 cityofjob
replace cityofjob = ibge_code if worksincity==1 
replace cityofjob = . if employed!=1


* Totals
egen total_employees = total(employed), by(cityofjob)
egen total_selfemployed = total(selfemployed), by(cityofjob)
egen total_formal = total(formal), by(cityofjob)
egen total_infomal = total(informal), by(cityofjob)
egen total_employer = total(employer), by(cityofjob)

save  "/Users/jpmvbastos/Library/CloudStorage/OneDrive-TexasTechUniversity/Personal/Projects/Data/Census/CENSO10_BRASIL.dta", replace

* Female totals 
egen total_female = total(female), by(cityofjob)
egen total_female_emp = total(employed*female), by(cityofjob)
egen total_female_self = total(selfemployed*female), by(cityofjob)
egen total_female_employer = total(employer*female), by(cityofjob)

* Manager Totals 
egen manager_t = total(manager), by(cityofjob)
egen manager_priv_t = total(manager_priv), by(cityofjob)
egen manager_public_t = total(manager_public), by(cityofjob)

* Female Manager Totals 
egen female_manager_t = total(female_manager), by(cityofjob)
egen female_manager_priv_t = total(female_manager_priv), by(cityofjob)
egen female_manager_public_t = total(female_manager_public), by(cityofjob)


save  "/Users/jpmvbastos/Library/CloudStorage/OneDrive-TexasTechUniversity/Personal/Projects/Data/Census/CENSO10_BRASIL.dta", replace


use  "/Users/jpmvbastos/Library/CloudStorage/OneDrive-TexasTechUniversity/Personal/Projects/Data/Census/CENSO10_BRASIL.dta"

drop v0625 v6252 v6254 v6256 v0626 v6262 v6264 v6266 literate v0628 v0629 v0630 v0631 v0632 v0633 v0634 v0635 v6400 v6352 v6354 v6356 v0636 v6362 v6364 v6366 v0637 v0638 v0639 v0640 v0641 v0642 v0643 v0644 v0645 v6461 v0649 v0650 v0651 v6511 v6513 v6514 v0652 v6521 v6524 v6525 v6526 v6527 v6528 v6529 v6530 v6531 v6532 v0653 v0654 v0655 v0656 v0657 v0658 v0659 v6591 v0660 v6602 v0661 v0662 v0663 v6631 v6632 v6633 v0664 v6641 v6642 v6643 v0665 v6660 v6664 v0667 v0668 v6681 v6682 v0669 v6691 v6692 v6693 v6800 v0670 v0671 v6900 v6910 v6920 v6930 v6940 v6121 v0604 v0605 v5020 v5060 v5070 v5080 v6462 v6472 v5110 v5120 v5030 v5040 v5090 v5100 v5130 v1005 v0011 v0010 v1002 v1003 v0502 v0504 v6036 v6037 v6040 v0620 v0621 v0622 v6222 v0623 v6471 v6400_s


* Counts per Category
 
foreach k in agriculture extractive manufacturing electric construction rw transportation accomodation finance profserv education health publicadmin dservices international poorlydefined {

	egen `k'_count = total(employed*`k'), by(cityofjob)
	egen `k'_female = total(employed*`k'*female), by(cityofjob)
	egen manager_`k' = total(manager*`k'), by(cityofjob)
	egen female_manager_`k' = total(female_manager*`k'), by(cityofjob)
	
}



local vars "foreigner inschool publicschool neverschool educationlevel manager manager_public manager_priv employed multiplejobs informal formal selfemployed employer agriculture extractive manufacturing electric construction rw transportation accomodation finance profserv education health publicadmin dservices international poorlydefined worksincity total_employees total_selfemployed total_formal total_infomal female_manager female_manager_public female_manager_priv manager_t manager_priv_t manager_public_t female_manager_t female_manager_priv_t female_manager_public_t total_employer female total_female total_female_emp total_female_self total_female_employer agriculture_count agriculture_female manager_agriculture female_manager_agriculture extractive_count extractive_female manager_extractive female_manager_extractive manufacturing_count manufacturing_female manager_manufacturing female_manager_manufacturing electric_count electric_female manager_electric female_manager_electric construction_count construction_female manager_construction female_manager_construction rw_count rw_female manager_rw female_manager_rw transportation_count transportation_female manager_transportation female_manager_transportation accomodation_count accomodation_female manager_accomodation female_manager_accomodation finance_count finance_female manager_finance female_manager_finance profserv_count profserv_female manager_profserv female_manager_profserv education_count education_female manager_education female_manager_education health_count health_female manager_health female_manager_health publicadmin_count publicadmin_female manager_publicadmin female_manager_publicadmin dservices_count dservices_female manager_dservices female_manager_dservices international_count international_female manager_international female_manager_international poorlydefined_count poorlydefined_female manager_poorlydefined female_manager_poorlydefined"


keep `vars' cityofjob

collapse (mean) `vars', by(cityofjob)




