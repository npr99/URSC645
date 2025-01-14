* Preinstall the following programs:
* ssc install estout // to create tables install estout
/*-------1---------2---------3---------4---------5---------6--------*/
/* Start Log File                                                   */
/*-------1---------2---------3---------4---------5---------6--------*/

capture log close   // suppress error and close any open logs
log using TMPFWF-1av2_TemplateDoFile-2020-02-03, replace text
/********-*********-*********-*********-*********-*********-*********/
/* Description of Program                                           */
/********-*********-*********-*********-*********-*********-*********/
// program:    TMPFWF-1av2_TemplateDoFile-2020-02-03.do
// task:       Demonstrate basic Stata Workflow
// version:    Major Revision Second Draft
// project:    Template Workflow
// author:     Nathanael Rosenheim \ Feb 10, 2017

/*------------------------------------------------------------------*/
/* Control Stata                                                    */
/*------------------------------------------------------------------*/
* Generic do file that sets up stata environment
clear all          // Clear existing data files
macro drop _all    // Drop macros from memory
version 15.1       // Set Version
set more off       // Tell Stata to not pause for --more-- messages
set varabbrev off  // Turn off variable abbreviations
set linesize 80    // Set Line Size - 80 Characters for Readability
numlabel _all, add // Print Prefix numeric values to value labels 
*set matsize 5000   // Set Matrix Size if program has a large matrix
*set max_memory 2g  // if the file size is larger than 64M change size

/*-------------------------------------------------------------------*/
/* Set Provenance                                                    */
/*-------------------------------------------------------------------*/
// What is the do file name? What program is needed to replicate results?
global dofilename "TMPFWF-1av2_TemplateDoFile-2020-02-03" 
global source "U.S. Census Bureau" // what is the data source

/*-------------------------------------------------------------------*/
/* Establish Project Directory Structure                             */
/*-------------------------------------------------------------------*/
* Stata can create folders if they do not exist
capture mkdir ${dofilename}     // Folder saves all outputs from do file

/********-*********-*********-*********-*********-*********-*********/
/* Obtain Data                                                      */
/********-*********-*********-*********-*********-*********-*********/
* US Census Bureau - Texas County Characteristics Datasets: 
* Annual County Resident Population Estimates by 
* Age, Sex, Race, and Hispanic Origin: April 1, 2010 to July 1, 2013

copy "https://www2.census.gov/programs-surveys/popest/datasets/2010-2013/counties/asrh/cc-est2013-alldata-48.csv" ///
     "${dofilename}/POP_CC-EST2013-ALLDATA-48.csv", replace
copy "https://www2.census.gov/programs-surveys/popest/technical-documentation/file-layouts/2010-2013/cc-est2013-alldata.pdf" ///
     "${dofilename}/POP_CC-EST2013-ALLDATA-48_Codebook.pdf", replace

* Small Area Income and Poverty Estimates
* Texas County Estimates for 2010
copy "https://www2.census.gov/programs-surveys/saipe/datasets/2010/2010-state-and-county/est10all.xls" ///
     "${dofilename}/SAIPE_est10all.xls", replace
copy "https://www2.census.gov/programs-surveys/saipe/technical-documentation/file-layouts/state-county/2010-estimate-layout.txt" ///
     "${dofilename}/SAIPE_est10ALL_Codebook.txt", replace

/********-*********-*********-*********-*********-*********-*********/
/* Scrub Data - Derive Stata Files from Sources                     */
/********-*********-*********-*********-*********-*********-*********/
/* Common scrubbing tasks
- Convert data from one format to another
- Filter observations
- Extract and replace values
- Split, merge, stack, or extract columns */

/*------------------------------------------------------------------*/
/* Create Population Estimates Stata file from CSV                  */
/*------------------------------------------------------------------*/

insheet using "${dofilename}/POP_CC-EST2013-ALLDATA-48.csv", clear
* Store notes about source data
notes: Source U.S. Census Bureau, Population Division ///
Annual County Resident Population Estimates by Age, Sex, Race, ///
and Hispanic Origin: April 1, 2010 to July 1, 2013 ///
Retrieved on `c(current_date)' from www2.census.gov/programs-surveys/ ///
popest/datasets/2010-2013/counties/asrh/cc-est2013-alldata-48.csv

/* create a temporary file */
tempfile POP_EST2013ALLDATA48
save "`POP_EST2013ALLDATA48'", replace

