* chapter2.do
* This reproduces the results shown in Chapter 2
* The programming to label variables, values, etc. is developed in c3.do
* and are not shown here.
* Once the dataset is created, we run the command 
* save firstsurvey
* We then can open it and run the set of commands for Chapter 2
use firstsurvey, clear
codebook gender
codebook education
describe
summarize
