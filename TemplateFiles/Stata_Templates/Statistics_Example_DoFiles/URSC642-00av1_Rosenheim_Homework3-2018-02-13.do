/********-*********-*********-*********-*********-*********-*********/
/* Description of Program                                           */
/********-*********-*********-*********-*********-*********-*********/
// program:    URSC642-00av1_Rosenheim_Homework3-2018-02-13.do
// task:       Replication of Homework 3
// computer exercises c4.2, c4.5, c4.9, and c5.1 Wooldridge, 4th edition 
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
global dofilename URSC642-00av1_Rosenheim_Homework3-2018-02-13
global source "URSC 642 Homework Wooldridge Ch 4 and Ch 5"

/*------------------------------------------------------------------*/
/* Start a log file to save results                                 */
/*------------------------------------------------------------------*/
capture log close   // suppress error and close any open logs
log using ${dofilename}.log, replace text

/********-*********-*********-*********-*********-*********-*********/
/* Replicate Lecture                                                */
/********-*********-*********-*********-*********-*********-*********/
/*------------------------------------------------------------------*/
/* Example 4.X                                                      */
/*------------------------------------------------------------------*/
* Open Law School Data File
use "../SourceData/Wooldridge2009_Datasets/mlb1.dta", clear

regress lsalary years gamesyr

regress lsalary years gamesyr bavg hrunsyr rbisyr

nestreg: regress lsalary (years gamesyr) (bavg hrunsyr rbisyr)

/*------------------------------------------------------------------*/
/* Example 4.4                                                      */
/*------------------------------------------------------------------*/
* Must install PROBABILITY TABLES
search probtabl

use "../SourceData/Wooldridge2009_Datasets/campus.dta", clear

regress lcrime lenroll

display (_b[lenroll]-1)/_se[lenroll]
test lenroll = 1

display Ftail(1,95,((_b[lenroll]-1)/_se[lenroll])^2)
display ttail(95,(_b[lenroll]-1)/_se[lenroll])

/********-*********-*********-*********-*********-*********-*********/
/* Problem C4.2                                                     */
/********-*********-*********-*********-*********-*********-*********/

* Open Law School Data File
use "../SourceData/Wooldridge2009_Datasets/lawsch85.dta", clear

* Models for Log of Median Starting Salary for new law school graduates
eststo clear
eststo: regress lsalary LSAT GPA llibvol lcost rank
eststo: regress lsalary llibvol lcost rank
eststo: regress lsalary LSAT GPA llibvol lcost rank clsize faculty

esttab using ///
	`"${dofilename}.rtf"' ///
	, replace ///
	b(%4.3f) se(%4.3f) ///
	r2 onecell  label modelwidth(6) nonumbers nogaps /// 
	title(4.2 Parameter Estimates from Models Log of Median Starting Salary for new law school graduates) ///
	alignment(c)  ///
	addnote("${source}, `c(filename)' `c(current_date)'")
eststo clear

regress lsalary LSAT GPA llibvol lcost rank
testparm LSAT GPA, equal
lincom LSAT - GPA
test LSAT = GPA

nestreg: reg lsalary (llibvol lcost rank) (LSAT GPA)

regress lsalary LSAT GPA llibvol lcost rank clsize faculty
testparm clsize faculty
testparm clsize faculty, equal
lincom clsize - faculty
test clsize = faculty

nestreg: reg lsalary (LSAT GPA llibvol lcost rank) (clsize faculty)


/********-*********-*********-*********-*********-*********-*********/
/* Problem C4.5                                                     */
/********-*********-*********-*********-*********-*********-*********/

* Open MLB Data from Wooldridge
use "../SourceData/Wooldridge2009_Datasets/mlb1.dta", clear

* Models for Home Price
eststo clear
eststo: regress lsalary years gamesyr bavg hrunsyr rbisyr
eststo: regress lsalary years gamesyr bavg hrunsyr
eststo: regress lsalary years gamesyr bavg hrunsyr runsyr fldperc sbasesyr
eststo: regress lsalary years gamesyr bavg hrunsyr rbisyr runsyr fldperc sbasesyr

esttab using ///
	`"${dofilename}.rtf"' ///
	, append ///
	b(%5.4f) se(%5.4f) ///
	r2 onecell  label modelwidth(6) nonumbers nogaps /// 
	title(4.5 Parameter Estimates from Model of MLB Player 1993 Log of Season Salary) ///
	alignment(c) parentheses ///
	addnote("${source}, `c(filename)' `c(current_date)'")
eststo clear

nestreg: regress lsalary (years gamesyr hrunsyr runsyr) (bavg fldperc sbasesyr)


