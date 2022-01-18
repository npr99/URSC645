set more off
clear all
version 10.0
set scheme ssccl

insheet using data/Orthodont.txt, names delim(" ")
l, clean
gen davg = (dist8 + dist10 + dist12 + dist14)/4
gsort -davg -subject
l subject davg, clean 

label define svals 1 "M10" 2 "M01" 3 "M04" ///
  4 "M06" 5 "F11" 6 "M15" 7 "M09"  ///
  8 "M14" 9 "F04" 10 "M13" 11 "M12" ///
 12 "M03" 13 "M08" 14 "M07" 15 "F03" ///
 16 "M11" 17 "M02" 18 "F08" 19 "M16" ///
 20 "M05" 21 "F07" 22 "F02" 23 "F05" ///  
 24 "F01" 25 "F09" 26 "F06" 27 "F10"  

gen nusubject = _n
label values nusubject svals
sort nusubject
l nusubject subject, clean

gen female = substr(subject,1,1) == "F"

qui reshape long dist, i(subject) j(age)
l subject age dist if _n <= 20 , sepby(subject) 

gen femalesubject = nusubject if female
label values femalesubject svals
label variable dist "Distance"
twoway line dist age, sort || scatter dist age, ///
by(femalesubject, rows(2) legend(off) note("")) 
graph export graphics/f10p1.eps, replace

qui reshape wide dist, i(subject) j(age)
corr dist* if female

graph matrix dist14 dist12 dist10 dist8 if female, ///
diagonal("DistFAge14" "DistFAge12" "DistFAge10" "DistFAge8")
graph export graphics/f10p2.eps, replace

qui reshape long dist, i(subject) j(age)

xtmixed dist age || subject: if female, nolog

predict fitdist, fitted
label variable dist "Distance"
label variable fitdist "Fitted values"
twoway lfit dist fitdist, range(16 28) ytitle("Distance") ///
 xtitle("Fitted Values") ///
|| scatter dist fitdist, xlabel(18(2)26) ///
by(femalesubject, rows(4) legend(off) note("")) 
graph export graphics/f10p3.eps, replace

preserve
keep if female
gen randint = fitdist - _b[age]*age
collapse (mean) randint, by(subject)
bysort subject: assert _n == 1
l subject randint
tempfile a
save `a'
restore
preserve
gen f1 = subject == "F01"
gen f2 = subject == "F02"
gen f3 = subject == "F03"
gen f4 = subject == "F04"
gen f5 = subject == "F05"
gen f6 = subject == "F06"
gen f7 = subject == "F07"
gen f8 = subject == "F08"
gen f9 = subject == "F09"
gen f10 = subject == "F10"
qui reg dist age f1-f10 if female
matrix coef = e(b)
matrix coef = coef[1,2..12]
matrix list coef
matrix coef = coef'
drop subject
matrix colnames coef = fixint
svmat coef, names(col)
replace fixint = fixint + fixint[11] if _n < 11
gen subject = "F0" + string(_n) if _n < 10
replace subject = "F" + string(_n) if inlist(_n,10,11) 
drop if subject == "" 
l subject fixint

bysort subject: assert _n == 1
merge subject using `a'
gen randMfix = randint - fixint
keep subject randint fixint randMfix
bysort subject: assert _n == 1
tempfile a
save `a'
restore
preserve
bysort subject: keep if _n == 1 
merge subject using `a'
sort nusubject
l subject randint fixint randMfix if _m == 3
restore

gen malesubject = nusubject if !female
label values malesubject svals
label variable dist "Distance"
twoway line dist age, sort ///
|| scatter dist age, by(malesubject, rows(2) legend(off) note("")) 
graph export graphics/f10p4.eps, replace

drop fit*
qui reshape wide dist, i(subject) j(age)
corr dist* if !female

graph matrix dist14 dist12 dist10 dist8 if !female, ///
diagonal("DistMAge14" "DistMAge12" "DistMAge10" "DistMAge8")
graph export graphics/f10p5.eps, replace

qui reshape long dist, i(subject) j(age)

xtmixed dist age || subject: if !female, nolog

predict fitdist, fitted
label variable dist "Distance"
label variable fitdist "Fitted values"
twoway lfit dist fitdist, range(20 30) ytitle("Distance") ///
xtitle("Fitted Values") ///
|| scatter dist fitdist, xlabel(22(4)30) ///
by(malesubject, rows(4) legend(off) note("")) 
graph export graphics/f10p6.eps, replace

gen femXage = female*age
xtmixed dist age female femXage || subject:, nolog

predict reff, reffects 
by subject: gen first = _n == 1
qnorm reff if first, ytitle("Random Effects")
graph export graphics/f10p8A.eps, replace

predict fitfix,xb
gen ares = dist - fitfix
predict res, residuals
preserve
keep ares res subject age
qui reshape wide ares res, i(subject) j(age)
corr ares*
graph matrix ares14 ares12 ares10 ares8, ///
diagonal("Age14" "Age12" "Age13" "Age14")
graph export graphics/f10p9A.eps, replace
corr res*
graph matrix res14 res12 res10 res8, diagonal("Age14" "Age12" "Age13" "Age14")
graph export graphics/f10p10A.eps, replace
restore

predict zefit, fitted
twoway scatter res zefit if female == 0, ///
xlabel(20(5)30) ylabel(-4(2)4) name(male) xsize(3) nodraw 
twoway scatter res zefit if female, ///
xlabel(20(5)30) ylabel(-4(2)4) name(female) xsize(3) nodraw
graph combine male female, xsize(6)
graph export graphics/f10p10.eps, replace
graph drop male female

matrix list e(b)
scalar varsubject = (exp(_b[lns1_1_1:_cons]))^2
scalar varerror = (exp(_b[lnsig_e:_cons]))^2
gen cholres = .
predict fixfit, xb
replace res = dist - fixfit
mata
varsubject = st_numscalar("varsubject")
varerror = st_numscalar("varerror")
estvar = varerror*I(st_numscalar("e(N)")) :+ varsubject
sm = cholesky(estvar)
smi = qrinv(estvar)
xstar = st_data(.,("res"))
cholres = smi*xstar
st_store((1,rows(cholres)),"cholres",cholres[,1])
end
gen eal = "Sex"
label define sexvals 0 "Male" 1 "Female"
label values female sexvals
label variable cholres "Cholesky residuals from model (10.5)"
graph box cholres, over(female) over(eal)
graph export graphics/f10p12.eps, replace

webuse pig, clear

local graphmac "twoway scatter weight week if id==1, connect(L)"
forvalues i = 2/48 {
local graphmac "`graphmac' || scatter weight week if id==`i', connect(L) "
}

`graphmac', legend(off) ytitle(weight) xtitle(time) 
graph export graphics/f10p13.eps, replace


qui reshape wide weight, i(id) j(week)
correlate weight*
graph matrix weight*, ///
diagonal("T1" "T2" "T3" "T4" "T5" "T6" "T7" "T8" "T9", size(huge))  
graph export graphics/f10p14.eps, replace

webuse pig, clear
tabulate week, generate(wk)
xtmixed weight week || id:wk*, nocons cov(unstructured)

