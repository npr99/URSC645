clear all
set more off
version 10.0
set scheme ssccl

//Figure 8.1
insheet using data/MichelinFood.txt, names
twoway scatter prop food, xtitle("Zagat Food Rating") ///
ytitle("Sample Proportion")
graph export graphics/f8p1.eps, replace

gen tot = inmichelin + notinmichelin

//Logistic Binomial Output
//get null deviance
qui binreg inmichelin, n(tot)
di e(deviance) 
di e(df)
//perform Logistic Regression
binreg inmichelin food, n(tot)

//Figure 8.2
twoway scatter prop food ///
|| function y=1/(1 + exp(-(_b[_cons] + _b[food]*x))),range(15 28) ///
legend(off) xtitle("Zagat Food Rating") ///
ytitle("Probability of Inclusion in the Michelin Guide") xlabel(16(2)28)
graph export graphics/f8p2.eps, replace


//Table 8.2
predict logitpred, xb
gen thetapred = 1/(1 + exp(-logitpred))
gen oddspred = exp(logitpred)
l food thetapred oddspred if food != .


//p-value, residual Deviance test
di 1-chi2(e(df),e(deviance))

local rdev = e(deviance)
local rdevdf = e(df)
qui binreg inmichelin, n(tot)

//p-value, difference Deviance tests
di 1-chi2(`e(df)' - `rdevdf',`e(deviance)'-`rdev')

//Pearson's X^2
qui binreg inmichelin food, n(tot)
preserve
predict res,pearson  
replace res = res*res
collapse (sum) res
di "Pearson's X^2 = " res[1]
restore

//Table 8.3
predict pearres, pearson
predict devres, deviance
predict respres, response
gen response = inmichelin/tot
l food response thetapred respres pearres devres

//Figure 8.3
predict pearstanres, pearson standardized
predict devstanres, deviance standardized
twoway scatter devstan food, xtitle("Food Rating") ///
ytitle("Standardized Deviance Residuals") name(g1) ///
nodraw xlabel(16(2)28) xsize(3)
twoway scatter pearstan food, xtitle("Food Rating") ///
ytitle("Standardized Pearson Residuals") name(g2) ///
nodraw xlabel(16(2)28) xsize(3)
graph combine g1 g2, xsize(6) ysize(5)
graph export graphics/f8p3.eps, replace
graph drop g1 g2

clear
insheet using data/MichelinNY.csv, names

//Figure 8.4
twoway scatter inmich food , xtitle("Food Rating") ///
ytitle("In Michelin Guide? (0=No, 1=Yes)") jitter(3) xlabel(16(2)28)
graph export graphics/f8p4.eps, replace

//Figure 8.5
gen eal = "In Michelin Guide? (0=No, 1=Yes)"
graph box food, ytitle("Food Rating") ylabel(16(2)28) over(inmich) over(eal) 
graph export graphics/f8p5.eps, replace

//Logistic Output
//Note Difference of Deviance Test is presented as GOF test
logit inmichelin food
//Null Deviance
gen tot = 1
qui binreg inmichelin, n(tot)
di e(deviance)
di e(df)
local ndev = e(deviance)
//Residual Deviance
qui binreg inmichelin food, n(tot)
di e(deviance)
di e(df)
//difference of deviance
local dd = `ndev' - e(deviance) 
di `dd'


//Figure 8.6
predict pearstanres, pearson standardized
predict devstanres, deviance standardized
twoway scatter devstanres food, xtitle("Food Rating") ///
ytitle("Standardized Deviance Residuals") xlabel(16(2)28) ///
nodraw name(g1) ylabel(-4(2)4) xsize(3)
twoway scatter pearstanres food, xtitle("Food Rating") ///
ytitle("Standardized Pearson Residuals") xlabel(16(2)28) ///
nodraw name(g2) ylabel(-4(2)4) xsize(3)
graph combine g1 g2, xsize(6)
graph export graphics/f8p6.eps, replace
graph drop g1 g2

//Figure 8.7
gen inmit2 = .
gen food2 = .
local a = 2/3
lowess_ties_optim inmichelin food, store(inmit2 food2) frac(`a') iter(1)
twoway scatter inmich food,jitter(3) ///
|| function y=1/(1 + exp(-(_b[_cons] + _b[food]*x))), range(15 28) ///
|| line inmit2 food2, sort lpattern(dash) legend(off) xtitle("Food Rating") ///
ytitle("In Michelin guide? (0=No,1=Yes)") xlabel(16(2)28)
graph export graphics/f8p7.eps, replace

//Figure 8.8
replace eal = "In Michelin Guide? (0=No, 1=Yes)"
graph box food, ytitle("Food Rating") over(inmich) over(eal) nodraw name(a)
graph box decor, ytitle("Decor Rating")  over(inmich) over(eal) nodraw name(b)
graph box service,ytitle("Service Rating") over(inmich) over(eal) nodraw name(c)
graph box cost, ytitle("price")  over(inmich) over(eal) nodraw name(d)
graph combine a b c d, rows(2)
graph drop a b c d
graph export graphics/f8p8.eps, replace

//Figure 8.9
gen lncost = ln(cost)
qui logit inmichelin food decor service cost lncost 
replace inmit2 = .
replace food2 = .
lowess_ties_optim inmichelin food, store(inmit2 food2) frac(`a') iter(1)
twoway scatter inmichelin food ///
|| line inmit2 food2,sort xlabel(16(2)28) xtitle("Food Rating, x1") ///
ytitle("Y, In Michelin Guide (0=No,1=Yes)") legend(off) nodraw name(g1) xsize(3)
predict yhat,pr
replace inmit2 = .
replace food2 = .
lowess_ties_optim yhat food, store(inmit2 food2) frac(`a') iter(1)
twoway scatter yhat food || line inmit2 food2, sort xlabel(16(2)28) ///
xtitle("Food Rating, x1") ytitle("Prediction") legend(off) ///
nodraw name(g2) xsize(3)
graph combine g1 g2, xsize(6)
graph export graphics/f8p9.eps, replace
graph drop g1 g2

//Figure 8.10
local a = 2/3
mmp, mean(pr) smoother(lowess) smoopt("bwidth(`a')") pred lin 
graph export graphics/f8p10.eps, replace

//Figure 8.11
twoway scatter service decor if inmich == 0, msymbol(oh) mcolor(black) ///
|| lfit service decor if inmich==0, lcolor(black) ///
|| scatter service decor if inmich == 1, msymbol(th) mcolor(red) ///
|| lfit service decor if inmich == 1, lcolor(red) legend(cols(1) ///
order(1 3) title("In Michelin Guide") label(1 "No") label(3 "Yes") ///
 ring(0) position(11)) xtitle("Decor Rating") ytitle("Service Rating") 
graph export graphics/f8p11.eps, replace

gen servdecor = service*decor
qui logit inmichelin food decor service cost lncost servdecor
//Figure 8.12
local a = 2/3
mmp, mean(pr) smoother(lowess) smoopt("bwidth(`a')") varlist(food decor ///
service cost lncost) lin
graph export graphics/f8p12.eps, replace

analysis_deviance inmichelin, reduced(food decor service cost lncost) ///
full(food decor service cost lncost servdecor)

//Fit the same model under binreg so we can get predictions
qui binreg  inmichelin food decor service cost lncost servdecor, n(tot)
predict hvalues, hat
predict stanresdeviance, deviance standardized
local lvgcutoff = 2*e(k)/e(N)
gen zelabel = restaur  if inlist(restaurant,"Alain Ducasse", "Arabelle", ///
"per se") 
twoway scatter stanresdev hvalues, mlabel(zelabel) mlabposition(3) ///
mlabsize(tiny) xlabel(0(.1).8) xline(`lvgcutoff') ///
ytitle("Standardized Deviance Residuals") xtitle("Leverage Values")
graph export graphics/f8p13.eps, replace
di `lvgcutoff'

//Logistic Output
logit inmichelin food decor service cost lncost servdecor, nolog 
//Null deviance
qui binreg inmichelin, n(tot)
di e(deviance)
di e(df)
//Residual deviance
qui binreg inmichelin food decor service cost lncost servdecor 
di e(deviance)
di e(df)

analysis_deviance inmichelin, reduced(food decor service lncost servdecor) ///
full(food decor service cost lncost servdecor)

//Logistic Output
logit inmichelin food decor service lncost servdecor, nolog 
//Null deviance
qui binreg inmichelin, n(tot)
di e(deviance)
di e(df)
//Residual deviance
qui binreg inmichelin food decor service lncost servdecor 
di e(deviance)
di e(df)

//Figure 8.14
qui logit inmichelin food decor service lncost servdecor
local a = 2/3
mmp, mean(pr) smoother(lowess) smoopt("bwidth(`a')") ///
varlist(food decor service lncost) lin 
graph export graphics/f8p14.eps, replace


//Figure 8.15
drop hvalues stanresdeviance zelabel
qui binreg inmichelin food decor service lncost servdecor 
predict hvalues, hat
predict stanresdeviance, deviance standardized
local lvgcutoff = 2*e(k)/e(N)
gen zelabel = restaur if inlist(restaur,"Park Terrace Bistro", ///
"Paradou","Odeon","Gavroche","Le Bilboquet","Arabelle", ///
"Terrace in the Sky","Café du Soleil","Atelier")
twoway scatter stanresdev hvalues, mlabel(zelabel) mlabposition(3) ///
mlabsize(tiny) xline(`lvgcutoff') ytitle("Standardized Deviance Residuals") ///
 xtitle("Leverage Values")
graph export graphics/f8p15.eps, replace

//Table 8.5
predict estp, mu
l estp inmichelin rest food decor service cost if abs(estp - inmichelin)> .85
