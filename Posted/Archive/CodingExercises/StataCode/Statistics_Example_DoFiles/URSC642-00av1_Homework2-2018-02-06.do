/********-*********-*********-*********-*********-*********-*********/
/* Description of Program                                           */
/********-*********-*********-*********-*********-*********-*********/
// program:    URSC642-00av1_Homework2-2018-02-06.do
// task:       Replication of Homework 2
// Homework  Wooldridge, pages 110-11, Chapter 3, 
// computer exercises C3.1, C3.2, C3.3, C3.4 
// version:    First Draft
// project:    URSC 642 - Analytic Methods ln Landscape and Urban Research II
// author:     Nathanael Rosenheim \ Feb 6, 2018

/*------------------------------------------------------------------*/
/* Control Stata                                                    */
/*------------------------------------------------------------------*/
* Generic do file that sets up stata environment
clear all          // Clear existing data files
macro drop _all    // Drop macros from memory
version 12       // Set Version
set more off       // Tell Stata to not pause for --more-- messages

/********-*********-*********-*********-*********-*********-*********/
/* Problem C3.1                                                     */
/********-*********-*********-*********-*********-*********-*********/

* Open Birth Weight Data from Wooldridge
use "../SourceData/Wooldridge2009_Datasets/BWGHT.dta", clear

* Do you think cigs and faminc are likely to be correlated? 
pwcorr cigs faminc bwght, obs sig

* Models for Birth Weight
eststo clear
eststo: regress bwght cigs faminc
eststo: regress bwght cigs
eststo: regress bwght faminc

esttab using ///
	`"URSC642-00av1_Homework2-2018-02-06.rtf"' ///
	, replace ///
	b(%4.3f) se(%4.3f) ///
	r2 onecell  label modelwidth(6) nonumbers  /// 
	title(Parameter Estimates from Models of Birth Weight) ///
	alignment(c)  ///
	addnote("URSC 642 Homework Wooldridge Ch 3, Birth Weight dataset")
eststo clear

/********-*********-*********-*********-*********-*********-*********/
/* Problem C3.2                                                     */
/********-*********-*********-*********-*********-*********-*********/

* Open Home Price Data from Wooldridge
use "../SourceData/Wooldridge2009_Datasets/HPRICE1.dta", clear

* Models for Home Price
eststo clear
eststo: regress price sqrft bdrms

esttab using ///
	`"URSC642-00av1_Homework2-2018-02-06.rtf"' ///
	, append ///
	b(%4.3f) se(%4.3f) ///
	r2 onecell  label modelwidth(6) nonumbers  /// 
	title(Parameter Estimates from Model of Home Price) ///
	alignment(c) parentheses ///
	addnote("URSC 642 Homework Wooldridge Ch 3, Home Price dataset")
eststo clear

* Use Stata as a calculator
regress price sqrft bdrms

* Stata stores the coefficient values
matrix list e(b)
display _b[_cons] 


* What is the predicted house price with 2,438 sq feet and 4 bedrooms
display (_b[_cons] + _b[sqrft]*2438 + _b[bdrms]*4)*1000

/********-*********-*********-*********-*********-*********-*********/
/* Problem C3.3                                                     */
/********-*********-*********-*********-*********-*********-*********/

* Open CEO Salary data from Wooldridge
use "../SourceData/Wooldridge2009_Datasets/CEOSAL2.dta", clear

* Scrub data
label variable lsales "Log of Sales"

* Models for CEO Salary
eststo clear
eststo: regress lsalary lsales lmktval
eststo: regress lsalary lsales lmktval profits
eststo: regress lsalary lsales lmktval profits ceoten

esttab using ///
	`"URSC642-00av1_Homework2-2018-02-06.rtf"' ///
	, append ///
	b(%4.3f) se(%4.3f) ///
	r2 onecell  label modelwidth(6) nonumbers  /// 
	title(Parameter Estimates from Models of CEO Salary) ///
	alignment(c) parentheses ///
	addnote("URSC 642 Homework Wooldridge Ch 3, CEO Salary dataset")
eststo clear

* Find the sample correlation coefficient between the variables log(mktval) and profits
pwcorr lmktval profits


/********-*********-*********-*********-*********-*********-*********/
/* Problem C3.4                                                     */
/********-*********-*********-*********-*********-*********-*********/

* Open Attendace data from Wooldridge
use "../SourceData/Wooldridge2009_Datasets/ATTEND.dta", clear

* Descriptive Statistics for Data
eststo clear
estpost tabstat atndrte priGPA ACT, ///
		statistics(min max p50 mean sd count) columns(statistics)
		
esttab using ///
	`"URSC642-00av1_Homework2-2018-02-06.rtf"' ///
	, append alignment(r) label gaps modelwidth(6) nonumbers  ///
	cells("count(fmt(%4.0f)) min(fmt(%4.2f)) max(fmt(%4.2f)) p50(fmt(%4.2f)) mean(fmt(%4.2f)) sd(fmt(%4.2f))") noobs ///
	title(Basic Descriptive Statistics For Attendance) ///
	addnote("URSC 642 Homework Wooldridge Ch 3, Attendance dataset")
eststo clear

* Models for Attendance
eststo clear
eststo: regress atndrte priGPA ACT

esttab using ///
	`"URSC642-00av1_Homework2-2018-02-06.rtf"' ///
	, append ///
	b(%4.3f) se(%4.3f) ///
	r2 onecell  label modelwidth(6) nonumbers  /// 
	title(Parameter Estimates from Model of College Attendance) ///
	alignment(c) parentheses ///
	addnote("URSC 642 Homework Wooldridge Ch 3, CEO Salary dataset")
eststo clear

* What is the predicted atndrte if priGPA = 3.65 and ACT = 20
display _b[_cons] + _b[priGPA]*3.65 + _b[ACT]*20

* If Student A has a priGPA = 3.1 and ACT = 21 and 
*    Student B has a priGPA = 2.1 and ACT = 26,
* what is the predicted difference in their attendance rates?.

display (_b[_cons] + _b[priGPA]*3.1 + _b[ACT]*21) - ///
		(_b[_cons] + _b[priGPA]*2.1 + _b[ACT]*26)