/*------------------------------------------------------------------*/
/*  Create SAIPE Stata file from Excel                              */
/*------------------------------------------------------------------*/

import excel "${dofilename}/SAIPE_est10ALL.xls", clear
* Store notes about source data
notes: Source U.S. Census Bureau, 2010 ///
Small Area Income and Poverty Estimates (SAIPE) ///
State and County Estimates ///
Retrieved on `c(current_date)' from www2.census.gov/programs-surveys/saipe/ ///
datasets/2010/2010-state-and-county/est10all.xls
/* create a temporary file: Stata assigns data to local macro names.
	When the program or do-file concludes data are erased. */

tempfile SAIPE_est10ALL
save `SAIPE_est10ALL', replace

/*------------------------------------------------------------------*/
/*  Drop Variables and Observations Population File                 */
/*------------------------------------------------------------------*/

use `POP_EST2013ALLDATA48', clear
keep if year == 1   //  4/1/2010 Census population
keep if agegrp == 0 //  Total age groups
keep state county  tot_pop wa* ba* h_* // Keep white, black Hispanic totals

/*------------------------------------------------------------------*/
/*  Add and Label Variables to Population File                      */
/*------------------------------------------------------------------*/

gen tot_wa = wa_male + wa_female // total white alone population
label variable tot_wa "Total White Alone"
notes tot_wa: Based on Annual County Resident Population Estimates ///
White alone male population + White alone female population

gen tot_ba = ba_male + ba_female // total black alone population
label variable tot_ba "Total Black Alone"
notes tot_ba: Based on Annual County Resident Population Estimates ///
Black or African American alone male population + ///
Black or African American alone female population

gen tot_h = h_male + h_female // total Hispanic alone population
label variable tot_h "Total Hispanic"
notes tot_h: Based on Annual County Resident Population Estimates ///
Hispanic male population + ///
Hispanic female population

label variable tot_pop "Total Population"
notes tot_pop: Based on Annual County Resident Population Estimates ///
Total County Population for 4/1/2010 Census population

gen year = 2010
label variable year "Year"

/*------------------------------------------------------------------*/
/*  Generate new Percent Versions of Race/Ethnicity Variables       */
/*------------------------------------------------------------------*/

foreach re in wa ba h { // loop through white, black, Hispanic
 gen p_`re' = tot_`re' / tot_pop * 100 
 format p_`re' %04.2f //
}
* Label variables
label variable p_wa "Percent White"
notes p_wa: Percent White alone, Not Hispanic of Total Population

label variable p_ba "Percent Black"
notes p_ba: Percent Black or African American alone, Not Hispanic of Total Population

label variable p_h  "Percent Hispanic" 
notes p_h: Percent Hispanic of Total Population

/*------------------------------------------------------------------*/
/*  ADD MERGE ID                                                    */
/*------------------------------------------------------------------*/
// generated FIPS_Code from State and County Codes
gen str5 FIPS_County = string(state,"%02.0f")+string(county,"%03.0f")
label variable FIPS_County "FIPS County Code"
notes FIPS_County: Unique Merge ID for County
sort FIPS_County

* Variables state county no longer needed
drop state county 
/*------------------------------------------------------------------*/
/*  Create a temporary file Population File                         */
/*------------------------------------------------------------------*/

local keepvars FIPS_County year tot* p_* 
order `keepvars'
keep `keepvars'       // drop sex variables

tempfile Pop_2010_TX
save `Pop_2010_TX', replace

/*------------------------------------------------------------------*/
/* Drop Variables and Observations SAIPE File                       */
/*------------------------------------------------------------------*/

use `SAIPE_est10ALL', clear
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
/*  ADD MERGE ID                                                    */
/*------------------------------------------------------------------*/
// generated FIPS_Code from State and County Codes
gen str5 FIPS_County = string(A,"%02.0f")+string(B,"%03.0f")
label variable FIPS_County "FIPS County Code"
notes FIPS_County: Unique Merge ID for County
sort FIPS_County

* Variables A B no longer needed
drop A B
/*------------------------------------------------------------------*/
/*  Create a temporary file SAIPE File                              */
/*------------------------------------------------------------------*/
tempfile SAIPE_2010_TX
save `SAIPE_2010_TX', replace

