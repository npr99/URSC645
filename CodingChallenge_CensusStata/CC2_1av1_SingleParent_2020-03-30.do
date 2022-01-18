* Preinstall the following programs:
* ssc install estout // to create tables install estout
/*-------1---------2---------3---------4---------5---------6--------*/
/* Start Log File                                                   */
/*-------1---------2---------3---------4---------5---------6--------*/

capture log close   // suppress error and close any open logs
log using CC2_1av1_SingleParent_2020-03-30, replace text
/********-*********-*********-*********-*********-*********-*********/
/* Description of Program                                           */
/********-*********-*********-*********-*********-*********-*********/
// program:    CC2_1av1_SingleParent_2020-03-30.do
// task:       Compare single parent statistic from 2 ACS Tables
// version:    First Draft
// project:    URSC 689 - CC2
// author:     Nathanael Rosenheim \ March 30, 2020

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
global dofilename "CC2_1av1_SingleParent_2020-03-30" 
global source "U.S. Census Bureau" // what is the data source

/*-------------------------------------------------------------------*/
/* Establish Project Directory Structure                             */
/*-------------------------------------------------------------------*/
* Stata can create folders if they do not exist
capture mkdir ${dofilename}     // Folder saves all outputs from do file

/********-*********-*********-*********-*********-*********-*********/
/* Obtain Data - B09002                                             */
/********-*********-*********-*********-*********-*********-*********/
* US Census Bureau - Texas County Characteristics Datasets: 
global sourcedata "..\SourceData\data.census.gov\"
global B09002 "ACSDT5Y2018.B09002_2020-03-30T094416"

insheet using "${sourcedata}/${B09002}/ACSDT5Y2018.B09002_data_with_overlays_2020-03-30T094414.csv", ///
	clear names
* Store notes about source data
notes: Source U.S. Census Bureau, ACS ///
B09002 ///
OWN CHILDREN UNDER 18 YEARS BY FAMILY TYPE AND AGE ///
Retrieved on 2020-03-30 from data.census.gov 

* second row has the label - for now drop second row and destring
drop if _n == 1

* destring all values
destring, replace

/* create a temporary file */
tempfile ACS_B09002
save "`ACS_B09002'", replace


/********-*********-*********-*********-*********-*********-*********/
/* Obtain Data - B11005                                            */
/********-*********-*********-*********-*********-*********-*********/
* US Census Bureau - Texas County Characteristics Datasets: 
global sourcedata "..\SourceData\data.census.gov\"
global B11005 "ACSDT5Y2018.B11005_2020-03-30T093818"

insheet using "${sourcedata}/${B11005}/ACSDT5Y2018.B11005_data_with_overlays_2020-03-30T093815.csv", ///
	clear names
* Store notes about source data
notes: Source U.S. Census Bureau, ACS ///
B11005 ///
HOUSEHOLDS BY PRESENCE OF PEOPLE UNDER 18 YEARS BY HOUSEHOLD TYPE ///
Retrieved on 2020-03-30 from data.census.gov 

* second row has the label - for now drop second row and destring
drop if _n == 1

* destring all values
destring, replace

/* create a temporary file */
tempfile ACS_B11005
save "`ACS_B11005'", replace

/********-*********-*********-*********-*********-*********-*********/
/* Scrub Data - Derive Stata Files from Sources                     */
/********-*********-*********-*********-*********-*********-*********/
/*------------------------------------------------------------------*/
/*  Merge B09002 and B11005                                         */
/*------------------------------------------------------------------*/

use `ACS_B09002', clear 
merge 1:1 geo_id using `ACS_B11005'

drop _merge

/*------------------------------------------------------------------*/
/*  Reorder Variables                                               */
/*------------------------------------------------------------------*/

/*------------------------------------------------------------------*/
/*  Label Key Variables                                             */
/*------------------------------------------------------------------*/

label variable B09002_001E "Estimate Total Families Own children under 18 years"

label variable B09002_008E "Estimate Total In Other Families"
notes B09002_008E: Assuming that other families means Single-Parent Households ///
either no wife or no husband present.

label variable B11005_001E "Estimate Total Households"

label variable B09002_008E "Estimate Total Family households!!Other family"


gen year = 2018
label variable year "Year"

/*------------------------------------------------------------------*/
/*  Generate new Percent Versions of Single Parent Variables        */
/*------------------------------------------------------------------*/

* Label variables
label variable p_wa "Percent White"
notes p_wa: Percent White alone, Not Hispanic of Total Population

label variable p_ba "Percent Black"
notes p_ba: Percent Black or African American alone, Not Hispanic of Total Population

label variable p_h  "Percent Hispanic" 
notes p_h: Percent Hispanic of Total Population

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
/* Save File as Stata .dta file                                     */
/*------------------------------------------------------------------*/
saveold "${dofilename}/${dofilename}.dta", version(14) replace

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
	


