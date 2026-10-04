/* SENSITIVITY ANALYSES */

--Note: unless otherwise specified, comments after "select distinct scrssn from [table]" queries represent sample size

/* Run the below command to select the required database */
use ORD_Sundaram_202108013D
go

/* EXAMINING PRIOR ENCOUNTERS */

select distinct a.PatientSID, a.ScrSSN,c.FirstHF_DischargeDatetime, cast(b.AdmitDateTime as date) as AdmitDateTime
into Dflt.HF_Prior_Encounters
--into #temphfpriorencounters
from Src.CohortCrosswalk as a with (NOLOCK) inner join
Src.Inpat_Inpatient as b with (NOLOCK) on a.PatientSID=b.PatientSID inner join
Dflt.HeartFailure as c with (NOLOCK) on a.ScrSSN=c.ScrSSN
where b.AdmitDateTime between dateadd(year, -2, c.FirstHF_DischargeDatetime) and dateadd(day, -1, c.FirstHF_DischargeDatetime) --had to add the 2nd clause, if I kept it as c.DischargeDateTime only, it retained the HF ICD code encounter

union all

select distinct a.PatientSID, a.ScrSSN, c.FirstHF_DischargeDatetime,cast(b.AdmitDateTime as date) as AdmitDateTime
from Src.CohortCrosswalk as a with (NOLOCK) inner join
Src.Inpat_Inpatient_Recent as b with (NOLOCK) on a.PatientSID=b.PatientSID inner join
Dflt.HeartFailure as c with (NOLOCK) on a.ScrSSN=c.ScrSSN
where b.AdmitDateTime between dateadd(year, -2, c.FirstHF_DischargeDatetime) and dateadd(day, -1, c.FirstHF_DischargeDatetime)

union all

select distinct a.PatientSID, a.ScrSSN,c.FirstHF_DischargeDatetime,cast(b.VisitDateTime as date) as VisitDateTime
from Src.CohortCrosswalk as a with (NOLOCK) inner join
Src.Outpat_Visit as b with (NOLOCK) on a.PatientSID=b.PatientSID inner join
Dflt.HeartFailure as c with (NOLOCK) on a.ScrSSN=c.ScrSSN
where b.VisitDateTime between dateadd(year, -2, c.FirstHF_DischargeDatetime) and dateadd(day, -1, c.FirstHF_DischargeDatetime)

union all

select distinct a.PatientSID, a.ScrSSN, c.FirstHF_DischargeDatetime, cast(b.VisitDateTime as date) as VisitDateTime
from Src.CohortCrosswalk as a with (NOLOCK) inner join
Src.Outpat_Visit_Recent as b with (NOLOCK) on a.PatientSID=b.PatientSID inner join
Dflt.HeartFailure as c with (NOLOCK) on a.ScrSSN=c.ScrSSN
where b.VisitDateTime between dateadd(year, -2, c.FirstHF_DischargeDatetime) and dateadd(day, -1, c.FirstHF_DischargeDatetime)

select distinct scrssn from Dflt.HF_Prior_Encounters -- 970,452

alter table Dflt.HF_Prior_Encounters rebuild with (data_compression=page)

select distinct ScrSSN, AdmitDateTime --, VisitDateTime
into Dflt.HF_Priorencountersunique
from Dflt.HF_Prior_Encounters 
order by admitdatetime

alter table Dflt.HF_Priorencountersunique rebuild with (data_compression=page)

select distinct scrssn, count(AdmitDateTime) as Encounter_Count

into Dflt.HF_priorencounterscount

from Dflt.HF_Priorencountersunique
group by scrssn

select distinct scrssn from Dflt.HF_priorencounterscount  --970,452

alter table Dflt.HF_priorencounterscount rebuild with (data_compression=page)

select avg(Encounter_Count) from Dflt.HF_priorencounterscount -- Average=67

select distinct scrssn, Encounter_Count from Dflt.HF_priorencounterscount
where Encounter_Count>=3 --950,844 unique values

