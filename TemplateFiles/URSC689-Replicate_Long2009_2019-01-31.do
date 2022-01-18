* Preinstall the following programs:
* ssc install estout // to create tables install estout
* ssc install fastcd // great for changing working directory quickly
/*-------1---------2---------3---------4---------5---------6--------*/
/* Start Log File: Change working directory to project directory    */
/*-------1---------2---------3---------4---------5---------6--------*/

capture log close   // suppress error and close any open logs
log using URSC689-Replicate_Long2009_2019-01-31, replace text
/********-*********-*********-*********-*********-*********-*********/
/* Description of Program                                           */
/********-*********-*********-*********-*********-*********-*********/
// program:    URSC689-Replicate_Long2009_2019-01-31.do
// task:       Setup Stata to Replicate Scott Long's 2009 Book
// version:    Second Draft - all files need to be in the same folder
// project:    URSC-SOCI 689
// author:     Nathanael Rosenheim \ Jan 16, 2019

/*------------------------------------------------------------------*/
/* Control Stata                                                    */
/*------------------------------------------------------------------*/
* Generic do file that sets up stata environment
clear all          // Clear existing data files
macro drop _all    // Drop macros from memory
version 14       // Set Version
set more off       // Tell Stata to not pause for --more-- messages
set varabbrev off  // Turn off variable abbreviations
set linesize 80    // Set Line Size - 80 Characters for Readability
numlabel _all, add // Print Prefix numeric values to value labels 
*set matsize 5000   // Set Matrix Size if program has a large matrix
*set max_memory 2g  // if the file size is larger than 64M change size


/*------------------------------------------------------------------*/
/* Install Workflow help files                                      */
/*------------------------------------------------------------------*/
* To see resources related to Scott Long 2009 Workflow book
findit workflow

* To install help files onto computer
* file will be installed in the ado plus folder
* for example C:\ado\plus\w
* to check where files are saved use the command
sysdir // list system directories

* Possible error if running with crtl+D - may have to run line 
net install wf-help.pkg, replace

* To download files related to book part 1
* NOTE: This command will download files to the current workding directory
* Change working directory first

* Command changes to working directory to folder named wf10-part1
cd Long2009_replicate_wf10_part1_part2
* Get part 1 files
net get wf10-part1.pkg, replace

* Get part 2 files
net get wf10-part2.pkg, replace


/*------------------------------------------------------------------*/
/* Close log and exit                                               */
/*------------------------------------------------------------------*/

log close
exit
