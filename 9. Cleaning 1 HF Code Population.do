***Cleaning excluded non-chronic HF cohort (i.e. only 1 HF code)

*STEP 1: clean main file
clear all
use "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\Heart Failure Raw Files\heartfailure_1hfcode.dta"
gen hfdate=dofc( FirstHF_DischargeDatetime)
*confirmed that FirstHF_DischargeDatetime is identical to DischargeDateTime, will only keep one of them
keep scrssn hfdate 
bysort scrssn: keep if _n==1
save "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\New Files Mortality\hf_1hfcode_cleaned.dta", replace

*STEP 2: clean EF file
clear
use "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\Heart Failure Raw Files\heartfailure_1hfcode_ef.dta"
rename ScrSSN scrssn
gen hfdate=dofc(FirstHF_dischargedatetime)
gen echodate=dofc(ValueDateTime)
gen diff=abs(echodate-hfdate)
bysort scrssn diff: keep if _n==1
bysort scrssn: keep if _n==1
drop diff
gen echodiff=echodate-hfdate
keep scrssn Low_value High_Value ValueDateTime echodiff

gen hf_type=1 if Low_value>=50 & !missing(Low_value)
replace hf_type=2 if Low_value<50
replace hf_type=3 if missing(Low_value)
save "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\New Files Mortality\hf_1hfcode_ef_cleaned.dta", replace

*STEP 3: clean age/sex file and merge with dod file
clear
use "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\Heart Failure Raw Files\heartfailure_1hfcode_age.dta"
drop FirstHF_Dischargedatetime
merge m:m ScrSSN using "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\Heart Failure Raw Files\heartfailure_1hfcode_dod.dta"
drop _merge
rename ScrSSN scrssn
bysort scrssn: keep if _n==1
save "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\New Files Mortality\hf_1hfcode_agesexdod_cleaned.dta", replace

*STEP 4: clean HF hospitalization files
clear
use "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\Heart Failure Raw Files\heartfailure_1hfcode_hfhospi.dta"
keep scrssn FirstHF_Dischargedatetime DischargeDateTime
*remove duplicate hospitalizations
**keep all hospitalizations:
bysort scrssn DischargeDateTime: keep if _n==1
save "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\New Files Mortality\hf_1hfcode_allhfh.dta"
**keep only first hospitalization:
bysort scrssn: keep if _n==1
save "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\New Files Mortality\hf_1hfcode_firsthfh.dta"

*STEP 5: merge all files (for HFH, use first HFH file first)
clear
use "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\New Files Mortality\hf_1hfcode_cleaned.dta"
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\New Files Mortality\hf_1hfcode_ef_cleaned.dta"
drop _merge
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\New Files Mortality\hf_1hfcode_agesexdod_cleaned.dta"
drop _merge
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\New Files Mortality\hf_1hfcode_firsthfh.dta"
drop _merge
recode hf_type .=3
drop FirstHF_Dischargedatetime
gen hfhdate=dofc( DischargeDateTime)
drop DischargeDateTime
save "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\New Files Mortality\hf_1hfcode_merged.dta"