--Examining dates of earliest encounters

select distinct a.PatientSID, a.ScrSSN,c.FirstHF_DischargeDatetime, cast(b.AdmitDateTime as date) as AdmitDateTime
into #temphfpriorencounters
from Src.CohortCrosswalk as a with (NOLOCK) inner join
Src.Inpat_Inpatient as b with (NOLOCK) on a.PatientSID=b.PatientSID inner join
Dflt.HeartFailure as c with (NOLOCK) on a.ScrSSN=c.ScrSSN
where b.AdmitDateTime < dateadd(day, -1, c.FirstHF_DischargeDatetime)

union all

select distinct a.PatientSID, a.ScrSSN, c.FirstHF_DischargeDatetime,cast(b.AdmitDateTime as date) as AdmitDateTime
from Src.CohortCrosswalk as a with (NOLOCK) inner join
Src.Inpat_Inpatient_Recent as b with (NOLOCK) on a.PatientSID=b.PatientSID inner join
Dflt.HeartFailure as c with (NOLOCK) on a.ScrSSN=c.ScrSSN
where b.AdmitDateTime < dateadd(day, -1, c.FirstHF_DischargeDatetime)

union all

select distinct a.PatientSID, a.ScrSSN,c.FirstHF_DischargeDatetime,cast(b.VisitDateTime as date) as VisitDateTime
from Src.CohortCrosswalk as a with (NOLOCK) inner join
Src.Outpat_Visit as b with (NOLOCK) on a.PatientSID=b.PatientSID inner join
Dflt.HeartFailure as c with (NOLOCK) on a.ScrSSN=c.ScrSSN
where b.VisitDateTime < dateadd(day, -1, c.FirstHF_DischargeDatetime)

union all

select distinct a.PatientSID, a.ScrSSN, c.FirstHF_DischargeDatetime, cast(b.VisitDateTime as date) as VisitDateTime
from Src.CohortCrosswalk as a with (NOLOCK) inner join
Src.Outpat_Visit_Recent as b with (NOLOCK) on a.PatientSID=b.PatientSID inner join
Dflt.HeartFailure as c with (NOLOCK) on a.ScrSSN=c.ScrSSN
where b.VisitDateTime < dateadd(day, -1, c.FirstHF_DischargeDatetime)

select distinct scrssn, AdmitDateTime from #temphfpriorencounters -- 970,452
order by AdmitDateTime







/*EXAMINING ONE-HF CODE COHORT */
-- creation of #temphficd table is found in the main SQL file

select distinct scrssn from #temphficd --984,515
select count(*) from #temphficd --

select distinct scrssn, icd9code, recenthfdatetime 
into #temphfcode
from #temphficd

select count(*) from #temphfcode --4,835,416

select scrssn, count( ICD9code) as TotalHFICDCodes

into #tempcounticdcode

from #temphfcode group by (scrssn)


select distinct scrssn from #tempcounticdcode --984,515

select distinct scrssn from #tempcounticdcode where TotalHFICDCodes >=2 -- 820,646

select distinct scrssn from #tempcounticdcode where TotalHFICDCodes < 2 --163,103

select a.scrssn, b.patientsid, b.sta3n, b.DischargeDateTime, b.FirstHF_DischargeDatetime
into Dflt.Heartfailure_2HFcodes
from #tempcounticdcode as a with (NOLOCK) inner join 
Dflt.heartfailure as b with (NOLOCK) on a.ScrSSN= b.scrssn where a.TotalHFICDCodes >=2

select a.scrssn, b.patientsid, b.sta3n, b.DischargeDateTime, b.FirstHF_DischargeDatetime
into Dflt.Heartfailure_1HFcode
from #tempcounticdcode as a with (NOLOCK) inner join 
Dflt.heartfailure as b with (NOLOCK) on a.ScrSSN= b.scrssn where a.TotalHFICDCodes <2

select distinct scrssn from Dflt.Heartfailure_2HFcodes --820,646
select * from Dflt.Heartfailure_2HFcodes

