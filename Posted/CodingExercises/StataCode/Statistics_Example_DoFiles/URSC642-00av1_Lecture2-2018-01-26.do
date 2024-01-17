/********-*********-*********-*********-*********-*********-*********/
/* Description of Program                                           */
/********-*********-*********-*********-*********-*********-*********/
// program:    URSC642-00av1_Lecture2-2018-01-26.do
// task:       Replication of Lecture 2 Examples - Simple Linear Regression
// version:    First Draft
// project:    URSC 642 - Analytic Methods ln Landscape and Urban Research II
// author:     Nathanael Rosenheim \ Jan 26, 2018

/*------------------------------------------------------------------*/
/* Control Stata                                                    */
/*------------------------------------------------------------------*/
* Generic do file that sets up stata environment
clear all          // Clear existing data files
macro drop _all    // Drop macros from memory
version 12       // Set Version
set more off       // Tell Stata to not pause for --more-- messages

/********-*********-*********-*********-*********-*********-*********/
/* Example 2.4                                                      */
/********-*********-*********-*********-*********-*********-*********/

* Open Wage Data from Wooldridge
use "../SourceData/Wooldridge2009_Datasets/WAGE1.dta", clear

* Model Data with Simple Linear Regression
regress wage educ

* Plot Data with Scatter plot and Linear Fit Line
twoway scatter wage educ || lfit wage educ

/********-*********-*********-*********-*********-*********-*********/
/* Example 2.5                                                      */
/********-*********-*********-*********-*********-*********-*********/

* Open Vote1 Data from Wooldridge
* use VOTE1.dta, clear

* Explore voteA
sum voteA

* Model Data with Simple Linear Regression
regress voteA shareA

* Plot Data with Scatter plot and Linear Fit Line
twoway scatter voteA shareA || lfit voteA shareA 

* Histogram of Percent Vote with Mean value of voteA highlighted
hist voteA, xline(50.50)

* Plot Data with Scatter plot, Linear Fit Line, and Mean Value of voteA highlighted
twoway scatter voteA shareA, yline(50.50) || lfit voteA shareA 
