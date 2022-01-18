* Preinstall the following programs:
* ssc install [], replace // describe add on programs needed to run do file
/*-------1---------2---------3---------4---------5---------6--------*/
/* Start Log File                                                   */
/*-------1---------2---------3---------4---------5---------6--------*/
capture log close   // suppress error and close any open logs
log using TMPWF_2bv1_CleanPopEst, replace text

/********-*********-*********-*********-*********-*********-*********/
/* Description of Program                                           */
/********-*********-*********-*********-*********-*********-*********/
// program:      TMPWF_2bv1_CleanPopEst
// task:         Clean Population Estimates
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
global dofilename "TMPWF_2bv1_CleanPopEst" 
capture mkdir ${dofilename}     // Folder saves all outputs from do file

/*********************************************************************/
/* Obtain Data                                                       */
/*********************************************************************/

import delimited "../SourceData/www2.census.gov/cc-est2013-alldata-48.csv", clear
* Store notes about source data
notes: Source U.S. Census Bureau, Population Division ///
Annual County Resident Population Estimates by Age, Sex, Race, ///
and Hispanic Origin: April 1, 2010 to July 1, 2013 ///
Retrieved on `c(current_date)' from www2.census.gov/programs-surveys/ ///
popest/datasets/2010-2013/counties/asrh/cc-est2013-alldata-48.csv

notes: Cleaned file contains population estimates for Texas Counties

/*********************************************************************/
/* Clean Data                                                        */
/*********************************************************************/
/*------------------------------------------------------------------*/
/*  Drop Variables and Observations Population File                 */
/*------------------------------------------------------------------*/

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

gen tot_ba = ba_male + ba_female // total Black alone population
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
/*  ADD UNIQUE ID                                                   */
/*------------------------------------------------------------------*/
// generated FIPS_Code from State and County Codes
gen str5 FIPS_County = string(state,"%02.0f")+string(county,"%03.0f")
label variable FIPS_County "FIPS County Code"
notes FIPS_County: Unique Merge ID for County
sort FIPS_County

* Variables state county no longer needed
drop state county 
/*------------------------------------------------------------------*/
/*  Reorder variables                                               */
/*------------------------------------------------------------------*/

local keepvars FIPS_County year tot* p_* 
order `keepvars'
keep `keepvars'       // drop sex variables

/*-------------------------------------------------------------------*/
/* Save Final file                                                   */
/*-------------------------------------------------------------------*/

label data "2010 Population Estimates for Texas Counties"
save "${dofilename}/${dofilename}.dta", replace

/*-------------------------------------------------------------------*/
/* End Log                                                           */
/*-------------------------------------------------------------------*/

capture log close

/*-------------------------------------------------------------------*/
/* Generate Codebook                                                 */
/*-------------------------------------------------------------------*/

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