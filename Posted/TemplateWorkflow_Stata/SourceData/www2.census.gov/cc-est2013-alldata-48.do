* Preinstall the following programs:
* ssc install estout // to create tables install estout
/*-------1---------2---------3---------4---------5---------6--------*/
/* Start Log File                                                   */
/*-------1---------2---------3---------4---------5---------6--------*/
capture log close   // suppress error and close any open logs
log using cc-est2013-alldata-48, replace text
/********-*********-*********-*********-*********-*********-*********/
/* Description of Program                                           */
/********-*********-*********-*********-*********-*********-*********/
// program:    cc-est2013-alldata-48
// task:       Obtain Source Data and codebook cc-est2013-alldata-48.csv
// version:    2021-03-12 - Simplified steps to just obtain 1 file
// project:    Template Workflow
// author:     Nathanael Rosenheim

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

/********-*********-*********-*********-*********-*********-*********/
/* Obtain Data                                                      */
/********-*********-*********-*********-*********-*********-*********/
* US Census Bureau - Texas County Characteristics Datasets: 
* Annual County Resident Population Estimates by 
* Age, Sex, Race, and Hispanic Origin: April 1, 2010 to July 1, 2013

copy "https://www2.census.gov/programs-surveys/popest/datasets/2010-2013/counties/asrh/cc-est2013-alldata-48.csv" ///
     "cc-est2013-alldata-48.csv", replace
copy "https://www2.census.gov/programs-surveys/popest/technical-documentation/file-layouts/2010-2013/cc-est2013-alldata.pdf" ///
     "cc-est2013-alldata.pdf", replace

	
/*-------------------------------------------------------------------*/
/* End Log                                                           */
/*-------------------------------------------------------------------*/

log close
exit
