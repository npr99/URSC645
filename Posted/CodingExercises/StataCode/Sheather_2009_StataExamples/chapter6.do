version 10.0 
set scheme ssccl
set more off
clear all

insheet using data/nyc.csv, names 

//figure 6.1
graph matrix food decor service, ///
diagonal("Food" "Decor" "Service",size("large")) xlabel(16(2)24, axis(1)) ///
 xlabel(14(2)24, axis(3))  xlabel(10(5)25, axis(2)) ylabel(14(2)24,axis(3)) ///
ylabel(16(2)24,axis(1)) ylabel(10(5)25,axis(2)) 
graph export graphics/f6p1.eps, replace

qui reg cost food decor service east
predict stanres1, rstandard
label variable stanres1 "Standardized Residuals"
twoway scatter stanres1 food, name("g1") nodraw
twoway scatter stanres1 decor,name("g2") nodraw
twoway scatter stanres1 service, name("g3") nodraw
twoway scatter stanres1 east, name("g4") nodraw
//Figure 6.2 
graph combine g1 g2 g3 g4, rows(2) xsize(10) ysize(10)
graph export graphics/f6p2.eps, replace
graph drop g1 g2 g3 g4


predict fitted, xb
label variable fitted "Fitted Values"
//Figure 6.3
twoway scatter cost fitted ///
|| lfit cost fitted, xlabel(20(10)60) ytitle(Cost) ylabel(20(10)60) legend(off)
graph export graphics/f6p3.eps,replace 

insheet using data/caution.txt, names clear delimit(" ") 
//Figure 6.4
graph matrix y x1 x2, diagonal("y" "x1" "x2",size("large")) ///
xlabel(0(.2)1, axis(1)) xlabel(-1(.5)1, axis(2)) xlabel(-1(.5)1, axis(3)) ///
ylabel(0(.2)1, axis(1)) ylabel(-1(.5)1, axis(2)) ylabel(-1(.5)1, axis(3))
graph export graphics/f6p4.eps, replace

qui reg y x1 x2
predict stanres1, rstandard
predict fitted, xb
label variable stanres1 "Standardized Residuals"
label variable fitted "Fitted Values"
//Figure 6.5
twoway scatter stanres1 x1, name("g1") nodraw
twoway scatter stanres1 x2, name("g2") nodraw
twoway scatter stanres1 fitted, name("g3") nodraw
graph combine g1 g2 g3, rows(2) xsize(10) ysize(10)
graph export graphics/f6p5.eps, replace
graph drop g1 g2 g3

//Figure 6.6 
twoway scatter y fitted ///
|| lfit y fitted, xlabel(0.05(.05).35) ytitle("y") xtitle("Fitted Values") ///
legend(off)
graph export graphics/f6p6.eps, replace

//Figure 6.7
insheet using data/nonlinearx.txt, clear
twoway scatter y x1, name(g1) nodraw
twoway scatter y x2, name(g2) nodraw
twoway scatter x2 x1, name(g3) nodraw
graph combine g1 g2 g3, rows(2) 
graph export graphics/f6p7.eps, replace
graph drop g1 g2 g3

qui reg y x1 x2
predict stanres1, rstandard
predict fitted, xb
label variable stanres1 "Standardized Residuals"
label variable fitted "Fitted Values"
//Figure 6.8
twoway scatter stanres1 x1, name("g1") nodraw
twoway scatter stanres1 x2, name("g2") nodraw
twoway scatter stanres1 fitted, name("g3") nodraw
graph combine g1 g2 g3, rows(2) xsize(10) ysize(10)
graph export graphics/f6p8.eps, replace
graph drop g1 g2 g3


clear
insheet using data/nyc.csv,names
//Figure 6.9 
twoway scatter cost food ///
|| lfit cost food, legend(off) xtitle("Food") ytitle("Cost") name("g1") nodraw
twoway scatter cost decor ///
|| lfit cost decor, legend(off) xtitle("Decor") ytitle("Cost") name("g2") nodraw
twoway scatter cost service ///
|| lfit cost service, legend(off) xtitle("Service") ytitle("Cost") name("g3") nodraw
twoway scatter cost east ///
|| lfit cost east, legend(off) xtitle("East") ytitle("Cost") name("g4") nodraw
graph combine g1 g2 g3 g4, xsize(10) ysize(10) rows(2)
graph export graphics/f6p9.eps, replace
graph drop g1 g2 g3 g4

