/********-*********-*********-*********-*********-*********-*********/
/* Description of Program                                           */
/********-*********-*********-*********-*********-*********-*********/
// program:    URSC642-00av1_Rosenheim_Homework5-2018-03-20.do
// task:       Replication of Homework 5
// Homework: Problems c7.1, c7.2, and c7.3, Wooldridge, 4th edition
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
global dofilename URSC642-00av1_Rosenheim_Homework5-2018-03-20
global source "URSC 642 Homework Wooldridge Ch 7"

/*------------------------------------------------------------------*/
/* Start a log file to save results                                 */
/*------------------------------------------------------------------*/
capture log close   // suppress error and close any open logs
log using ${dofilename}.log, replace text


/********-*********-*********-*********-*********-*********-*********/
/* Problem C7.1                                                     */
/********-*********-*********-*********-*********-*********-*********/

* 
use "../SourceData/Wooldridge2009_Datasets/GPA1.dta", clear

* Generate Squared Term
gen hsGPAsq = hsGPA^2
label variable hsGPAsq "High School GPA Squared"


* Cleanup Variable Labels
label variable hsGPA "High School GPA"
label variable ACT "'Achievement' Test Score"
label variable PC "Computer Ownership"
label variable mothcoll "Mother College Grad"
label variable fathcoll "Father College Grad"

* 
eststo clear
eststo: regress colGPA PC hsGPA ACT
eststo: regress colGPA PC hsGPA ACT mothcoll fathcoll
eststo: regress colGPA PC hsGPA ACT mothcoll fathcoll hsGPAsq

esttab using ///
	`"${dofilename}.rtf"' ///
	, replace ///
	b(%4.3f) se(%4.3f) ///
	r2 onecell  label modelwidth(6) nonumbers nogaps /// 
	title(7.1 Parameter Estimates from Models C7.1) ///
	alignment(c)  ///
	addnote("${source}, `c(filename)' `c(current_date)'")
eststo clear

*c 7.1 iii - what are the turning points in the model?
regress colGPA PC hsGPA ACT mothcoll fathcoll hsGPAsq

local turingpoint_hsgpasq = abs(_b[hsGPA]/(2*_b[hsGPAsq]))
display "When High School GPA is greater than `turingpoint_hsgpasq' " _n ///
	"it begins to have a positive effect on College GPA"

*c 7.1 iii - is HS GPA squared needed
nestreg: regress colGPA (PC hsGPA ACT mothcoll fathcoll) (hsGPAsq)
	
/********-*********-*********-*********-*********-*********-*********/
/* Problem C7.2                                                     */
/********-*********-*********-*********-*********-*********-*********/

use "../SourceData/Wooldridge2009_Datasets/WAGE2.dta", clear

* Generate Squared Terms
gen expersq = exper^2
label variable expersq "Years of Work Experience Squared"
gen tenuresq = tenure^2
label variable tenuresq "Years with Current Employer Squared"

* Generate an interaction term for black and education for C7.2iii
gen blackeduc = black * educ
label variable blackeduc "Interaction Between Black and Education"

* Generate years of education black and nonblack
* Check for missing values 
tab educ black, missing
gen educblack = 0 if !missing(educ,black)
replace educblack = educ if black == 1 
label variable educblack "Years of Education Black"

gen educnonblack = 0
replace educnonblack = educ if black == 0
label variable educnonblack "Years of Education Nonblack"
notes educnonblack: Created variable to compare the models in C7.2iii ///
it looks like adding the interaction term for black and education makes ///
race not significant... But I want to explore this in more detail.

* Generate new groups of people for C7.2iv
* Check for Missing Values
tab black, missing
tab married, missing

tab black married, missing

tab black if married == 1
tab black if married == 0

* Generate Dummy variable for Married and Black
gen marrblck = 0 if !missing(married,black)
label variable marrblck "Married and Black"
* Set variable to 1 if Married and Black
replace marrblck = 1 if married == 1 & black == 1


* Generate Dummy variable for Married and Not Black
gen marrnonblck = 0 if !missing(married,black)
label variable marrnonblck "Married and Nonblack"
* Set variable to 1 if Married and Nonblack
replace marrnonblck = 1 if married == 1 & black == 0

* Generate Dummy variable for Single and Black
gen singblck = 0 if !missing(married,black)
label variable singblck "Single and Black"
* Set variable to 1 if Single and Black
replace singblck = 1 if married == 0 & black == 1

* Generate Dummy variable for Single and Nonblack
gen singnonblck = 0 if !missing(married,black)
label variable singnonblck "Single and Nonblack"
* Set variable to 1 if Single and Nonblack
replace singnonblck = 1 if married == 0 & black == 0

* Double check new variables
tab black married, missing
tab marrblck, missing
tab marrnonblck, missing
tab singblck, missing
tab singnonblck, missing

* Cleanup Variable Labels
label variable lwage "Log of Monthly Earnings"
label variable educ "Years of Education"
label variable exper "Years of Work Experience"
label variable tenure "Years with Current Employer"
label variable married "Married"
label variable black "Black"
label variable south "Lives in South"
label variable urban "Lives in SMSA"