select distinct scrssn from Dflt.Heartfailure_1HFcode -- 162,940


/* Extraction for patients with only 1 HF ICD Code */

select distinct scrssn from Dflt.Heartfailure_1HFCode --162,940
alter table Dflt.Heartfailure_1HFCode rebuild with (data_compression=page)

/*LVEF */

select distinct a.PatientSID, a.sta3n, a.ScrSSN, a.FirstHF_dischargedatetime, b.High_Value, b.Low_value,b.ValueDateTime

into Dflt.Heartfailure_1HFCode_EF

from Dflt.Heartfailure_1HFCode as a with (NOLOCK) inner join 
Src.VINCI_TIU_NLP_LVEF as b with (NOLOCK) on a.PatientSID= b.PatientSID 

select distinct scrssn from Dflt.Heartfailure_1HFCode_EF --126,696

alter table Dflt.Heartfailure_1HFCode_EF rebuild with (data_compression=page)

/* Age */

select a.ScrSSN, a.FirstHF_Dischargedatetime, b.DOB,b.SEX
into Dflt.Heartfailure_1HFCode_DOB
from Dflt.Heartfailure_1HFCode as a with (NOLOCK) inner join
Src.VitalStatus_Mini as b with (NOLOCK) on a.scrssn= b.scrssn

select *, datediff( year, DOB, FirstHF_DischargeDatetime) as age
into Dflt.Heartfailure_1HFCode_Age
from Dflt.Heartfailure_1HFCode_DOB

select distinct scrssn from Dflt.Heartfailure_1HFCode_Age --162,917
select distinct scrssn from Dflt.Heartfailure_1HFCode_Age where SEX ='F' --4,695

alter table Dflt.Heartfailure_1HFCode_Age rebuild with (data_compression=page)
alter table Dflt.Heartfailure_1HFCode_DOB rebuild with (data_compression=page)


/* DOD */

select distinct a.ScrSSN,  b.MPI_DOD
into Dflt.Heartfailure_1HFCode_DOD
from Dflt.Heartfailure_1HFCode as a with (NOLOCK) inner join
Src.SDAF_DAFMaster as b with (NOLOCK) on a.scrssn= b.MPI_scrssn
where b.MPI_DOD is not null

select distinct scrssn from Dflt.Heartfailure_1HFCode_DOD --127,005

alter table Dflt.Heartfailure_1HFCode_DOD rebuild with (data_compression=page)

/* HF Hospitalization */

select top 100* from Dflt.Heartfailure_1HFCode
select distinct a.scrssn, a.patientsid, a.sta3n, a.FirstHF_Dischargedatetime,b.DischargeDateTime,c.ICD9Code,b.AdmitDiagnosis
/*ICD9 Codes*/

into Dflt.Heartfailure_1HFCode_HFHospi

from Dflt.Heartfailure_1HFCode as a with (NOLOCK) inner join
Src.Inpat_Inpatient as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.PrincipalDiagnosisICD9SID=c.ICD9SID 
where c.ICD9Code in ('398.91','428.0','428.1','428.20','428.21','428.22','428.23','428.30',
						'428.31','428.32','428.33','428.40','428.41','428.42','428.43','428.9')
					and b.DischargeDateTime > a.FirstHF_dischargedatetime
union all

/*ICD10 Codes*/
select distinct a.scrssn, a.patientsid, a.sta3n, a.FirstHF_Dischargedatetime, b.DischargeDateTime, c.ICD10Code, b.AdmitDiagnosis

from Dflt.Heartfailure_1HFCode as a with (NOLOCK) inner join
Src.Inpat_Inpatient as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.PrincipalDiagnosisICD10SID=c.ICD10SID 
where ICD10Code in ('I50.00','I50.1','I50.20','I50.30','I50.40','I50.9',
									'I11.0','I13.0','I13.2','I25.5')
and b.DischargeDateTime > a.FirstHF_dischargedatetime

select distinct scrssn from Dflt.Heartfailure_1HFCode_HFHospi -- 3,927