qui reg cost food decor service east
gen caselabel = string(_n) if inlist(_n,117,168)
//Figure 6.10 
avplots,mlabel(caselabel) recast(scatter) ytitle(, orientation(vertical) ///
justification(left) margin(right)) caption(, justification(left))
graph export graphics/f6p10.eps, replace


clear
insheet using data/defects.txt, names
//Figure 6.11
graph matrix defect temp dens rate,  ///
diagonal("Defective" "Temperature" "Density" "Rate", size("medlarge")) ///
xlabel(0(20)60, axis(1)) xlabel(1(.5)3,axis(2)) xlabel(20(4)32,axis(3)) ///
xlabel(180(40)260, axis(4)) ylabel(0(20)60, axis(1)) /// 
ylabel(1(.5)3,axis(2)) ylabel(20(4)32,axis(3)) ylabel(180(40)260,axis(4)) 
graph export graphics/f6p11.eps, replace

qui reg defect temperature density rate
predict stanres1, rstandard
predict fitted, xb
label variable stanres1 "Standardized Residuals"
label variable fitted "Fitted Values
//Figure 6.12
twoway scatter stanres1 temperature, xlabel(1(.5)3) name(g1) nodraw
twoway scatter stanres1 density, xlabel(20(2)32) name(g2) nodraw
twoway scatter stanres1 rate , xlabel(180(20)280) name(g3) nodraw
twoway scatter stanres1 fitted, xlabel(-10(10)50) name(g4) nodraw
graph combine g1 g2 g3 g4, rows(2) xsize(10) ysize(10)
graph drop g1 g2 g3 g4
graph export graphics/f6p12.eps, replace

//Figure 6.13
twoway scatter defective fitted ///
 || lfit defective fitted, lpattern(dash) ///
|| qfit defective fitted, legend(off) xlabel(-10(10)50) ///
ylabel(0(10)60) ytitle("Defective") xtitle("Fitted Values")
graph export graphics/f6p13.eps, replace

//Figure 6.14
irp defect temperature density rate, try(0 1) opt
graph export graphics/f6p14.eps, replace

//Figure 6.15
plot_bc defect temperature density rate, level(95) ///
plotpts(100) window(.3 .65) xlabel(.3(.05).65) ylabel(-96(.5)-93)
graph export graphics/f6p15.eps, replace

//Figure 6.16
gen sqrtdefect = sqrt(defect)
label variable sqrtdefect "Sqrt(Defective)"
twoway scatter sqrtdefect temperature, name("g1") ///
nodraw xlabel(1(.5)3) ylabel(2(2)8)
twoway scatter sqrtdefect density, name("g2") ///
nodraw xlabel(20(2)32) ylabel(2(2)8)
twoway scatter sqrtdefect rate, name("g3") ///
nodraw xlabel(180(20)280) ylabel(2(2)8)
graph combine g1 g2 g3, xsize(10) ysize(10) rows(2)
graph export graphics/f6p16.eps, replace
graph drop g1 g2 g3


// Figure 6.17 
qui reg sqrtdefect temp dens rate
predict stanrest, rstandard
drop fitted
predict fitted, xb
label variable fitted "Fitted Values"
twoway scatter stanrest temperature, name("g1") nodraw xlabel(1(.5)3) ///
ylabel(-2(1)2)
twoway scatter stanrest density, name("g2") nodraw xlabel(20(2)32) ///
ylabel(-2(1)2)
twoway scatter stanrest rate, name("g3") nodraw xlabel(180(20)280) ///
ylabel(-2(1)2)
twoway scatter stanrest fitted, name("g4") nodraw xlabel(0(2)8) ///
ylabel(-2(1)2)
graph combine g1 g2 g3 g4, xsize(10) ysize(10) rows(2)
graph export graphics/f6p17.eps, replace
graph drop g1 g2 g3 g4