/*------------------------------------------------------------------*/
/*  Merge SAIPE and Population Data                                 */
/*------------------------------------------------------------------*/

use `Pop_2010_TX', clear 
merge 1:1 FIPS_County year using `SAIPE_2010_TX'

drop _merge
order FIPS_County year countyname state/* create a temporary file */

tempfile SAIPE_POP_2010_TX
save `SAIPE_POP_2010_TX', replace

/*------------------------------------------------------------------*/
/* Save File as Stata .dta file                                     */
/*------------------------------------------------------------------*/
saveold "${dofilename}/${dofilename}.dta", version(12) replace

/*------------------------------------------------------------------*/
/* Save File as CSV file                                            */
/*------------------------------------------------------------------*/
outsheet using ///
     "${dofilename}/${dofilename}.csv", comma replace
	 
/********-*********-*********-*********-*********-*********-*********/
/* Explore Data - Create Tables and Figures to Interpret            */
/********-*********-*********-*********-*********-*********-*********/
* ssc install estout, replace // to create tables install estout
* Create Table with Descriptive Statistics
use "${dofilename}/${dofilename}.dta", replace

global provenance "Provenance: ${source} ${dofilename}.do `c(filename)' `c(current_date)'"

/*------------------------------------------------------------------*/
/* Output Descriptive Statistics Table to Word                      */
/*------------------------------------------------------------------*/

local dscrb_vars PALL p_*  // Variables to describe

* Use estout Commands to output tables to Rich Text File 
eststo clear
estpost tabstat `dscrb_vars', ///
		statistics(min max p50 mean sd count) columns(statistics)
esttab using ///
`"${dofilename}/${dofilename}.rtf"' ///
, alignment(r) replace label gaps modelwidth(6) nonumbers  ///
cells("count(fmt(%4.0f)) min(fmt(%4.2f)) max(fmt(%4.2f)) p50(fmt(%4.2f)) mean(fmt(%4.2f)) sd(fmt(%4.2f))") noobs ///
title(Basic Descriptive Statistics Poverty and Population Data for Texas Counties 2010) ///
addnote("$provenance")
eststo clear

