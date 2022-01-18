version 10.0
clear all
set scheme ssccl
set more off
insheet using data/production.txt, names
label variable runsize "Run Size"
label variable runtime "Run Time"

// Figure 2.1 
twoway scatter runtime runsize, ylabel(160(20)240) xlabel(50(50)350)
graph export graphics/f2p1.eps, replace

reg runtime runsize
// Figure 2.3 
twoway scatter runtime runsize ///
|| lfit runtime runsize, ylabel(160(20)240) xlabel(50(50)350) ///
ytitle("Run Time") xtitle("Run Size") legend(off)
graph export graphics/f2p3.eps, replace

// t-value 
display invttail(18,.05/2)
//95% confidence intervals 
reg, level(95)

rlcipi , arg(50 100 150 200 250 300 350) level(95) len(7) prec(4)
matrix list r(result)
rlcipi , pred arg(50 100 150 200 250 300 350) level(95) len(7) prec(4)

clear
set obs 101
gen x = _n - 51
set seed 12345678
gen yerror = invnorm(uniform())*5
gen y = 50 + x + yerror
gen showit = x == 20 
sum y
gen ybar = r(mean)
//Fig. 2.4 
twoway scatter y x if showit ///
|| lfit y x ///
|| line ybar x, legend(cols(1) lab(2 "yhat") lab(3 "ybar") order(2 3) ///
ring(0) position(11)) xlabel(-40(20)40) ylabel(0(20)100) ytitle("y") ///
xtitle("x") lpattern("dash")
graph export graphics/f2p4.eps, replace

clear
insheet using data/production.txt, names
anova runtime runsize, continuous(runsize)
clear
insheet using data/changeover_times.txt, names
set graphics off
twoway scatter changeover new || lfit changeover new, legend(off) ///
xlabel(0(.2)1.0) ylabel(5(10)40) xtitle("Dummy variable, new") ///
ytitle("Change Over Time") name("a")
gen eal = "Dummy variable, New"
graph box changeover, over(new) ytitle("Change Over Time") ///
over(eal) name("b") ylabel(5(10)40)
replace eal = "Method"
graph box changeover, over(method) ytitle("Change Over Time") ///
over(eal) name("c") ylabel(5(10)40)
set graphics on
//Fig 2.5
graph combine a b c, rows(2)
graph export graphics/f2p5.eps, replace

reg changeover new
//p-value 
display 1-ttail(118,-2.254)
display 2*(1-ttail(118,-2.254))

