* Preinstall the following programs:
* ssc install estout, replace // to create tables install estout
* lookup lean2 // select Software Update with Scheme Lean2 for plots

/*-------1---------2---------3---------4---------5---------6--------*/
/* Start Log File: Change working directory to project directory    */
/*-------1---------2---------3---------4---------5---------6--------*/

capture log close   // suppress error and close any open logs
log using URSC689_3bv1_Estimate_Outs_Demo_2019-04-11.log, replace text
/********-*********-*********-*********-*********-*********-*********/
/* Description of Program                                           */
/********-*********-*********-*********-*********-*********-*********/
// program:    URSC689_3bv1_Estimate_Outs_Demo_2019-04-11.do
// task:       Demonstrate Estimates Out Command
// version:    v1 
// project:    URSC-SOCI 689 In Class Demo
// author:     Nathanael Rosenheim \ April 11 2019

/*------------------------------------------------------------------*/
/* Control Stata                                                    */
/*------------------------------------------------------------------*/
* Generic do file that sets up stata environment
clear all          // Clear existing data files
macro drop _all    // Drop macros from memory
version 12.1       // Set Version
set more off       // Tell Stata to not pause for --more-- messages
set varabbrev off  // Turn off variable abbreviations
set linesize 80    // Set Line Size - 80 Characters for Readability
numlabel _all, add // Print Prefix numeric values to value labels 
*set matsize 5000   // Set Matrix Size if program has a large matrix
*set max_memory 2g  // if the file size is larger than 64M change size

/*-------------------------------------------------------------------*/
/* Set Provenance                                                    */
/*-------------------------------------------------------------------*/
// What is the do file name? What program is needed to replicate results?
global dofilename "URSC689_3bv1_Estimate_Outs_Demo_2019-04-11" 
global provenance "Provenance: ${dofilename}.do `c(filename)' `c(current_date)'"
global source "IN-CORE Project, Nathanael Rosenheim" // what is the data source

* Create folder to save output
capture mkdir ${dofilename}
/********-*********-*********-*********-*********-*********-*********/
/* Obtain Data                                                      */
/********-*********-*********-*********-*********-*********-*********/

local sourcefolder "../SourceData/IN-CORE/"
use "`sourcefolder'IN-CORE_4av4_Predict_IKE_EvacuationData_2019-03-29.dta", replace

/********-*********-*********-*********-*********-*********-*********/
/* Explore Data - Summary Statistics                                */
/********-*********-*********-*********-*********-*********-*********/

* Descriptive Statistics for Data
eststo clear
estpost tabstat pr_evac se_evac income randincome soci*, ///
		statistics(min max p50 mean sd count) columns(statistics)
		
esttab using ///
	"${dofilename}/${dofilename}.rtf" ///
	, replace alignment(r) label nogaps nonumbers  ///
	cells("count(fmt(%8.0fc)) min(fmt(%4.2f)) max(fmt(%10.2fc)) p50(fmt(%10.2fc)) mean(fmt(%10.2fc)) sd(fmt(%10.2fc))") noobs ///
	title(Basic Descriptive Statistics For Key Variables) ///
	addnote("Source: Estimated Population Data using parcel, 2010 Block and 2012 ACS Tract data" "`c(filename)' `c(current_date)'")
eststo clear

/********-*********-*********-*********-*********-*********-*********/
/* Explore Data - Population Size and data available                */
/********-*********-*********-*********-*********-*********-*********/

