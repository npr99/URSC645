* chapter8.do
* Chapter 8: Correlation and Regression
use "C:\master2\master\dof\gss2006_all.dta", clear
* use gss2002_chapter8, clear
****************************************************
* SCATTERGRAMS	
****************************************************
set seed 123
sample 100, count
twoway (scatter educ paeduc, ytitle(Son's education) ///
  xtitle(Father's education) title(Scattergram ///
  relating father's education to his son's education, size(medium)) ///
  note(Data source: GSS 2006; random subsample of N = 100)
twoway (scatter educ paeduc, jitter(6)), ytitle(Son's education) ///
  xtitle(Father's education) title(Scattergram ///
  relating father's education to his son's education, size(medium)) ///
  note(Data source: GSS 2006; random subsample of N = 100)
twoway (scatter educ paeduc, mcolor(black) mfcolor(black) ///
  jitter(5) jitterseed(222)) (scatter educ paeduc) ///
  if sex==1, ytitle(Son's education) ytitle() ///
  yscale(titlegap(5)) xtitle(Father's education) ///
  title(Scattergram relating father's education to his ///
  son's education, size(medium)) ///
  note(Data source: GSS 2006; random sample of N = 100) ///
  legend(off)
twoway (lfit educ paeduc) (scatter educ paeduc) if sex == 1, ///
   title(Scattergram relating father's education to his son's education, size(medium)) ///
   note(Data source: GSS 2002) xtitle(Father's education) ///
   ytitle(Son's education)

****************************************************
* CASEWISE AND PAIRWISE CORRELATION
****************************************************
use http://www.ats.ucla.edu/stat/stata/notes/hsb2, clear
codebook ses female
numlabel _all, add
tab1 female ses
correlate read write math science ses female
pwcorr read write math science socst ses female, obs sig star(5)
pwcorr read write math science socst ses female, bon sig obs star(5)
pwcorr read write math science socst ses female ///
    if !missing(read, write, math, science, socst, ses, female), ///
    bon sig obs star(5)

****************************************************
* REGRESSION AND CURVE FITTING
****************************************************
use gss2006_chapter8_selected, clear
summarize prestg80 hrs1 
pwcorr prestg80 hrs1, obs sig
regress prestg80 hrs1, beta
regress prestg80 hrs1
twoway (lfitci prestg80 hrs1), scheme(s2mono)

recode sex(2=1 Female) (1=0 Male), gen(female)
pbis female hrs1
bysort sex: corr hrs1 educ
bysort sex: regress hrs1 educ
