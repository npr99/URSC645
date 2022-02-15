* Preinstall the following programs:
* ssc install [], replace // describe add on programs needed to run do file
/*-------1---------2---------3---------4---------5---------6--------*/
/* Start Log File                                                   */
/*-------1---------2---------3---------4---------5---------6--------*/
capture log close   // suppress error and close any open logs
log using TMPWF_2cv1_SAIPEMergePop, replace text

/********-*********-*********-*********-*********-*********-*********/
/* Description of Program                                           */
/********-*********-*********-*********-*********-*********-*********/
// program:      TMPWF_2cv1_SAIPEMergePop
// task:         Merge SAIPE and Population Estimates
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
global dofilename "TMPWF_2cv1_SAIPEMergePop" 
capture mkdir ${dofilename}     // Folder saves all outputs from do file

/*********************************************************************/
/* Obtain Data                                                       */
/*********************************************************************/

local sourcefile = "TMPWF_2av1_CleanSAIPE"
use "`sourcefile'/`sourcefile'.dta", clear

/*********************************************************************/
/* Clean Data                                                        */
/*********************************************************************/
/*------------------------------------------------------------------*/
/*  Merge SAIPE and Population Data                                 */
/*------------------------------------------------------------------*/

local mergefile = "TMPWF_2bv1_CleanPopEst"
merge 1:1 FIPS_County year using "`mergefile'/`mergefile'.dta",

drop _merge
order FIPS_County year countyname state

/*-------------------------------------------------------------------*/
/* Save Final file                                                   */
/*-------------------------------------------------------------------*/

label data "2010 Population and Poverty Estimates for Texas Counties"
save "${dofilename}/${dofilename}.dta", replace

/*------------------------------------------------------------------*/
/* Save File as CSV file                                            */
/*------------------------------------------------------------------*/
outsheet using ///
     "${dofilename}/${dofilename}.csv", comma replace
	 
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