/********-*********-*********-*********-*********-*********-*********/
/* Problem C4.9                                                     */
/********-*********-*********-*********-*********-*********-*********/

* Open Fast Food Discrimination from Wooldridge
use "../SourceData/Wooldridge2009_Datasets/discrim.dta", clear

* Relabel variables used in model
label variable lhseval "Log Median Housing Value, Zipcode"

* Models for Price of Soda
eststo clear
eststo: regress lpsoda prpblck lincome prppov
eststo: regress lpsoda prpblck lincome prppov lhseval

esttab using ///
	`"${dofilename}.rtf"' ///
	, append ///
	b(%5.4f) t(%5.4f) ///
	r2 onecell  label modelwidth(6) nonumbers nogaps /// 
	title(4.9 Parameter Estimates from Model of Log Price of Medium Soda First Wave) ///
	alignment(c) parentheses ///
	addnote("${source}, `c(filename)' `c(current_date)'")
eststo clear

pwcorr lincome prppov

regress lpsoda prpblck lincome prppov lhseval
test lhseval
nestreg: regress lpsoda (prpblck lhseval) (lincome prppov)

regress lpsoda lincome prppov lhseval prpblck
vif 

eststo clear
estpost tabstat lpsoda prpblck lincome prppov lhseval, ///
		statistics(min max p50 mean sd count) columns(statistics)
esttab using ///
	`"${dofilename}.rtf"' ///
	, append ///
	alignment(r) label gaps modelwidth(6) nonumbers  ///
	cells("count(fmt(%4.0f)) min(fmt(%4.2f)) max(fmt(%4.2f)) p50(fmt(%4.2f)) mean(fmt(%4.2f)) sd(fmt(%4.2f))") noobs ///
	title(Basic Descriptive Statistics for variables in model) ///
	addnote("${source}, `c(filename)' `c(current_date)'")
eststo clear
/********-*********-*********-*********-*********-*********-*********/
/* Problem C5.1                                                     */
/********-*********-*********-*********-*********-*********-*********/

use "../SourceData/Wooldridge2009_Datasets/wage1.dta", clear

* Models for Wage
eststo clear
eststo: regress wage educ exper tenure

esttab using ///
	`"${dofilename}.rtf"' ///
	, append ///
	b(%5.4f) t(%5.4f) ///
	r2 onecell  label modelwidth(6) nonumbers nogaps /// 
	title(5.1 Parameter Estimates from Model of Average Hourly Earnings) ///
	alignment(c) parentheses ///
	addnote("${source}, `c(filename)' `c(current_date)'")
eststo clear

predict residuals1, residuals
predict yhat

label variable residuals1 "Residuals of Wage Model"

* Generate a historgram of the residuals 
local graphcaption = "Histogram of Model 1 Residuals"
histogram residuals1, frequency normal kdensity ///
	title(`graphcaption') ///
	caption("${source}, `c(filename)' `c(current_date)'", size(tiny))
graph export `"${dofilename}_residuals1.pdf"', replace
graph export `"${dofilename}_residuals1.tif"', replace

sum residuals1, detail
sum wage, detail

eststo clear
eststo: regress lwage educ exper tenure

esttab using ///
	`"${dofilename}.rtf"' ///
	, append ///
	b(%5.4f) t(%5.4f) ///
	r2 onecell  label modelwidth(6) nonumbers nogaps /// 
	title(5.1 Parameter Estimates from Model of Log of Average Hourly Earnings) ///
	alignment(c) parentheses ///
	addnote("${source}, `c(filename)' `c(current_date)'")
eststo clear

predict residuals2, residuals
label variable residuals2 "Residuals of Wage Model"

* Generate a historgram of the residuals 
local graphcaption = "Histogram of Model 2 Residuals"
histogram residuals2, frequency normal kdensity ///
	title(`graphcaption') ///
	caption("${source}, `c(filename)' `c(current_date)'", size(tiny))
graph export `"${dofilename}_residuals2.pdf"', replace
graph export `"${dofilename}_residuals2.tif"', replace

sum residuals2, detail
sum lwage, detail

eststo clear
estpost tabstat wage residuals1 lwage residuals2, ///
		statistics(mean skewness) columns(statistics)
esttab using ///
	`"${dofilename}.rtf"' ///
	, append ///
	alignment(r) label nogaps modelwidth(6) nonumbers  ///
	cells("mean(fmt(%7.4f)) skewness(fmt(%7.4f))") noobs ///
	title(Comparison of Mean and Skewness between Model 1 and Model 2) ///
	addnote("${source}, `c(filename)' `c(current_date)'")
eststo clear


/*------------------------------------------------------------------*/
/* End Log                                                          */
/*------------------------------------------------------------------*/

log close
exit
