*Cleaning HFpEF Comorbidities

*STEP 1: clean individual comorbidities --> remove duplicates, create variables
*Hypertension
clear
cd "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\Heart Failure Raw Files"
use heartfailure_hfpef_hypertension
rename ScrSSN scrssn
bysort scrssn: gen scrssn_n=_n
keep if scrssn_n==1
keep scrssn
gen htn=1
save "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\New Files Mortality\hfpef_htn.dta"

*Diabetes
clear
use heartfailure_hfpef_diabetes
rename ScrSSN scrssn
bysort scrssn: gen scrssn_n=_n
keep if scrssn_n==1
keep scrssn
gen dm=1
save "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\New Files Mortality\hfpef_dm.dta"

*Coronary artery disease
clear
use heartfailure_hfpef_cad
bysort scrssn: gen scrssn_n=_n
keep if scrssn_n==1
keep scrssn
gen cad=1
save "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\New Files Mortality\hfpef_cad.dta", replace

*Myocardial infarction
clear
use heartfailure_hfpef_mi
bysort scrssn: gen scrssn_n=_n
keep if scrssn_n==1
keep scrssn
gen mi=1
save "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\New Files Mortality\hfpef_mi.dta", replace

*Stroke
clear
use heartfailure_hfpef_stroke
bysort scrssn: gen scrssn_n=_n
keep if scrssn_n==1
keep scrssn
gen stroke=1
save "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\New Files Mortality\hfpef_stroke.dta", replace

*Peripheral artery disease
clear
use heartfailure_hfpef_pad
bysort scrssn: gen scrssn_n=_n
keep if scrssn_n==1
keep scrssn
gen pad=1
save "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\New Files Mortality\hfpef_pad.dta"

*Atrial fibrillation
clear
use heartfailure_hfpef_affinal
rename ScrSSN scrssn
bysort scrssn: gen scrssn_n=_n
keep if scrssn_n==1
keep scrssn
gen af=1
save "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\New Files Mortality\hfpef_af.dta"

*Prior pacemaker (PPM) and implantable cardioverter-defibrillator --> note that both PPM and ICD are combined in this file
clear
use heartfailure_hfpef_priorpmdc
bysort scrssn: gen scrssn_n=_n
keep if scrssn_n==1
keep scrssn
gen ppmicd=1
save "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\New Files Mortality\hfpef_ppmicd.dta"

*Chronic kidney disease
clear
use heartfailure_hfpef_kd
bysort scrssn: gen scrssn_n=_n
keep if scrssn_n==1
keep scrssn
gen ckd=1
*note that ICD codes also include ESRD
save "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\New Files Mortality\hfpef_ckd.dta", replace

*End stage renal disease
clear
use heartfailure_hfpef_esrd
bysort scrssn: gen scrssn_n=_n
keep if scrssn_n==1
keep scrssn
gen esrd=1
save "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\New Files Mortality\hfpef_esrd.dta" 

*Chronic lung disease (previously "COPD")
clear
use heartfailure_hfpef_copd
bysort scrssn: gen scrssn_n=_n
keep if scrssn_n==1
keep scrssn
gen lungdz=1
save "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\New Files Mortality\hfpef_lungdz.dta"

*Chronic liver disease
clear
use heartfailure_hfpef_liverdisease
bysort scrssn: gen scrssn_n=_n
keep if scrssn_n==1
keep scrssn
gen liverdz=1
save "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\New Files Mortality\hfpef_liverdz.dta"

*Hypothyroidism
clear
use heartfailure_hfpef_hypothyr
bysort scrssn: gen scrssn_n=_n
keep if scrssn_n==1
keep scrssn
gen hypothyroid=1
save "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\New Files Mortality\hfpef_hypothyroid.dta"

*Depression
clear
use heartfailure_hfpef_depression
bysort scrssn: gen scrssn_n=_n
keep if scrssn_n==1
keep scrssn
gen depression=1
save "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\New Files Mortality\hfpef_depression.dta"

*Alcohol use disorder
use heartfailure_hfpef_alcoholabuse
bysort scrssn: gen scrssn_n=_n
keep if scrssn_n==1
keep scrssn
gen alcohol=1
save "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\New Files Mortality\hfpef_alcohol.dta", replace

*Polysubstance use disorder
clear
use heartfailure_hfpef_polyabuse
bysort scrssn: gen scrssn_n=_n
keep if scrssn_n==1
keep scrssn
gen polyabuse=1
save "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\New Files Mortality\hfpef_polyabuse.dta", replace

*Schizophrenic disorder
clear
use heartfailure_hfpef_schizo
bysort scrssn: gen scrssn_n=_n
keep if scrssn_n==1
keep scrssn
gen schizo=1
save "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\New Files Mortality\hfpef_schizo.dta", replace

*Malignancy
clear
use heartfailure_hfpef_malignancy
bysort scrssn: gen scrssn_n=_n
keep if scrssn_n==1
keep scrssn
gen cancer=1
save "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\New Files Mortality\hfpef_malignancy.dta", replace

*Smoking
clear
use heartfailure_hfpef_smoke
rename ScrSSN scrssn
rename SMOKE smoke
bysort scrssn: gen scrssn_n=_n
keep if scrssn_n==1
keep scrssn smoke
save "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\New Files Mortality\hfpef_smoke.dta", replace

***STEP 2: merging
clear
use "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\New Files Mortality\hfpef_htn.dta"
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\New Files Mortality\hfpef_dm.dta"
drop _merge
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\New Files Mortality\hfpef_cad.dta"
drop _merge
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\New Files Mortality\hfpef_mi.dta"
drop _merge
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\New Files Mortality\hfpef_stroke.dta"
drop _merge
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\New Files Mortality\hfpef_pad.dta"
drop _merge
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\New Files Mortality\hfpef_af.dta"
drop _merge
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\New Files Mortality\hfpef_ppmicd.dta"
drop _merge
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\New Files Mortality\hfpef_ckd.dta"
drop _merge
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\New Files Mortality\hfpef_esrd.dta"
drop _merge
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\New Files Mortality\hfpef_lungdz.dta"
drop _merge
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\New Files Mortality\hfpef_liverdz.dta"
drop _merge
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\New Files Mortality\hfpef_hypothyroid.dta"
drop _merge
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\New Files Mortality\hfpef_depression.dta"
drop _merge
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\New Files Mortality\hfpef_alcohol.dta"
drop _merge
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\New Files Mortality\hfpef_polyabuse.dta"
drop _merge
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\New Files Mortality\hfpef_schizo.dta"
drop _merge
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\New Files Mortality\hfpef_malignancy.dta"
drop _merge
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\New Files Mortality\hfpef_smoke.dta"
drop _merge

recode htn dm cad mi stroke pad af ppmicd ckd esrd lungdz liverdz hypothyroid depression alcohol polyabuse schizo cancer smoke (.=0)

gen hf_type=1

save "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\New Files Mortality\hfpef_comorbidities.dta", replace
