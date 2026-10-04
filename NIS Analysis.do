/* NIS ANALYSIS 2009-2023 */

***STEP 1: cleaning files for each year
*Need core file, comorbidities

*2019-2023
clear
cd "/Users/irfan/Documents/Research/Sundaram/NIS Database/NIS New Files"
forvalues i=2019/2023 {
	use "NIS_`i'_Core.dta", clear
	merge 1:1 KEY_NIS using "NIS_`i'_DX_PR_GRPS.dta"
	save "/Users/irfan/Documents/Research/Sundaram/NIS Database/NIS New Files/NIS_`i'_cleaned.dta", replace
}

*2016 - 2018
*Only use Core file; DX_PR_GRPS not available in 2016/2017, no comorbidities listed in 2018 DX_PR_GRPS file

*2015: use Core file and merge with Q1-Q3 and Q4 separately

*2012-2014: just use Core files

*2011
*Core file has HOSPID, need to merge with pre-2012 weights found in HCUP website
clear
use "NIS_2011_Core.dta"
merge m:1 HOSPID using "NIS_2011_HOSPITAL_TrendWt.dta"
drop _merge
merge m:1 HOSPID using "NIS_2011_Hospital.dta"
drop HOSPST AHAID HFIPSSTCO H_CONTRL HOSPADDR HOSPCITY HOSPNAME HOSPSTCO HOSPWT HOSPZIP HOSP_BEDSIZE HOSP_CONTROL HOSP_LOCATION HOSP_LOCTEACH HOSP_REGION HOSP_TEACH IDNUMBER N_DISC_U N_HOSP_U S_DISC_U S_HOSP_U TOTAL_DISC HOSP_RNPCT HOSP_RNFTEAPD HOSP_LPNFTEAPD HOSP_NAFTEAPD HOSP_OPSURGPCT HOSP_MHSMEMBER HOSP_MHSCLUSTER _merge
save "NIS_2011_cleaned.dta", replace

*2010
clear
use "NIS_2010_Core.dta"
merge m:1 HOSPID using "NIS_2010_HOSPITAL_TrendWt.dta"
drop _merge
merge m:1 HOSPID using "NIS_2010_Hospital.dta"
drop HOSPST AHAID HFIPSSTCO H_CONTRL HOSPADDR HOSPCITY HOSPNAME HOSPSTCO HOSPWT HOSPZIP HOSP_BEDSIZE HOSP_CONTROL HOSP_LOCATION HOSP_LOCTEACH HOSP_REGION HOSP_TEACH IDNUMBER N_DISC_U N_HOSP_U S_DISC_U S_HOSP_U TOTAL_DISC HOSP_RNPCT HOSP_RNFTEAPD HOSP_LPNFTEAPD HOSP_NAFTEAPD HOSP_OPSURGPCT HOSP_MHSMEMBER HOSP_MHSCLUSTER _merge
save "NIS_2010_cleaned.dta", replace

*2009
clear
use "NIS_2009_Core.dta"
merge m:1 HOSPID using "NIS_2009_HOSPITAL_TrendWt.dta"
drop _merge
merge m:1 HOSPID using "NIS_2009_Hospital.dta"
drop HOSPST AHAID HFIPSSTCO H_CONTRL HOSPADDR HOSPCITY HOSPNAME HOSPSTCO HOSPWT HOSPZIP HOSP_BEDSIZE HOSP_CONTROL HOSP_LOCATION HOSP_LOCTEACH HOSP_REGION HOSP_TEACH IDNUMBER N_DISC_U N_HOSP_U S_DISC_U S_HOSP_U TOTAL_DISC HOSP_RNPCT HOSP_RNFTEAPD HOSP_LPNFTEAPD HOSP_NAFTEAPD HOSP_OPSURGPCT HOSP_MHSMEMBER HOSP_MHSCLUSTER _merge
save "NIS_2009_cleaned.dta", replace