//Figure 6.18
twoway scatter sqrtdefect fitted ///
|| lfit sqrtdefect fitted, xlabel(0(2)8) ylabel(2(2)8) legend(off) ///
ytitle("Sqrt(Defective)") xtitle("Fitted Values")
graph export graphics/f6p18.eps, replace

//Figure 6.19
plot_lm, smoother("lowess_ties_optim")
graph export graphics/f6p19.eps, replace

//Regression output 
regress

//Figure 6.20
avplots,rlopt(lcolor(red))  recast(scatter) ///
 ytitle(, orientation(vertical) justification(left) margin(right)) ///
caption(, justification(left))
graph export graphics/f6p20.eps, replace

clear
insheet using data/magazines.csv, names

//Figure 6.21
graph matrix adrevenue adpages subrevenue newsrevenue, ///
diagonal("AdRevenue" "AdPages" "SubRevenue" "NewsRevenue",size("medsmall")) ///
xlabel(500 2000 3500,axis(2)) ylabel(500 2000 3500, axis(2)) ///
xlabel(0 100000 250000 ,axis(4)) ylabel(0 100000 250000 ,axis(4)) ///
xlabel(0 1000000, axis(1)) ylabel(0 1000000, axis(1))
graph export graphics/f6p21.eps, replace

// Approach 1 output 
mboxcox adpages subrevenue newsrevenue
test adpages = 1
di sqrt(r(chi2))
test subrevenue = 1
di sqrt(r(chi2))
test newsrevenue = 1
di sqrt(r(chi2))

gen tadpages = ln(adpages)
gen tsubrevenue = ln(subrevenue)
gen tnewsrevenue = ln(newsrevenue)
//Figure 6.22
irp  adrevenue tadpages tsubrevenue tnewsrevenue, opt try(0 1)
graph export graphics/f6p22.eps, replace

// Approach 2 output 
mboxcox adrevenue adpages subrevenue newsrevenue
test adrevenue = 1
di sqrt(r(chi2))
test adpages = 1
di sqrt(r(chi2))
test subrevenue = 1
di sqrt(r(chi2))
test newsrevenue = 1
di sqrt(r(chi2))
gen tadrevenue = ln(adrevenue)
//Figure 6.23
graph matrix tadrevenue tadpages tsubrevenue tnewsrevenue, ///
diagonal("log(AdRevenue)" "log(AdPages)" "log(SubRevenue)" "log(NewRevenue)",size("small")) 
graph export graphics/f6p23.eps, replace

qui reg tadrevenue tadpages tsubrevenue tnewsrevenue
predict fitted, xb
predict stanres2, rstandard
//Figure 6.24
twoway scatter stanres2 tadpages, xtitle("log(AdPages)") ///
ytitle("Standardized Residuals") nodraw name(g1)
twoway scatter stanres2 tsubrevenue, xtitle("log(SubRevenue)") ///
ytitle("Standardized Residuals") nodraw name(g2)
twoway scatter stanres2 tnewsrevenue, xtitle("log(NewsRevenue)") ///
ytitle("Standardized Residuals") nodraw name(g3)
twoway scatter stanres2 fitted, xtitle("Fitted Values") ///
ytitle("Standardized Residuals") nodraw name(g4)
graph combine g1 g2 g3 g4, xsize(10) ysize(10) rows(2)
graph export graphics/f6p24.eps, replace
graph drop g1 g2 g3 g4

//Figure 6.25
twoway scatter tadrevenue fitted ///
 || lfit tadrevenue fitted, xlabel(8(1)14) ylabel(8(1)13) ///
ytitle("log(AdRevenue)") xtitle("Fitted Values") legend(off)
graph export graphics/f6p25.eps, replace
//Figure 6.26
plot_lm, smoother("lowess_ties_optim")
graph export graphics/f6p26.eps, replace

//regression output 
reg 
//Figure 6.27
avplots,rlopt(lcolor(red))  recast(scatter) ytitle(, orientation(vertical) ///
justification(left) margin(right)) caption(, justification(left))
graph export graphics/f6p27.eps, replace


