version 10.0
clear all
set more off
set scheme ssccl

insheet using data/bimodal.txt, clear
l
local n = _N
local h = .25
set obs 601
gen xx = -300
replace xx = xx + _n - 1
replace xx = xx/100
gen ysum = 0
local graphmac "line y1 xx"
local i = 1 
gen y`i' = (1/(`h'*sqrt(2*_pi)))*exp(-0.5*((xx-x[`i'])/`h')^2)
replace ysum = y`i'/`n' + ysum
replace y`i' = y`i'/`n'
forvalues i = 2/`n' {
gen y`i' = (1/(`h'*sqrt(2*_pi)))*exp(-0.5*((xx-x[`i'])/`h')^2)
replace ysum = y`i'/`n' + ysum
replace y`i' = y`i'/`n'
local graphmac "`graphmac' || line y`i' xx"
}

gen truedensity = 0.5*(3/(sqrt(2*_pi)))*exp(-0.5*((xx+1)/(1/3))^2) + ///
0.5*(3/(sqrt(2*_pi)))*exp(-0.5*((xx-1)/(1/3))^2)
gen top = 1/(`n'*`h'*sqrt(2*_pi))
gen zero = 0
twoway `graphmac' ///
|| line ysum xx ///
|| line truedensity xx, lpattern(dash) ///
|| pcspike top x zero x, xlabel(-3(1)3) ylabel(0(0.05)0.65) ///
ytitle("Estimated & True Densities") legend(off) xtitle("x")
graph export graphics/fAPPp1.eps, replace

insheet using data/bimodal.txt, clear
local n = _N
local h = .6
set obs 601
gen xx = -300
replace xx = xx + _n - 1
replace xx = xx/100

gen ysum = 0
local graphmac "line y1 xx"
local i = 1 
gen y`i' = (1/(`h'*sqrt(2*_pi)))*exp(-0.5*((xx-x[`i'])/`h')^2)
replace ysum = y`i'/`n' + ysum
replace y`i' = y`i'/`n'
forvalues i = 2/`n' {
gen y`i' = (1/(`h'*sqrt(2*_pi)))*exp(-0.5*((xx-x[`i'])/`h')^2)
replace ysum = y`i'/`n' + ysum
replace y`i' = y`i'/`n'
local graphmac "`graphmac' || line y`i' xx"
}

gen truedensity = 0.5*(3/(sqrt(2*_pi)))*exp(-0.5*((xx+1)/(1/3))^2) + ///
0.5*(3/(sqrt(2*_pi)))*exp(-0.5*((xx-1)/(1/3))^2)
gen top = 1/(`n'*`h'*sqrt(2*_pi))
gen zero = 0
twoway `graphmac' ///
|| line ysum xx ///
|| line truedensity xx, lpattern(dash) ///
|| pcspike top x zero x, xlabel(-3(1)3) ylabel(0(0.05)0.65) ///
ytitle("Estimated & True Densities") xtitle("x") legend(off)
graph export graphics/fAPPp2.eps, replace

insheet using data/curve.txt,clear
local n = _N
local h = 0.026
gen m = 15 + 15*x*cos(4*_pi*x)
gen x1 = .5
gen yy = (1/(`h'*sqrt(2*_pi)))*exp(-0.5*((x1-x)/`h')^2)
twoway scatter y x, msymbol(plus) ///
|| line yy x,lpattern(dash) ///
|| line m x, lpattern(dash) ///
|| lpoly y x,bwidth(`h') degree(1) ytitle("Estimated & True Curves") ///
xtitle("x") legend(off)
graph export graphics/fAPPp3.eps, replace


local hlo = `h'/5 
local hhi = `h'*5
line m x ,lpattern(dash) ///
|| scatter y x, msymbol(plus) ///
|| lpoly y x,bwidth(`hlo') degree(1) ysize(1.5) name(a) nodraw legend(off) ///
ytitle("Estimated & True Curves") xtitle("x")
line m x ,lpattern(dash) ///
|| scatter y x, msymbol(plus) ///
|| lpoly y x,bwidth(`hhi') degree(1) ysize(1.5) name(b) nodraw legend(off) ///
ytitle("Estimated & True Curves") xtitle("x") 

graph combine a b, rows(2)
graph export graphics/fAPPp4.eps, replace
graph drop a b


local a = 1/3
lowess y x, bwidth(`a') addplot(line m x,lpattern(dash)) xtitle(x) ///
ytitle("Estimated & True Curves") legend(off)
graph export graphics/fAPPp5.eps, replace

local a = 2/3
lowess y x, bwidth(`a') nodraw addplot(line m x,lpattern(dash)) ///
xtitle(x) ytitle("Estimated & True Curves") name(a) ysize(2.5) legend(off)
local a = .05
lowess y x, bwidth(`a') nodraw addplot(line m x,lpattern(dash)) ///
xtitle(x) ytitle("Estimated & True Curves") name(b) ysize(2.5) legend(off)
graph combine a b, rows(2) 
graph export graphics/fAPPp6.eps, replace
graph drop a b

sum x
local max = r(max)
local min = r(min)
forvalues i = 1/6 {
gen knot`i' = `min' + `i'*.15
}
assert knot5 < `max' - .15 & knot6 > `max' - .15

drop knot6
forvalues i = 1/5 {
gen spline`i' = x - knot`i' if x > knot`i'
replace spline`i' = 0 if x <= knot`i'
}

xtmixed y x || _all: spline*,nocons nolog

predict fit2, fitted
line m x ,lpattern(dash) ///
|| scatter y x, msymbol(plus) ///
|| line fit2 x, legend(off) ytitle("Estimated & True Curves") xtitle("x")
graph export graphics/fAPPp8.wmf, replace