eststo clear
eststo: regress lwage educ exper tenure married black south urban
eststo: regress lwage educ exper tenure married black south urban expersq tenuresq

esttab using ///
	`"${dofilename}.rtf"' ///
	, append ///
	b(%4.3f) se(%4.3f) ///
	r2 onecell  label modelwidth(6) nonumbers nogaps /// 
	title(7.2 Parameter Estimates from Models c7.2) ///
	alignment(c)  ///
	addnote("${source}, `c(filename)' `c(current_date)'")
eststo clear

/*------------------------------------------------------------------*/
/* C7.2 i                                                           */
/*------------------------------------------------------------------*/

* correct log value using equation 7.10
regress lwage educ exper tenure married black south urban
display 100*(exp(_b[black])-1)

/*------------------------------------------------------------------*/
/* C7.2 ii                                                          */
/*------------------------------------------------------------------*/

nestreg: regress lwage (educ exper tenure married black south urban) (expersq tenuresq)

* Confirm that results are insignificant at the 20% level
display Ftail(2,925,1.49)

/*------------------------------------------------------------------*/
/* C7.2 iii                                                         */
/*------------------------------------------------------------------*/

eststo clear
eststo: regress lwage educ exper tenure married black south urban
eststo: regress lwage educ exper tenure married black south urban black#c.educ
eststo: regress lwage educ exper tenure married black south urban blackeduc
eststo: regress lwage exper tenure married black south urban educblack educnonblack 

esttab using ///
	`"${dofilename}.rtf"' ///
	, append ///
	b(%4.3f) se(%4.3f) ///
	r2 onecell  label modelwidth(6) nonumbers nogaps /// 
	title(7.2iii Parameter Estimates from Models c7.2iii) ///
	alignment(c)  ///
	addnote("${source}, `c(filename)' `c(current_date)'")
eststo clear

regress lwage educ exper tenure married black south urban blackeduc
lincom educ + blackeduc

regress lwage exper tenure married black south urban educblack educnonblack 
lincom educnonblack - educblack


/*------------------------------------------------------------------*/
/* C7.2 iv                                                          */
/*------------------------------------------------------------------*/

eststo clear
eststo: regress lwage educ exper tenure married black south urban
eststo: regress lwage educ exper tenure south urban marrblck marrnonblck singblck
eststo: regress lwage educ exper tenure south urban singnonblck marrblck singblck
eststo: regress lwage educ exper tenure south urban marrnonblck marrblck singnonblck

esttab using ///
	`"${dofilename}.rtf"' ///
	, append ///
	b(%4.3f) se(%4.3f) ///
	r2 onecell  label modelwidth(6) nonumbers nogaps /// 
	title(7.2iv Parameter Estimates from Models c7.2iv) ///
	alignment(c)  ///
	addnote("${source}, `c(filename)' `c(current_date)'")
eststo clear

* What is the difference between Married Blacks and Married Nonblacks
regress lwage educ exper tenure south urban marrblck marrnonblck singblck
lincom marrnonblck - marrblck


/********-*********-*********-*********-*********-*********-*********/
/* Problem C7.3                                                     */
/********-*********-*********-*********-*********-*********-*********/

use "../SourceData/Wooldridge2009_Datasets/MLB1.dta", clear

* Cleanup Variable Labels
label variable frstbase "First Base"
label variable scndbase "Second Base"
label variable thrdbase "Third Base"
label variable shrtstop "Shortstop"
label variable catcher "Catcher"
label variable outfield "Outfield"

* Explore the positions variables
eststo clear
estpost tabstat frstbase scndbase thrdbase shrtstop catcher outfield, ///
		statistics(min max p50 mean sd count) columns(statistics)
		
esttab using ///
	`"${dofilename}.rtf"' ///
	, append ///
	alignment(r) label nogaps modelwidth(6) nonumbers  ///
	cells("count(fmt(%4.0f)) min(fmt(%4.2f)) max(fmt(%4.2f)) mean(fmt(%4.2f))") noobs ///
	title(7.3 Basic Descriptive Statistics for Field Positions) ///
	addnote("${source}, `c(filename)' `c(current_date)'")
eststo clear


eststo clear
eststo: regress lsalary years gamesyr bavg hrunsyr rbisyr runsyr fldperc ///
allstar frstbase scndbase thrdbase shrtstop catcher

esttab using ///
	`"${dofilename}.rtf"' ///
	, append ///
	b(%4.3f) se(%4.3f) ///
	r2 onecell  label modelwidth(6) nonumbers nogaps /// 
	title(7.3 Parameter Estimates from Models c7.3i) ///
	alignment(c)  ///
	addnote("${source}, `c(filename)' `c(current_date)'")
eststo clear

/*------------------------------------------------------------------*/
/* C7.3 ii                                                          */
/*------------------------------------------------------------------*/

regress lsalary years gamesyr bavg hrunsyr rbisyr runsyr fldperc ///
allstar frstbase scndbase thrdbase shrtstop catcher

test frstbase scndbase thrdbase shrtstop catcher



/********-*********-*********-*********-*********-*********-*********/
/* Exit and Close Log                                               */
/********-*********-*********-*********-*********-*********-*********/
log close
exit
