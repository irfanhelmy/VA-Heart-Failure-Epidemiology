*Sensitivity analyses / extra analyses for reviewers

***1) Split cohort into HFpEF, HFmrEF, HFrEF, and Unclassified EF
**First step from do-file #3
clear
use "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\New Files Mortality\hf_demographics_dod.dta"

gen hfyear=year(hfdate)

*Recode EF variable
gen hf_type2=hf_type
recode hf_type2 3=4
replace hf_type2=3 if hf_type==2 & Low_Value<40
replace hf_type=2 if hf_type==2 & Low_Value>=40

tab hf_type2

label define newEF 1 "HFpEF" 2 "HFmrEF" 3 "HFrEF" 4 "Unclassified"
label values hf_type2 newEF

*Repeat phenotype trends over time
tab hfyear hf_type2

*note: hfdate2 = date of 2nd HF ICD code
preserve
gen diff=hfdate-valuedatetime
replace hf_type2=4 if abs(diff)>90
replace hfdate2=hfdate if hfdate2==.
replace hfdate2=hfdate2-0.01 if hfdate2==dod
tab hfyear hf_type
tab hfyear hf_type, row

*Crude one-year mortality
*Setting time zero at 2nd HF ICD code to prevent immortal time bias
gen failure=1 if dod <= hfdate2+365
recode failure .=0

gen outcome=min(hfdate2+365, dod)
stset outcome, id(scrssn) origin(hfdate2) fail(failure) scale(365.25)

strate hfyear if hf_type2==1, per(100)
strate hfyear if hf_type2==2, per(100)
strate hfyear if hf_type2==3, per(100)
strate hfyear if hf_type2==4, per(100)
restore

***2) Excluding HFrEF with baseline GDMT
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\New Files Mortality\hfref_med_merged.dta"

gen GDMT=1 if ACEARB==1 | ARNI==1 | BB==1 | MRA==1 | SGLT2==1
preserve
keep if hf_type2==2 | hf_type2==3
gen hfmref= hf_type2==0
tab hfmref GDMT, col
logit hfmref i.GDMT, or
logit hfmref i.GDMT i.hfyear agegp sex, or
margins GDMT


***3) Spline analysis on HF phenotype incidence
clear
use "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\New Files Mortality\hf_demographics_dod.dta"

gen hfdate=dofc(FirstHF_dischargedatetime)
gen hfyear=year(hfdate)

gen hfpef=1 if hf_type==1
recode hfpef .=0

*to keep the argument clean and focused on HFpEF incidence only, will drop unclassified HF cohort so the message won't be confounded by improvements in EF ascertainment
drop if hf_type==3

*multiple knots
mkspline yr1 2014 yr2 2019 yr3=hfyear, marginal
logit hfpef yr*, or
lincom yr1 + yr2, or
lincom yr1 + yr2 + yr3, or
*glm hfpef yr*, family(binomial) link(identity) vce(robust) --> for grouped data

*sensitivity analyses with multiple knots
drop yr*
mkspline yr1 2014 yr2 2020 yr3=hfyear, marginal
logit hfpef yr*, or
lincom yr1 + yr2, or
lincom yr1 + yr2 + yr3, or
drop yr*

mkspline yr1 2014 yr2 2021 yr3=hfyear, marginal
logit hfpef yr*, or
lincom yr1 + yr2, or
lincom yr1 + yr2 + yr3, or

*generate graph, define splines first
drop yr*
mkspline yr1 2014 yr2 2019 yr3=hfyear, marginal
logit hfpef yr1 yr2 yr3
predict phat, pr
predict xb, xb
predict se, stdp
gen lo=invlogit(xb - 1.96*se)
gen hi=invlogit(xb + 1.96*se)

preserve
collapse(mean) obs_prop=hfpef (mean) phat hi lo, by(hfyear)
gen obs_pct=100*obs_prop
gen fit_pct=100*phat
gen lo_pct=100*lo
gen hi_pct=100*hi

twoway (rarea lo_pct hi_pct hfyear, color(navy%30) lwidth(none)) (scatter obs_pct hfyear, msymbol(circle) msize(small) mcolor(navy%70)) (line fit_pct hfyear, sort lcolor(navy) lwidth(medthick)), xline(2014 2019, lpattern(dash) lcolor(gs9))


***4) Lead time bias analysis
*a) restrict to only EF measurements available within 30 days (EF dates outside this window are Unclassified HF)
clear
use "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\New Files Mortality\hf_demographics_dod.dta"

