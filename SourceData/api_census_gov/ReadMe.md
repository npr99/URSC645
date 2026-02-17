# 1. UNDERSTANDING THE ACS: THE BASICS
## What is the ACS?
The American Community Survey (ACS) is a nationwide survey designed to provide communities with reliable and timely social, economic, housing, and
demographic data every year

* The ACS has an annual sample size of about 3.5 million addresses
* Estimates reflect data that have been collected over a period of time
* ACS 1-year estimates are available for geographic areas with at least 65,000 people.
* ACS 5-year estimates are available for all geographic areas 

Because the ACS is based on a sample, rather than all housing units and people, ACS estimates have a degree of uncertainty associated with them, called sampling error. In general, the larger the sample, the smaller the
level of sampling error. To help users understand the impact of sampling error on data reliability, the Census Bureau provides a “margin of error” for each published ACS estimate. The margin of error, combined with the
ACS estimate, give users a range of values within which the actual “real-world” value is likely to fall.

## How are ACS Data Collected?
The ACS collected data using 
1. Internet response
2. Paper questionnaires through the mail
3. Personal visits with a Census Bureau interviewer

The annual sample size of the ACS has increased over
time, from 2.9 million addresses in 2005 to more than
3.5 million addresses in 2015. 

* The survey is not mailed to specific people, but rather to specific addresses
*  The Census Bureau selects a random sample of addresses to be included in the ACS. 
* Each address has about a 1-in-480 chance of being selected in a given month
* No address should be selected more than once every 5 years
* Over a 5-year period, the Census Bureau samples approximately 1-in-9 households nationwide
* The sampling rate is higher in areas with small populations 
* The sampling rate is higher in areas with low predicted response rates


***For more information about the ACS see:***

> U.S. Census Bureau. (2018). Understanding and Using American Community Survey Data: What All Data Users Need to Know. U.S. Government Printing Office, Washington, DC. Retrieved from: https://www.census.gov/content/dam/Census/library/publications/2018/acs/acs_general_handbook_2018.pdf


## Comments about Block Group Level Data
Because the ACS sample sizes get smaller as the geographic area gets smaller, data at the block group level can be problematic. Block groups have between 240 and 1,200 housing units (https://www.census.gov/glossary/#term_BlockGroupBG), with a 1-9 sample for a 5-year ACS that means a sample size of between 27 and 333 households. The small sample size leads to a large Margins of Error.

## Helpful links for Census API

https://www.census.gov/data/developers/data-sets/acs-5year.2018.html

https://api.census.gov/data/2018/acs/acs5/variables.html

Working with data.census.gov it is possible to figure out the variables and the exact geography.

After pointing and clicking through data.census.gov one copy the hyperlink for the table:

ACS 5-year table: https://data.census.gov/cedsci/table?g=0500000US48167.150000&tid=ACSDT5Y2013.B19013

Notice that the hyperlink include the details:
* The table id `tid=ACSDT5Y2013.B19013`
* The GEOID for Galveston County, Texas (48167) and Block Groups (150) `g=0500000US48167.150000`

(Available geographies https://api.census.gov/data/2013/acs/acs5/geography.html)

The data can be downloaded. After downloading the data it is possible to see the metadata (or the data about the data). The metadata provides the details about each variable.

## The downloaded metadata file

For example the first variable is NAME - which refers to the Geographic Area Name.
NAME	Geographic Area Name

The first variable is `B19013_001E` which provides the Mediain household income estimate. 

`B19013_001E	Estimate!!Median household income in the past 12 months (in 2013 inflation-adjusted dollars)`

The variable provides the margin of error for the Median Income.

## What county and year do you want for the data?
For this you will need to find the 5 digit county fips code.

For a full list of County FIPS codes: https://www.nrcs.usda.gov/wps/portal/nrcs/detail/national/home/?cid=nrcs143_013697 

Examples: Brazos County, Texas = 48041 (state = '48', county = '041')

Notice that the leading 0 must be included.

The year corresponds to the 5 year ACS.
For example, 2013 means the years 2009-2013 5-year ACS.

## Replace Missing Data Codes
Notice that missing data is flagged as -666666666 and -222222222.
The details of these codes can be found in the Notes tab on data.census.gov

1. Estimate value = -222222222, Annotation Value = ''**''
> An ''**'' entry in the margin of error column indicates that either no sample observations or too few sample observations were available to compute a standard error and thus the margin of error. A statistical test is not appropriate.
2. Estimate value = -666666666, Annotation Value = ''-'' 
> An ''-'' entry in the estimate column indicates that either no sample observations or too few sample observations were available to compute an estimate, or a ratio of medians cannot be calculated because one or both of the median estimates falls in the lowest interval or upper interval of an open-ended distribution.

List of Annotation Values:

https://www.census.gov/data/developers/data-sets/acs-1year/notes-on-acs-estimate-and-annotation-values.html

To explore these Block Groups the next command will locate (.loc) observations where the median income is missing. The sample size variable (`B00002_001E`) will indicate how many housing units were surveyed in the block group.

For more deatilas on the variables:
* https://api.census.gov/data/2013/acs/acs5/variables/B19013_001MA.html
* https://api.census.gov/data/2013/acs/acs5/variables/B00002_001E.html
