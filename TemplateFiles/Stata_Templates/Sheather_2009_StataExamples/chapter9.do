set more off
clear all
version 10.0
set scheme ssccl

insheet using data/confood2.txt, names

gen lnprice = ln(price)
gen lnsales = ln(sales)

//Figure 9.1
twoway scatter lnsales lnprice if promo == 0,msymbol(th) ///
|| scatter lnsales lnprice if promo == 1, msymbol(plus) ///
legend(title("Promotion") label(1 "No") label(2 "Yes") ///
cols(1) ring(0) position(2)) xtitle("log(Price[t])") ytitle("log(Sales[t])")
graph export graphics/f9p1.eps, replace

//set time variable 
tsset week

//Figure 9.2
tsline lnsales || scatter lnsales week if promo == 0, msymbol(th) ///
|| scatter lnsales week if promo == 1, msymbol(plus) xtitle("Week, t") ///
ytitle("log(Sales[t])") legend(title("Promotion") order(2 3) label(2 "No") ///
 label(3 "Yes") cols(1) ring(0) position(11))
graph export graphics/f9p2.eps, replace

gen laglnsales = L.lnsales

//Figure 9.3
twoway scatter lnsales laglnsales,xtitle("log(Sales[t-1])") ytitle("log(Sales)")
graph export graphics/f9p3.eps, replace

ac lnsales, lag(17) nodraw generate(lnsalesAC)
gen lag = _n if _n < 18
gen zero = 0
local top = 2/sqrt(_N)
local bot = -2/sqrt(_N)
replace lag = 0 if _n == 18
replace lnsalesAC = 1 if lag == 0