gen hfyear=year(hfdate)

gen diff=hfdate-valuedatetime
tabstat diff, statistics(p10, p25, p50, p75, p90) by(hfyear)
bysort hf_type: tabstat diff, statistics(p10, p25, p50, p75, p90) by(hfyear)

gen hfyear2=hfyear
recode hfyear2 2000/2004=1 2005/2009=2 2010/2014=3 2015/2019=4 2020/2025=5
tabstat diff, s(p10 p25 p50 p75 p90) by(hfyear2)

preserve
replace hf_type=3 if abs(diff)>30
tab hfyear hf_type
tab hfyear hf_type, row
restore

*b) same as (a) but within 90 days
preserve
replace hf_type=3 if abs(diff)>90
tab hfyear hf_type
tab hfyear hf_type, row
restore

*c) Proportion of EF within 7, 30, 60, 90, 365 days of HF diagnosis
preserve
drop if hf_type==3

gen diff7=1 if abs(diff) <=7
gen diff30=1 if abs(diff) <=30
gen diff90=1 if abs(diff) <=90
gen diff365=1 if abs(diff) <=365

recode diff7 diff30 diff90 diff365 (.=0)

tab hfyear diff7, row
tab hfyear diff30, row
tab hfyear diff90, row
tab hfyear diff365, row

tab hfyear2 diff7, row
tab hfyear2 diff30, row
tab hfyear2 diff90, row
tab hfyear2 diff365, row

*d) Median [IQR] LVEF over time
tabstat Low_Value if hf_type==2, statistics (p25 p50 p75) by(hfyear)
tabstat Low_Value if hf_type==1, statistics (p25 p50 p75) by(hfyear)

*e) HFpEF-ABA score over time (for HFpEF cohort)
clear
use "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\New Files Mortality\hf_demographics_dod.dta"
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\New Files Mortality\hfpef_af.dta"
drop _merge
recode af .=0
replace bmi=. if bmi<15
replace bmi=. if bmi>70

gen hfyear=year(hfdate)

gen aba = -7.788751 + 0.062564*age + 0.135149*bmi + 2.040806*af
gen abas = exp(aba)
gen ABA = abas/(1+abas)

tabstat ABA, s(p25 p50 p75) by(hfyear)
tabstat ABA, s(p25 p50 p75) by(hfyear) format(%9.2f)


***5) Immortal time analyses
clear
use "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\New Files Mortality\hf_demographics_dod.dta"

*Descriptive data
gen hfdiff=hfdate2-hfdate
replace hfdate2=hfdate if hfdate2==.

foreach d in 0 1 2 3 4 5 6 7 {
	count if hfdiff==`d' & hf_type==1
}
count if hfdiff<=7 & hf_type==1
count if hfdiff<=30 & hf_type==1
count if hfdiff<=90 & hf_type==1
count if hfdiff<=365 & hf_type==1

foreach d in 0 1 2 3 4 5 6 7 {
	count if hfdiff==`d' & hf_type==2
}
count if hfdiff<=7 & hf_type==2
count if hfdiff<=30 & hf_type==2
count if hfdiff<=90 & hf_type==2
count if hfdiff<=365 & hf_type==2

