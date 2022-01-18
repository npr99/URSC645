* c4.do
* do-file opens firstsurvey_chapter4.dta, summarizes education 
* and prison for women and then graphs a pie chart on prison.
use firstsurvey_chapter4, clear
summarize
summarize education, detail
list gender education prison in 1/5
list gender education prison in 1/5, nolabel
numlabel _all, add
list gender education prison in 1/5
use firstsurvey_chapter4, clear
summarize education  prison if gender == 2, detail
list gender education prison in 1/5
graph pie, over(prison) title(Length of Prison Sentences) ///
    note(firstsurvey_chapter4.dta) plabel(_all name) cw