eststo clear
estpost tabulate race fulldata [fw=numprec], missing
esttab using ///
"${dofilename}/${dofilename}.rtf" ///
	, append ///
	title(Population Size By Race by Data Availability) ///
	cell(b(fmt(%12.0fc)) colpct(fmt(2) par)) ///
	nostar unstack label modelwidth(20) onecell varlabels(`e(labels)') ///
	collabels(none) nomtitle nonumber noobs ///
	addnote("Source: Estimated Population Data using parcel, 2010 Block and 2012 ACS Tract data" "`c(filename)' `c(current_date)'")
eststo clear

eststo clear
estpost tabulate ownershp fulldata [fw=numprec], missing
esttab using ///
"${dofilename}/${dofilename}.rtf" ///
	, append ///
	title(Population Size By Tenure by Data Availability) ///
	cell(b(fmt(%12.0fc)) colpct(fmt(2) par)) ///
	nostar unstack label modelwidth(20) onecell varlabels(`e(labels)') ///
	collabels(none) nomtitle nonumber noobs ///
	addnote("Source: Estimated Population Data using parcel, 2010 Block and 2012 ACS Tract data" "`c(filename)' `c(current_date)'")
eststo clear

eststo clear
estpost tabulate vacancy fulldata if vacancy != 0
esttab using ///
"${dofilename}/${dofilename}.rtf" ///
	, append ///
	title(Vacancy Status by Data Availability) ///
	cell(b(fmt(%12.0fc)) colpct(fmt(2) par)) ///
	nostar unstack label modelwidth(20) onecell varlabels(`e(labels)') ///
	collabels(none) nomtitle nonumber noobs ///
	addnote("Source: Estimated Population Data using parcel, 2010 Block and 2012 ACS Tract data" "`c(filename)' `c(current_date)'")
eststo clear

/********-*********-*********-*********-*********-*********-*********/
/* Explore Data - Income Medians                                    */
/********-*********-*********-*********-*********-*********-*********/

* Mediain Income by Race and Full Data
eststo clear
estpost tabstat income if fulldata == 0, by(race) statistics(p50) columns(statistics) listwise
		
esttab using ///
"${dofilename}/${dofilename}.rtf" ///
	, b(a3) append main(p50 %12.2fc) ///
	title(Median Income By Race, Data not Available) ///
	nostar unstack label modelwidth(20) onecell varlabels(`e(labels)') ///
	collabels(none) nomtitle nonumber noobs ///
	addnote("Source: Estimated Population Data using parcel, 2010 Block and 2012 ACS Tract data" "`c(filename)' `c(current_date)'")
eststo clear

eststo clear
estpost tabstat income if fulldata == 1, by(race) statistics(p50) columns(statistics) listwise
		
esttab using ///
"${dofilename}/${dofilename}.rtf" ///
	, b(a3) append main(p50 %12.2fc) ///
	title(Median Income By Race, Data Available) ///
	nostar unstack label modelwidth(20) onecell varlabels(`e(labels)') ///
	collabels(none) nomtitle nonumber noobs ///
	addnote("Source: Estimated Population Data using parcel, 2010 Block and 2012 ACS Tract data" "`c(filename)' `c(current_date)'")
eststo clear

eststo clear
estpost tabstat income, by(race) statistics(p50) columns(statistics) listwise
		
esttab using ///
"${dofilename}/${dofilename}.rtf" ///
	, b(a3) append main(p50 %12.2fc) ///
	title(Median Income By Race, Total) ///
	nostar unstack label modelwidth(20) onecell varlabels(`e(labels)') ///
	collabels(none) nomtitle nonumber noobs ///
	addnote("Source: Estimated Population Data using parcel, 2010 Block and 2012 ACS Tract data" "`c(filename)' `c(current_date)'")
eststo clear

* Mediain Income by Race and Full Data - Not Hispanic
eststo clear
estpost tabstat income if fulldata == 0 & hispan == 0, by(race) statistics(p50) columns(statistics) listwise
		
esttab using ///
"${dofilename}/${dofilename}.rtf" ///
	, b(a3) append main(p50 %12.2fc) ///
	title(Median Income By Race Not Hispanic, Data not Available) ///
	nostar unstack label modelwidth(20) onecell varlabels(`e(labels)') ///
	collabels(none) nomtitle nonumber noobs ///
	addnote("Source: Estimated Population Data using parcel, 2010 Block and 2012 ACS Tract data" "`c(filename)' `c(current_date)'")
eststo clear

eststo clear
estpost tabstat income if fulldata == 1 & hispan == 0, by(race) statistics(p50) columns(statistics) listwise
		
esttab using ///
"${dofilename}/${dofilename}.rtf" ///
	, b(a3) append main(p50 %12.2fc) ///
	title(Median Income By Race Not Hispanic, Data Available) ///
	nostar unstack label modelwidth(20) onecell varlabels(`e(labels)') ///
	collabels(none) nomtitle nonumber noobs ///
	addnote("Source: Estimated Population Data using parcel, 2010 Block and 2012 ACS Tract data" "`c(filename)' `c(current_date)'")
eststo clear

eststo clear
estpost tabstat income if hispan == 0, by(race) statistics(p50) columns(statistics) listwise
		
esttab using ///
"${dofilename}/${dofilename}.rtf" ///
	, b(a3) append main(p50 %12.2fc) ///
	title(Median Income By Race Not Hispanic, Total) ///
	nostar unstack label modelwidth(20) onecell varlabels(`e(labels)') ///
	collabels(none) nomtitle nonumber noobs ///
	addnote("Source: Estimated Population Data using parcel, 2010 Block and 2012 ACS Tract data" "`c(filename)' `c(current_date)'")
eststo clear

* Mediain Income by Ethnicity and Full Data
eststo clear
estpost tabstat income if fulldata == 0, by(hispan) statistics(p50) columns(statistics) listwise
		
esttab using ///
"${dofilename}/${dofilename}.rtf" ///
	, b(a3) append main(p50 %12.2fc) ///
	title(Median Income By Ethnicity, Data not Available) ///
	nostar unstack label modelwidth(20) onecell varlabels(`e(labels)') ///
	collabels(none) nomtitle nonumber noobs ///
	addnote("Source: Estimated Population Data using parcel, 2010 Block and 2012 ACS Tract data" "`c(filename)' `c(current_date)'")
eststo clear

eststo clear
estpost tabstat income if fulldata == 1, by(hispan) statistics(p50) columns(statistics) listwise
		
esttab using ///
"${dofilename}/${dofilename}.rtf" ///
	, b(a3) append main(p50 %12.2fc) ///
	title(Median Income By Ethnicity, Data Available) ///
	nostar unstack label modelwidth(20) onecell varlabels(`e(labels)') ///
	collabels(none) nomtitle nonumber noobs ///
	addnote("Source: Estimated Population Data using parcel, 2010 Block and 2012 ACS Tract data" "`c(filename)' `c(current_date)'")
eststo clear

eststo clear
estpost tabstat income, by(hispan) statistics(p50) columns(statistics) listwise
		
esttab using ///
"${dofilename}/${dofilename}.rtf" ///
	, b(a3) append main(p50 %12.2fc) ///
	title(Median Income By Ethnicity, Total) ///
	nostar unstack label modelwidth(20) onecell varlabels(`e(labels)') ///
	collabels(none) nomtitle nonumber noobs ///
	addnote("Source: Estimated Population Data using parcel, 2010 Block and 2012 ACS Tract data" "`c(filename)' `c(current_date)'")
eststo clear

/********-*********-*********-*********-*********-*********-*********/
/* Explore Data - Income Distribution                               */
/********-*********-*********-*********-*********-*********-*********/
sum income, detail

twoway (histogram randincome if race == 1 & hispan == 0 & randincome < 200000, start(0) width(5000) ///
	   color(gray) frequency) ///
       (histogram randincome if race == 2 & hispan == 0 & randincome < 200000, start(0) width(5000) ///
	   fcolor(none) lcolor(black) frequency),  ///
	   legend(order(1 "White Alone, not Hispanic" 2 "African-American Alone, not Hispanic" ) size(vsmall)) ///
	   note(" $provenance ", size(tiny)) ///
	   xlabel(50000 "$50,000" 100000 "$100,000" 150000 "$150,000") ///
	   xtick(0(10000)200000) ///
	   title("Distribution of Income by Race, Galveston Island, TX 2010", size(small)) ///
	   ytitle("Number of households") ///
	   graphregion(color(white)) bgcolor(white)
graph export "${dofilename}/${dofilename}_incomerace1.emf", replace	
	   
twoway (histogram randincome if renter == 0 & randincome < 200000, start(0) width(5000) color(gray) frequency) ///
       (histogram randincome if renter == 1 & hispan == 0 & randincome < 200000, start(0) width(5000) ///
	   fcolor(none) lcolor(black) frequency),  ///
	   legend(order(1 "Homeowners" 2 "Renters" ) size(vsmall)) ///
	   note(" $provenance ", size(tiny)) ///
	   xlabel(50000 "$50,000" 100000 "$100,000" 150000 "$150,000") ///
	   title("Distribution of Income by Tenure Status, Galveston Island, TX 2010", size(small)) ///
	   ytitle("Number of households") ///
	   graphregion(color(white)) bgcolor(white)
graph export "${dofilename}/${dofilename}_incometenure1.emf", replace

twoway (histogram randincome if hispan == 0 & randincome < 200000, start(0) width(5000) color(gray) frequency) ///
       (histogram randincome if hispan == 1 & randincome < 200000, start(0) width(5000) ///
	   fcolor(none) lcolor(black) frequency), ///
	   legend(order(1 "Not Hispanic" 2 "Hispanic" ) size(vsmall)) ///
	   note(" $provenance ", size(tiny)) ///
	   xlabel(50000 "$50,000" 100000 "$100,000" 150000 "$150,000") ///
	   title("Distribution of Income by Ethnicity, Galveston Island, TX 2010", size(small)) ///
	   ytitle("Number of households") ///
	   graphregion(color(white)) bgcolor(white)
graph export "${dofilename}/${dofilename}_incometenure1.emf", replace		

/*-------------------------------------------------------------------*/
/* Sources of missing population data                                */
/*-------------------------------------------------------------------*/

eststo clear
estpost tabulate race hispan if numprec == 7
esttab using ///
"${dofilename}/${dofilename}.rtf" ///
	, append ///
	title(Households with 7 plus persons by Race and Ethnicity) ///
	cell(b(fmt(%12.0fc)) colpct(fmt(2) par)) ///
	nostar unstack label modelwidth(20) onecell varlabels(`e(labels)') ///
	collabels(none) nomtitle nonumber noobs ///
	addnote("Source: Estimated Population Data using parcel, 2010 Block and 2012 ACS Tract data" "`c(filename)' `c(current_date)'")
eststo clear

estpost tabulate gqtype [fw=numprec]
esttab using ///
"${dofilename}/${dofilename}.rtf" ///
	, append ///
	title(Group Quarters Population) ///
	cell(b(fmt(%12.0fc)) colpct(fmt(2) par)) ///
	nostar unstack label modelwidth(20) onecell varlabels(`e(labels)') ///
	collabels(none) nomtitle nonumber noobs ///
	addnote("Source: Estimated Population Data using parcel, 2010 Block and 2012 ACS Tract data" "`c(filename)' `c(current_date)'")
eststo clear

/*-------------------------------------------------------------------*/
/* Explore Population By Traffic Cluster                             */
/*-------------------------------------------------------------------*/

tabstat numprec, by(clusterin) statistics(sum)
sum renter
tabstat renter, by(clusterin) statistics(mean)

sum soci_vul
tabstat soci_vul, by(clusterin) statistics(mean)

sum soci_vul1
codebook soci_vul*, notes
tabstat soci_vul1, by(clusterin) statistics(mean)
tabstat soci_vul2, by(clusterin) statistics(mean)
tabstat soci_vul3, by(clusterin) statistics(mean)

eststo clear
estpost tabstat numprec, by(clusterin) statistics(sum) columns(statistics) listwise

esttab using ///
"${dofilename}/${dofilename}.rtf" ///
	, b(a3) append main(sum %12.0fc) ///
	title(Total Population, by Traffic Cluster) ///
	nostar unstack label modelwidth(20) onecell varlabels(`e(labels)') ///
	collabels(none) nogaps nomtitle nonumber noobs ///
	addnote("Source: Estimated Population Data using parcel, 2010 Block and 2012 ACS Tract data" "`c(filename)' `c(current_date)'")
eststo clear

eststo clear
estpost tabstat soci_vul1, by(clusterin) statistics(mean) columns(statistics) listwise

esttab using ///
"${dofilename}/${dofilename}.rtf" ///
	, b(a3) append main(mean %6.3fc) ///
	title(Social Vulnerabilty Income, by Traffic Cluster) ///
	nostar unstack label modelwidth(20) onecell varlabels(`e(labels)') ///
	collabels(none) nogaps nomtitle nonumber noobs ///
	addnote("Source: Estimated Population Data using parcel, 2010 Block and 2012 ACS Tract data" "`c(filename)' `c(current_date)'")
eststo clear

eststo clear
estpost tabstat soci_vul2, by(clusterin) statistics(mean) columns(statistics) listwise

esttab using ///
"${dofilename}/${dofilename}.rtf" ///
	, b(a3) append main(mean %6.3fc) ///
	title(Social Vulnerabilty Race, by Traffic Cluster) ///
	nostar unstack label modelwidth(20) onecell varlabels(`e(labels)') ///
	collabels(none) nogaps nomtitle nonumber noobs ///
	addnote("Source: Estimated Population Data using parcel, 2010 Block and 2012 ACS Tract data" "`c(filename)' `c(current_date)'")
eststo clear

eststo clear
estpost tabstat soci_vul3, by(clusterin) statistics(mean) columns(statistics) listwise

esttab using ///
"${dofilename}/${dofilename}.rtf" ///
	, b(a3) append main(mean %6.3fc) ///
	title(Social Vulnerabilty Tenure, by Traffic Cluster) ///
	nostar unstack label modelwidth(20) onecell varlabels(`e(labels)') ///
	collabels(none) nogaps nomtitle nonumber noobs ///
	addnote("Source: Estimated Population Data using parcel, 2010 Block and 2012 ACS Tract data" "`c(filename)' `c(current_date)'")
eststo clear

eststo clear
estpost tabstat soci_vulA3, by(clusterin) statistics(mean) columns(statistics) listwise

esttab using ///
"${dofilename}/${dofilename}.rtf" ///
	, b(a3) append main(mean %6.3fc) ///
	title(Social Vulnerabilty All Three, by Traffic Cluster) ///
	nostar unstack label modelwidth(20) onecell varlabels(`e(labels)') ///
	collabels(none) nogaps nomtitle nonumber noobs ///
	addnote("Source: Estimated Population Data using parcel, 2010 Block and 2012 ACS Tract data" "`c(filename)' `c(current_date)'")
eststo clear

/*-------------------------------------------------------------------*/
/* Notes on Data Sources                                             */
/*-------------------------------------------------------------------*/

notes: $provenance

/*-------------------------------------------------------------------*/
/* End Log                                                           */
/*-------------------------------------------------------------------*/

log close
exit