clear
insheet using data/circulation.txt, names
gen lnweekday = ln(weekday)
gen lnsunday = ln(sunday)
//Figure 6.28
twoway scatter lnsunday lnweekday if tabl == 0, mcol(black) ///
|| scatter lnsunday lnweekday if tabl == 1, msym(th) mcol(red) ///
ytitle("log(Sunday Circulation)")  xtitle("log(Weekday Circulation)") ///
xlabel(11.5(.5)14.0) ylabel(12.0(.5)14.0) ///
legend( title("Tabloid dummy variable",size("medium")) label(1 "0") ///
label(2 "1") cols(1) ring(0) position(11))
graph export graphics/f6p28.eps, replace

qui reg lnsunday lnweekday tabloid
predict fitted,xb
predict stanres1,rstandard

//Figure 6.29
twoway scatter stanres1 lnweekday, xlabel(11.5(.5)14.0) ///
xtitle("log(Sunday Circulation)") ytitle("Standardized Residuals") ///
nodraw name(g1)
twoway scatter stanres1 tabl, xlabel(0 1) ///
xtitle("Tabloid with a Serious Competitor") ///
ytitle("Standardized Residuals") nodraw name(g2)
twoway scatter stanres1 fitted, xtitle("Fitted Values") ///
ytitle("Standardized Residuals") nodraw name(g3)
graph combine g1 g2 g3
graph drop g1 g2 g3
graph export graphics/f6p29.eps, replace

//Figure 6.30
twoway scatter lnsunday fitted ///
|| lfit lnsunday fitted, xtitle("Fitted Values") ///
ytitle("log(Sunday Circulation)") legend(off)
graph export graphics/f6p30.eps, replace

//Figure 6.31
plot_lm , smoother("lowess_ties_optim")
graph export graphics/f6p31.eps, replace

//Regression output
reg
//Figure 6.32
avplot lnweekday, name(g1) rlopt(lcolor(red)) nodraw xsize(2.5)
avplot tabl, name(g2) rlopt(lcolor(red)) nodraw xsize(2.5)
graph combine g1 g2, xsize(5) rows(1) 
graph drop g1 g2
graph export graphics/f6p32.eps, replace



clear
set obs 2
gen lnweekday =ln(210000)
gen tabloidwithaseriouscompetitor = _n == 1
predict fit, xb
predict fitse, stdf
gen lwr = fit - fitse*invttail(e(df_r),(1-.95)/2)
gen upr = fit + fitse*invttail(e(df_r),(1-.95)/2)
replace fit = exp(fit)
replace lwr = exp(lwr)
replace upr = exp(upr)
l fit lwr upr

clear
insheet using data/profsalary.txt, names
//figure 6.33 
qui reg salary experience
local alpha = 2/3
mmp, mean(xb) smoother(lowess) predictors smooptions("bwidth(`alpha')") 
graph export graphics/f6p33.eps, replace

gen experience2 = experience^2
qui reg salary experience experience2
local alpha = 2/3
//figure 6.34
mmp, mean(xb) smoother(lowess) varlist(experience) smooptions("bwidth(`alpha')") 
graph export graphics/f6p34.eps, replace

