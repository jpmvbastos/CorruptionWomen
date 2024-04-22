* Getting census data 
* For documentation, see https://github.com/datazoompuc/datazoom_social_Stata 

/*  
If you still don't have the .dta file for each state, run the code below: 

datazoom_censo, years( 2010 ) ufs( RO AC AM RR PA AP TO MA PI CE RN PB PE AL SE BA MG ES RJ SP PR SC RS MS MT GO DF ) ///
original(/Users/joamacha/Desktop/Microdata Censo/ALL/2010) saving(/Users/joamacha/Desktop/Microdata Censo/ALL/2010) pes english


*/ 

cd "/Users/jpmvbastos/Library/CloudStorage/OneDrive-TexasTechUniversity/Personal/Projects/Data/Census/"


*Read first file and append other states 
use "CENSO10_AC_pes.dta", clear

append using "CENSO10_RO_pes.dta"
append using "CENSO10_AM_pes.dta"
append using "CENSO10_RR_pes.dta"
append using "CENSO10_PA_pes.dta"
append using "CENSO10_AP_pes.dta"
append using "CENSO10_TO_pes.dta"
append using "CENSO10_MA_pes.dta"
append using "CENSO10_PI_pes.dta"
append using "CENSO10_CE_pes.dta"
append using "CENSO10_RN_pes.dta"
append using "CENSO10_PB_pes.dta"
append using "CENSO10_PE_pes.dta"
append using "CENSO10_AL_pes.dta"
append using "CENSO10_SE_pes.dta"
append using "CENSO10_BA_pes.dta"
append using "CENSO10_MG_pes.dta"
append using "CENSO10_ES_pes.dta"
append using "CENSO10_RJ_pes.dta"
append using "CENSO10_SP_pes.dta"
append using "CENSO10_PR_pes.dta"
append using "CENSO10_SC_pes.dta"
append using "CENSO10_RS_pes.dta"
append using "CENSO10_MS_pes.dta"
append using "CENSO10_MT_pes.dta"
append using "CENSO10_GO_pes.dta"
append using "CENSO10_DF_pes.dta"

*Save dataset with all states 
save "CENSO10_BRASIL.dta",replace

