**STEP 1: set up variables
clear
use "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\New Files Mortality\hf_demographics_dod.dta"

gen hfdate=dofc(FirstHF_dischargedatetime)
gen hfyear=year(hfdate)

*Heart failure phenotype distribution with time
tab hfyear hf_type
tab hfyear hf_type, row

****STEP 2: One-year Mortlaity

*Crude annual mortality rates with time
gen failure=1 if dod <= hfdate+365
recode failure .=0

gen outcome=min(hfdate+365, dod)
stset outcome, id(scrssn) origin(hfdate) fail(failure) scale(365.25)

strate hfyear, per(100)
strate hfyear if hf_type==1, per(100)
strate hfyear if hf_type==2, per(100)
strate hfyear if hf_type==3, per(100)

gen agegp=age
recode agegp min/50=1 51/60=2 61/70=3 71/80=4 81/90=5 90/max=6
tab agegp

*Crude one-year mortality IRR:
preserve
keep if hfyear==2000 | hfyear==2012 | hfyear==2024
recode hfyear 2000=1 2012=2 2024=3
poisson _d i.hfyear, irr

*Adjusted one-year mortality IRR
poisson _d i.hfyear agegp, irr
poisson _d i.hfyear agegp sex, irr
bysort hf_type: poisson _d i.hfyear agegp sex, irr
restore

*Sensitivity analysis: only Definitive HFpEF
preserve
keep if hfyear==2000 | hfyear==2012 | hfyear==2024
recode hfyear 2000=1 2012=2 2024=3
drop if hf_certainty==2
bysort hf_type: poisson _d i.hfyear agegp sex, irr
restore

****STEP 3: Five-Year Mortality
drop failure outcome

gen failure=1 if dod <= hfdate+(365.25*5)
recode failure .=0

drop if hfyear>2020

gen outcome=min(hfdate+(365.25*5), dod)
stset outcome, id(scrssn) origin(hfdate) fail(failure) scale(365.25)

strate hfyear, per(100)
strate hfyear if hf_type==1, per(100)
strate hfyear if hf_type==2, per(100)
strate hfyear if hf_type==3, per(100)

*Crude five-year mortality IRR
preserve
keep if hfyear==2000 | hfyear==2010 | hfyear==2020
recode hfyear 2000=1 2010=2 2020=3
poisson _d i.hfyear, irr

*Adjusted five-year mortality IRR:
poisson _d i.hfyear agegp sex, irr
bysort hf_type: poisson _d i.hfyear agegp sex, irr
restore

****STEP 4: Ten-Year Mortality
drop failure outcome

gen failure=1 if dod <= hfdate+(365.25*10)
recode failure .=0

preserve
drop if hfyear>2015

gen outcome=min(hfdate+(365.25*10), dod)
stset outcome, id(scrssn) origin(hfdate) fail(failure) scale(365.25)

strate hfyear, per(100)
strate hfyear if hf_type==1, per(100)
strate hfyear if hf_type==2, per(100)
strate hfyear if hf_type==3, per(100)
restore
*Crude ten-year mortality IRR
preserve
keep if hfyear==2000 | hfyear==2010
recode hfyear 2000=1 2010=2
poisson _d hfyear, irr

*Adjusted ten-year mortality IRR:
poisson _d hfyear agegp sex, irr
bysort hf_type: poisson _d hfyear agegp sex, irr
restore

*****STEP 5: Crude survival over time
clear
use "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\New Files Mortality\hf_demographics_dod.dta"

gen hfdate=dofc( FirstHF_dischargedatetime)
gen hfyear=year(hfdate)

sum dod
*max value = 24087
di %td 24087
*last death recorded: 12/12/2025; will set 06/30/2025 as last date of follow-up to maximize accuracy
gen follow_up=mdy(06,30,2025)
gen death=1 if dod <= follow_up
replace death=0 if dod==.
gen outcome=min(dod, follow_up)
stset outcome, id(scrssn) origin(hfdate) fail(death) scale(365.25)

*median survival of entire cohort:
sum _t, detail
*Median = 2.93 years

*median survival amongst those who died:
sum _t if _d==1, detail
*Median = 2.31 years

*Median survival by year of diagnosis
bysort hfyear: sum _t, detail