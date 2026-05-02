*Cleaning Unclassified HF Comorbidities

*STEP 1: clean individual comorbidities --> remove duplicates, create variables
*HTN
clear
cd "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\Heart Failure Raw Files"
use heartfailure_hfuc_hypertension
rename ScrSSN scrssn
bysort scrssn: gen scrssn_n=_n
keep if scrssn_n==1
keep scrssn
gen htn=1
save "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\New Files Mortality\hfuc_htn.dta"

*Diabetes
clear
use heartfailure_hfuc_diabetes
rename ScrSSN scrssn
bysort scrssn: gen scrssn_n=_n
keep if scrssn_n==1
keep scrssn
gen dm=1
save "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\New Files Mortality\hfuc_dm.dta"

*CAD
clear
use heartfailure_hfuc_cad
bysort scrssn: gen scrssn_n=_n
keep if scrssn_n==1
keep scrssn
gen cad=1
save "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\New Files Mortality\hfuc_cad.dta", replace

*MI
clear
use heartfailure_hfuc_mi
bysort scrssn: gen scrssn_n=_n
keep if scrssn_n==1
keep scrssn
gen mi=1
save "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\New Files Mortality\hfuc_mi.dta", replace

*Stroke
clear
use heartfailure_hfuc_stroke
bysort scrssn: gen scrssn_n=_n
keep if scrssn_n==1
keep scrssn
gen stroke=1
save "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\New Files Mortality\hfuc_stroke.dta", replace

*PAD
clear
use heartfailure_hfuc_pad
bysort scrssn: gen scrssn_n=_n
keep if scrssn_n==1
keep scrssn
gen pad=1
save "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\New Files Mortality\hfuc_pad.dta"

*AF
clear
use heartfailure_hfuc_affinal
rename ScrSSN scrssn
bysort scrssn: gen scrssn_n=_n
keep if scrssn_n==1
keep scrssn
gen af=1
save "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\New Files Mortality\hfuc_af.dta"

*Prior PPM/ICD --> note that both PPM and ICD are combined in this file
clear
use heartfailure_hfuc_priorpmdc
bysort scrssn: gen scrssn_n=_n
keep if scrssn_n==1
keep scrssn
gen ppmicd=1
save "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\New Files Mortality\hfuc_ppmicd.dta"

*CKD
clear
use heartfailure_hfuc_kd
bysort scrssn: gen scrssn_n=_n
keep if scrssn_n==1
keep scrssn
gen ckd=1
*note that ICD codes also include ESRD
save "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\New Files Mortality\hfuc_ckd.dta", replace

*ESRD
clear
use heartfailure_hfuc_esrd
bysort scrssn: gen scrssn_n=_n
keep if scrssn_n==1
keep scrssn
gen esrd=1
save "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\New Files Mortality\hfuc_esrd.dta" 

*Chronic lung disease (previously "COPD")
clear
use heartfailure_hfuc_copd
bysort scrssn: gen scrssn_n=_n
keep if scrssn_n==1
keep scrssn
gen lungdz=1
save "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\New Files Mortality\hfuc_lungdz.dta"

*Chronic liver disease
clear
use heartfailure_hfuc_liverdisease
bysort scrssn: gen scrssn_n=_n
keep if scrssn_n==1
keep scrssn
gen liverdz=1
save "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\New Files Mortality\hfuc_liverdz.dta"

*Hypothyroidism
clear
use heartfailure_hfuc_hypothyr
bysort scrssn: gen scrssn_n=_n
keep if scrssn_n==1
keep scrssn
gen hypothyroid=1
save "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\New Files Mortality\hfuc_hypothyroid.dta"

*Depression
clear
use heartfailure_hfuc_depression
bysort scrssn: gen scrssn_n=_n
keep if scrssn_n==1
keep scrssn
gen depression=1
save "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\New Files Mortality\hfuc_depression.dta"

*Alcohol use disorder
use heartfailure_hfuc_alcoholabuse
bysort scrssn: gen scrssn_n=_n
keep if scrssn_n==1
keep scrssn
gen alcohol=1
save "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\New Files Mortality\hfuc_alcohol.dta", replace

*Polysubstance use disorder
clear
use heartfailure_hfuc_polyabuse
bysort scrssn: gen scrssn_n=_n
keep if scrssn_n==1
keep scrssn
gen polyabuse=1
save "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\New Files Mortality\hfuc_polyabuse.dta", replace

*Schizophrenic disorder
clear
use heartfailure_hfuc_schizo
bysort scrssn: gen scrssn_n=_n
keep if scrssn_n==1
keep scrssn
gen schizo=1
save "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\New Files Mortality\hfuc_schizo.dta", replace

*Malignancy
clear
use heartfailure_hfuc_malignancy
bysort scrssn: gen scrssn_n=_n
keep if scrssn_n==1
keep scrssn
gen cancer=1
save "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\New Files Mortality\hfuc_malignancy.dta", replace

*Smoking
clear
use heartfailure_hfuc_smoke
rename ScrSSN scrssn
rename SMOKE smoke
bysort scrssn: gen scrssn_n=_n
keep if scrssn_n==1
keep scrssn smoke
save "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\New Files Mortality\hfuc_smoke.dta", replace

***STEP 2: merging
clear
use "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\New Files Mortality\hfuc_htn.dta"
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\New Files Mortality\hfuc_dm.dta"
drop _merge
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\New Files Mortality\hfuc_cad.dta"
drop _merge
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\New Files Mortality\hfuc_mi.dta"
drop _merge
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\New Files Mortality\hfuc_stroke.dta"
drop _merge
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\New Files Mortality\hfuc_pad.dta"
drop _merge
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\New Files Mortality\hfuc_af.dta"
drop _merge
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\New Files Mortality\hfuc_ppmicd.dta"
drop _merge
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\New Files Mortality\hfuc_ckd.dta"
drop _merge
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\New Files Mortality\hfuc_esrd.dta"
drop _merge
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\New Files Mortality\hfuc_lungdz.dta"
drop _merge
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\New Files Mortality\hfuc_liverdz.dta"
drop _merge
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\New Files Mortality\hfuc_hypothyroid.dta"
drop _merge
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\New Files Mortality\hfuc_depression.dta"
drop _merge
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\New Files Mortality\hfuc_alcohol.dta"
drop _merge
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\New Files Mortality\hfuc_polyabuse.dta"
drop _merge
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\New Files Mortality\hfuc_schizo.dta"
drop _merge
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\New Files Mortality\hfuc_malignancy.dta"
drop _merge
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\New Files Mortality\hfuc_smoke.dta"
drop _merge

recode htn dm cad mi stroke pad af ppmicd ckd esrd lungdz liverdz hypothyroid depression alcohol polyabuse schizo cancer smoke (.=0)

gen hf_type=3

save "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\New Files Mortality\hfuc_comorbidities.dta", replace
