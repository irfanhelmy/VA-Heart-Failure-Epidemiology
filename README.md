# VA Heart Failure Epidemiology - Mortality Project
## Overview

This repository contains the SQL and STATA code used for the indentification, extraction, preparation, and analysis of an incident heart failure cohort derived from the U.S. Department of Veterans Affairs (VA) electronic health record database from Januay 1, 2000 to June 30, 2025.

The SQL scripts were used to extract the study population and relevant variables from the VA database, including demographic characteristics, comorbidities, laboratory values, left ventricular ejection fraction, and related clinical data. The extracted tables were then cleaned and merged into analytic datasets using STATA. STATA do-files were subsequently used for data management, cohort assembly, variable derivation, and statistical analyses.

To facilitate review, the STATA do-files are numbered sequentially to reflect the order of data cleaning and analytic workflow.

This repository is intended to document the analytic methods used in the associated manuscript and to support transparency and reproducibility to the extent permitted by VA data-use and privacy regulations.

## Repository Contents

This repository includes:
- SQL code for cohort identification and extraction of study variables from the VA database
- STATA code for data cleaning, merging, variable construction, and statistical analysis
- Sequentially numbered analysis files to indicate workflow order

## Use and interpretation

These scripts were created within the VA data environment (VA Informatics and Computing Infrastructure [VINCI]) and there are intended to document the analytic methods used in the associated manuscript. Because the underlying source data are not publicly available, and because some scripts depend on local table structures, file paths, and environment-specific settings, direct execution outside the VA environment may require modification.

This repository does **NOT** contain patient-level data.

## System requirements

### Software dependencies

The code was developed for use in the VA VINCI environment.

Required software includes:
- STATA
- SQL Server Management Studio or another SQL execution environment compatible with VA VINCI SQL Server databases
- Microsoft SQL Server
- Operating system: Windows Server environment within VA VINCI

No user-written STATA packages are required.

Tested software:
- STATA MP 18.0 and 19.0
- Microsoft SQL Server Management Studio: version 20.2.1
- Operating system: Windows Server 2019 Standard (environment used in VINCI)

## Required hardware
No non-standard hardware is required.

The full workflow was designed to run inside the VA VINCI environment. Runtime and memory requirements depend on the size of the source VA tables and the permissions, workspace, and computing resources available to the user.

## Installation Guide
1. Download this repository.
2. Upload the SQL files and STATA do-files onto an approved remote VINCI desktop.
3. Update database names, schema names, and output locations in the SQL scripts as needed for the approved VA VINCI project workspace.
4. Update file paths in the STATA do-files to match the local or VINCI directory structure.

## Typical installation time
Uploading the SQL scripts and STATA do-files should take less than 5 minutes. 

## Demo
No demo dataset is included because the analytic workflow depends on protected VA electronic health record data that cannot be shared publicly.

## Instructions for use
The full workflow requires authorized access to VA data sources within the VA VINCI environment.
The intended order of execution is:
1. Run the SQL scripts to identify the cohort and extract relevant variables from the VA database.
2. Export or save the extracted SQL output tables to the approved project workspace.
3. Run the STATA do-files in sequential order.
4. Review the generated logs and output files after each major step.
5. Use the final analytic dataset and statistical output to reproduce the analyses reported in the manuscript.
6. The STATA do-files are numbered to indicate the intended execution order.

## Reproduction instructions
The full quantitative results in the manuscript can be reproduced only by users with authorized access to the same VA data sources and project workspace.
To reproduce the manuscript results:
1. Obtain appropriate VA approvals and access to the required VINCI data sources.
2. Run the SQL scripts in the order indicated by the file names or project documentation.
3. Confirm that all extracted tables are saved in the expected project directory.
4. Run the STATA do-files sequentially.
5. Confirm that the final analytic dataset matches the cohort definitions described in the manuscript.
6. Compare the generated tables, figures, and model output with the reported manuscript results.

Because patient-level VA data cannot be made publicly available, external users will not be able to fully reproduce the manuscript results from this repository alone.

## Contact

Please contact the repository owner with any questions regarding the code or workflow:

Irfan Helmy, MD | Varun Sundaram, MD, PhD, MSc

ixh119@case.edu | vxs173@case.edu

Louis Stokes Cleveland Veteran Affairs Medical Center

Case Western Reserve University School of Medicine