foreach d in 0 1 2 3 4 5 6 7 {
	count if hfdiff==`d' & hf_type==3
}
count if hfdiff<=7 & hf_type==3
count if hfdiff<=30 & hf_type==3
count if hfdiff<=90 & hf_type==3
count if hfdiff<=365 & hf_type==3

bysort hf_type: sum hfdiff, detail

tabstat hfdiff, s(p10 p25 p50 p75 p90) by(hfyear)


*Solution to immortal time bias problem: time zero = 2nd HF ICD code, and restrict population to when 2nd HF diagnosis is within 90 days of first HF diagnosis
*hfdate2 = date of 2nd HF ICD code
drop if hfdate2>hfdate+90
replace hfdate2=hfdate2-0.01 if hfdate2==dod
stset outcome, id(scrssn) origin(hfdate2) fail(failure) scale(365.25)

strate hfyear, per(100)
strate hfyear if hf_type==1, per(100)
strate hfyear if hf_type==2, per(100)
strate hfyear if hf_type==3, per(100)

***6) Analyzing one-HF code cohort: for selection bias + immortal time bias; time zero = first HF diagnosis
clear
use "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\New Files Mortality\hf_demographics_dod.dta"
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\New Files Mortality\hf_1hfcode_merged.dta", update
drop _merge

gen hfyear=year(hfdate)
replace dod=MPI_DOD if MPI_DOD~=.
replace hfdate=hfdate-0.001 if hfdate==dod
gen failure=1 if dod<=hfdate+365
recode failure .=0
gen outcome=min(hfdate+365, dod)
stset outcome, id(scrssn) origin(hfdate) fail(failure) scale(365.25)

strate hfyear, per(100)
strate hfyear if hf_type==1, per(100)
strate hfyear if hf_type==2, per(100)
strate hfyear if hf_type==3, per(100)

*analyzing 1-HF cohort only
preserve
keep if _merge==2
strate hfyear, per(100)
strate hfyear if hf_type==1, per(100)
strate hfyear if hf_type==2, per(100)
strate hfyear if hf_type==3, per(100)
restore

drop if hfyear==2025
gen hfyear2=hfyear
recode hfyear2 2000/2004=1 2005/2009=2 2010/2014=3 2015/2019=4 2020/2024=5

gen agegp=age
recode agegp min/50=1 51/60=2 61/70=3 71/80=4 81/90=5 90/max=6

poisson _d i.hfyear agegp sex, irr
bysort hf_type: poisson _d i.hfyear agegp sex, irr


***7) ICD-9 to ICD-10 transition
clear
use "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\New Files Mortality\hf_demographics_dod.dta"

gen hfyear=year(hfdate)
gen hfmonth=month(hfdate)
gen hfday=day(hfdate)

tab hfmonth if hfyear==2014
tab hfmonth if hfyear==2015
tab hfmonth if hfyear==2016
tab hfmonth if hfyear==2017

tab hfday if hfmonth==9 & hfyear==2015
tab hfday if hfmonth==10 & hfyear==2015
*confirmed very large drop in counts of incident HF exactly on October 1st, 2015

***8) Cause of death sensitivity analyses
clear
use "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\New Files Mortality\causeofdeath.dta"

*Descriptive analyses
tab death if dod<=mdy(12,31,2019)
replace death=0 if dod>mdy(12,31,2019)
*Unknown cause of death is only 1.1% of deaths

*Setting up data for one-year CV mortality
gen hfyear=year(hfdate)
gen hfyear2=year(hfdate2)
gen follow_up=hfdate+365.25
gen exit=mdy(12,31,2019)
gen outcome=min(dod, follow_up, exit)

*Cause-specific HR (for CV death)
stset outcome, id(scrssn) origin(hfdate2) failure(death==1) scale(365.25)

*Crude
stcox i.hfyear2
bysort hf_type: stcox i.hfyear2

*Adjusted
gen agegp=age
recode agegp min/50=1 51/60=2 61/70=3 71/80=4 81/90=5 90/max=6

poisson _d i.hfyear agegp sex, irr cformat(%9.3f)
bysort hf_type: poisson _d i.hfyear agegp sex, irr cformat(%9.3f)

*************************************************************************
/* EXTERNAL VALIDATION */

*NIS HFpEF proportions will be done separately to account for survey weights

*TriNetX
clear
use  "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\New Files Mortality\TriNetX.dta"
gen total = var2+var3
gen prop=var2/total
gen percent=prop*100
rename var1 year
rename var2 hfpef
rename var3 hfref
gen year2=year-2010
gen cohort=1

regress percent year2
regress percent year2 [aw=total]

glm hfpef c.year2, family(binomial total) link(identity)
*to account for overdispersion
glm hfpef c.year2, family(binomial total) link(identity) scale(x2)


*VA-EHR
clear
use "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\New Files Mortality\hf_demographics_dod.dta"
gen hfyear=year(hfdate)

keep if hf_type==1 | hf_type==2
gen hfpef=1 if hf_type==1
recode hfpef .=0
collapse (mean) prop=hfpef (count) n_classified=hfpef, by(hfyear)
rename 
gen percent=prop*100
gen year2=hfyear-2000
gen cohort=2

regress percent year2
regress percent year2 [aw=n_classified]

twoway (scatter percent hfyear) (lfit percent hfyear [aw=n_classified])
twoway (scatter percent hfyear) (lfitci percent hfyear [aw=n_classified])

*alternative approach for 95% CI
predict fitted, xb
predict se_fitted, stdp
gen lci=fitted - invttail(e(df_r), 0.025)*se_fitted
gen hci=fitted + invttail(e(df_r), 0.025)*se_fitted

twoway (rarea hci lci hfyear) (scatter percent hfyear) (line fitted hfyear)