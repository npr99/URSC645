/********-*********-*********-*********-*********-*********-*********/
/* Description of Program                                           */
/********-*********-*********-*********-*********-*********-*********/
// program:    URSC642-00av1_Rosenheim_Homework4-2018-02-27.do
// task:       Replication of Homework 4
// Homework: Problems c6.1, c6.2, and c6.5, Wooldridge, 4th edition
// version:    First Draft
// project:    URSC 642 - Analytic Methods ln Landscape and Urban Research II
// author:     Nathanael Rosenheim \ Feb 27, 2018

/*------------------------------------------------------------------*/
/* Control Stata                                                    */
/*------------------------------------------------------------------*/
* Generic do file that sets up stata environment
clear all          // Clear existing data files
macro drop _all    // Drop macros from memory
version 12       // Set Version
set more off       // Tell Stata to not pause for --more-- messages
set linesize 80

/*------------------------------------------------------------------*/
/* Set Provenance                                                   */
/*------------------------------------------------------------------*/
global dofilename URSC642-00av1_Rosenheim_Homework4-2018-02-27
global source "URSC 642 Homework Wooldridge Ch 6"

/*------------------------------------------------------------------*/
/* Start a log file to save results                                 */
/*------------------------------------------------------------------*/
capture log close   // suppress error and close any open logs
log using ${dofilename}.log, replace text


/********-*********-*********-*********-*********-*********-*********/
/* Problem C6.1                                                     */
/********-*********-*********-*********-*********-*********-*********/

* 
use "../SourceData/Wooldridge2009_Datasets/KIELMC.dta", clear

* Note: for this problem, we are only interested in cases for 1981
tab year

* Generate squared term
gen ldistsq = ldist^2
label variable ldistsq "Log Distance Squared"

* 
eststo clear
eststo: regress lprice ldist if year == 1981
eststo: regress lprice ldist lintst larea lland rooms baths age if year == 1981
eststo: regress lprice ldist lintst larea lland rooms baths age lintstsq if year == 1981
eststo: regress lprice ldist lintst larea lland rooms baths age lintstsq ldistsq if year == 1981

esttab using ///
	`"${dofilename}.rtf"' ///
	, replace ///
	b(%4.3f) se(%4.3f) ///
	r2 onecell  label modelwidth(6) nonumbers nogaps /// 
	title(6.1 Parameter Estimates from Models C6.1) ///
	alignment(c)  ///
	addnote("${source}, `c(filename)' `c(current_date)'")
eststo clear

reg lprice ldist ldistsq lintst lintstsq larea lland rooms baths age if year == 1981
testparm ldistsq

*c 6.1 iii - what are the turning points in the model?
regress lprice ldist lintst larea lland rooms baths age lintstsq if year == 1981

local turingpoint_interstate = abs(_b[lintst]/(2*_b[lintstsq]))
local turingpoint_interstate_in_feet = exp(`turingpoint_interstate')
display "At `turingpoint_interstate_in_feet' feet the effect of " _n ///
	"distance from interstate begins to decrease"

/********-*********-*********-*********-*********-*********-*********/
/* Problem C6.2                                                     */
/********-*********-*********-*********-*********-*********-*********/

use "../SourceData/Wooldridge2009_Datasets/WAGE1.dta", clear

eststo clear
eststo: regress lwage educ exper expersq

esttab using ///
	`"${dofilename}.rtf"' ///
	, append ///
	b(%4.3f) se(%4.3f) ///
	r2 onecell  label modelwidth(6) nonumbers nogaps /// 
	title(6.2 Parameter Estimates from Models c6.2) ///
	alignment(c)  ///
	addnote("${source}, `c(filename)' `c(current_date)'")
eststo clear

local experience = 4
local delta_experience = 5 - 4
local deltawage_year5 = 100*(_b[exper]+2*_b[expersq]*`experience')*`delta_experience'
display `deltawage_year5'

local experience = 20
local delta_experience = 20-19
local deltawage_year20 = 100*(_b[exper]+2*_b[expersq]*`experience')*`delta_experience'
display `deltawage_year20'

local turingpoint = abs(_b[exper]/(2*_b[expersq]))
display `turingpoint'
count if exper >= `turingpoint' & exper != .

/********-*********-*********-*********-*********-*********-*********/
/* Problem C6.5                                                     */
/********-*********-*********-*********-*********-*********-*********/

use "../SourceData/Wooldridge2009_Datasets/hprice1.dta", clear

eststo clear
eststo: regress lprice llotsize lsqrft bdrms

esttab using ///
	`"${dofilename}.rtf"' ///
	, append ///
	b(%4.3f) se(%4.3f) ///
	r2 onecell  label modelwidth(6) nonumbers nogaps /// 
	title(6.5 Parameter Estimates from Models c6.5) ///
	alignment(c)  ///
	addnote("${source}, `c(filename)' `c(current_date)'")
eststo clear

/*------------------------------------------------------------------*/
/* Predict y given the model is log(y)                              */
/*------------------------------------------------------------------*/

* Need to calculate the smearing esimate
regress lprice llotsize lsqrft bdrms
predict pred_lprice, xb
* Calcuate the transformed predicted value for each observation
gen m = exp(pred_lprice)
* regress the predicted value on the obsererved value
regress price m, noconstant

* use the coeffiecnt to approximate the smearing estimate
local smearing_estimate = _b[m]

regress lprice llotsize lsqrft bdrms
local givenlotsize = log(20000)
local givensqrft = log(2500)
local givenbdrms = 4
local predicted_lprice _b[llotsize]*`givenlotsize'+ ///
	_b[lsqrft]*`givensqrft'+_b[bdrms]*`givenbdrms'+_b[_cons]
local transform_predicted_lprice = exp(`predicted_lprice')*1000
local transform_predicted_lpricev2 = `smearing_estimate'*`transform_predicted_lprice'

display "Without the adjustment using the smearing estimate " _n ///
		"the predicted home value would be $`transform_predicted_lprice'" _n ///
		"With the adjustment using the smearing estimate " _n ///	
		"the predicted home value would be $`transform_predicted_lpricev2'"

		
/*------------------------------------------------------------------*/
/* Compare model with log dependant variable to non log             */
/*------------------------------------------------------------------*/
/*
6.5 iii - the r-square from the log model is not comparable to
the r-square for the not-logged model. 
One must calculate the r-square for the transformed model 
in order to compare which model better predicts price.
*/
* generate corrected predicted prices based on the log model
gen mpprice = `smearing_estimate'*m
* Determine the correlation between the predicted price and observed price
corr price mpprice
* The square of the correlation is the same as the r-square
reg price mpprice


regress  price lotsize sqrft bdrms
predict pred_price, xb
corr price pred_price

/*------------------------------------------------------------------*/
/* End Log                                                          */
/*------------------------------------------------------------------*/

log close
exit
