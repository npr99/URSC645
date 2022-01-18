* Preinstall the following programs:
* ssc install [], replace // describe add on programs needed to run do file
/*-------1---------2---------3---------4---------5---------6--------*/
/* Start Log File - Change name of log file to match program name   */
/*-------1---------2---------3---------4---------5---------6--------*/
capture log close master   // suppress error and close any open logs
log using 00_templatedofile_2020-02-10, ///
	replace text name(master)

/********-*********-*********-*********-*********-*********-*********/
/* Description of Program                                           */
/********-*********-*********-*********-*********-*********-*********/
// program:    00_templatedofile_2020-02-10.do
// task:       Template Do File
// Version:    first Version
// project:    Template Stata Program Example
// author:     Nathanael Rosenheim \ Feb 10, 2020

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
* set matsize 5000   // Set Matrix Size
* set max_memory 2g  // the file size is larger than 64M 

/********-*********-*********-*********-*********-*********-*********/
/* Set Provenance - What is the do file name?                       */
/********-*********-*********-*********-*********-*********-*********/
global dofilename "00_templatedofile_2020-02-10" 
capture mkdir ${dofilename}     // Folder to save outputs from do file

/********************************************************************/
/* Obtain Data                                                      */
/********************************************************************/


/*------------------------------------------------------------------*/
/* Save Final file                                                  */
/*------------------------------------------------------------------*/
save "${dofilename}/${dofilename}.dta", replace

/*------------------------------------------------------------------*/
/* End Log                                                          */
/*------------------------------------------------------------------*/

log close master
exit
