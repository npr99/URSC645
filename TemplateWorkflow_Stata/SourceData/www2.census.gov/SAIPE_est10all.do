* Preinstall the following programs:
* ssc install estout // to create tables install estout
/*-------1---------2---------3---------4---------5---------6--------*/
/* Start Log File                                                   */
/*-------1---------2---------3---------4---------5---------6--------*/
capture log close   // suppress error and close any open logs
log using SAIPE_est10all, replace text
/********-*********-*********-*********-*********-*********-*********/
/* Description of Program                                           */
/********-*********-*********-*********-*********-*********-*********/
// program:    SAIPE_est10all
// task:       Obtain Source Data and codebook SAIPE est10all.xls
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
* Small Area Income and Poverty Estimates
* Texas County Estimates for 2010
copy "https://www2.census.gov/programs-surveys/saipe/datasets/2010/2010-state-and-county/est10all.xls" ///
     "SAIPE_est10all.xls", replace
copy "https://www2.census.gov/programs-surveys/saipe/technical-documentation/file-layouts/state-county/2010-estimate-layout.txt" ///
     "SAIPE_2010-estimate-layout.txt", replace

/*-------------------------------------------------------------------*/
/* End Log                                                           */
/*-------------------------------------------------------------------*/

log close
exit