* Start log file output printto command will redirect log window to file;
proc printto log="TMPWF_1av1_readindata_20190228.log";
run;

/********-*********-*********-*********-*********-*********-*********/
/* Description of Program                                           */
/********-*********-*********-*********-*********-*********-*********/
* program:    TMPWF_1av1_readindata_20190228.SAS
* task:       Read in ACS Data to SAS, select county level data, output
* project:    Template Workflow Example
* author:     Nathanael Rosenheim \ Feb 27 2019;

/********-*********-*********-*********-*********-*********-*********/
/* Control SAS                                                      */
/********-*********-*********-*********-*********-*********-*********/
options linesize=80; * specifies the output line length;
options SYMBOLGEN MPRINT; *see how macro variables are resolved;

/*-------------------------------------------------------------------*/
/* Important Folder Locations                                        */
/*-------------------------------------------------------------------*/
* Confirm that the current directory;
* NOTE: If SAS is launched by double-clicking the .sas file the 
		current directory should be the same as the file;
* Find the file path and filename;
%let filepath = %sysget(SAS_EXECFILEPATH);
%let length_filepath = %length(&filepath);
%let filename = %sysget(SAS_EXECFILEname);
%let length_filename = %length(&filename);

* Use substring to remove the filename from the path;
%let cd = %qsubstr(&filepath, 1,&length_filepath-&length_filename);
%put The current directory is: &cd;

%LET rootdir = &cd;
* Where will the sas7bdat files be saved?;
%LET dd_SASLib = &rootdir.TMPWF_1av1_readindata_20190228/;
/*-------------------------------------------------------------------*/
/* Define SAS Library                                                */
/*-------------------------------------------------------------------*/
%let library = Output;
LIBNAME &library "&dd_SASLib";

/********-*********-*********-*********-*********-*********-*********/
/* Obtain Data                                                      */
/********-*********-*********-*********-*********-*********-*********/

* Source File
https://www2.census.gov/programs-surveys/acs/summary_file/2017/data/5_year_seq_by_state/Texas/All_Geographies_Not_Tracts_Block_Groups/;

* READ IN ESTIMATES FILE;
filename ACSfile ZIP 'SourceData/20175tx0001000.zip' member='e20175tx0001000.txt';
DATA work.SFe0001tx;
	LENGTH FILEID   $6
		   FILETYPE $6
		   STUSAB   $2
		   CHARITER $3
		   SEQUENCE $4
		   LOGRECNO $7;

	INFILE ACSfile DSD TRUNCOVER DELIMITER =',' LRECL=3000;

	LABEL FILEID  ='File Identification'
       FILETYPE='File Type'  
 	   STUSAB  ='State/U.S.-Abbreviation (USPS)'
 	   CHARITER='Character Iteration'
 	   SEQUENCE='Sequence Number'
 	   LOGRECNO='Logical Record Number';

	ATTRIB 
		B00001e1 format = comma16. label ='UNWEIGHTED SAMPLE COUNT OF THE POPULATION Universe:  Total Population: Total: (e)'
		B00002e1 format = comma16. label ='UNWEIGHTED SAMPLE HOUSING UNITS Universe:  Housing Units: Total: (e)';

	INPUT
		FILEID   $ 
		FILETYPE $ 
		STUSAB   $ 
		CHARITER $ 
		SEQUENCE $ 
		LOGRECNO $
		B00001e1
		B00002e1;
run;

* READ IN Margin of Error FILE;
filename ACSfile ZIP 'SourceData/20175tx0001000.zip' member='m20175tx0001000.txt';
DATA work.SFm0001tx;
	LENGTH FILEID   $6
		   FILETYPE $6
		   STUSAB   $2
		   CHARITER $3
		   SEQUENCE $4
		   LOGRECNO $7;

	INFILE ACSfile DSD TRUNCOVER DELIMITER =',' LRECL=3000;

	LABEL FILEID  ='File Identification'
       FILETYPE='File Type'  
 	   STUSAB  ='State/U.S.-Abbreviation (USPS)'
 	   CHARITER='Character Iteration'
 	   SEQUENCE='Sequence Number'
 	   LOGRECNO='Logical Record Number';

	ATTRIB 
		B00001m1 format = comma16. label ='UNWEIGHTED SAMPLE COUNT OF THE POPULATION Universe:  Total Population: Total: (m)'
		B00002m1 format = comma16. label ='UNWEIGHTED SAMPLE HOUSING UNITS Universe:  Housing Units: Total: (m)';

	INPUT
		FILEID   $ 
		FILETYPE $ 
		STUSAB   $ 
		CHARITER $ 
		SEQUENCE $ 
		LOGRECNO $
		B00001m1
		B00002m1;
