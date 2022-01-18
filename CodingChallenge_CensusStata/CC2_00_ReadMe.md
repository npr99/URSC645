CC2 Project Overview 2020-03-30

# Project Mnemonic

CC2 is the project mnemonic, which stands for Coding Challenge 2 (CC2).

This is part of URSC 689

# Project Title

Comparison of Single Parent Household Statistics for 2018, for Texas Counties.

# Project Research Question:

Do different Census tables provide different statistics for Single Parent Households?

# Project Description:

## Project Members (Principal Investigators):

The name and affiliation of the Principal Investigator(s), in order of importance to the study.

| **Name** | **Email** | **Affiliation** | **Role** |
| --- | --- | --- | --- |
| Nathanael Rosenheim | nrosenheim@arch.tamu.edu | Texas A&amp;M University | Project lead |
| Joy Semien | joysemien@tamu.edu | Texas A &amp; M University | Student |
| YouJoung Kim | kyj0244k@tamu.edu | Texas A&amp;M University | Student |
| Malini Roy | mr956@tamu.edu | Texas A&amp;M University | Student |
| Jinhyun Bae | jinhyun2009@tamu.edu | Texas A&amp;M University | Student |
| Rui Zhu | zr1991@tamu.edu | Texas A&amp;M University | Student |
| Wayne Day | waynecday@tamu.edu | Texas A&amp;M University | Student |

## Summary

A common practice in urban planning is to use US Census Bureau data to determine population characteristics. One example of this is social vulnerability analysis. Social vulnerability analysis often requires the calculation of new variables based on a variety of Census tables. Documenting the source Census Tables is critical for a reproducible workflow. To demonstrate the impacts of using different tables we will compare values for calculating the percent of single parent households.

Using Stata compare values for the derived variable:

Percent Single Parent Household, with person under 18 years

Using the 2018-5 year ACS tables B11005 vs B09002

County level data for Texas

Create a clean data set that provides the calculated variable from each table. Include the nominal values for comparing how the percentage value was calculated.

## Funding Sources:

Texas A&amp;M University - URSC 689 - Dept of Landscape Arch and Urban Planning

## Scope of Project:

### Subject Terms

social vulnerability, single parent households, US Census Data

### Geographic Coverage

Texas Counties

### Time Period(s)

2018 - 5-year ACS (2014-2018)

### Collection Dates

Continuous between 2014-2018

### Universe

Compare Census Tables

**B09002 Universe:** Own children under 18 years

B11005 Households

### Collection Notes

See ACS

## Methodology

### Response Rate

See ACS

## Sampling

See ACS

## Data Source

###

United States Bureau American Community Survey, 2018

## Collection Mode(s)

See ACS

## Scales

n/a

## Weight(s)

n/a

## Unit(s) of Observation

County

## Geographic Unit

County

# Related Publications

n/a

# Data Workflow Planning:

The following sections are meant to help think through the data science process or workflow. As illustrated in figure one the process starts with raw data and moves to data cleaning. The data cleaning process creates a clean dataset or datafile that can be used in data exploration and data modeling. Notice that data exploration may lead to more data cleaning. After data is modeled the results can be communicated in a report and new data products can be sent out to the world.

![](RackMultipart20220118-4-tj428a_html_760240bc10cb0ef8.png)

_Figure 1. Data Science Process._
_# 2_

# Data Sources:

Remember &quot;the _analysis_ of the data, not the amount of data collected, determines the originality and significance of your study – the analysis is what answers your research question, not your data&quot; (Foss and Williams, 2015, p. 50). When thinking of data sources, consider your research question and try to limit the amount of data that you collect.

For each data source fill out the following list. If an item in the list does not apply type &quot;N/A&quot;.

| File Name |
 |
| --- | --- |
| File Type |
 |
| Number of files |
 |
| File storage size |
 |
| Data file dimensions (rows, cols) |
 |
| Principal Investigator |
 |
| Summary |
 |
| Funding Source |
 |
| Scope of Data File |
 |
| Subject Terms |
 |
| Geographic Coverage |
 |
| Time Period(s) |
 |
| Collection Dates |
 |
| Universe |
 |
| Methodology |
 |
| Response Rate |
 |
| Sampling |
 |
| Data Source |
 |
| Collection Mode(s) |
 |
| Scales |
 |
| Weight(s) |
 |
| Unit(s) of Observation |
 |
| Primary Key |
 |
| Foreign Keys |
 |
| Geographic Unit |
 |
| Codebook/Metadata format |
 |
| Data Accessibility
 |
 |
| Owner |
 |
| Cost |
 |
| Time |
 |
| Location |
 |

# Data Cleaning Process:

Data cleaning includes all of the steps needed to convert the source data into datafiles that are useful for data exploration and modeling. The clean datasets should also be considered data products that could be made public. Data cleaning also includes documenting metadata.

| **Typical Data Cleaning Steps** |
 |
| --- | --- |
| Convert file formats |
 |
| Extract patterns in text |
 |
| Merge Files |
 |
| Append Files |
 |
| Drop observations |
 |
| Drop variables |
 |
| Generate new variables |
 |
| Creating variables for analysis |
 |
| Ordering variables |
 |
| Compressing files |
 |
| Recoding variables |
 |
| Dummy (Binary) Variable creation |
 |
| Label variables |
 |
| Add variable notes |
 |
| Add data file notes |
 |
| Adding value labels |
 |
| Using multiple languages |
 |
| Sorting |
 |
| Geocoding |
 |
| Ranking |
 |
