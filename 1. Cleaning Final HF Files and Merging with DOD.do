**HFpEF
**STEP 1A: clean main HFpEF file
clear all
use "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\Heart Failure Raw Files\heartfailure_finalhfpef.dta"

drop PatientSID sta3n
rename ScrSSN scrssn
bysort scrssn: gen scrssn_n=_n
keep if scrssn_n==1
drop scrssn_n
rename HFpEFType hf_certainty

save "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\New Files Mortality\hfpef_cleaned.dta", replace

**STEP 1B: merge with dod (date of death) file
clear
use "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\Heart Failure Raw Files\heartfailure_hfpef_dod.dta"
rename ScrSSN scrssn
bysort scrssn: gen scrssn_n=_n
keep if scrssn_n==1
drop scrssn_n
rename MPI_DOD dod


merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\New Files Mortality\hfpef_cleaned.dta"
drop _merge
gen hf_type=1

save "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\New Files Mortality\hfpef_dod_cleaned.dta", replace

*******************************************************************
**HFrEF
**STEP 2A: clean main HFrEF file
clear all
use "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\Heart Failure Raw Files\heartfailure_finalhfref.dta"

drop PatientSID sta3n
rename ScrSSN scrssn
bysort scrssn: gen scrssn_n=_n
keep if scrssn_n==1
drop scrssn_n
rename HFrEFType hf_certainty

save "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\New Files Mortality\hfref_cleaned.dta", replace

**STEP 2B: merge with dod file
clear all
use "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\Heart Failure Raw Files\heartfailure_hfref_dod.dta"
rename ScrSSN scrssn
bysort scrssn: gen scrssn_n=_n
keep if scrssn_n==1
drop scrssn_n
rename MPI_DOD dod

merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\New Files Mortality\hfref_cleaned.dta"
drop _merge
gen hf_type=2

save "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\New Files Mortality\hfref_dod_cleaned.dta", replace

*******************************************************************
**Unclassified HF
**STEP 3A: clean main unclassified HF file
clear all
use "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\Heart Failure Raw Files\heartfailure_finalhfuc.dta"

drop PatientSID sta3n
rename ScrSSN scrssn
bysort scrssn: gen scrssn_n=_n
keep if scrssn_n==1
drop scrssn_n
rename HFUCType hf_certainty

save "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\New Files Mortality\hfunc_cleaned.dta", replace 

**STEP 3B: merge with dod file
clear 
use "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\Heart Failure Raw Files\heartfailure_hfuc_dod.dta" 
rename ScrSSN scrssn
bysort scrssn: gen scrssn_n=_n
keep if scrssn_n==1
drop scrssn_n
rename MPI_DOD dod

merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\New Files Mortality\hfunc_cleaned.dta"
drop _merge 
gen hf_type=3

save "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\New Files Mortality\hfunc_dod_cleaned.dta"

****************************************************************
**STEP 4: merging all HF subtypes/dod files
clear all
use "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\New Files Mortality\hfpef_dod_cleaned.dta"
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\New Files Mortality\hfref_dod_cleaned.dta"
drop _merge
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\New Files Mortality\hfunc_dod_cleaned.dta"
drop _merge

label define hf_type 1 "HFpEF" 2 "HFrEF" 3 "Unclassified"
label values hf_type hf_type

encode hf_certainty, gen(hfcertainty)
drop hf_certainty 
rename hfcertainty hf_certainty 

save "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\New Files Mortality\hf_dod_cleaned.dta", replace

******************************************************************
