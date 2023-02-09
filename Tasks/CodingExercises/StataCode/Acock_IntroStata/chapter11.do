* chapter11.do
* hypothetical data relating divorce in first 5 years of marriage
* to score on positive feedback in discussions with spouse prior to 
* marriage
use "divorce.dta", clear
list divorce positives
label define yes 1 "Divorced" 0 "Not divorced"
label values divorce yes
scatter divorce positives, scheme(s2mono)
logit divorce positives
predict prdivorce
scatter prdivorce positives, scheme(s2mono)
predict logit, xb
scatter logit positives, scheme(s2mono)
regress divorce positives
predict divols
twoway (scatter divorce positives) (lfit divols positives)
***********************************************
* What is a logit?
***********************************************
clear
use "environ.dta", clear
tab2 environ libcand, row

***********************************************
* Logistic regression examples
***********************************************
clear
use nlsy97_chapter11, clear
summarize drank30 age97 pdrink97 dinner97 male if !missing(drank30, age97, ///
   pdrink97, dinner97, male)
logistic drank age97 male pdrink97 dinner97
logit drank30 age97 male pdrink97 dinner97
listcoef, help
listcoef, help percent

**************************************************
* Create a barchart from listcoef, percent command
**************************************************
use "c11barchart", clear
graph bar (asis) Age male peers dinner, bargap(10) blabel(name, position(outside)) ///
	ytitle(Percent Change in Odds) title(Percentage Change in Odds of Drinking by) ///
	subtitle("Age, Gender, Percent of Peers Drinking, Meals with Family") ///
	legend(off) scheme(s2manual)

**************************************************
* Testing parameter estimates
**************************************************
use nlsy97_chapter11, clear
logistic drank30 age97 male pdrink97 dinner97
lrdrop1
test pdrink97 dinner97
******************************************************
* Nested logistic regression / Hierarchical Regression
******************************************************
nestreg: logistic drank30 (male) (age97) (dinner97 pdrink97)
