* Preinstall the following programs:
* ssc install estout, replace // describe add on programs needed to run do file
/*-------1---------2---------3---------4---------5---------6--------*/
/* Start Log File                                                   */
/*-------1---------2---------3---------4---------5---------6--------*/
capture log close   // suppress error and close any open logs
log using TMPWF_3av1_ExploreSAIPEPop, replace text

/********-*********-*********-*********-*********-*********-*********/
/* Description of Program                                           */
/********-*********-*********-*********-*********-*********-*********/
// program:      TMPWF_3av1_ExploreSAIPEPop
// task:         Explore Poverty and Population Data - 
//               Automate table and figures
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
global dofilename "TMPWF_3av1_ExploreSAIPEPop" 
capture mkdir ${dofilename}     // Folder saves all outputs from do file

/*********************************************************************/
/* Obtain Data                                                       */
/*********************************************************************/

local sourcefile = "TMPWF_2cv1_SAIPEMergePop" 
use "`sourcefile'/`sourcefile'.dta", clear

global provenance "Provenance: ${source} ${dofilename}.do `c(filename)' `c(current_date)'"

/*********************************************************************/
/* Explore Data - Create Tables and Figures to Interpret             */
/*********************************************************************/

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
local graphcaption = "Percent poverty has a normal distribution for Texas counties 2010"
histogram PALL, frequency normal kdensity ///
	title(`graphcaption', size(medium)) ///
	caption("$provenance", size(tiny))
graph export `"${dofilename}/${dofilename}_HistPALL.pdf"', replace
graph export `"${dofilename}/${dofilename}_HistPALL.tif"', replace

/********-*********-*********-*********-*********-*********-*********/
/* Model Data                                                       */
/********-*********-*********-*********-*********-*********-*********/
* Output Regression Table
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

/*-------------------------------------------------------------------*/
/* End Log                                                           */
/*-------------------------------------------------------------------*/

capture log close

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