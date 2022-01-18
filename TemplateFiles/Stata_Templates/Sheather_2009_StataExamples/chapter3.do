version 10.0
set scheme ssccl 
clear all
set more off

infile case x1 x2 x3 x4 y1 y2 y3 y4 using   data/anscombe.txt in 2/12

set graphics off
forvalues i = 1/4 {
twoway scatter y`i' x`i'  ///
|| lfit y`i' x`i', legend(off) xtitle("x`i'") ytitle("y`i'") ///
title("Data Set `i'") xlabel(5(5)20) ylabel(4(2)14) range(0 20) name("g`i'")
}
set graphics on
//Figure 3.1
graph combine g1 g2 g3 g4, rows(2)
graph export graphics/f3p1.eps, replace
//Regression output 
forvalues i = 1/4 {
reg y`i' x`i'
}

graph drop g1 g2 g3 g4
// Figure 3.2
set graphics off
forvalues i = 1/4 {
qui reg y`i' x`i'
predict  y`i'resid, resid
twoway scatter y`i'resid x`i', ytitle("Residuals") xtitle("x`i'") ///
xlabel(5(5)20) ylabel(-2(1)2) title("Data Set `i'") name("g`i'")
}

set graphics on
graph combine g1 g2 g3 g4,rows(2)
graph export graphics/f3p2.eps, replace
graph drop g1 g2 g3 g4

set graphics off
twoway scatter y2 x2 || lfit y2 x2,legend(off) xtitle("x2") ///
ytitle("y2") xlabel(4(2)14) ylabel(3(1)10) range(4 14) name("g1") xsize(2.5)
twoway scatter y2resid x2,legend(off) xtitle("x2") ytitle("Residuals") ///
xlabel(4(2)14) ylabel(-2(1)2) xsize(2.5)  name("g2") 
// Figure 3.3
set graphics on
graph combine g1 g2, rows(1) title("Data Set 2")
graph export graphics/f3p3.eps, replace
graph drop g1 g2

clear
insheet using data/huber.txt, names

set graphics off
twoway scatter ybad x || lfit ybad x, legend(off) ytitle("YBad") ///
xtitle("x") ylabel(-10(5)0) xlabel(-4(2)10) name("g1") xsize(2.5)
twoway scatter ygood x || lfit ygood x, legend(off) ytitle("YGood") ///
xtitle("x") ylabel(-10(5)0) xlabel(-4(2)10) name("g2") ysize(2.5)
set graphics on
graph combine g1 g2, rows(1) 
graph export graphics/f3p7.eps, replace
graph drop g1 g2

//Regression Output 
reg ybad x
predict badres, resid
l ybad x badres
reg ygood x
predict goodres, resid
l ygood x goodres

//Leverage values in Table 3.3 
predict goodlevg, leverage
qui reg ybad x
predict badlevg, leverage
l x goodlevg badlevg

//regression output 
gen x2 = x^2
reg ybad x x2
//figure 3.8 
twoway scatter ybad x ///
|| function y=_b[_cons] + _b[x]*x + _b[x2]*(x^2), range(-4 10) ///
ytitle("YBad") xtitle("x") xlabel(-4(2)10) ylabel(-3(1)3) legend(off)
graph export graphics/f3p8.eps, replace

clear
insheet using data/bonds.txt, names

set graphics on
//Figure 3.9 
twoway scatter bidprice couponrate ///
|| lfit bidprice couponrate, legend(off) xlabel(2(2)14) ///
ylabel(85(5)120) xtitle("Coupon Rate(%)") ytitle("Bid Price($)") 
graph export graphics/f3p9.eps, replace
//Regression ouput , confidence intervals
reg bidprice couponrate
predict bidresid, resid
predict bidresidsr, rstandard
predict bidlevg,leverage
//Table 3.4 
l couponrate bidprice bidlevg bidresid bidresidsr
gen out = string(_n) if  bidresidsr < -2 | bidresidsr > 1.8
//Figure 3.10 
twoway scatter bidresidsr couponrate, mlabel(out) yline(-2,lpattern(dash)) ///
yline(2,lpattern(dash)) xlabel(2(2)14) ylabel(-2(1)3) ///
xtitle("Coupon Rate (%)") ytitle("Standardized Residuals") legend(off) 
graph export graphics/f3p10.eps, replace
// Figure 3.11 
twoway scatter bidprice couponrate if !inlist(out,"4","13","35") ///
|| lfit bidprice couponrate if !inlist(out,"4","13","35") , ///
legend(off) xlabel(2(2)14) ylabel(85(5)120) xtitle("Coupon Rate (%)") ///
ytitle("Bid Price ($)") title("Regular Bonds") range(5.5 13.7)
graph export graphics/f3p11.eps, replace
//Regression output 
reg bidprice couponrate if !inlist(out,"4","13","35")
drop bidresidsr
predict bidresidsr if e(sample), rstandard

