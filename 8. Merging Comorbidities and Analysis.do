*Merging comorbidities and analysis

*STEP 1A: merge comorbidities file
clear
use "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\New Files Mortality\hfpef_comorbidities.dta"
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\New Files Mortality\hfref_comorbidities.dta"
drop _merge
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\New Files Mortality\hfuc_comorbidities.dta"
drop _merge

*STEP 1B: merge with demographics/dod file (from do-file #2)
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\New Files Mortality\hf_demographics_dod.dta"
drop _merge

*STEP 2: cleaning abnormal values in continuous variables
sum age, detail
count if age < 18
replace age=. if age < 18

sum bmi, detail
replace bmi=. if bmi < 15 | bmi>70

*categorizing continuous variables
gen agegp=age
recode agegp min/49=1 50/59=2 60/69=3 70/79=4 80/89=5 90/max=6
tab agegp

gen obesity=bmi
recode obesity min/18.4999999=1 18.5/24.9999=2 25/29.9999=3 30/34.9999=4 35/39.9999=5 40/max=6
tab obesity

gen obesity2=obesity
recode obesity2 1/3=1 4/6=2

*creating year of HF diagnosis variable
gen hfdate=dofc( FirstHF_dischargedatetime)
gen hfyear=year(hfdate)

*Examining missing variables
recode htn dm cad mi stroke pad af ppmicd ckd esrd lungdz liverdz hypothyroid depression alcohol polyabuse schizo cancer smoke (.=0)

misstable summarize

*cleaning missing variables
recode sex .=9
label define sexlabel 1 "Male" 2 "Female" 9 "Missing", replace
label values sex sexlabel

recode obesity .=9
label define obesity 1 "Underweight" 2 "Normal" 3 "Overweight" 4 "Obesity: Class I" 5 "Obesity: Class II" 6 "Obesity: Class III" 9 "Missing", replace
label values obesity obesity

save "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\New Files Mortality\hf_comorbidities_analysis.dta", replace

*STEP 3: baseline characteristics
clear
use "P:\ORD_Sundaram_202108013D\Padmini\Heart Failure Files\New Files Mortality\hf_comorbidities_analysis.dta"
sum age
bysort sex: sum age

foreach var of varlist sex obesity obesity2 htn dm cad mi stroke pad af ppmicd ckd esrd lungdz liverdz hypothyroid depression alcohol polyabuse schizo cancer {
	tab `var'
}

*stratify by sex
foreach var of varlist obesity obesity2 htn dm cad mi stroke pad af ppmicd ckd esrd lungdz liverdz hypothyroid depression alcohol polyabuse schizo cancer {
	tab `var' sex, col
}

/*STEP 4: baseline characteristics stratified by time period
per discussion: will look at five distinct 3-year intervals:
2000-2002; 2005-2007; 2010-2012; 2015-2017; 2021-2023*/

*2000-2002
preserve
keep if hfyear>=2000 & hfyear<=2002

sum age

foreach var of varlist sex obesity obesity2 htn dm cad mi stroke pad af ppmicd ckd esrd lungdz liverdz hypothyroid depression alcohol polyabuse schizo cancer {
	tab `var'
}
restore

*2005-2007
preserve
keep if hfyear>=2005 & hfyear<=2007

sum age

foreach var of varlist sex obesity obesity2 htn dm cad mi stroke pad af ppmicd ckd esrd lungdz liverdz hypothyroid depression alcohol polyabuse schizo cancer {
	tab `var'
}
restore

*2010-2012
preserve
keep if hfyear>=2010 & hfyear<=2012

sum age

foreach var of varlist sex obesity obesity2 htn dm cad mi stroke pad af ppmicd ckd esrd lungdz liverdz hypothyroid depression alcohol polyabuse schizo cancer {
	tab `var'
}
restore

*2015-2017
preserve
keep if hfyear>=2015 & hfyear<=2017

sum age

foreach var of varlist sex obesity obesity2 htn dm cad mi stroke pad af ppmicd ckd esrd lungdz liverdz hypothyroid depression alcohol polyabuse schizo cancer {
	tab `var'
}
restore

*2021-2023
preserve
keep if hfyear>=2021 & hfyear<=2023

sum age

foreach var of varlist sex obesity obesity2 htn dm cad mi stroke pad af ppmicd ckd esrd lungdz liverdz hypothyroid depression alcohol polyabuse schizo cancer {
	tab `var'
}
restore

***STEP 5: baseline characteristics (HFrEF) stratified by sex and time period

keep if hf_type==2
sum age
bysort sex: sum age

*overall
foreach var of varlist sex obesity obesity2 htn dm cad mi stroke pad af ppmicd ckd esrd lungdz liverdz hypothyroid depression alcohol polyabuse schizo cancer {
	tab `var'
}

*stratify by sex
foreach var of varlist obesity obesity2 htn dm cad mi stroke pad af ppmicd ckd esrd lungdz liverdz hypothyroid depression alcohol polyabuse schizo cancer {
	tab `var' sex, col
}

*use same codes as above to stratify by time period

**STEP 6: baseline characteristics (HFpEF) stratified by sex and time period

keep if hf_type==1
sum age
bysort sex: sum age

*overall
foreach var of varlist sex obesity obesity2 htn dm cad mi stroke pad af ppmicd ckd esrd lungdz liverdz hypothyroid depression alcohol polyabuse schizo cancer {
	tab `var'
}

*stratify by sex
foreach var of varlist obesity obesity2 htn dm cad mi stroke pad af ppmicd ckd esrd lungdz liverdz hypothyroid depression alcohol polyabuse schizo cancer {
	tab `var' sex, col
}

*use same codes as above to stratify by time period
