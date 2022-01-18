* Preinstall the following programs:
* ssc install [], replace // describe add on programs needed to run do file
/*-------1---------2---------3---------4---------5---------6--------*/
/* Start Log File                                                   */
/*-------1---------2---------3---------4---------5---------6--------*/
capture log close   // suppress error and close any open logs
log using TMPWF_0av3_TemplateDoFile, replace text

/********-*********-*********-*********-*********-*********-*********/
/* Description of Program                                           */
/********-*********-*********-*********-*********-*********-*********/
// program:      TMPWF_0av3_TemplateDoFile
// task:         Template Do File for Replication Workflow
// Versions:      
// 2020-01-23    version 2 - modifications for Spring 2020
// 2021-03-12    Version 3 - updating for Spring 2021 URSC 689
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
global dofilename "TMPWF_0av3_TemplateDoFile_2021-03-12" 
capture mkdir ${dofilename}     // Folder saves all outputs from do file

/*********************************************************************/
/* Obtain Data                                                       */
/*********************************************************************/

import delimited using "../SourceData/"

/*-------------------------------------------------------------------*/
/* Save Final file                                                   */
/*-------------------------------------------------------------------*/

save "${dofilename}/${dofilename}.dta", replace

/*-------------------------------------------------------------------*/
/* End Log                                                           */
/*-------------------------------------------------------------------*/

log close

/*-------------------------------------------------------------------*/
/* Move Log File                                                     */
/*-------------------------------------------------------------------*/
* Log files tend to get in the way, this step cleans up the folder
copy ${dofilename}.log  ${dofilename}/${dofilename}.log, replace
erase  ${dofilename}.log

exit