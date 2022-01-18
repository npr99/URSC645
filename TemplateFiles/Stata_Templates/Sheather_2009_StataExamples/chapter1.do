version 10.0
clear all
set scheme ssccl
set more off
insheet using data/FieldGoals2003to2006.csv, comma names
d
l name yeart fgatm1 in 1/10 
sum fgat fgtm1 
tab name
tab name year if year > 2004
label variable fgt "Field Goal Percentage in Year t"
label variable fgtm1 "Field Goal Percentage in Year t-1"
//	Fig 1.1
twoway scatter fgt fgtm1, title("Unadjusted Correlation=-.0139", span) 
graph export graphics/f1p1.eps, replace
encode name, generate(nn)
l name nn in 1/10, nolabel
//	pvalues 
anova fgt fgtm1 nn nn*fgtm1, class(nn)

gen AdamVinatieri = name == "Adam Vinatieri"
gen DavidAkers = name == "David Akers"
gen JasonElam = name == "Jason Elam"
gen JasonHanson = name == "Jason Hanson"
gen JayFeely = name == "Jay Feely"
gen JeffReed = name == "Jeff Reed"
gen JeffWilkins = name == "Jeff Wilkins"
gen JohnCarney = name == "John Carney"
gen JohnHall = name == "John Hall"
gen KrisBrown = name == "Kris Brown"
gen MattStover = name == "Matt Stover"
gen MikeVanderjagt = name == "Mike Vanderjagt"
gen NeilRackers = name == "Neil Rackers"
gen OlindoMare = name == "Olindo Mare"
gen PhilDawson = name == "Phil Dawson"
gen RianLindell = name == "Rian Lindell"
gen RyanLongwell = name == "Ryan Longwell"
gen SebastianJanikowski = name == "Sebastian Janikowski"
gen ShayneGraham = name == "Shayne Graham"
//	slope of lines in Figure 1.2 given by fgtm1
reg fgt DavidAkers JasonElam JasonHanson JayFeely    JeffReed ///
   JeffWilkins JohnCarney  JohnHall    KrisBrown   MattStover ///
 MikeVanderjagt NeilRackers    OlindoMare     PhilDawson   ///
RianLindell  RyanLongwell  SebastianJanikowski ShayneGraham fgtm1  

