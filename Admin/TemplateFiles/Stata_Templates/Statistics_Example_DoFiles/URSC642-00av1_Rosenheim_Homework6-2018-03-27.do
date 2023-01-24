/********-*********-*********-*********-*********-*********-*********/
/* Description of Program                                           */
/********-*********-*********-*********-*********-*********-*********/
// program:    URSC642-00av1_Rosenheim_Homework6-2018-03-27.do
// task:       Replication of Homework 6 
// Homework: Problems c8.2, c8.3, and c8.4, Wooldridge, 4th edition
// version:    First Draft
// project:    URSC 642 - Analytic Methods ln Landscape and Urban Research II
// author:     Nathanael Rosenheim \ March 20, 2018

/*------------------------------------------------------------------*/
/* Control Stata                                                    */
/*------------------------------------------------------------------*/
* Generic do file that sets up stata environment
clear all          // Clear existing data files
macro drop _all    // Drop macros from memory
version 12       // Set Version
set more off       // Tell Stata to not pause for --more-- messages
set linesize 80    // Ensures that log file output will fit on page

/*------------------------------------------------------------------*/
/* Set Provenance                                                   */
/*------------------------------------------------------------------*/
global dofilename URSC642-00av1_Rosenheim_Homework6-2018-03-27
global source "URSC 642 Homework Wooldridge Ch 8"

/*------------------------------------------------------------------*/
/* Start a log file to save results                                 */
/*------------------------------------------------------------------*/
capture log close   // suppress error and close any open logs
log using ${dofilename}.log, replace text


/********-*********-*********-*********-*********-*********-*********/
/* Problem C8.2                                                   */
/********-*********-*********-*********-*********-*********-*********/

use "../SourceData/Wooldridge2009_Datasets/hprice1.dta", clear
	
reg price lotsize sqrft bdrms
reg price lotsize sqrft bdrms, robust

reg lprice llotsize lsqrft bdrms
reg lprice llotsize lsqrft bdrms, robust

/********-*********-*********-*********-*********-*********-*********/
/* Problem C8.3                                                     */
/********-*********-*********-*********-*********-*********-*********/

use "../SourceData/Wooldridge2009_Datasets/hprice1.dta", clear

reg lprice llotsize lsqrft bdrms
estat imtest, white

/********-*********-*********-*********-*********-*********-*********/
/* Problem C8.4                                                     */
/********-*********-*********-*********-*********-*********-*********/

use "../SourceData/Wooldridge2009_Datasets/VOTE1.dta", clear

* Cleanup Variable Labels

/*------------------------------------------------------------------*/
/* C8.4 i                                                           */
/*------------------------------------------------------------------*/
reg voteA prtystrA democA lexpendA lexpendB
predict youhatvota, residuals

reg youhatvota prtystrA democA lexpendA lexpendB
/*------------------------------------------------------------------*/
/* C8.4 ii                                                          */
/*------------------------------------------------------------------*/


reg youhatvota prtystrA democA lexpendA lexpendB
estat hettest prtystrA democA lexpendA lexpendB, fstat

/*------------------------------------------------------------------*/
/* C8.4 iii                                                         */
/*------------------------------------------------------------------*/
reg voteA prtystrA democA lexpendA lexpendB

predict predvoteA, xb
gen predvoteA2 = predvoteA^2
estat hettest predvoteA predvoteA2, fstat


/********-*********-*********-*********-*********-*********-*********/
/* Exit and Close Log                                               */
/********-*********-*********-*********-*********-*********-*********/
log close
exit
