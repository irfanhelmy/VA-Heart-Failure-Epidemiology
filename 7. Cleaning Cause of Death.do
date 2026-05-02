*Cause of death

*STEP 1: merge cause of death file with file containing MPI_DOD
clear
use "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\Heart Failure Raw Files\fy25_33_sundaram_15jan2026.dta"
keep scrssn UnderlyingCause_NDI DOD_NDI rec_cond1
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\New Files Mortality\hf_demographics_dod.dta"
drop if _merge==1
drop _merge

*STEP 2: define CV death, non-CV death, and unknown cause of death

*Extract first letter out of ICD codes for Underlying Cause of Death & Record-Axis Condition 1
gen firstletter=substr( UnderlyingCause_NDI,1,1)
gen firstletter2=substr( rec_cond1, 1, 1)

*CV death definition: both Underlying Cause of Death & Record-Axis Condition 1 must have ICD-10 codes of death from I00-I99 (equivalent to first letter=="I"). Exclude obviously non-CV ICD-10 codes that start with "I": 
gen death=0 if dod==.
replace death=1 if firstletter=="I" & firstletter2=="I"
replace death=2 if death!=1 & death!=0
replace death=3 if dod!=. & DOD_NDI==.

*define labels for cause of death
label define death 0 "Alive" 1 "CV Death" 2 "Non-CV Death" 3 "Unknown Cause of Death"
label values death death

save "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\New Files Mortality\causeofdeath.dta", replace

*STEP 3: Descriptive analysis

tab death
tab death if death!=0
tab death hf_type if death!=0, col
tab hfyear death if death!=0, row
*^among those who are not dead

tab hfyear death if death!=0 & hf_type==1, row
tab hfyear death if death!=0 & hf_type==2, row
tab hfyear death if death!=0 & hf_type==3, row
*separating cause of death by HF type (HFpEF, HFrEF, unclassified)

*STEP 4: One-year CV mortality (non-CV death as competing risk)
*STEP 4A: setting up data
gen hfdate=dofc( FirstHF_dischargedatetime)
gen hfyear=year(hfdate)
gen follow_up=hfdate+365.25
gen outcome=min(dod, follow_up)

*chose 2000, 2009, 2018, because we do not have clear cause of death info after 2022, and 2020-2022 estimates appear to be unstable

keep if hfyear==2000 | hfyear==2009 | hfyear==2018
recode hfyear 2000=1 2009=2 2018=3

*merging CV death with unknown cause of death
recode death 3=1

*STEP 4B: survival analysis
stset outcome, id(scrssn) origin(hfdate) failure(death==1) scale(365.25)

*Unadjusted
stcrreg i.hfyear, compete(death==2)
stcrreg i.hfyear if hf_type==2, compete(death==2)
stcrreg i.hfyear if hf_type==1, compete(death==2)

*Adjusted for age + sex
gen agegp=age
recode agegp min/50=1 51/60=2 61/70=3 71/80=4 81/90=5 90/max=6

stcrreg i.hfyear agegp sex, compete(death==2)
stcrreg i.hfyear agegp sex if hf_type==2, compete(death==2)
stcrreg i.hfyear agegp sex if hf_type==1, compete(death==2)