***STEP 2: add HF and HFpEF + HFrEF variables to each year
*HF PHENOTYPE: ICD-10
gen HF=0
foreach var of varlist I10_DX* {
	replace HF=1 if strpos(`var',"I50")==1
}

gen byte hf_type=.
forvalues i=1/40 {
	*HFrEF
	replace hf_type=1 if hf_type==. & (strpos(I10_DX`i',"I502")==1 | strpos(I10_DX`i',"I504")==1)
	*HFpEF
	replace hf_type=2 if hf_type==. & strpos(I10_DX`i',"I503")==1
}

replace hf_type=3 if HF==1 & hf_type==.

label define hf_type 1 "HFrEF" 2 "HFpEF" 3 "Unclassified HF"
label values hf_type hf_type

*ICD-9/ICD-10
gen HF=0
foreach var of varlist DX* {
	replace HF=1 if ((strpos(`var',"428")==1) | (strpos(`var',"I50")==1) | `var'=="40201" | `var'=="40211" | `var'=="40291" | `var'=="40401" | `var'=="40403" | `var'=="40411" | `var'=="40413" | `var'=="40491" | `var'=="40493" | `var'=="425.4")
}

gen byte hf_type=.
forvalues i=1/30 {
	*HFrEF
	replace hf_type=1 if hf_type==. & ((strpos(DX`i',"I502")==1 | strpos(DX`i',"I504")==1) | strpos(DX`i',"4282")==1 | strpos(DX`i',"4284")==1)
	*HFpEF
	replace hf_type=2 if hf_type==. & (strpos(DX`i',"I503")==1 | strpos(DX`i',"4283")==1)
}

replace hf_type=3 if HF==1 & hf_type==.

label define hf_type 1 "HFrEF" 2 "HFpEF" 3 "Unclassified HF"
label values hf_type hf_type


***STEP 3: Appending/files
clear
cd "/Users/irfan/Documents/Research/Sundaram/NIS Database/NIS New Files"
use "NIS_2023_cleaned"
drop I10* CMR*
append using "NIS_2022_cleaned"
drop I10* CMR* _merge
append using "NIS_2021_cleaned"
drop I10* CMR* _merge
append using "NIS_2020_cleaned"
drop I10* CMR* _merge
append using "NIS_2019_cleaned"
drop I10* CMR* _merge
drop AGE_NEONATE AMONTH AWEEKEND DISPUNIFORM DQTR DRG DRGVER DRG_NoPOA ELECTIVE HCUP_ED HOSP_DIVISION LOS MDC MDC_NoPOA PAY1 PCLASS_ORPROC PL_NCHS PRDAY1 PRDAY2 PRDAY3 PRDAY4 PRDAY5 PRDAY6 PRDAY7 PRDAY8 PRDAY9 PRDAY10 PRDAY11 PRDAY12 PRDAY13 PRDAY14 PRDAY15 PRDAY16 PRDAY17 PRDAY18 PRDAY19 PRDAY20 PRDAY21 PRDAY22 PRDAY23 PRDAY24 PRDAY25 TOTCHG TRAN_IN TRAN_OUT
append using "NIS_2018_Core"
drop I10* 
append using "NIS_2017_Core"
drop I10* PR*
drop AGE_NEONATE AMONTH AWEEKEND DISPUNIFORM DQTR DRG DRGVER DRG_NoPOA DXVER ELECTIVE HCUP_ED HOSP_DIVISION LOS MDC MDC_NoPOA PAY1 PL_NCHS TOTCHG TRAN_IN TRAN_OUT
save "/Users/irfan/Documents/Research/Sundaram/NIS Database/NIS New Files/NIS_2017_2023_merged.dta"

clear
use "NIS_2016_Core"
drop I10*
append using "NIS_2015_cleaned"
drop DX* I10* _merge
drop NCHRONIC NDX
append using "NIS_2014_Core"
drop DX* NDX
append using "NIS_2013_Core"
drop DX* NDX
append using "NIS_2012_Core"
drop DX* NDX
drop hfref hfpef
append using "NIS_2011_cleaned"
drop DX* NDX
append using "NIS_2010_cleaned"
drop DX* NDX
append using "NIS_2009_cleaned"
drop DX* NDX
save "/Users/irfan/Documents/Research/Sundaram/NIS Database/NIS New Files/NIS_2009_2016_merged.dta"

clear
use "NIS_2017_2023_merged.dta"
append using "NIS_2009_2016_merged.dta"
save "/Users/irfan/Documents/Research/Sundaram/NIS Database/NIS New Files/NIS_2009_2023_merged.dta"

***STEP 4: Analyzing trends
*After 2012, use DISCWT; before 2012, use TRENDWT; will merge these into one variable
gen double nis_weight= TRENDWT if YEAR==2009 | YEAR==2010 | YEAR==2011
replace nis_weight=DISCWT if YEAR>=2012

gen double hospital_id= HOSPID if YEAR==2009 | YEAR==2010 | YEAR==2011
replace hospital_id=HOSP_NIS if YEAR>=2012

egen long strata_year=group(YEAR NIS_STRATUM)
egen long hospital_year=group(YEAR hospital_id)

svyset hospital_year [pweight=nis_weight], strata(strata_year)
gen byte classified_hf=1 if hf_type==1 | hf_type==2
recode classified_hf .=0

gen byte adult_classified_hf=(classified_hf==1 & AGE>=18 & AGE!=.)
gen hfpef=(hf_type==2)
gen hfpef_percent=hfpef*100

svy, subpop(adult_classified_hf): regress hfpef_percent c.YEAR
/*
Survey: Linear regression

Number of strata =  2,297                       Number of obs   =  100,114,158
Number of PSUs   = 52,453                       Population size =  494,445,736
                                                Subpop. no. obs =    9,645,363
                                                Subpop. size    = 47,962,346.2
                                                Design df       =       50,156
                                                F(1, 50156)     =       296.18
                                                Prob > F        =       0.0000
                                                R-squared       =       0.0008

------------------------------------------------------------------------------
             |             Linearized
hfpef_perc~t | Coefficient  std. err.      t    P>|t|     [95% conf. interval]
-------------+----------------------------------------------------------------
        YEAR |   .3336565   .0193875    17.21   0.000     .2956568    .3716561
       _cons |  -624.4619   39.13144   -15.96   0.000      -701.16   -547.7639
------------------------------------------------------------------------------
Note: 210 strata omitted because they contain no subpopulation members.
*/

svy, subpop(adult_classified_hf): proportion hf_type, over(YEAR)
/*. svy, subpop(adult_classified_hf): proportion hf_type, over(YEAR)
(running proportion on estimation sample)

Survey: Proportion estimation

Number of strata =  2,297                Number of obs   =  100,114,158
Number of PSUs   = 52,453                Population size =  494,445,736
                                         Subpop. no. obs =    9,645,363
                                         Subpop. size    = 47,962,346.2
                                         Design df       =       50,156

-----------------------------------------------------------------------
                      |             Linearized            Logit
                      | Proportion   std. err.     [95% conf. interval]
----------------------+------------------------------------------------
         hf_type@YEAR |
          HFrEF 2009  |   .5541028   .0063287      .5416672     .566471
          HFrEF 2010  |    .533248   .0051404      .5231604    .5433084
          HFrEF 2011  |   .5287201    .004948      .5190124    .5384062
          HFrEF 2012  |   .5288785    .002411      .5241504    .5336014
          HFrEF 2013  |   .5260321   .0022604      .5215998    .5304604
          HFrEF 2014  |   .5273708   .0022206      .5230165     .531721
          HFrEF 2015  |   .5295033   .0020923      .5254005    .5336022
          HFrEF 2016  |   .5218873   .0020305      .5179061    .5258657
          HFrEF 2017  |   .5116002   .0019375       .507802     .515397
          HFrEF 2019  |   .5001616   .0018944      .4964486    .5038746
          HFrEF 2020  |    .501555   .0018549      .4979195    .5051905
          HFrEF 2021  |   .4999142   .0018258      .4963357    .5034927
          HFrEF 2022  |   .5014963    .001805      .4979584     .505034
          HFrEF 2023  |   .4985663   .0019434      .4947574    .5023753
          HFpEF 2009  |   .4458972   .0063287       .433529    .4583328
          HFpEF 2010  |    .466752   .0051404      .4566916    .4768396
          HFpEF 2011  |   .4712799    .004948      .4615938    .4809876
          HFpEF 2012  |   .4711215    .002411      .4663986    .4758496
          HFpEF 2013  |   .4739679   .0022604      .4695396    .4784002
          HFpEF 2014  |   .4726292   .0022206       .468279    .4769835
          HFpEF 2015  |   .4704967   .0020923      .4663978    .4745995
          HFpEF 2016  |   .4781127   .0020305      .4741343    .4820939
          HFpEF 2017  |   .4883998   .0019375       .484603     .492198
          HFpEF 2019  |   .4998384   .0018944      .4961254    .5035514
          HFpEF 2020  |    .498445   .0018549      .4948095    .5020805
          HFpEF 2021  |   .5000858   .0018258      .4965073    .5036643
          HFpEF 2022  |   .4985037    .001805       .494966    .5020416
          HFpEF 2023  |   .5014337   .0019434      .4976247    .5052426
Unclassified HF 2009  |          0  (no observations)
Unclassified HF 2010  |          0  (no observations)
Unclassified HF 2011  |          0  (no observations)
Unclassified HF 2012  |          0  (no observations)
Unclassified HF 2013  |          0  (no observations)
Unclassified HF 2014  |          0  (no observations)
Unclassified HF 2015  |          0  (no observations)
Unclassified HF 2016  |          0  (no observations)
Unclassified HF 2017  |          0  (no observations)
Unclassified HF 2019  |          0  (no observations)
Unclassified HF 2020  |          0  (no observations)
Unclassified HF 2021  |          0  (no observations)
Unclassified HF 2022  |          0  (no observations)
Unclassified HF 2023  |          0  (no observations)
-----------------------------------------------------------------------
Note: 210 strata omitted because they contain no subpopulation members.*/

***STEP 5: Comorbidities
clear
cd "/Users/irfan/Documents/Research/Sundaram/NIS Database/NIS New Files"

use "NIS_2023_cleaned"
keep if AGE >=18

*Hypertension
gen htn=0
foreach var of varlist I10_DX* {
	replace htn=1 if ///
		strpos(`var',"I10")==1 | ///
		strpos(`var',"I11")==1 | ///
		strpos(`var',"I12")==1 | ///
		strpos(`var',"I13")==1 | ///
		`var'=="I150" | ///
		`var'=="I158" | ///
		strpos(`var',"O10")==1 | ///
		strpos(`var',"O11")==1 | ///
		strpos(`var',"O19")==1 
}

*Atrial fibrillation
gen af=0
foreach var of varlist I10_DX* {
	replace af=1 if strpos(`var',"I48")==1
}

*CKD
gen ckd=0
foreach var of varlist I10_DX* {
	replace ckd=1 if ///
	strpos(`var',"N183")==1 | ///
	strpos(`var',"N184")==1 | ///
	strpos(`var',"N185")==1 | ///
	strpos(`var',"N186")==1 | ///
	strpos(`var',"I120")==1 | ///
	strpos(`var',"I311")==1 | ///
	strpos(`var',"I132")==1
}

*CAD
gen cad=0
foreach var of varlist I10_DX* {
	replace cad=1 if ///
	`var'=="I240" | ///
	`var'=="I241" | ///
	`var'=="I248" | ///
	`var'=="I280" | ///
	strpos(`var',"I20")==1 | ///
	strpos(`var',"I25")==1
}
