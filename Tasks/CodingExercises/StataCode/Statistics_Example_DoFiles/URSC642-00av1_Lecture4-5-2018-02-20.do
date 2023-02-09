/********-*********-*********-*********-*********-*********-*********/
/* Description of Program                                           */
/********-*********-*********-*********-*********-*********-*********/
// program:    URSC642-00av1_Lecture4-5-2018-02-20.do.do
// task:       Replication of Lecture 4.5
// version:    First Draft
// project:    URSC 642 - Analytic Methods ln Landscape and Urban Research II
// author:     Nathanael Rosenheim \ Feb 13, 2018

/*------------------------------------------------------------------*/
/* Control Stata                                                    */
/*------------------------------------------------------------------*/
* Generic do file that sets up stata environment
clear all          // Clear existing data files
macro drop _all    // Drop macros from memory
version 12       // Set Version
set more off       // Tell Stata to not pause for --more-- messages

/*------------------------------------------------------------------*/
/* Set Provenance                                                   */
/*------------------------------------------------------------------*/
global dofilename URSC642-00av1_Lecture4-5-2018-02-20.do
global source "URSC 642 Homework Wooldridge Ch 4 and Ch 5"

/*------------------------------------------------------------------*/
/* Start a log file to save results                                 */
/*------------------------------------------------------------------*/
capture log close   // suppress error and close any open logs
log using ${dofilename}.log, replace text

/********-*********-*********-*********-*********-*********-*********/
/* Replicate Lecture                                                */
/********-*********-*********-*********-*********-*********-*********/

* Open MLB Data from Wooldridge
use "../SourceData/Wooldridge2009_Datasets/mlb1.dta", clear

* Models for Home Price
eststo clear
eststo: regress lsalary years gamesyr
eststo: regress lsalary years gamesyr bavg hrunsyr rbisyr

esttab using ///
	`"${dofilename}.rtf"' ///
	, append ///
	b(%5.4f) se(%5.4f) ///
	r2 onecell  label modelwidth(6) nonumbers nogaps /// 
	title(4.5 Parameter Estimates from Model of MLB Player 1993 Log of Season Salary) ///
	alignment(c) parentheses ///
	addnote("${source}, `c(filename)' `c(current_date)'")
eststo clear

nestreg: regress lsalary (years gamesyr) (bavg hrunsyr rbisyr)

regress lsalary years gamesyr
predict residuals, residuals

regress residuals years gamesyr bavg hrunsyr rbisyr

* dispaly model statistics

ereturn list
local lm = `e(N)'*`e(r2)'
display "Lagrange multiplier (LM) equals `lm'"


* chitable command is not a standard Stata program
findit chitable  // the findit command shows that chitable is part of the 
		         // Probability tables package
net install probtabl.pkg, replace
chitable `e(df_m)'

/*------------------------------------------------------------------*/
/* End Log                                                          */
/*------------------------------------------------------------------*/

log close
exit
