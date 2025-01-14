clear all
version 10.0
set more off
set scheme ssccl

insheet using data/bridge.txt, names
gen lntime = ln(time)
gen lndarea = ln(darea)
gen lnccost = ln(ccost)
gen lndwgs = ln(dwgs)
gen lnlength = ln(length)
gen lnspans = ln(span)

//regression output
reg lntime lndarea lnccost lndwgs lnlength lnspans

vselect lntime lndarea lnccost lndwgs lnlength lnspans, best
return list
matrix list r(info)
forvalues i = 1/5 {
local best`i' "`r(best`i')'"
local best`i'= subinstr("`best`i''","lndarea","lDA",.)
local best`i'= subinstr("`best`i''","lnccost","lC",.)
local best`i'= subinstr("`best`i''","lndwgs","lgD",.)
local best`i'= subinstr("`best`i''","lnlength","lL",.)
local best`i'= subinstr("`best`i''","lnspans","lS",.)
}
matrix A = r(info)
svmat A, names(col)

gen best = ""
forvalues i = 1/5 {
replace best = "`best`i''" if _n == `i'
}

twoway scatter R2ADJ case if case <= 5, xlabel(1(1)5) xtitle("Subset Size") ///
ytitle("Adjusted R-Squared") name(g1) nodraw
twoway scatter R2ADJ case if case <= 5, mlabel(best) mlabsize(small) ///
mlabposition(12) xlabel(1(1)5) xtitle("Subset Size") ///
ytitle("Adjusted R-Squared") name(g2) nodraw ///
text(.72 4 "lDA : logDArea" "lC : logCCost" "lgD : logDwgs" ///
"lL : logLength" "lS : logSpans", box size(medlarge))

graph combine g1 g2, xsize(10) rows(1)
graph export graphics/f7p1.eps, replace
graph drop g1 g2

//regression output
reg lntime lndwg lnsp
reg lntime lndw lnsp lncc

//backward AIC
vselect lntime lndarea lnccost lndwgs lnlength lnspans, backward aic

//forward AIC 
vselect lntime lndarea lnccost lndwgs lnlength lnspans, forward aic

insheet using data/prostateTraining.txt, clear names

//Figure 7.2 
graph matrix lpsa lcavol lweight age lbph svi lcp gleason pgg45
graph export graphics/f7p2.eps, replace

qui reg lpsa lcavol lweight age lbph svi lcp gleason pgg45
predict stanres, rstandard
predict zefit, xb
label variable stanres "Standardized Residuals"
label variable zefit "Fitted Values"

//Figure 7.3
twoway scatter stanres lcavol, name(g1) nodraw
twoway scatter stanres lweight,name(g2) nodraw
twoway scatter stanres age, name(g3) nodraw
twoway scatter stanres lbph, name(g4) nodraw
twoway scatter stanres svi, name(g5) nodraw
twoway scatter stanres lcp, name(g6) nodraw
twoway scatter stanres gleason, name(g7) nodraw
twoway scatter stanres pgg45, name(g8) nodraw
twoway scatter stanres zefit, name(g9) nodraw
graph combine g1 g2 g3 g4 g5 g6 g7 g8 g9, xsize(15) ysize(15) rows(3)
graph export graphics/f7p3.eps, replace
graph drop g1 g2 g3 g4 g5 g6 g7 g8 g9


//Figure 7.4
twoway scatter lpsa zefit ///
|| lfit lpsa zefit, legend(off) ytitle("lpsa") xtitle("Fitted")
graph export graphics/f7p4.eps, replace

//Figure 7.5
plot_lm, smoother("lowess_ties_optim")
graph export graphics/f7p5.eps, replace

//Figure 7.6
local alpha = 2/3
mmp, mean(xb) smoother(lowess) linear predictors smooptions("bwidth(`alpha')") 
graph export graphics/f7p6.eps, replace

//regression output
regress

//Figure 7.7
set graphics off
gen labelcase = "45" if _n == 45
avplot lcavol , rlopt(lcolor(red)) note("") name(a) xsize(4)
avplot lweight , mlabel(labelcase) rlopt(lcolor(red)) note("") name(b) xsize(4)
avplot age , rlopt(lcolor(red)) note("") name(c) xsize(4)
avplot lbph , rlopt(lcolor(red)) note("") name(d) xsize(4)
avplot svi , rlopt(lcolor(red)) note("") name(e) xsize(4)
avplot lcp , rlopt(lcolor(red)) note("") name(f) xsize(4)
avplot gleason , rlopt(lcolor(red)) note("") name(g) xsize(4)
avplot pgg45 , rlopt(lcolor(red)) note("") name(h) xsize(4)
set graphics on
graph combine a b c d e f g h, rows(2) xsize(16) ysize(10)
graph drop a b c d e f g h
graph export graphics/f7p7.eps,replace

//vif output
vif

gen case = _n
vselect lpsa lcavol lweight age lbph svi lcp gleason pgg45, best
return list
matrix list r(info)
forvalues i = 1/8 {
local best`i' "`r(best`i')'"
local best`i' = subinstr("`best`i''","lpsa","",.)
local best`i' = subinstr("`best`i''","lcavol","lcv",.)
local best`i' = subinstr("`best`i''","lweight","lw",.)
local best`i' = subinstr("`best`i''","age","a",.)
local best`i' = subinstr("`best`i''","lbph","lb",.)
local best`i' = subinstr("`best`i''","svi","s",.)
local best`i' = subinstr("`best`i''","gleason","g",.)
local best`i' = subinstr("`best`i''","pgg45","p",.)
local best`i' = subinstr("`best`i''","svi","s",.)
}
matrix A = r(info)
svmat A, names(col)

gen best = ""
forvalues i = 1/8 {
replace best = "`best`i''" if _n == `i'
}

twoway scatter R2ADJ case if case <= 8, mlabel(best) mlabposition(9) ///
xlabel(1(1)8) xtitle("Subset Size") ytitle("Adjusted R-Squared") name(g1) ///
text(.57 4 "lcv: lcavol" "lw: lweight" "a: age" "lb: lbph" "s: svi" ///
"lcp: lcp" "g: gleason" "p: pgg45", box size(medium)) nodraw
twoway scatter R2ADJ case if 4 <= case & case <= 8 , mlabel(best) ///
 mlabsize(small) mlabposition(12) xlabel(4(1)8) xtitle("Subset Size") ///
ytitle("Adjusted R-Squared") name(g2) nodraw text(.64 7 "lcv: lcavol" ///
"lw: lweight" "a: age" "lb: lbph" "s: svi" "lcp: lcp" "g: gleason" ///
"p: pgg45", box size(medium))

graph combine g1 g2, xsize(10) rows(1)
graph export graphics/f7p8.eps, replace

//regression output
reg lpsa lcavol lweight
reg lpsa lcavol lweight svi lbph
reg lpsa lcavol lweight svi lbph pgg45 lcp age

insheet using data/prostateTest.txt, clear names
reg lpsa lcavol lweight
reg lpsa lcavol lweight svi lbph
reg lpsa lcavol lweight svi lbph pgg45 lcp age

insheet using data/prostateTraining.txt, clear names

drop if _n == 45
gen case = _n
vselect lpsa lcavol lweight age lbph svi lcp gleason pgg45, best
return list
matrix list r(info)
forvalues i = 1/8 {
local best`i' "`r(best`i')'"
local best`i' = subinstr("`best`i''","lpsa","",.)
local best`i' = subinstr("`best`i''","lcavol","lcv",.)
local best`i' = subinstr("`best`i''","lweight","lw",.)
local best`i' = subinstr("`best`i''","age","a",.)
local best`i' = subinstr("`best`i''","lbph","lb",.)
local best`i' = subinstr("`best`i''","svi","s",.)
local best`i' = subinstr("`best`i''","gleason","g",.)
local best`i' = subinstr("`best`i''","pgg45","p",.)
local best`i' = subinstr("`best`i''","svi","s",.)
}
matrix A = r(info)
svmat A, names(col)

gen best = ""
forvalues i = 1/8 {
replace best = "`best`i''" if _n == `i'
}

twoway scatter R2ADJ case if case <= 8, mlabel(best) mlabposition(9) ///
xlabel(1(1)8) xtitle("Subset Size") ytitle("Adjusted R-Squared") name(g3) ///
text(.57 4 "lcv: lcavol" "lw: lweight" "a: age" "lb: lbph" "s: svi" ///
"lcp: lcp" "g: gleason" "p: pgg45", box size(medium)) nodraw
graph combine g1 g3, xsize(10) rows(1) title("With Case 45                                              Without Case 45", span)
graph export graphics/f7p9.eps, replace


insheet using data/prostateAlldata.txt, names clear

//Figure 7.10
twoway scatter lpsa lweight if train == "F", msymbol("th") mcolor(black) ///
|| lfit lpsa lweight if train == "F",lcolor(black) ///
|| scatter lpsa lweight if train == "T", mcolor(red) msymbol(plus) ///
|| lfit lpsa lweight if train == "T", lcolor(red) lpattern(dash) ///
xtitle(lweight) ytitle(lpsa) legend(title("Data Set") order(3 1) ///
label(3 "Training") label(1 "Test") cols(1) ring(0) position(4))
graph export graphics/f7p10.eps, replace

qui reg lpsa lcavol lweight age lbph svi lcp gleason pgg45 if train == "F"
sort train case
by train: gen order = _n

gen labcase = "9" if order == 9 & train == "F"

//Figure 7.11
avplot lweight, rlopt(lcolor(red)) mlabel(labcase) mlabpos(9)
graph export graphics/f7p11.eps, replace
