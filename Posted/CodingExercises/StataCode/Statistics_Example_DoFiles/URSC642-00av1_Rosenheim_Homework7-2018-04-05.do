/********-*********-*********-*********-*********-*********-*********/
/* Description of Program                                           */
/********-*********-*********-*********-*********-*********-*********/
// program:    URSC642-00av1_Rosenheim_Homework7-2018-04-05.do
// task:       Replication of Homework 7 
// Homework: Problems 11.1 11.2, Acock, 3rd edition
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
global dofilename URSC642-00av1_Rosenheim_Homework7-2018-04-05
global source "URSC 642 Homework Acock Ch 11"

/*------------------------------------------------------------------*/
/* Start a log file to save results                                 */
/*------------------------------------------------------------------*/
capture log close   // suppress error and close any open logs
log using ${dofilename}.log, replace text

/********-*********-*********-*********-*********-*********-*********/
/* Problem 11.1                                                     */
/********-*********-*********-*********-*********-*********-*********/
use "../SourceData/Acock 3rd edition datafiles/severity.dta", clear

* Label Variable Values
label define female_l 0 "Male", add
label define female_l 1 "Female", add
label values female female_l

label define liberal_l 1 "Conservative", add
label define liberal_l 5 "Liberal", add
label values liberal liberal_l
label variable liberal "Liberal Scale"


logistic severity female liberal

* To add listcoef use the command:
* net install spost9_ado.pkg
listcoef, help percent

margins, at(liberal=(1(1)5)) over(female)
marginsplot, ///
	note("Provenance: ${source} ${dofilename}.do `c(filename)' `c(current_date)'",size(tiny)) ///
	title("Predicted Probability that a person sees prison sentences as too severe with 95% CIs", size(small)) ///
	ytitle("Probability a person sees prison sentences as too severe",size(vsmall)) ///
	recast(line)
	
graph export `"${dofilename}_MarginsPlot11_1.pdf"', replace
graph export `"${dofilename}_MarginsPlot11_1.tif"', replace

logistic severity female liberal
predict yhat, xb

histogram yhat
order severity yhat
pwcorr severity yhat
graph box yhat, over(severity)

regress severity yhat

/********-*********-*********-*********-*********-*********-*********/
/* Problem 11.2                                                     */
/********-*********-*********-*********-*********-*********-*********/

/*------------------------------------------------------------------*/
/* Obtain Data                                                      */
/*------------------------------------------------------------------*/
* Note: The file gss2002_chapter11.dta is not correct will not work
use "../SourceData/Acock 3rd edition datafiles/gss2002_chapter11a.dta", clear

* What predicts who will support abortion for any reason?

/*------------------------------------------------------------------*/
/* Scrub Data                                                       */
/*------------------------------------------------------------------*/

* Recode abort12 to be a dummy variable called abort
* Need to look at abort12 to see how it is coded 
tab abort12, missing

* Need to see how abort12 is coded
* The numlabel command will add the numbers associated with the label
numlabel, add

* Now when I use the tab command it will have the numbers and labels
tab abort12, missing

* Now I want to recode abort based on current code
* Dummy variable means that 1 = yes and 0 = no

recode abort12 (2 = 0), gen(abort)

* Relable variable
label variable abort "Abortion for any reason"

* Confirm that recode is correct
tab abort12 abort, missing

* The reliten variable is not clear
* Look at GSS Codebook 
* https://gssdataexplorer.norc.org/variables/2429/vshow
/* Survey Question
Would you call yourself a strong (PREFERENCE NAMED IN RELIG) or 
a not very strong (PREFERENCE NAMED IN RELIG)?
*/
labelbook reliten

tab reliten, missing
recode reliten (1 2 3 = 1) (4 = 0), gen(religion)
tab reliten religion, missing

label define religion_l 1 "Some Religion", add
label define religion_l 0 "No Religion", add
label values religion religion_l


label variable religion "Religious Affiliation"

/*------------------------------------------------------------------*/
/* Explore Data                                                     */
/*------------------------------------------------------------------*/

sum abort polviews reliten premarsx sei ///
	if !missing(abort,polviews,reliten,premarsx,sei)

* Look at categorical variables across dependent variable
tab polviews abort, missing
tab reliten abort, missing
tab premarsx abort, missing

tab premarsx abort12, missing
* Notes there are no observations for polviews or premarsx for abort

* Look at continous variables
sum sei if abort != . 
/*------------------------------------------------------------------*/
/* Model Data Preidct abort                                         */
/*------------------------------------------------------------------*/

logit abort polviews reliten premarsx sei

* To add listcoef use the command:
* net install spost9_ado.pkg
listcoef, help percent

* Output Margins Plot
margins, at(sei=(20(10)100)) over(reliten)
marginsplot, ///
	note("Provenance: ${source} ${dofilename}.do `c(filename)' `c(current_date)'",size(tiny)) ///
	title("Predicted Probability of Supportin Abortion for any Reason with 95% CIs", size(small)) ///
	ytitle("Probability of Abortion for any Reason",size(vsmall)) ///
	recast(line) ///
	yscale(range(0 1))

graph export `"${dofilename}_MarginsPlot11_2_1.pdf"', replace
graph export `"${dofilename}_MarginsPlot11_2_1.tif"', replace
	
* Use recoded religion variable 
logistic abort religion sei
listcoef, help percent

* Output Margins Plot
margins, at(sei=(20(10)100)) over(religion)
marginsplot, ///
	note("Provenance: ${source} ${dofilename}.do `c(filename)' `c(current_date)'",size(tiny)) ///
	title("Predicted Probability of Supportin Abortion for any Reason with 95% CIs", size(small)) ///
	ytitle("Probability of Abortion for any Reason",size(vsmall)) ///
	recast(line) ///
	yscale(range(0 1))
	
graph export `"${dofilename}_MarginsPlot11_2_2.pdf"', replace
graph export `"${dofilename}_MarginsPlot11_2_2.tif"', replace
	
/*------------------------------------------------------------------*/
/* End Log                                                          */
/*------------------------------------------------------------------*/

log close
exit