| Flagging |
 |
| Filtering Missing Data |
 |
| Imputing (filling in missing data) |
 |
| Adding unique non-missing id |
 |
| Spatial Joins |
 |
| Adding foreign keys for relational databases |
 |
| Pivoting data (transposing wide to long or long to wide) |
 |
| Removing duplicates |
 |
| Detecting outliers |
 |
| Random sampling |
 |
| Working with date-time variables |
 |
| Codebook generation |
 |

# Cleaned Dataset

Describe the expected cleaned dataset.

| File Name |
 |
| --- | --- |
| File Type |
 |
| Number of files |
 |
| File storage size |
 |
| Data file dimensions (rows, cols) |
 |
| Principal Investigator |
 |
| Summary |
 |
| Funding Source |
 |
| Scope of Data File |
 |
| Subject Terms |
 |
| Geographic Coverage |
 |
| Time Period(s) |
 |
| Collection Dates |
 |
| Universe |
 |
| Methodology |
 |
| Response Rate |
 |
| Sampling |
 |
| Data Source |
 |
| Collection Mode(s) |
 |
| Scales |
 |
| Weight(s) |
 |
| Unit(s) of Observation |
 |
| Primary Key |
 |
| Foreign Keys |
 |
| Geographic Unit |
 |
| Codebook/Metadata format |
 |
| Data Accessibility
 |
 |
| Owner |
 |
| Cost |
 |
| Time |
 |
| Location |
 |

# Data Exploration Plan:

Data exploration is a critical step to understanding your data and for checking data quality, validity, and reliability.

| **Typical Data Exploration Steps** |
 |
| --- | --- |
| Summary statistics (count, mean, median, sd, min, max, percentiles) |
 |
| Cross-tabs |
 |
| Correlation matrix |
 |
| Scatterplots |
 |
| Boxplots |
 |
| Histograms |
 |
| T-test |
 |
| ANOVA |
 |
| Spatial exploration (GIS) mapping |
 |
| Temporal exploration – time-series graphs |
 |
|
 |
 |

## Example Table Shells

Include detailed examples of table shells. Please indicate the unit of analysis used in each table.

Table 1. Summary statistics for variables by [unit of analysis].

|
 |
 |
 |
 |
 |
 |
 |
| --- | --- | --- | --- | --- | --- | --- |
|
 | count | min | max | p50 | mean | sd |
| Variable Label 1 |
 |
 |
 |
 |
 |
 |
| --- | --- | --- | --- | --- | --- | --- |
| Variable Label 2 |
 |
 |
 |
 |
 |
 |

Source/Provenance

## Description of Data Exploration Graphs

Include detailed description of planned graphs. Please indicate the unit of analysis used in each graph.

## Description of Data Exploration Maps

Include detailed description of planned maps. Please indicate the unit of analysis used in each map.

# Data Modeling Plan:

Data modeling

| **Typical Data Exploration Steps** |
 |
| --- | --- |
| Summary statistics (count, mean, median, sd, min, max, percentiles) |
 |
| Cross-tabs |
 |
| Correlation matrix |
 |
| Scatterplots |
 |
| Boxplots |
 |
| Histograms |
 |
| T-test |
 |
| ANOVA |
 |
|
 |
 |

# Example Table Shells
# 6

Include detailed examples of table shells. Please indicate the unit of analysis used in each table.

Table 2. Parameter Estimates from Models.

|
 | Model 1 |
| --- | --- |
| Variable Label 1 |
 |
| --- | --- |
|
 |
 |
| Variable Label 2 |
 |
|
 |
 |
| Constant |
 |
| Observations |
 |
| --- | --- |
| Adjusted _R_2 |
 |

Standard errors in parentheses

Source/Provenance

\*_p_ \&lt; 0.05, \*\*_p_ \&lt; 0.01, \*\*\*_p_ \&lt; 0.001

# Data Publication Plan:

[1](#sdfootnote1anc) Much of the text provided in this example outline comes from the data archiving instructions used by ICPSR. For more information visit [https://www.icpsr.umich.edu/icpsrweb/content/datamanagement/index.html](https://www.icpsr.umich.edu/icpsrweb/content/datamanagement/index.html)

[2](#sdfootnote2anc) Caldwell, J. (2016) A Data Science Solution to the Question &quot;What is Data Science?&quot; R-Bloggers Retrieved from [https://www.r-bloggers.com/a-data-science-solution-to-the-question-what-is-data-science/](https://www.r-bloggers.com/a-data-science-solution-to-the-question-what-is-data-science/)

[3](#sdfootnote3anc) Foss and Waters (2015) p. 49 – Try to conceptualize your project so that you can collect the data easily and in a reasonable amount of time.

[4](#sdfootnote4anc) Foss and Waters (2015) p. 49 – Try to conceptualize your project so that you can collect the data easily and in a reasonable amount of time.

[5](#sdfootnote5anc) The idea behind table shells is to create a plan for analysis and to think through the data exploration process. The CDC National Center for Health Statistics requires this as part of their proposal process. For examples see [https://www.cdc.gov/rdc/b3prosal/PP300.htm](https://www.cdc.gov/rdc/b3prosal/PP300.htm)

[6](#sdfootnote6anc) The idea behind table shells is to create a plan for anlaysis and to think through the data exploration process. The CDC National Center for Health Statistics requires this as part of their proposal process. For examples see [https://www.cdc.gov/rdc/b3prosal/PP300.htm](https://www.cdc.gov/rdc/b3prosal/PP300.htm)

25