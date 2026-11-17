*Direct Standardization

**STEP 1: set up variables
clear
use "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\New Files Mortality\hf_demographics_dod.dta"

gen hfyear=year(hfdate)
replace hfdate2=hfdate if hfdate2==.
gen diff=hfdate2-hfdate
drop if abs(diff)>90
drop if age<18
drop if sex==.
drop if hfyear==2025

gen agegp=age
recode agegp min/50=1 51/60=2 61/70=3 71/80=4 81/90=5 90/max=6

save "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\New Files Mortality\hf_survival_analysis.dta"

**STEP 2: direct standardization
*Using US census data
clear
use "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\New Files Mortality\hf_survival_analysis.dta"

recode agegp 6=5
gen agesex=(agegp-1)*2 + sex

gen failure=1 if dod <= hfdate2+365
recode failure .=0

gen outcome=min(hfdate2+365, dod)
replace hfdate2=hfdate2-0.01 if hfdate2==dod
stset outcome, id(scrssn) origin(hfdate2) fail(failure) scale(365.25)

collapse (sum) deaths=_d (count) population=_d, by(hfyear agesex)
merge m:1 agesex using "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\New Files Mortality\census2000_reference_population.dta"

dstdize deaths population agesex, by(hfyear)