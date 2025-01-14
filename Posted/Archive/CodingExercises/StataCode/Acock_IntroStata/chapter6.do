* chapter6tex.do
* gss2002_chapter6.dta
* variables include
*   sex
*   sexfreq
*   marital
**************************************************************
use gss2006_chapter6, clear
tabulate sex abany, row
tabulate sex abany, chi2 expected row
* Type -findit chitable- to find and install the -chitable- command
chitable
tabulate sex abany

use chapter6_aspirin
tabulate aspirin heartattack, chi2 row V

use gss2006_chapter6
gen p = 1 - chi2(1,10.0509)
list p in 1/1
codebook happy health, compact
tabulate health happy, chi2 column gamma row V taub 
ssc install tabplot, replace

tabplot health happy
label var sex "respondent sex"
tabulate sex abany
* interactive tables
tabi 215 269\172 244, chi2 row V
label var sex "Gender"
table sex, contents(mean hrs1 sd hrs1 count hrs1)
table sex marital, contents(mean hrs1 sd hrs1 freq) row
graph bar (mean) hrs1, over(sex) over(marital) blabel(bar, format(%9.1f)) ///
  title(Hours Worked Last Week) subtitle(By Gender and Marital Status) ///
  scheme(s1mono)
tabulate sex
generate female = sex - 1
label define female 0 "Male" 1 "Female"
label variable female female
pbis female hrs1
use "C:\master2\master\dof\gss2006_chapter6.dta", clear
tab sex pornlaw