//Figure 9.4
twoway pcspike lnsalesAC lag zero lag , ///
yline(`top',lpattern(dash) lcolor(red)) ///
yline(`bot',lpattern(dash) lcolor(red))  xtitle("Lag") ytitle("ACF") ///
xlabel(0 5 10 15) ylabel(-0.4(.2)1.0) title("Series log(Sales)")
graph export graphics/f9p4.eps, replace


qui reg lnsales lnprice week promotion
predict stanres1, rstandard
predict fitted, xb

//Figure 9.5
twoway scatter stanres1 lnprice, name(g1) ///
ytitle("Standardized Residuals") xtitle("log(Price[t])") nodraw
twoway scatter stanres1 week || line stanres1 week, name(g2) ///
ytitle("Standardized Residuals") xtitle("Week, t") nodraw legend(off)
twoway scatter stanres1 promo, name(g3) ytitle("Standardized Residuals") ///
xtitle("Promotion") nodraw
twoway scatter stanres1 fitted, name(g4) ytitle("Standardized Residuals") ///
xtitle("Fitted Values") nodraw
graph combine g1 g2 g3 g4, rows(2) xsize(10) ysize(10)
graph export graphics/f9p5.eps, replace
graph drop g1 g2 g3 g4

ac stanres1, lag(17) nodraw generate(stanres1AC)
replace lag = 0 if _n == 18
replace stanres1AC = 1 if lag == 0

//Figure 9.6
twoway pcspike stanres1AC lag zero lag , yline(`top',lpattern(dash) ///
lcolor(red)) yline(`bot',lpattern(dash) lcolor(red))  xtitle("Lag") ///
ytitle("ACF") xlabel(0 5 10 15) ylabel(-0.4(.2)1.0) ///
title("Series Standardized Residuals")
graph export graphics/f9p6.eps, replace

//Generalized Least Squares Output 
arima lnsales lnprice week promotion, arima(1,0,0) vce(oim) nolog

predict glsresid, resid structur 
ac glsresid, lag(17) nodraw generate(glsresidAC)
replace lag = 0 if _n == 18
replace glsresidAC = 1 if lag == 0

//Figure 9.7
twoway pcspike glsresidAC lag zero lag , yline(`top',lpattern(dash) ///
lcolor(red)) yline(`bot',lpattern(dash) lcolor(red))  xtitle("Lag") ///
ytitle("ACF") xlabel(0 5 10 15) ylabel(-0.4(.2)1.0) ///
title("Series GLS Residuals")
graph export graphics/f9p7.eps, replace

gen lnsales_star = .
gen lnprice_star = .
gen promo_star = .
gen week_star = .
gen cons_star = .


mata
xstar = st_data(.,("lnprice","promotion","week"))
xstar = (J(rows(xstar),1,1),xstar)
rho = J(rows(xstar),rows(xstar),.5504)
sigma = range(1,rows(xstar),1)
sigma
sigma = J(rows(xstar),rows(xstar),1) :* sigma
sigma
sigma = sigma - sigma'
sigma = abs(sigma)
sigma = rho :^ sigma
sm = cholesky(sigma)
smi = qrinv(sm)
xstar = smi * xstar
ystar = st_data(.,"lnsales")
ystar = smi * ystar
st_store((1,rows(xstar)),"cons_star", xstar[,1])
st_store((1,rows(xstar)),"lnprice_star",xstar[,2])
st_store((1,rows(xstar)),"promo_star",xstar[,3])
st_store((1,rows(xstar)),"week_star",xstar[,4])
st_store((1,rows(xstar)),"lnsales_star",ystar[,1])
end
reg lnsales_star cons_star lnprice_star promo_star week_star, noconstant
gen case = "1" if _n == 1
//Figure 9.8
twoway scatter lnsales_star cons_star, mlabel(case) mlabposition(6)  ///
 xtitle("Intercept*") ytitle("log(Sales)*") name(g1) nodraw
twoway scatter lnsales_star lnprice_star, mlabel(case) mlabposition(6) ///
  xtitle("log(Price)*") ytitle("log(Sales)*") name(g2) nodraw
twoway scatter lnsales_star promo_star, mlabel(case) mlabposition(6)  ///
 xtitle("Promotion*") ytitle("log(Sales)*") name(g3) nodraw
twoway scatter lnsales_star week_star,  mlabel(case) mlabposition(6) ///
 xtitle("Week*") ytitle("log(Sales)*") name(g4) nodraw
graph combine g1 g2 g3 g4, xsize(10) ysize(10)
graph export graphics/f9p8.eps, replace
graph drop g1 g2 g3 g4

predict tlsrst, rstandard

local top = 2/sqrt(e(N))
local bot = -2/sqrt(e(N))
ac tlsrst, lag(17) nodraw generate(tlsrstAC)
replace lag = 0 if _n == 18
replace tlsrstAC = 1 if lag == 0

//Figure 9.9
twoway pcspike tlsrstAC lag zero lag , ///
yline(`top',lpattern(dash) lcolor(red)) yline(`bot',lpattern(dash) lcolor(red))  xtitle("Lag") ytitle("ACF") xlabel(0 5 10 15) ylabel(-0.4(.2)1.0) title("Series Standardized LS Residuals")
graph export graphics/f9p9.eps, replace

drop fitted
predict fitted, xb

replace case = ""
replace case = "38" if _n == 38
replace case = "30" if _n == 30

//Figure 9.10
twoway scatter tlsrst lnprice, xtitle("log(Price[t])") name(g1) nodraw
twoway scatter tlsrst week,mlab(case) mlabpos(3)  ///
|| line tlsrst week,xtitle("Week, t") ytitle("Standardized LS Residuals") ///
name(g2) nodraw legend(off)
twoway scatter tlsrst promotion, xtitle("Promotion") ///
ytitle("Standardized LS Residuals") name(g3) nodraw
twoway scatter tlsrst fitted, xtitle("Fitted") ///
ytitle("Standardized LS Residuals") name(g4) nodraw
graph combine g1 g2 g3 g4, xsize(10) ysize(10)
graph export graphics/f9p10.eps, replace
graph drop g1 g2 g3 g4


//Figure 9.11
plot_lm, smoother("lowess_ties_optim")
graph export graphics/f9p11.eps, replace

insheet using data/BayArea.txt, names clear

//Figure 9.12
graph matrix interestrate loansclosed  vacancyindex, ///
diagonal("InterestRate" "LoansClosed" "VacancyIndex") 
graph export graphics/f9p12.eps, replace

qui regress interestrate loansclosed  vacancyindex
predict rfit,xb
predict stanres,rstandard

twoway scatter stanres loansclosed ///
|| qfit stanres loansclosed, ytitle("Standardized Residuals") ///
name(a) legend(off) nodraw
twoway scatter stanres vacancyindex, ytitle("Standardized Residuals") ///
 name(b) legend(off) nodraw
twoway scatter stanres rfit ///
|| qfit stanres rfit, ytitle("Standardized Residuals") ///
xtitle("Fitted Values") name(c) legend(off) nodraw

tsset month
gen lag = _n if _n < 13
ac stanres, lag(13) nodraw generate(srAC)
replace lag = 0 if _n == 13
replace srAC = 1 if lag == 0
gen zero = 0
local top = 2/sqrt(_N)
local bot = -2/sqrt(_N)

//Figure 9.13
twoway pcspike srAC lag zero lag , ///
yline(`top',lpattern(dash) lcolor(red)) yline(`bot',lpattern(dash) lcolor(red))  xtitle("Lag") ytitle("ACF") xlabel(0(2)12) ylabel(-0.5(.5)1.0) ///
 title("Standardized LS Residuals") legend(off) name(d) nodraw
graph combine a b c d, rows(2)
graph export graphics/f9p13.eps, replace
graph drop a b c d

arima interestrate loansclosed  vacancyindex, arima(1,0,0) vce(oim) nolog

gen interestrate_star = .
gen loansclosed_star = .
gen vacancyindex_star = .
gen month_star = .
gen cons_star = .

mata
xstar = st_data(.,("loansclosed","vacancyindex","month"))
xstar = (J(rows(xstar),1,1),xstar)
rho = J(rows(xstar),rows(xstar),.9572082)
sigma = range(1,rows(xstar),1)
sigma
sigma = J(rows(xstar),rows(xstar),1) :* sigma
sigma
sigma = sigma - sigma'
sigma = abs(sigma)
sigma = rho :^ sigma
sm = cholesky(sigma)
smi = qrinv(sm)
xstar = smi * xstar
ystar = st_data(.,"interestrate")
ystar = smi * ystar
st_store((1,rows(xstar)),"cons_star", xstar[,1])
st_store((1,rows(xstar)),"loansclosed_star",xstar[,2])
st_store((1,rows(xstar)),"vacancyindex_star",xstar[,3])
st_store((1,rows(xstar)),"month_star",xstar[,4])
st_store((1,rows(xstar)),"interestrate_star",ystar[,1])
end
reg interestrate_star loansclosed_star vacancyindex_star cons_star, noconstant

gen case = "1" if _n == 1
twoway scatter interestrate_star cons_star, mlabel(case) mlabposition(6) ///
  xtitle("Intercept*") ytitle("InterestRate*") name(g1) nodraw
twoway scatter interestrate_star loansclosed_star, mlabel(case) ///
mlabposition(6)   xtitle("LoansClosed*") ytitle("InterestRate*") ///
 name(g2) nodraw
twoway scatter interestrate_star vacancyindex_star, mlabel(case) ///
mlabposition(6)   xtitle("VacancyIndex*") ytitle("InterestRate*") ///
name(g3) nodraw
twoway scatter  vacancyindex_star loansclosed_star,  mlabel(case) ///
mlabposition(6)  xtitle("LoansClosed*") ytitle("VacancyIndex*") ///
name(g4) nodraw
graph combine g1 g2 g3 g4, xsize(10) ysize(10)
graph export graphics/f9p14.eps, replace
graph drop g1 g2 g3 g4


predict trfit,xb
predict tstanres,rstandard

twoway scatter tstanres loansclosed_star, mlabel(case) ///
xtitle("LoansClosed*") ytitle("Standardized Residuals") ///
name(a) legend(off) nodraw
twoway scatter tstanres vacancyindex_star, mlabel(case) ///
 xtitle("VacancyIndex*") ytitle("Standardized Residuals") ///
 name(b) legend(off) nodraw
twoway scatter tstanres trfit, mlabel(case) xtitle("Fitted Values*") ///
ytitle("Standardized Residuals") xtitle("Fitted Values") ///
 name(c) legend(off) nodraw

ac tstanres, lag(13) nodraw generate(tsrAC)
replace tsrAC = 1 if lag == 0

//Figure 9.15
twoway pcspike tsrAC lag zero lag , ///
 yline(`top',lpattern(dash) lcolor(red)) ///
 yline(`bot',lpattern(dash) lcolor(red))  xtitle("Lag") ytitle("ACF") ///
xlabel(0(2)12) ylabel(-0.5(.5)1.0) title("Standardized LS Residuals") ///
legend(off) name(d) nodraw
graph combine d a b c, rows(2)
graph export graphics/f9p15.eps, replace
graph drop a b c d



