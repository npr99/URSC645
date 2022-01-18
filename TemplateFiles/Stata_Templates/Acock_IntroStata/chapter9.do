* chapter9.do
***************************************
* ONEWAY ANOVA
***************************************
use partyid, clear
oneway stemcell partyid, bonferroni tabulate

use gss2006_chapter9, clear
oneway prestg80 mobile16 if age > 29 & age < 60 & wrkstat==1, bonferroni ///
  tabulate
graph bar (mean) prestg80 if age > 29 & age < 60 & wrkst==1, over(mobile16) ///
  title(Mean prestige by mobility since age of 16) ///
  subtitle(Adults age 30 to 59) ytitle(Mean prestige rating) scheme(s2mono)

**************************************
* NONPARAMETRIC ALTERNATIVE
**************************************
use partyid, clear 
kwallis stemcell, by(partyid)
tabstat stemcell, statistics(mean median sd) by(partyid)
graph hbar (median) stemcell, over(partyid) ///
  title(Median stem-cell attitude score by party identification) ///
  ytitle(Median score on stem-cell attitude) ///
  scheme(s2mono)
graph box stemcell, over(partyid) ///
   title(Support for stem-cell research by party identification) ///
   ytitle(Support for stem-cell research) scheme(s2mono)

********************************************
* Analysis of Covariance
********************************************
use gss2006_chapter9, replace
anova prestg80 mobile16 age if age > 29 & age < 60 & wrkst==1, continuous(age) partial
adjust age, by(mobile16) xb ci generate(adj_mean) label(Adjusted Means) ///
 cilabel(Confidence Interval) left
table mobile16 if age > 29 & age < 60 & wrkstat==1, contents(mean adj_mean mean prestg80)
omega2 mobile16 
omega2 age

*******************************************
* TWO WAY ANOCA anova using anova command 
*******************************************
tabulate mobile16 sex if age > 29 & age < 60 & wrkst==1, summarize(prestg80)
anova prestg80 mobile16 sex mobile16*sex if age > 29 & age < 60 & wrkst==1, partial
* Creating graph for two way ANOVA
adjust, xb generate(prestige)
twoway (connected prestige mobile16 if age > 29 & age < 60 & wrkst==1 & sex==1, ///
   sort lpattern(longdash_dot) msymbol(diamond_hollow) msize(large)) ///
   (connected prestige mobile16 if age >29 & age < 60 & wrkst==1 & sex==2, ///
   sort lpattern(dash) msymbol(circle_hollow) msize(large)), xlabel(1(1)3, ///
   valuelabel angle(forty_five)) title(Mobility and Prestige by Gender) ///
   legend(on order(1 "Men" 2 "Women")) legend(title(Title of Legend)) scheme(s2mono)

******************************************
* REPEATED MEASURES 
******************************************
use wide9, clear
list
reshape long test, i(id) j(time)
list
anova test id time, repeated(time)
table time, contents(mean test)

*******************************************
* INTRACLASS CORRELATION
*******************************************
use intraclass, clear
list
loneway medicare group
