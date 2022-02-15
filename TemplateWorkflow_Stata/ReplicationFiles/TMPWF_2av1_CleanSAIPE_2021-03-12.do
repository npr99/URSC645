* Preinstall the following programs:
* ssc install [], replace // describe add on programs needed to run do file
/*-------1---------2---------3---------4---------5---------6--------*/
/* Start Log File                                                   */
/*-------1---------2---------3---------4---------5---------6--------*/
capture log close   // suppress error and close any open logs
log using TMPWF_2av1_CleanSAIPE, replace text

/********-*********-*********-*********-*********-*********-*********/
/* Description of Program                                           */
/********-*********-*********-*********-*********-*********-*********/
// program:      TMPWF_2av1_CleanSAIPE
// task:         Clean SAIPE Data
// Versions:      
// 2021-03-12    Version 1
// project:      Template Workflow
// funding:	     Texas A&M University, Landscape Architecture and Urban Planning
// author(s):    Nathanael Rosenheim

/*------------------------------------------------------------------*/
/* Control Stata                                                    */
/*------------------------------------------------------------------*/
* Generic do file that sets up Stata environment
clear all          // Clear existing data files
macro drop _all    // Drop macros from memory
version 15         // Set Version
set more off       // Tell Stata to not pause for --more-- messages
set varabbrev off  // Turn off variable abbreviations
set linesize 80    // Set Line Size - 80 Characters for Readability
* set matsize 5000   // Set Matrix Size
* set max_memory 2g  // the file size is larger than 64M 

/*-------------------------------------------------------------------*/
/* Set Provenance                                                    */
/*-------------------------------------------------------------------*/
// What is the do file name? What program is needed to replicate results?
global dofilename "TMPWF_2av1_CleanSAIPE" 
capture mkdir ${dofilename}     // Folder saves all outputs from do file

/*********************************************************************/
/* Obtain Data                                                       */
/*********************************************************************/

import excel  "../SourceData/www2.census.gov/SAIPE_est10ALL.xls", clear
* Store notes about source data
notes: Source U.S. Census Bureau, 2010 ///
Small Area Income and Poverty Estimates (SAIPE) ///
State and County Estimates ///
Retrieved on `c(current_date)' from www2.census.gov/programs-surveys/saipe/ ///
datasets/2010/2010-state-and-county/est10all.xls

notes: Cleaned file contains poverty estimates for Texas Counties

/*********************************************************************/
/* Clean Data                                                        */
/*********************************************************************/
/*------------------------------------------------------------------*/
/* Drop Variables and Observations SAIPE File                       */
/*------------------------------------------------------------------*/

drop E-G K-AE      // Do not need variables

* Example of Stata native variables
drop if _n <= 3    // Drop first 3 rows
keep if A == "48"  // Keep Texas
drop if B == "0" // Drop observation for entire state
destring, replace  // Convert Strings to numeric

/*------------------------------------------------------------------*/
/*  Rename and Label Variables to SAIPE File                        */
/*------------------------------------------------------------------*/

rename H PALL      // Poverty Percent All Ages
label variable PALL "Poverty Percent All Ages"
notes PALL: Source U.S. Census Bureau, 2010 SAIPE State and County Estimates


* Poverty Confidence Intervals
rename I PALL_LB 
label variable PALL_LB "Poverty Percent All Ages CI LB"
notes PALL_LB: 90% confidence interval lower bound of ///
estimate of percent of people of all ages in poverty
notes PALL_LB: Source U.S. Census Bureau, 2010 SAIPE State and County Estimates

rename J PALL_UB 
label variable PALL_UB "Poverty Percent All Ages CI UB"
notes PALL_UB: 90% confidence interval upper bound of ///
estimate of percent of people of all ages in poverty
notes PALL_UB: Source U.S. Census Bureau, 2010 SAIPE State and County Estimates

rename D countyname
label variable countyname "County Name"

rename C state
label variable state "State Abbreviation"

gen year = 2010
label variable year "Year"

/*------------------------------------------------------------------*/
/*  ADD UNIQUE ID                                                   */
/*------------------------------------------------------------------*/
// generated FIPS_Code from State and County Codes
gen str5 FIPS_County = string(A,"%02.0f")+string(B,"%03.0f")
label variable FIPS_County "FIPS County Code"
notes FIPS_County: Unique ID for County
sort FIPS_County
* move unique id to first column
order FIPS_County

* Variables A B no longer needed
drop A B

/*-------------------------------------------------------------------*/
/* Save Final file                                                   */
/*-------------------------------------------------------------------*/

label data "2010 Poverty Estimates for Texas Counties"
save "${dofilename}/${dofilename}.dta", replace

/*-------------------------------------------------------------------*/
/* End Log                                                           */
/*-------------------------------------------------------------------*/

capture log close

/*-------------------------------------------------------------------*/
/* Generate Codebook                                                 */
/*-------------------------------------------------------------------*/

capture log close Codebook

log using "${dofilename}/${dofilename}_codebook.txt", replace text ///
	name(Codebook)

codebook, compact

codebook, detail all

capture log close Codebook

/*-------------------------------------------------------------------*/
/* Move Log File                                                     */
/*-------------------------------------------------------------------*/
* Log files tend to get in the way, this step cleans up the folder
copy ${dofilename}.log  ${dofilename}/${dofilename}.log, replace
erase  ${dofilename}.log

exit
/*
File Nameing:
All files must start with the project or subproject mnemonic
All files should end with the date in the format YYYY-MM-DD

File Name Structure
                   s     #
                    \   /     description         extension
                     - -     /                    /
                PRJ_tsv#_xxxxxxxxxxxx_yyyy-mm-dd.ext
                   -  -                -   -  -
                  /  /                 |   |  |
                 t  v                  y   m  d


            name    length          contents
            -----------------------------------------------------------
            PRJ         3-5         Project Mnemonic (fixed string)
            _            1          padding underscore
            t            1          datascience workflow task number (0-6)
            s            1          letter step within task (a,b,c..)
            v            1          v = version
            #            1          version number (1,2,3,4...)
            _            1          padding underscore
            x           5-10*       description of step
            _            1          padding underscore
            y            4          year (2017,2018,2019,2020...)
            -            1          padding dash
            m            2          month (01,02...12)
            -            1          padding dash
            d            2          date (01,02,...31)
            .            1          decimal
            ext          3          file type extension
            -----------------------------------------------------------
            t: datascience workflow task numbers
		0 = Research Log or Project Admin
		1 = Obtain Data
		2 = Clean Data
		3 = Explore Data
		4 = Model Data
		5 = Interpret Data
		6 = Publish Data
		
*/