clear
insheet using data/defects.txt, names
qui reg defective temperature density rate
local alpha = 2/3
//figure 6.35
lowess defective temperature, bwidth(`alpha') note("") title("") ///
xlabel(1(.5)3) ylabel(0(20)60) xtitle("Temperature, x1") ///
ytitle("Defective, Y") name("g1") note("") nodraw xsize(2.5)
predict dhat,xb
lowess dhat temperature, bwidth(`alpha') note("") title("") ///
xlabel(1(.5)3) ylabel(-10(20)50) xtitle("Temperature, x1") ///
ytitle("Fitted") name("g2") note("") nodraw  xsize(2.5)
graph combine g1 g2, rows(1) 
graph export graphics/f6p35.eps, replace
graph drop g1 g2

//figure 6.36
local alpha = 2/3
mmp, mean(xb) smoother(lowess) varlist(temperature) smooptions("bwidth(`alpha')") 
graph export graphics/f6p36.eps, replace

//figure 6.37
local alpha = 2/3
mmp, mean(xb) smoother(lowess) linear predictors smooptions("bwidth(`alpha')") 
graph export graphics/f6p37.eps, replace

gen sqrtdefective = sqrt(defective)
qui reg sqrtdefective temperature density rate
//figure 6.38
local alpha = 2/3
mmp, mean(xb) smoother(lowess) linear predictors smooptions("bwidth(`alpha')") 
graph export graphics/f6p38.eps, replace

clear
insheet using data/bridge.txt, names
//Figure 6.39
graph matrix time darea ccost dwgs length spans, ///
diagonal("Time" "Darea" "CCost""Dwgs" "Length" "Span") 
graph export graphics/f6p39.eps, replace

// BoxCox output 
mboxcox time darea ccost dwgs length span
test time =1
di sqrt(r(chi2)) 
test darea =1
di sqrt(r(chi2))
test ccost =1
di sqrt(r(chi2))
test dwgs =1
di sqrt(r(chi2))
test length= 1
di sqrt(r(chi2))
test span= 1
di sqrt(r(chi2))

gen lntime =  ln(time)
gen lndarea = ln(darea)
gen lnccost = ln(ccost)
gen lndwgs = ln(dwgs)
gen lnlength = ln(length)
gen lnspans = ln(spans)
//Figure 6.40
graph matrix lntime lndarea lnccost lndwgs lnlength lnspans, ///
diagonal("log(Time)" "log(DArea)" "log(CCost)" "log(Dwgs)" "log(Length)" "log(Span)") 
graph export graphics/f6p40.eps, replace

qui reg lntime lndarea lnccost lndwgs lnlength lnspans
predict fitted, xb
predict stanres1, rstandard

// Figure 6.41
twoway scatter stanres1 lndarea, name(g1) ytitle("Standardized Residuals") ///
xtitle("log(DArea)") nodraw xsize(3.5)
twoway scatter stanres1 lnccost, name(g2) ytitle("Standardized Residuals") ///
xtitle("log(CCost)") nodraw xsize(3.5)
twoway scatter stanres1 lndwgs , name(g3) ytitle("Standardized Residuals") ///
xtitle("log(Dwgs)") nodraw xsize(3.5)
twoway scatter stanres1 lnlength , name(g4) ytitle("Standardized Residuals") ///
xtitle("log(Length)") nodraw xsize(3.5)
twoway scatter stanres1 lnspans , name(g5) ytitle("Standardized Residuals") /// 
xtitle("log(Spans)") nodraw xsize(3.5)
twoway scatter stanres1 fitted, name(g6) ytitle("Standardized Residuals") ///
xtitle("Fitted Values") nodraw xsize(3.5)
graph combine g1 g2 g3 g4 g5 g6, xsize(10.5) ysize(10) rows(2)
graph export graphics/f6p41.eps, replace
graph drop g1 g2 g3 g4 g5 g6


//figure 6.42
twoway scatter lntime fitted || lfit lntime fitted, legend(off) ///
ytitle("log(Time)") xtitle("Fitted Values")
graph export graphics/f6p42.eps, replace

//Figure 6.43
plot_lm, smoother("lowess_ties_optim")
graph export graphics/f6p43.eps, replace

//Figure 6.44
local alpha = 2/3
mmp, mean(xb) smoother(lowess) linear predictors smooptions("bwidth(`alpha')") 
graph export graphics/f6p44.eps,replace

//regression output 
regress
//Figure 6.45
avplots,rlopt(lcolor(red))  xsize(15) ysize(10)
graph export graphics/f6p45.eps, replace

//correlation output 
corr lndarea lnccost lndwgs lnlength lnspans
//vif output 
vif

clear
insheet using data/Bordeaux.csv, comma names
gen lnprice = ln(price)
gen lnparkerpoints = ln(park)
gen lncoatespoints = ln(coat)
qui reg lnprice lnpark lncoat p95 first cult pom vint
predict stanres, rstandard
predict fitted, xb
set graphics off
twoway scatter stanres lnpark, ylabel(-2 0 2) ///
ytitle("Standardized Residuals") xtitle("log(ParkerPoints)") name("a1")
twoway scatter stanres lncoat, ylabel(-2 0 2) ///
ytitle("Standardized Residuals") xtitle("log(CoatesPoints)") name("a2")
gen eal = "P95andAbove"
graph box stanres, ytitle("Standardized Residuals") ylabel(-2 0 2) over(p95) ///
over(eal) name("a")
replace eal = "FirstGrowth"
graph box stanres, ytitle("Standardized Residuals") ylabel(-2 0 2) ///
over(first) over(eal) name("b")
replace eal = "CultWine"
graph box stanres, ytitle("Standardized Residuals") ylabel(-2 0 2) ///
over(cult) over(eal) name("c")
replace eal = "Pomerol"
graph box stanres, ytitle("Standardized Residuals") ylabel(-2 0 2) ///
over(pom) over(eal) name("d")
replace eal = "Vintage"
graph box stanres, ytitle("Standardized Residuals") ylabel(-2 0 2) ///
over(vint) over(eal) name("e")
twoway scatter stanres fitted, ylabel(-2 0 2) ///
ytitle("Standardized Residuals") xtitle("Fitted") name("z")
set graphics on
graph combine a1 a2 a b c d e z, rows(3) xsize(15) ysize(15)
graph drop a1 a2 a b c d e z
graph export graphics/f6p46.eps, replace

//figure 6.47
twoway scatter lnprice fitted ///
|| lfit lnprice fitted, legend(off) ytitle("log(Price)") ///
xtitle("Fitted Values")
graph export graphics/f6p47.eps, replace

//figure 6.48
plot_lm, smoother(lowess_ties_optim)
graph export graphics/f6p48.eps, replace

//figure 6.49
local alpha = 2/3
mmp, mean(xb) smoother(lowess) linear predictors smooptions("bwidth(`alpha')") 
graph export graphics/f6p49.eps,replace

//regression output 
regress
//figure 6.50
set graphics off
gen labelcase = string(_n) if inlist(_n,44,61,53)
avplot lnpark, mlabel(labelcase) rlopt(lcolor(red)) note("") name(a) xsize(2.5)
avplot lncoat, mlabel(labelcase) rlopt(lcolor(red)) note("") name(b) xsize(2.5)
avplot p95 , rlopt(lcolor(red)) note("") name(c) xsize(2.5)
avplot first , rlopt(lcolor(red)) note("") name(d) xsize(2.5)
avplot cult , rlopt(lcolor(red)) note("") name(e) xsize(2.5)
avplot pom , rlopt(lcolor(red)) note("") name(f) xsize(2.5)
avplot vint, rlopt(lcolor(red)) note("") name(g) xsize(2.5)
set graphics on
graph combine a b c d e f g, rows(2) xsize(10) ysize(10)
graph drop a b c d e f g
graph export graphics/f6p50.eps,replace

//vif output 
vif

//regression output 
reg lnprice lnpark lncoat first cult pom vint
//analysis of variance output 
nestreg: reg lnprice (lnpark lncoat first cult pom vint) (p95)

//listing on 
qui regress lnprice lnpark lncoat first cult pom vint
predict stanresred, rstandard
l wine stanresred if stanresred >= 2
l wine stanresred if stanresred <= -2

insheet using data/storks.txt, names clear
twoway scatter babies storks ///
|| lfit babies storks, xtitle("Number of Storks") ///
ytitle("Number of Babies") legend(off)
graph export graphics/f6p51.eps, replace

//regression output 
regress babies storks

twoway scatter babies storks ///
|| lfit babies storks, xtitle("Number of Storks") ///
ytitle("Number of Babies") legend(off) nodraw name(a) 
twoway scatter babies women ///
|| lfit babies women, xtitle("Number of Women") ///
ytitle("Number of Babies") legend(off) nodraw name(b) 
twoway scatter women storks ///
|| lfit women storks, xtitle("Number of Storks") ///
ytitle("Number of Women") legend(off) nodraw name(c) 
graph combine a b c, rows(2) xsize(10) ysize(10)
graph export graphics/f6p52.eps, replace

//regression output 
regress babies stork women





