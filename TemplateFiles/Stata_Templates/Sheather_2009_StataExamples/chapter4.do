clear all
version 10.0
set scheme ssccl
set more off

insheet using data/cleaningwtd.txt,names

//output 
reg rooms crew [aweight=1/(stddev^2)]
predict wm1resid,resid
replace wm1resid = sqrt(1/stddev^2)*wm1resid
tabstat wm1resid, stat(min p25 median p75 max)

//Stata doesn't do prediction intervals for weighted regression
di 4*_b[crew] + _b[_cons]
di 16*_b[crew] + _b[_cons]

gen ynew = rooms/stddev 
gen x1new = 1/stddev
gen x2new = crews/stddev
reg ynew x1new x2new, nocons

preserve
clear
set obs 2 
gen x1new = 1/4.97 if _n == 1
replace x1new = 1/12 if _n == 2
gen x2new = 4*x1new if _n == 1
replace x2new = 16*x1new if _n == 2
predict fitted, xb
predict forese, stdf
gen lwr = fitted - forese*invttail(e(N)-2,(1-.95)/2)  
gen upr = fitted + forese*invttail(e(N)-2,(1-.95)/2)
l fitted lwr upr
restore 
