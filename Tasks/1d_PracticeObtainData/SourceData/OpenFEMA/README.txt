READ ME
OpenFEMA Data
webpage level 1:https://www.fema.gov/about/openfema/data-sets
webpage level 2: https://www.fema.gov/openfema-data-page/individuals-and-households-program-valid-registrations-v1

Description
This dataset contains FEMA applicant-level data for the Individuals and Households Program (IHP). 
All PII information has been removed. The location is represented by county, city, and zip code. 
This dataset contains IA applications from DR1439 (declared in 2002) to those declared over 30 days ago. 
The full data set is refreshed on an annual basis. 
A weekly refresh occurs to update disasters declared in the last 18 months.

IHP is intended to meet basic needs and supplement disaster recovery efforts. 
The IHP is not intended to return disaster-damaged property to its pre-disaster condition. 
Disaster damage to secondary or vacation homes does not qualify for IHP assistance.

This is raw, unedited data from FEMA's National Emergency Management Information System (NEMIS) 
and as such is subject to a small percentage of human error.

Any financial information is derived from NEMIS and not FEMA's official financial systems. 
Due to differences in reporting periods, status of obligations and how business rules are applied, 
this financial information may differ slightly from official publication on public websites such as usaspending.gov; 
this dataset is not intended to be used for any official federal financial reporting.

This dataset is not intended to be an official federal report, and should not be considered an official federal report.

Citation: The Agency's preferred citation for datasets (API usage or file downloads) can be found on 
the OpenFEMA Terms and Conditions page, 
Citing Data section: https://www.fema.gov/about/openfema/terms-conditions.

Due to the size of this file, tools other than a spreadsheet may be required to 
analyze, visualize, and manipulate the data. 
MS Excel will not be able to process files this large without data loss. 
It is recommended that a database (e.g., MS Access, MySQL, PostgreSQL, etc.) 
be used to store and manipulate data. Other programming tools such as R, Apache Spark, 
and Python can also be used to analyze and visualize data. Further, basic Linux/Unix tools 
can be used to manipulate, search, and modify large files.

If you have media inquiries about this dataset, please email the 
FEMA News Desk FEMA-News-Desk@dhs.gov or call (202) 646-3272. 
For inquiries about FEMA's data and Open government program please contact the OpenFEMA team via email OpenFEMA@fema.dhs.gov.

Full Data
Format		Address		Record Count		Approximate File Size
csv		Link to csv	20572398		large (500MB - 10GB)


Access the metadata API calls for additional information:

https://www.fema.gov/api/open/v1/OpenFemaDataSets?$filter=name%20eq%20%27IndividualsAndHouseholdsProgramValidRegistrations%27
https://www.fema.gov/api/open/v1/OpenFemaDataSetFields?$filter=openFemaDataSet%20eq%20%27IndividualsAndHouseholdsProgramValidRegistrations%27%20and%20datasetVersion%20eq%201
Last updated January 29, 2023