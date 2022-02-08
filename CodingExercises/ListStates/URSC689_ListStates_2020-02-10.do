* Preinstall the following programs:
* ssc install [], replace // describe add on programs needed to run do file
/*-------1---------2---------3---------4---------5---------6--------*/
/* Start Log File - Change name of log file to match program name   */
/*-------1---------2---------3---------4---------5---------6--------*/
capture log close   // suppress error and close any open logs
log using URSC689_ListStates_2020-02-10, replace text

/********-*********-*********-*********-*********-*********-*********/
/* Description of Program                                           */
/********-*********-*********-*********-*********-*********-*********/
// program:    URSC689_ListStates_2020-02-10.do
// task:       Coding challange Loop Through all States
// Version:    first Version
// project:    URSC689
// author:     Nathanael Rosenheim \ Feb 10, 2020

/*------------------------------------------------------------------*/
/* Control Stata                                                    */
/*------------------------------------------------------------------*/
* Generic do file that sets up stata environment
clear all          // Clear existing data files
macro drop _all    // Drop macros from memory
version 15.1       // Set Version
set more off       // Tell Stata to not pause for --more-- messages
set varabbrev off  // Turn off variable abbreviations
set linesize 80    // Set Line Size - 80 Characters for Readability
* set matsize 5000   // Set Matrix Size
* set max_memory 2g  // the file size is larger than 64M 

/********-*********-*********-*********-*********-*********-*********/
/* Set Provenance - What is the do file name?                       */
/********-*********-*********-*********-*********-*********-*********/
global dofilename "URSC689_ListStates_2020-02-10" 
capture mkdir ${dofilename}     // Folder to save outputs from do file

/********************************************************************/
/* Obtain Data                                                      */
/********************************************************************/
* Data from
* https://www.census.gov/library/reference/code-lists/ansi.html

copy "https://www2.census.gov/geo/docs/reference/state.txt" ///
     "${dofilename}/state.txt", replace

/* 
This file contains pipe delimited records for each state. The records are of the format:

FIPS State Code
Official United States Postal Service (USPS) Code
Name
Geographic Names Information System Identifier (GNISID)
*/

insheet using "${dofilename}/state.txt", clear delimiter("|") 
notes: Source https://www2.census.gov/geo/docs/reference/state.txt
notes: US Census Bureau. (2020). American National Standards Institute (ANSI) ///
Codes for States, the District of Columbia, Puerto Rico, and ///
the Insular Areas of the United States. Retrieved from ///
https://www.census.gov/library/reference/code-lists/ansi.html ///
on February 10, 2020.


/*------------------------------------------------------------------*/
/* Basic Loop                                                       */
/*------------------------------------------------------------------*/

forvalues i = 1(10)50 {
	display "`i'"
	list state_name in `i'
}


/********************************************************************/
/* Clean  Data                                                      */
/********************************************************************/

label variable state "FIPS State Code"

label variable stusab "USPS Code"
notes stusab: Official United States Postal Service (USPS) Code

label variable state_name "State Name"

label variable statens "GNISID"
notes statens: Geographic Names Information System Identifier (GNISID)

/*------------------------------------------------------------------*/
/* What is the unique ID of the datafile?                           */
/*------------------------------------------------------------------*/

isid state // this command produces an error the varlist is not unique
duplicates report state

codebook, notes

* all of the variabels are unique and non missing


/*------------------------------------------------------------------*/
/* Advanced Loop                                                    */
/*------------------------------------------------------------------*/

* Idea from statalist https://www.stata.com/statalist/archive/2007-03/msg00525.html
local N = _N
forvalues i = 1/`N' {
	if state_name[`i'] != "" {
		display state_name[`i']
	}
	else {
	}
}

/*------------------------------------------------------------------*/
/* Abstraction - Program to Print State Name                        */
/*------------------------------------------------------------------*/
* Write a short program that displays the state name given a numeric value

* When debugging program have to drop the program in memory
capture program drop returnstatename
program returnstatename, rclass
	syntax, fips(int)
	* to find observation by a value first the program will need to 
	* create a variable that identifies observation number 
	tempvar observation_number
	gen long `observation_number' = _n 
	* Summarize observation number to find the row number
	quietly summarize `observation_number' if state == `fips', meanonly
	
	* Check to make sure only 1 row has fips code 
	if `r(N)' == 1 {
		* `r(min)' will provide the row number
		local state_name = state_name[`r(min)']
		* To return a value from the program
		return local display_name = "`state_name'"		
		display as result "State name found: `state_name'"
	}
	* Check if no obsevations were found for fips code
	if `r(N)' == 0 {
		display as error "No state with FIPS code = `fips'"
	}
end

returnstatename, fips(48)
return list
display "`r(display_name)'"


* Use Basic Loop with function
forvalues i = 1(1)56 {
	returnstatename, fips(`i')
}


/*------------------------------------------------------------------*/
/* Save Final file                                                  */
/*------------------------------------------------------------------*/
save "${dofilename}/${dofilename}.dta", replace

/*------------------------------------------------------------------*/
/* Review Codebook for data file                                    */
/*------------------------------------------------------------------*/

describe, fullnames
codebook, compact
codebook, all notes

/*------------------------------------------------------------------*/
/* End Log                                                          */
/*------------------------------------------------------------------*/

log close
exit