run;

* READ IN Geography FILE;
* Code to read in data from:
https://www2.census.gov/programs-surveys/acs/summary_file/2017/documentation/user_tools/SF_All_Macro_5YR.sas;

data work.g20175tx;
INFILE "SourceData/g20175tx.txt" MISSOVER TRUNCOVER LRECL=500;
LABEL	
		FILEID  ='File Identification'              STUSAB   ='State Postal Abbreviation'
		SUMLEVEL='Summary Level'                    COMPONENT='geographic Component'
		LOGRECNO='Logical Record Number'            US       ='US'
		REGION  ='Region'                           DIVISION ='Division'
		STATECE ='State (Census Code)'              STATE    ='State (FIPS Code)'
		COUNTY  ='County'                           COUSUB   ='County Subdivision (FIPS)'
		PLACE   ='Place (FIPS Code)'                TRACT    ='Census Tract'
		BLKGRP  ='Block Group'                      CONCIT   ='Consolidated City'
		CSA     ='Combined Statistical Area'        METDIV   ='Metropolitan Division'
		UA      ='Urban Area'                       UACP     ='Urban Area Central Place'
		VTD     ='Voting District'                  ZCTA3    ='ZIP Code Tabulation Area (3-digit)'
		SUBMCD  ='Subbarrio (FIPS)'                 SDELM    ='School District (Elementary)'
		SDSEC   ='School District (Secondary)'      SDUNI    ='School District (Unified)'
		UR      ='Urban/Rural'                      PCI      ='Principal City Indicator'
		TAZ     ='Traffic Analysis Zone'            UGA      ='Urban Growth Area'
		GEOID   ='geographic Identifier'            NAME     ='Area Name' 					    
		AIANHH  ='American Indian Area/Alaska Native Area/Hawaiian Home Land (Census)'
		AIANHHFP='American Indian Area/Alaska Native Area/Hawaiian Home Land (FIPS)'
		AIHHTLI ='American Indian Trust Land/Hawaiian Home Land Indicator'
		AITSCE  ='American Indian Tribal Subdivision (Census)'
		AITS    ='American Indian Tribal Subdivision (FIPS)'
		ANRC    ='Alaska Native Regional Corporation (FIPS)'
		CBSA    ='Metropolitan and Micropolitan Statistical Area'
		MACC    ='Metropolitan Area Central City'	
		MEMI    ='Metropolitan/Micropolitan Indicator Flag'
		NECTA   ='New England City and Town Combined Statistical Area'
		CNECTA  ='New England City and Town Area'
		NECTADIV='New England City and Town Area Division'
		CDCURR  ='Current Congressional District'
		SLDU    ='State Legislative District Upper'	
		SLDL    ='State Legislative District Lower'
		ZCTA5   ='ZIP Code Tabulation Area (5-digit)'
		PUMA5   ='Public Use Microdata Area - 5% File'
		PUMA1   ='Public Use Microdata Area - 1% File';

INPUT
		FILEID    $ 1-6         STUSAB    $ 7-8			SUMLEVEL  $ 9-11							
		COMPONENT $ 12-13       LOGRECNO  $ 14-20		US        $ 21-21  
		REGION    $ 22-22       DIVISION  $ 23-23		STATECE   $ 24-25							
		STATE     $ 26-27       COUNTY    $ 28-30		COUSUB    $ 31-35 
		PLACE     $ 36-40       TRACT     $ 41-46		BLKGRP    $ 47-47							
		CONCIT    $ 48-52       AIANHH    $ 53-56		AIANHHFP  $ 57-61
		AIHHTLI   $ 62-62       AITSCE    $ 63-65		AITS      $ 66-70							
		ANRC      $ 71-75       CBSA      $ 76-80		CSA       $ 81-83
		METDIV    $ 84-88       MACC      $ 89-89		MEMI      $ 90-90							
		NECTA     $ 91-95       CNECTA    $ 96-98		NECTADIV  $ 99-103	
		UA        $ 104-108     UACP      $ 109-113		CDCURR    $ 114-115						    
		SLDU      $ 116-118     SLDL      $ 119-121		VTD       $ 122-127
		ZCTA3     $ 128-130     ZCTA5     $ 131-135		SUBMCD    $ 136-140						    
		SDELM     $ 141-145     SDSEC     $ 146-150		SDUNI     $ 151-155
		UR        $ 156-156     PCI       $ 157-157		TAZ       $ 158-163							
		UGA       $ 164-168     PUMA5     $ 169-173		PUMA1     $ 174-178
		GEOID     $ 179-218     NAME      $ 219-418;