local a = "twoway scatter fgt fgtm1"
tokenize "DavidAkers JasonElam JasonHanson JayFeely    JeffReed    JeffWilkins JohnCarney  JohnHall    KrisBrown   MattStover  MikeVanderjagt NeilRackers    OlindoMare     PhilDawson   RianLindell  RyanLongwell  SebastianJanikowski ShayneGraham"
display "`1'"
d `1'

forvalues i = 1/18 {
local a `"`a' || function y=_b[_cons] + _b[``i''] + _b[fgtm1]*x, range(66.6 100)"'
di "`a'"
}
local a `"`a' || function y =_b[_cons] + _b[fgtm1]*x, range(66.6 100)"'
// Figure 1.2 
`a' legend(off) ytitle("Field Goal Percentage in Year t") ///
xtitle("Field Goal Percentage in Year t-1") ///
title("Slope of each line=-.504") ///
 xlabel(70(10)100) 
graph export graphics/f1p2.eps, replace

clear
insheet using data/circulation.txt, names
// Figure 1.3 
twoway scatter sunday weekday if tabloid == 0 ///
|| scatter sunday weekday if tabloid == 1, ///
legend( title("Tabloid dummy variable",size("medium")) label(1 "0") ///
label(2 "1") cols(1) ring(0) position(11)) msymbol("th") ///
xtitle("Weekday Circulation") ytitle("Sunday Circulation") ///
ylabel(500000(500000)1500000) xlabel(2e5(2e5)1e6)
graph export graphics/f1p3.eps, replace
gen lnsunday = ln(sunday)
gen lnweekday = ln(weekday)
//Figure 1.4 
twoway scatter lnsunday lnweekday if tabloid == 0 ///
|| scatter lnsunday lnweekday if tabloid == 1, ///
legend( title("Tabloid dummy variable",size("medium")) label(1 "0") ///
label(2 "1") cols(1) ring(0) position(11)) msymbol("th") ///
xtitle("log(Weekday Circulation)") ytitle("log(Sunday Circulation)") /// 
ylabel(12(.5)14) xlabel(11.5(.5)14)
graph export graphics/f1p4.eps, replace

clear
insheet using data/nyc.csv, names comma 
//Figure 1.5
graph matrix cost food decor service, ///
diagonal("Price" "Food" "Decor" "Service",size("large")) ///
xlabel(16(2)24, axis(2))  xlabel(14(2)24, axis(4)) ///
 xlabel(20(10)60, axis(1)) xlabel(10(5)25, axis(3)) ///
ylabel(14(2)24,axis(4)) ylabel(16(2)24,axis(2)) ///
ylabel(10(5)25,axis(3)) ylabel(20(10)60, axis(1))
graph export graphics/f1p5.eps, replace

//Figure 1.6
gen eal = "East(1 = East of Fifth Avenue)"
graph box cost, over(east) over(eal) ytitle("Price")
graph export graphics/f1p6.eps, replace

clear
insheet using data/Bordeaux.csv, comma names
//Figure 1.7
graph matrix price parkerpoints coatespoints, ///
diagonal("Price" "ParkerPoints" "CoatesPoints",size("large")) ///
xlabel(0 2000 6000 10000,axis(1)) xlabel(88(2)100,axis(2)) ///
xlabel(15(1)19,axis(3)) ylabel(0 2000 6000 10000,axis(1)) ///
ylabel(88(2)100,axis(2)) ylabel(15(1)19,axis(3))  
graph export graphics/f1p7.eps, replace

set graphics off
gen eal = "P95andAbove"
graph box price, ytitle("Price") ylabel(0 2000 6000 10000) ///
over(p95) over(eal) name("a")
replace eal = "First Growth"
graph box price, ytitle("Price")  ylabel(0 2000 6000 10000) ///
  over(first) over(eal) name("b")
replace eal = "Cult Wine"
graph box price, ytitle("Price")  ylabel(0 2000 6000 10000) ///
over(cult) over(eal) name("c")
replace eal = "Pomerol"
graph box price, ytitle("Price")  ylabel(0 2000 6000 10000) ///
over(pom) over(eal) name("d")
replace eal = "Vintage Superstar"
graph box price, ytitle("Price")  ylabel(0 2000 6000 10000) ///
over(vint) over(eal) name("e")

set graphics on
//Figure 1.8 
graph combine a b c d e , rows(2)
graph export graphics/f1p8.eps, replace
graph drop a b c d e 

gen lnprice = ln(price)
gen lnpark = ln(park)
gen lncoat = ln(coat)
//Figure 1.9 
graph matrix lnprice lnpark lncoat, ///
diagonal("log(Price)" "log(ParkerPoints)" "log(CoatesPoints)",size("medium")) ///
xlabel(5(1)9,axis(1)) xlabel(4.48(.04)4.60,axis(2)) xlabel(2.70(.1)2.90,axis(3)) ///
ylabel(5(1)9,axis(1)) ylabel(4.48(.04)4.60,axis(2)) ylabel(2.70(.1)2.90,axis(3))
graph export graphics/f1p9.eps, replace

set graphics off 
replace eal = "P95andAbove"
graph box lnprice, ytitle("log(Price)") ylabel(5(1)9) over(p95) over(eal) name("a")
replace eal = "First Growth"
graph box lnprice, ytitle("log(Price)") ylabel(5(1)9)   over(first) over(eal) name("b")
replace eal = "Cult Wine"
graph box lnprice, ytitle("log(Price)") ylabel(5(1)9) over(cult) over(eal) name("c")
replace eal = "Pomerol"
graph box lnprice, ytitle("log(Price)") ylabel(5(1)9) over(pom) over(eal) name("d")
replace eal = "Vintage Superstar"
graph box lnprice, ytitle("log(Price)") ylabel(5(1)9) over(vint) over(eal) name("e")
set graphics on

//Figure 1.10
graph combine a b c d e , rows(2)
graph export graphics/f1p10.eps, replace
graph drop a b c d e