// Figure 3.12 
twoway scatter bidresidsr couponrate, yline(-2,lpattern(dash)) ///
yline(2,lpattern(dash)) xlabel(2(2)14) ylabel(-3(1)2) ///
xtitle("Coupon Rate (%)") ytitle("Standardized Residuals") ///
 legend(off) title("Regular Bonds",span)
graph export graphics/f3p12.eps, replace

qui reg bidprice couponrate 
predict bidcooks, cooks
local cutoff = 4/(35-2)
replace out = "" if out == "34"
//Figure 3.13 
twoway scatter bidcooks couponrate,mlabel(out) ///
yline(`cutoff',lpattern(dash)) xlabel(2(2)14) ///
ylabel(0(.2)1) xtitle("Coupon Rate (%)") ytitle("Cook's Distance") legend(off)
graph export graphics/f3p13.eps, replace
clear
insheet using data/production.txt, names
reg runtime runsize
local a = 2/3
//Figure 3.14 
plot_lm, smoother("lowess_ties_optim") f(`a')
graph export graphics/f3p14.eps, replace

clear
insheet using data/cleaning.txt,names
//Figure 3.15 
twoway scatter room crew ///
|| lfit room crew, xtitle("Number of Crews") ///
ytitle("Number of Rooms Cleaned") xlabel(2(2)16) ///
 ylabel(10(10)80) legend(off)
graph export graphics/f3p15.eps, replace

//Regression output 
reg room crew
rlcipi , pred arg(4 16) lev(95) len(7) prec(4)

predict roomsr,rstandard
//Figure 3.16 
twoway scatter roomsr crews, xlabel(2(2)16) ylabel(-2(1)2) ///
xtitle("Number of Crews") ytitle("Standardized Residuals")
graph export graphics/f3p16.eps, replace

gen saroomsr = sqrt(abs(roomsr))
//Figure 3.17 
twoway scatter saroomsr crew ///
|| lfit saroomsr crew, xtitle("Number of Crews") ///
ytitle("Square Root(|Standardized Residuals|)") ///
xlabel(2(2)16) ylabel(.2(.2)1.6) legend(off)
graph export graphics/f3p17.eps,replace

//Figure 3.18 
local a = 2/3
plot_lm, smoother("lowess_ties_optim") f(`a')
graph export graphics/f3p18.eps, replace

preserve
collapse (sd) rooms, by(crew)
//Figure 3.19 
twoway scatter rooms crews ///
|| lfit rooms crews, xlabel(2(2)16) ylabel(4(2)12) ///
ytitle("Standard Deviation(Rooms Cleaned)") ///
xtitle("Number of Crews") legend(off) 
graph export graphics/f3p19.eps, replace
restore

//Regression output 
gen sqrtcrews = sqrt(crews)
gen sqrtrooms = sqrt(rooms)
reg sqrtrooms sqrtcrews
rlcipi, pred arg(2 4) lev(95) len(7) prec(4)


set graphics off
twoway scatter sqrtrooms sqrtcrews ///
|| lfit sqrtrooms sqrtcrews, ytitle("Square Root(Number of Rooms Cleaned)") ///
xtitle("Square Root(Number of Crews)") xlabel(1.5(.5)4.0) ylabel(3(1)9) ///
legend(off)  name(g1) xsize(2.5)
predict srrooms, rstandard
twoway scatter srrooms sqrtcrew, xlabel(1.5(.5)4.0) ylabel(-2(1)2) ///
xtitle("Square Root(Number of Crews)") ytitle("Standardized Residuals") ///
name(g2) xsize(2.5)
set graphics on
graph combine g1 g2, 
//Figure 3.20 
graph export graphics/f3p20.eps,replace
graph drop g1 g2

local a = 2/3
plot_lm, smoother("lowess_ties_optim") f(`a')
graph export graphics/f3p21.eps, replace

clear
insheet using data/confood1.txt,names
//Figure 3.22 
twoway scatter sales price ///
|| lfit sales price , xtitle("Price") ytitle("Sales") xlabel(.6(.05).85) ///
ylabel(0(1000)7000) legend(off)
graph export graphics/f3p22.eps, replace

gen lnprice = ln(price)
gen lnsales = ln(sales)
//Figure 3.23 
twoway scatter lnsales lnprice ///
|| lfit lnsales lnprice, legend(off) ytitle("log(Sales)") ///
xtitle("log(Price)") ylabel(5(1)8) xlabel(-.5(.1)-.2)
graph export graphics/f3p23.eps, replace

//regression output 
reg lnsales lnprice
predict salessr, rstandard
//Figure 3.24 
twoway scatter salessr lnprice, ytitle("Standardized Residuals") ///
xtitle("log(Price)") xlabel(-.5(.1)-.2) ylabel(-2(1)3)
graph export graphics/f3p24.eps,replace

clear
insheet using data/responsetransformation.txt, names 
twoway scatter y x, ytitle("y") xtitle("x") ylabel(0(20)80) xlabel(1(1)4)
// Figure 3.26 
graph export graphics/f3p25.eps, replace

reg y x
predict srf, rstandard
gen sqsrf = sqrt(abs(srf))
set graphics off
// Figure 3.26 
twoway scatter srf x, xtitle("x") ytitle("Standardized Residuals") ///
xlabel(1(1)4) ylabel(-1(1)5) name(g1) xsize(2.5)
twoway scatter sqsrf x, xtitle("x") ///
ytitle("Square Root(Standardized Residuals)") xlabel(1(1)4) ylabel(0(1)2) ///
name(g2) xsize(2.5)
set graphics on
graph combine g1 g2, rows(1) 
graph drop g1 g2
graph export graphics/f3p26.eps, replace

set graphics off
kdens y,bw(sjpi) ysize(3) xsize(5.5) name(g1)
graph box y, ysize(3) xsize(5.5) name(g2)
qnorm y, ysize(3) xsize(5.5) name(g3)
kdens x,bw(sjpi) ysize(3) xsize(5.5) name(g4)
graph box x,  ysize(3) xsize(5.5) name(g5)
qnorm x, ysize(3) xsize(5.5) name(g6)
set graphics on
graph combine g1 g2 g3 g4 g5 g6, xsize(11) ysize(9) rows(3)
// Figure 3.27 
graph export graphics/f3p27.eps, replace
graph drop g1 g2 g3 g4 g5 g6 

// Figure 3.28 
irp y x, try(0 1) opt
graph export graphics/f3p28.eps, replace
// Figure 3.29 
irp y x, try(-1 -0.5  -0.33 -0.25 0 0.25 0.33 0.5 1) nodraw
matrix list r(tranres)
matrix b = r(tranres)
matrix h = b[1..9,1]
matrix v = b[1..9,2]
draw_matrix, x(h) y(v) line xtitle("lambda") ytitle("RSS(lambda)")
graph export graphics/f3p29.eps, replace

//Figure 3.30 
plot_bc y x, plotpts(100) window(.28 .388) ylabel(-695(5)-665) ///
name(g1) nodraw xsize(2.5)
plot_bc y x, plotpts(100) window(.325 .34) ylabel(-664(.5)-663) ///
name(g2) nodraw xsize(2.5)
graph combine g1 g2 
graph export graphics/f3p30.eps, replace
graph drop g1 g2
//regression output 
gen yt = y^(1/3)
reg yt x
predict ytresid, resid
tabstat ytresid, stat(min p25 median p75 max)
label variable yt "y ^ 1/3"
//Figure 3.31 p 65
kdens yt,bw(sjpi) name(g1) nodraw
graph box yt,  name(g2) nodraw
qnorm yt,  name(g3) nodraw
twoway scatter yt x ///
|| lfit yt x, legend(off) xtitle("x") ytitle("y ^ 1/3") name(g4) nodraw
graph combine g1 g2 g3 g4, xsize(10) ysize(10) rows(2)
graph export graphics/f3p31.eps, replace
graph drop g1 g2 g3 g4
clear
insheet using data/salarygov.txt,names delimiter(" ")
reg maxsalary score
predict stanres1, rstand
gen absrtsr1 = sqrt(abs(stanres1))
// Figure 3.32 
twoway scatter maxsalary score ///
|| lfit maxsalary score, legend(off) nodraw xtitle("Score") ///
ytitle("MaxSalary") name("g1")
twoway scatter stanres1 score, legend(off) nodraw xtitle("Score") ///
ytitle("Standardized Residuals") name("g2")
twoway scatter absrtsr1 score ///
 || lfit absrtsr1 score, legend(off) nodraw xtitle("Score") ///
ytitle("Square Root(|Standardized Residuals|)") name("g3")
graph combine g1 g2 g3, xsize(10) ysize(10) rows(2)
graph export graphics/f3p32.eps, replace
graph drop g1 g2 g3
// Figure 3.33 
set graphics off
kdens maxsalary,bw(sjpi) ysize(3) xsize(5.5) name(g1) xtitle("MaxSalary") ///
xlabel(2000(2000)8000)
graph box maxsalary, ysize(3) xsize(5.5) name(g2) ytitle("MaxSalary") ///
ylabel(2000 6000)
qnorm maxsalary, ysize(3) xsize(5.5) name(g3) ytitle("MaxSalary") ///
ylabel(2000 6000)
kdens score,bw(sjpi) ysize(3) xsize(5.5) name(g4) xtitle("Score") ///
xlabel(0(200)1000)
graph box score,  ysize(3) xsize(5.5) name(g5) ytitle("Score") ///
ylabel(200(400)1000)
qnorm score, ysize(3) xsize(5.5) name(g6) ytitle("Score") ///
ylabel(200(400)1000)
set graphics on
graph combine g1 g2 g3 g4 g5 g6, xsize(11) ysize(9) rows(3)
graph export graphics/f3p33.eps, replace
graph drop g1 g2 g3 g4 g5 g6

//output 
mboxcox maxsalary score
//Wald test of power = 1
test maxsalary = 1
di sqrt(r(chi2))
test score = 1
di sqrt(r(chi2))

gen sqrtscore = sqrt(score)
gen lnmaxsalary = ln(maxsalary)
// Figure 3.34 
twoway scatter lnmaxsalary sqrtscore ///
 || lfit lnmaxsalary sqrtscore, xlabel(10(5)30) ylabel(7.5(.5)9) ///
xtitle("Sqrt(Score)") ytitle("log(MaxSalary)")  legend(off)
graph export graphics/f3p34.eps, replace

// Figure 3.35 
kdens lnmaxsalary,bw(sjpi) ysize(3) xsize(5.5) name(g1) ///
xtitle("log(MaxSalary)") nodraw
graph box lnmaxsalary, ysize(3) xsize(5.5) name(g2) ///
ytitle("log(MaxSalary)") nodraw
qnorm lnmaxsalary, ysize(3) xsize(5.5) name(g3) ///
ytitle("log(MaxSalary)") nodraw
kdens sqrtscore,bw(sjpi) ysize(3) xsize(5.5) name(g4) ///
xtitle("Sqrt(Score)") nodraw
graph box sqrtscore,  ysize(3) xsize(5.5) name(g5) ///
ytitle("Sqrt(Score)") nodraw
qnorm sqrtscore, ysize(3) xsize(5.5) name(g6) ///
ytitle("Sqrt(Score)") nodraw
graph combine g1 g2 g3 g4 g5 g6, xsize(11) ysize(9) rows(3)
graph export graphics/f3p35.eps, replace
graph drop g1 g2 g3 g4 g5 g6

reg lnmaxsalary sqrtscore
predict stanres2, rstandard
gen absrtsr2 = sqrt(abs(stanres2))
// Figure 3.36 
twoway scatter stanres2 sqrtscore, xtitle("Sqrt(Score)") xsize(2.5) ///
ytitle("Standardized Residuals") name(g1) nodraw
twoway scatter absrtsr2 sqrtscore || lfit absrtsr2 sqrtscore, xsize(2.5) ///
lpattern(dash) xtitle("Sqrt(Score)") ///
ytitle("Square Root(|Standardized Residuals|)") name(g2) legend(off) nodraw
graph combine g1 g2, rows(1)
graph export graphics/f3p36.eps, replace
graph drop g1 g2

//output 
mboxcox score
test score = 1
di sqrt(r(chi2))

//Figure 3.37 
irp maxsalary sqrtscore, try(0 1) opt
graph export graphics/f3p37.eps, replace

//Figure 3.38 
gen fourthmaxsalary = maxsalary^(-.25)
kdens fourthmaxsalary,bw(sjpi)  name("g1") xtitle("maxsalary^(-.25)") nodraw
graph box fourthmaxsalary,  name("g2") ytitle("maxsalary^(-.25)") nodraw
qnorm fourthmaxsalary,  name("g3") ytitle("maxsalary^(-.25)") nodraw
graph combine g1 g2 g3, xsize(10) ysize(10) rows(2)
graph export graphics/f3p39.eps, replace
graph drop g1 g2 g3

qui reg fourthmaxsalary sqrtscore
predict stanres3, rstandard
gen absrtsr3 = sqrt(abs(stanres3))
twoway scatter fourthmaxsalary sqrtscore ///
|| lfit fourthmaxsalary sqrtscore, lpattern(dash) legend(off) ///
nodraw xtitle("Sqrt(Score)") ytitle("MaxSalary^(-.25)") name("g1")
twoway scatter stanres3  sqrtscore, legend(off) nodraw ///
xtitle("Sqrt(Score)") ytitle("Standardized Residuals") name("g2")
twoway scatter absrtsr3 sqrtscore ///
|| lfit absrtsr3 sqrtscore, lpattern(dash) ///
legend(off) nodraw xtitle("Sqrt(Score)") ///
ytitle("Square Root(|Standardized Residuals|)") name("g3")
graph combine g1 g2 g3, xsize(10) ysize(10) rows(2)
graph export graphics/f3p40.eps, replace
graph drop g1 g2 g3
