clear all
version 10.0
set scheme ssccl
set more off
insheet using data/profsalary.txt
//Figure 5.1
twoway scatter salary experience , xtitle("Years of Experience") xlabel(0(5)35)
graph export graphics/f5p1.eps, replace

reg salary experience
predict stanres1, rstandard

//Figure 5.2 
twoway scatter stanres1 experience, xtitle("Years of Experience") ///
ytitle("Standardized Residuals") xlabel(0(5)35)
graph export graphics/f5p2.eps, replace

//Figure 5.3
gen exp2 = experience^2
reg salary experience exp2
twoway scatter salary experience ///
|| function y= _b[_cons] + _b[experience]*x + _b[exp2]*(x^2), ///
range(0 35) ytitle("Salary") xtitle("Years of Experience") ///
legend(off) xlabel(0(5)35)
graph export graphics/f5p3.eps,replace

//Figure 5.4
predict stanres2, rstandard
twoway scatter stanres2 experience, xtitle("Years of Experience") ///
ytitle("Standardized Residuals") xlabel(0(5)35)
graph export graphics/f5p4.eps, replace

predict leverage2, leverage
local lvgcutoff = 6/_N
//Figure 5.5 
twoway scatter leverage2 experience, yline(`lvgcutoff', lpattern("dash")) /// 
xtitle("Years of Experience") ytitle("Leverage") xlabel(0(5)35) ///
ylabel(0.01(.01).07) legend(off) xlabel(0(5)35)
graph export graphics/f5p5.eps, replace

//Regression output 
reg 

preserve
clear
set obs 1
gen experience = 10
gen exp2 = 100
predict pred,xb
predict predse,stdf
gen lwr = pred - predse*invttail(e(N)-3,(1-.95)/2)
gen upr = pred + predse*invttail(e(N)-3,(1-.95)/2)
l pred lwr upr
restore

//Figure 5.6
plot_lm, smoother("lowess_ties_optim")
graph export graphics/f5p6.eps, replace

clear
insheet using data/nyc.csv, names

//regression output 
reg cost food decor service east
//regression output 
reg cost food decor east


clear
insheet using data/travel.txt,names

//figure 5.7 
gen segA = "A" if c == 0
gen segC = "C" if c == 1
twoway scatter amount age, mlabel(segA) mlabcol(black) msymbol(i) ///
 mlabposition(0) || scatter amount age, mlabel(segC) mlabcolor("red") ///
msymbol(i) mlabposition(0) ytitle("Amount Spent") xtitle("Age") ///
xlabel(30(10)60) ylabel(400(200)1400) legend(off)
graph export graphics/f5p7.eps, replace

gen agec = age*c

//regression output 
reg amount age c agec
//regression output 
reg amount age
//regression output 
nestreg: regress amount age (c agec)

clear
insheet using data/nyc.csv, names
gen foodeast = food*east
gen decoreast= decor*east 
gen serviceeast = service*east
//regression output 
reg cost food decor service east foodeast decoreast serviceeast
//regression output 
reg cost food decor east
nestreg: reg cost (food decor east) (service foodeast decoreast serviceeast)

