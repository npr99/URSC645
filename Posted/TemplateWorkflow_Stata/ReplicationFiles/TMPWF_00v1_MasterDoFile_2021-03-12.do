/********-*********-*********-*********-*********-*********-*********/
/* Description of Program                                           */
/********-*********-*********-*********-*********-*********-*********/
// program:      TMPWF_00v1_MasterDoFile
// task:         Master Do File - shows which do files to run in order
// Versions:      
// 2021-03-12    Version 1 Spring 2021 URSC 689
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

/*********************************************************************/
/* Run Do Files in this order                                        */
/*********************************************************************/

* SourceData Do files only need to be run one time 
* SourceData Do files must be run in the SourceData folder
*do ../SourceData/www2.census.gov/cc-est2013-alldata-48.do
*do ../SourceData/www2.census.gov/SAIPE_est10all.do
do TMPWF_2av1_CleanSAIPE_2021-03-12.do
do TMPWF_2bv1_CleanPopEst_2021-03-12.do
do TMPWF_2cv1_SAIPEMergePop_2021-03-12.do
do TMPWF_3av1_ExploreSAIPEPop_2021-03-12.do

/*-------------------------------------------------------------------*/
/* Exit Program                                                      */
/*-------------------------------------------------------------------*/
exit