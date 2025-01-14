* chapter5tex.do
* descriptive gss.dta
use "descriptive_gss.dta", clear
histogram childs if childs>0, xlabel(1(1)9) discrete frequency ///
   title(Number of Children in Families with at Least One Child) ///
   note(descriptive gss.dta) scheme(sj)
* generate two normal distributions, both with means of 1000, but one
* with an SD of 100 and the other with and SD of 200
* need to run -findit zdemo- to use the next command
zdemo2 1000 100 1000 200
* tabulate sex and marital with and without plot option
tab1 sex marital polviews
fre sex marital polviews
graph pie, over(marital) title(Marital Status in the United States) ///
  note(descriptive gss.dta) plabel(_all name) scheme(s2mono) cw
histogram marital, discrete percent gap(10) addlabels xtitle(Marital Status) ///
   xlabel(, valuelabel) title(Marital Status in the United States) scheme(s1mono)
numlabel _all, add
tab1 polviews
summarize polviews, detail
histogram polviews, discrete start(1) percent addlabels ///
   xtitle(Political Conservatism) ///
   xlabel(#7, valuelabel angle(forty_five)) ///
   title(Political Views in the United States) subtitle(Adult Population) ///
   plotregion(margin(t=5)) ///
   note(General Social Survey 2002) scheme(s1mono)
summarize wwwhr, detail
sktest wwwhr 
histogram wwwhr, frequency
histogram wwwhr if wwwhr < 25, freq by(sex)
tabstat wwwhr, statistics(mean median sd skewness kurtosis cv iqr) by(sex) columns(statistics)
graph hbox wwwhr if wwwhr < 25, over(sex) title(Hours Spent on the World Wide Web) ///
  subtitle(By Gender) note(descriptive gss.dta) scheme(s2manual)
numlabel _all, remove
graph hbox wwwhr if wwwhr < 25, over(sex, label(angle(forty_five))) ///
  over(marital) title(Hours on the World Wide Web) ///
  subtitle(Women and Men Compared by Marital Status) scheme(s2manual) ///
  note(descriptive gss.dta)
