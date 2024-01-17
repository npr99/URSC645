* chapter10.do
set more off
use "\ops2004.dta", clear
**************************************************
* Increment to R-square
**************************************************
codebook env_con educat inc com3 hlthprob epht3 male, compact
regress env_con educat inc com3 hlthprob epht3, beta
pcorr2 env_con educat inclog com3 hlthprob epht3

**************************************************
* Graphic Displays of normality assumption
**************************************************
histogram env_con, frequency normal kdensity
hangroot env_con, bar
fre env_con
summarize env_con, detail
sktest env_con
regress env_con educat inc com3 hlthprob epht3, beta robust
regress env_con educat inclog com3 hlthprob epht3, vce(bootstrap, reps(1000))
regress env_con educat inclog com3 hlthprob epht3, beta
preserve
rvfplot
restore
regress env_con educat inclog com3 hlthprob epht3, beta
predict envhat
predict res, resid
hangroot res, bar
preserve
set seed 111
sample 100, count
twoway (scatter env_con envhat) (lfit env_con envhat)
restore
*residuals
use ed_inc_graph, clear
twoway (scatter income educat) (lfit income educat)
**************************************************
* Regression diagnostics
**************************************************
use ops2004.dta, clear
regress env_con educat inclog com3 hlthprob epht3, beta
predict yhat
predict residual, resid
predict rstandard, rstandard
list respnum env_con yhat resid rstandard if abs(rstandard) > 2.58 & rstandard < .
dfbeta
estat vif
**************************************************
* Weighted data
**************************************************
list finalwt finalwt2 in 1/5
regress env_con educat inclog com3 hlthprob epht3 [pweight=finalwt], beta

**************************************************
* Dummy variables, Hiearachical/Nested Regression
**************************************************
use nlsy97_selected_variables, clear
generate male = gender97
replace male = 0 if gender97==2
gen race=race97
replace race=1 if race97==1 & ethnic97==0
replace race=2 if race97==2 & ethnic97==0
replace race=3 if ethnic97==1
replace race=4 if race97>3 & ethnic97==0
label define race_ethn 1 "White, non-Hispanic"
label define race_ethn 2 "African American, Black", add
label define race_ethn 3 "Hispanic", add
label define race_ethn 4 "Other", add
label values race race_ethn
tab2 race race97 ethnic97
recode race (2 = 1 African_American) (1 3/4= 0 Other), generate(aa)
recode race (3 = 1 Hispanic) (1/2 4 = 0 Other), generate(hispanic)
recode race (4 = 1 Other_race ) (1/3 = 0 W_AA_H), generate(other)
tab1 aa hispanic other
regress smday97 age97 male if !missing(smday97, age97, male, ///
	psmoke97, aa, hispanic, other), beta
regress smday97 age97 male psmoke97 if !missing(smday97, age97, male, ///
	psmoke97, aa, hispanic, other), beta
pcorr2 smday97 age97 male psmoke97 if !missing(smday97, age97, male, ///
	psmoke97, aa, hispanic, other)
regress smday97 age97 male psmoke97 aa hispanic other if !missing(smday97, ///
	age97, male, psmoke97, aa, hispanic, other), beta
test aa hispanic other
nestreg: regress smday97 (age97 male) (psmoke97) (aa hispanic other), beta
 
hireg smday97 (age97 male) (psmoke97) (aa hispanic other), nomiss regopts(beta)
 
**************************************************
* Interaction
**************************************************
use c:\master2\master\dof\c10interaction, clear
sjlog using c10males
regress inc educ male, beta
sjlog close
predict incfnoi if male==0
predict incmnoi if male==1
twoway (connected incmnoi educ if male == 1, lcolor(black) lpattern(dot) ///
  msymbol(diamond) msize(large)) (connected incfno educ if male==0, ///
  lcolor(black) lpattern(solid) msymbol(circle) msize(large)), ///
  ytitle(Income in thousands) xtitle(Education) legend(order(1 "Men" 2 "Women")) ///
  scheme(s2manual)

regress inc educ male ed_male, beta
predict incf if male==0
predict incm if male==1
twoway (connected incm educ if male == 1, lcolor(black) lpattern(dot) ///
 msymbol(diamond) msize(large)) (connected incf educ if male==0, lcolor(black) ///
 lpattern(solid) msymbol(circle) msize(large)), ytitle(Income in thousands) ///
 xtitle(Education) legend(order(1 "Men" 2 "Women")) scheme(s2manual)
