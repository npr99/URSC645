* c3.do
* This do-file does the analysis for chapter 3
use relate, clear
describe R3483600 R3483700 R3483800 R3483900
codebook, compact
codebook R3483600
mvdecode _all, mv(-5=.a\-4=.b\-3=.c\-2=.d\-1=.e)
label define often  0 "Never" 1 "Rarely" 2 "Sometimes" 3 "Usually" 4 "Always"
label define often .a "Noninterview" .b "Valid skip" .c "Invalid skip", add
label define often .d "Don't know" .e "Refusal", add
label define often_r  4 "Never" 3 "Rarely" 2 "Sometimes" 1 "Usually" 0 "Always"
label define often_r .a "Noninterview" .b "Valid skip" .c "Invalid skip", add
label define often_r .d "Don't know" .e "Refusal", add
label values R3483600 often
label values R3483800 often
label values R3485200 often
label values R3485400 often

recode R3483700 R3483900 R3485300 R3485500 (0=4) (1=3) (2=2) (3=1) (4=0), ///
	generate(mocritr moblamer facritr fablamer)
label variable mocritr "Mother criticizes R, R3483700 reversed"
label variable moblamer "Mother blames R, R3483900 reversed"
label variable facritr "Father criticizes R, R3485300 reversed"
label variable fablamer "Father blames R, R3485500 reversed"
label values mocritr often_r
label values moblamer often_r
label values facritr often_r
label values fablamer often_r
generate id = R0000100
generate sex = R3828700
generate age = R3828100
generate mopraise = R3483600
generate mohelp = R3483800
generate fapraise = R3485200
generate fahelp = R3485400
generate facritr = 4 - R3485300
tabulate Facritr R3485300, miss nolabel
generate ymorelate = mopraise + mocritr + mohelp + moblamer
generate yfarelate = fapraise + facritr + fahelp + fablamer
egen momissing = rowmiss(mopraise mocritr mohelp moblamer)
tab momissing
tabulate facritr R3485300, miss nolabel
egen float momeana = rowmean(mopraise mocritr mohelp moblamer)
*  Save the master dataset before dropping variables
save nlsy97_mstr, replace
*  Drop the original items because we no longer need them
drop R3483600-R3828700
*  Reorder the variables when saving to make them easier to read
order id sex age ymorelate yfarelate m* f*
save nlsy97_fp, replace