run;

/********-*********-*********-*********-*********-*********-*********/
/* Explore Data for Unique ID                                       */
/********-*********-*********-*********-*********-*********-*********/

/* Use the NLEVELS option with the ODS SELECT statement to capture the */
/* number of levels for a variable. */

data _NULL_;
	set work.SFe0001tx nobs=n;
	* Save number of observations as macro nrows;
	call symputx('nrows',n);
run;
%put nobs=&nrows;

ods select nlevels;

proc freq data=work.SFe0001tx nlevels;
   tables FILEID
		FILETYPE
		STUSAB
		CHARITER
		SEQUENCE
		LOGRECNO
		B00001e1
		B00002e1;
title 'Number of distinct values for each variable'; 
run; 

/********-*********-*********-*********-*********-*********-*********/
/* Merge Estimates, MOE and Geography Files                         */
/********-*********-*********-*********-*********-*********-*********/

data work.SFem0001tx;
	  merge  work.SFe0001tx(IN=x) work.SFm0001tx(IN=y);
   		by logrecno;
run;

data work.SFemg0001tx;
  	 merge  work.g20175tx(IN=g) work.SFem0001tx(IN=x);
   		by logrecno;
run;

/* Add year and file to file */
data work.SFemg0001tx REPLACE;
	Set work.SFemg0001tx;
	ACSFile = "acs2017_5yr";
	ACSYear = 2017;
run;

* Reorder variables;
data work.SFemg0001tx REPLACE;
	Retain ACSFile ACSYear;
	Set work.SFemg0001tx;
run;

/********-*********-*********-*********-*********-*********-*********/
/* Keep Observations with Estimates                                 */
/********-*********-*********-*********-*********-*********-*********/

* Look at summary levels;
* List of sumlevel codes:
https://factfinder.census.gov/help/en/summary_level_code_list.htm;

* Keep sumlevel for county;
data work.SFemg0001txv_county REPLACE;
	Set work.SFemg0001tx (where=(SUMLEVEL="050"));
run;

* Keep key variables;
data output.SFemg0001txv_county REPLACE;
	Set work.SFemg0001txv_county
		(keep=
			ACSFile
			ACSYear
			FILEID STUSAB SUMLEVEL STATE COUNTY NAME 
			B00001e1--B00002m1);
run;

/********-*********-*********-*********-*********-*********-*********/
/* Export File as CSV                                               */
/********-*********-*********-*********-*********-*********-*********/

proc export data=output.SFemg0001txv_county
   outfile="TMPWF_1av1_readindata_20190228/SFemg0001txv_county.csv"
   dbms=csv
   replace;
run;

ODS PDF FILE = "TMPWF_1av1_readindata_20190228/SFemg0001txv_county_codebook.pdf";
ODS PDF STYLE = JOURNAL;

proc contents
     data = output.SFemg0001txv_county
          varnum
          out = SFemg0001txv_countyv2_codebook
               (keep = name label varnum type format);
	 title "Contents of ACS 2017 5 year Data for Texas";
run;

proc means data = output.SFemg0001txv_county;
	var _NUMERIC_;
	title 'Summary Statistics for Numeric Variables';
run;

options obs=5; * Look at first 5 observations;
proc print data = output.SFemg0001txv_county;
   var _CHARACTER_;
   title 'Example Values for Character Variables';
run;
options obs=MAX; * Turn off set obs;
ODS PDF CLOSE;

/********-*********-*********-*********-*********-*********-*********/
/* Close Log File                                                   */
/********-*********-*********-*********-*********-*********-*********/
* Turn off Print to for log file;
proc printto; run;