/*------------------------------------------------------------------*/
/* Save Histogram to PDF File and Image File                        */
/*------------------------------------------------------------------*/
* Create Histogram of poverty
use "${dofilename}/${dofilename}", replace
local graphcaption = "Histogram of Percent Poverty for Texas Counties 2010."
histogram PALL, frequency normal kdensity ///
	title(`graphcaption') ///
	caption("$provenance", size(tiny))
graph export `"${dofilename}/${dofilename}_HistPALL.pdf"', replace
graph export `"${dofilename}/${dofilename}_HistPALL.tif"', replace
notes: Poverty has a normal distribution

* Save again to save notes
saveold "${dofilename}/${dofilename}.dta", version(12) replace

/********-*********-*********-*********-*********-*********-*********/
/* Model Data                                                       */
/********-*********-*********-*********-*********-*********-*********/
* Output Regression Table
use "${dofilename}/${dofilename}", replace
eststo: regress PALL p_ba p_h

esttab using ///
	`"${dofilename}/${dofilename}.rtf"' ///
	, append ///
	b(%4.3f) se(%4.3f) ///
	ar2 onecell  label modelwidth(6) nonumbers  /// 
	title(Parameter Estimates from Models of Poverty with Race and Ethnicity) ///
	alignment(c) parentheses ///
	addnote("$provenance")
eststo clear

esttab using ///
	`"${dofilename}/${dofilename}.rtf"' ///
	, append ///
	b(%10.2fc) ci(%10.2fc) ///	
	r2 nogap wide nopar label modelwidth(10) ///
	title(Parameter Estimates from Models of Poverty with Race and Ethnicity) ///
	alignment(c) ///
	addnote("$provenance")
eststo clear

notes: Race and ethnicity predictors have significant coef.
notes: Include median income? Will race still be significant?

* Save again to save notes
saveold "${dofilename}/${dofilename}.dta", version(12) replace
/********-*********-*********-*********-*********-*********-*********/
/* Interpret Data                                                   */
/********-*********-*********-*********-*********-*********-*********/
notes  // View notes
// Example of how Stata stores regression results

notes: For Texas in 2010, at the county level, ///
there was a significant association between    ///
percent poverty, percent Black, and Percent Hispanic. ///
The model had `e(N)' counties and ///
an adjusted r-square of `e(r2_a)'. ///


/*-------------------------------------------------------------------*/
/* Notes on Data Sources                                             */
/*-------------------------------------------------------------------*/

* Best option is to use saveold - otherwise collaborators using 
* an early version will not be able to open data files
saveold "${dofilename}/${dofilename}.dta", version(12) replace

notes: $provenance
saveold "${dofilename}/${dofilename}.dta", version(12) replace

/*-------------------------------------------------------------------*/
/* End Log                                                           */
/*-------------------------------------------------------------------*/

log close

/*-------------------------------------------------------------------*/
/* Generate Codebook                                                 */
/*-------------------------------------------------------------------*/
log using "${dofilename}/${dofilename}_codebook.txt", replace text

codebook, compact

codebook, detail all

log close
exit


* NOTE * Nothing below "exit" will run or be included in the log file

to replicate a random process use "set seed"
however, this only works if the data have a unique identifier and 
the data is sorted by this unique id. 
Be sure to confirm that the random process can be replicated. 


eststo, esttab come from estout
For more information on estout see: Making Regression Tables in Stata
     http://repec.org/bocode/e/estout/

/********-*********-*********-*********-*********-*********-*********/
/* QUICK STATA REMINDERS                                            */
/********-*********-*********-*********-*********-*********-*********/
Good resources: 
1. http://data.princeton.edu/stata/
2. http://www.ats.ucla.edu/stat/stata/
3. Programming Stata - http://www.stata.com/manuals13/u18.pdf

Stata is case sensitive - for variable names as well as commands. 
Stata sees a return as then end of a line.

Create indents with spaces instead of tabs - if possible.
Avoid spaces in folder and file names.

Macros - See help macro
/********-*********-*********-*********-*********-*********-*********/
local name = expression      
     `name' defined by expression
      Use for numbers, strings, nested macros ie. name = "`var'`i'"
      During execute in the do-file where created

local name variable list 
     `name' contains list of variables * NOTE * Missing equal sign
      Great for model variables
      During execute in the do-file where created

global same options as local
      $name or ${name} - when using {} name can be nested ${`var'`i'}
	  Great for project name, filter options
      During current Stata session, across all do-files  
	  
STATA If Conditions 
Operator  Meaning
/********-*********-*********-*********/
==        equal to
>         greater than
>=        greater than or equal to
<         less than
<=        less than or equal to\
!= or ~=  not equal to
&         combine operators AND
|         combine operators OR

Stata has two built-in variables called _n and _N. 
_n is Stata notation for the current observation number. 
_n is 1 in the first observation, 2 in the second, 3 in the third, and so on.
_N is Stata notation for the total number of observations.


Comment types
  Comments may be added to programs in three ways:
        o begin the line with *
        o begin the comment with // or
        o place the comment between /* and */ delimiters.
		
/// A "Triple Forward Slash" comment is one way to make long lines more readable
/// The "Triple Forward Slash" makes Stata ignore the "return" so that that 
/// Stata will "Read" the next line as a continuation
Like the "Double Forward Slash" // comment indicator, the /// indicator must be preceded by one or
    more blanks.

Additional ways to control Stata
set varabbrev off  // Turn off variable abbreviations
set linesize 80    // Set Line Size - 80 Characters for Readability

Stata 12 can not read *.dta files saved in Stata 13 
saveold will fix this problem

To create a directory use the command capture mkdir

Relative Paths vs. Absolute Paths
Stata will use relative paths which means that the program does not need 
to include the full path name for a file.
To check the "Current Directory" type the command cd 
To change the "Current Directory" use the command cd ["]directory_name["]
The tool fastcd is also helpful for changing directories
If Stata is launched by double clicking on a .do file the current directory
will be automatically set to the directory of the .do file

Stata notes command
The notes command is a great way to store metadata about variables and datafiles.
A variable can have multiple notes.
The notes command respects SMCL directives (see help smcl) so you can use 
those to add formatting to notes (including boldface, italics, URLs, etc).
For example:
note: Source: {break} ///
	Rosenheim, N. (2018). {it:Stata Template Workflow}. {break} ///
	{browse "https://github.com/npr99":Available on Github}
	


