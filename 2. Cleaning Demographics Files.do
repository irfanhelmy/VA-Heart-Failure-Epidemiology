**Cleaning age/sex/zip code files

*STEP 1: clean/merge BMI files
clear
use "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\Heart Failure Raw Files\heartfailure_hfpef_bmi.dta"
merge m:m ScrSSN using "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\Heart Failure Raw Files\heartfailure_hfref_bmi.dta"
drop _merge
merge m:m ScrSSN using "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\Heart Failure Raw Files\heartfailure_hfuc_bmi.dta"
drop _merge

rename ScrSSN scrssn
bysort scrssn: gen scrssn_n=_n
keep if scrssn_n==1
keep scrssn bmi

save "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\New Files Mortality\hf_bmi_cleaned.dta"

**STEP 2: merge HF subtypes
clear
use "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\Heart Failure Raw Files\heartfailure_hfpef_age.dta"
merge m:m ScrSSN using "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\Heart Failure Raw Files\heartfailure_hfref_age.dta"
drop _merge
merge m:m ScrSSN using "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\Heart Failure Raw Files\heartfailure_hfuc_age.dta"
drop _merge


*STEP 2B: removing duplicates, define labels
rename ScrSSN scrssn 
bysort scrssn: gen scrssn_n=_n
keep if scrssn_n==1
drop scrssn_n 

replace SEX="1" if SEX=="M"
replace SEX="2" if SEX=="F"
destring SEX, replace
rename SEX sex
label define sexlabel 1 "Male" 2 "Female"
label values sex sexlabel

save "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\New Files Mortality\hf_agesex_cleaned.dta"

**STEP 3: merge with Race files
clear
use "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\Heart Failure Raw Files\heartfailure_hfref_raceethn.dta"
merge m:m ScrSSN using "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\Heart Failure Raw Files\heartfailure_hfpef_raceethn.dta"
drop _merge
merge m:m ScrSSN using "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\Heart Failure Raw Files\heartfailure_hfuc_raceethn.dta"
drop _merge

rename ScrSSN scrssn
bysort scrssn: gen scrssn_n=_n
keep if scrssn_n==1

/*gen hf_certainty=1 if HFrEFType=="Definitive" | HFpEFType=="Definitive" | HFUCType=="Definitive"
replace hf_certainty=0 if  HFrEFType=="Possible" | HFpEFType=="Possible" | HFUCType=="Possible"*/

keep scrssn race ethnicity

replace ethnicity="Hispanic or Latino" if ethnicity=="HISPANIC OR LATINO"
replace ethnicity="Not Hispanic or Latino" if ethnicity=="NOT HISPANIC OR LATINO"

replace race="Black or African American" if race=="BLACK OR AFRICAN AMERICAN"
replace race="White" if race=="WHITE"
replace race="Asian" if race=="ASIAN"
replace race="American Indian or Alaska Native" if race=="AMERICAN INDIAN OR ALASKA NATIVE"

*encode race, gen(race2)
*recode race2 6=1 3=2 1/2=3 4/5=3
*replace race="Other" if race=="American Indian or Alaska Native" | race=="Asian" | race=="UNKNOWN" | race=="Native Hawaiian or Other Pacific Islander"

save "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\New Files Mortality\hf_race_cleaned.dta", replace

**STEP 4: merge with HF DOD file (from do-file #1)
clear
use "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\New Files Mortality\hf_dod_cleaned.dta"
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\New Files Mortality\hf_bmi_cleaned.dta"
drop _merge
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\New Files Mortality\hf_agesex_cleaned.dta"
drop FirstHF_Dischargedatetime _merge
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\New Files Mortality\hf_race_cleaned.dta"
drop _merge

save "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\New Files Mortality\hf_demographics_dod.dta", replace