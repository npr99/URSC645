# General Filename Plan for Reproducible Workflow

Filename plan goals: Avoid a data dumpster. Let the filenames tell the story of your project. If read in order, filenames will communicate the path. Good filenames:
- Reinforce all steps in a reproducible workflow. 
- Reinforce provenance for all input and output files. 
- Prepare workflow for publication. 

This filename plan provides basic guidelines to help with reproducible research. 
An ideal filename provides information about the author, the contents, and when the file was made. 
Consistent filenames make finding files easy. 
The need for a clear file naming plan is important for a large research project that produces a large number of files. 
This document outlines the four main parts of a filename. 
These include the provenance or origin of the file, 
the contents of the file, 
the file version, and 
the file type. 
This naming plan can be applied to all files including: survey instruments, data files, and programs such as Jupyter Notebooks.
The following sections provide more details about the filename parts.

![Comic: Never Look in Someone Else's Documents Folder](https://raw.githubusercontent.com/npr99/URSC645/main/.github/images/filename_xkcd.com_1459.png)

## Filename Part 1 – Highlight Provenance

To highlight the project a filename that starts with a mnemonic, a short string of letters, will help future users of the file recognize its provenance or origin. 
For example, TAMU, is an acronym and a mnemonic for the Texas A&amp;M University. 
TAMU has many departments and centers. 
HRRC is the mnemonic for the Hazard Reduction and Recovery Center. 
LAUP is the mnemonic for the Department of Landscape Architecture and Urban Planning.
TAMU, HRRC, and LAUP are all recognizable mnemonics.

Notice that all filenames in the URSC645 project have a recognizable mnemonic that uniquely identifies the provenance of the files.

## Filename Part 2 - Function or Data Science Step

![DataScienceWorkflow_2022](https://user-images.githubusercontent.com/5131566/164036900-ff105fa1-2437-4e41-b421-ef9a0402f568.JPG)

The function of the file provides helpful insight into how the file relates to other files in the project. The data science process (pictured above (Cadwell 2016)) provides one way to organize the functions of files. Ideally files can be sorted by name and reveal the order by which the files should be open or run. 
For example, a program that obtains data should be run before a program that cleans data.

![URSC645_ExampleFileNamesSorted_2022](https://user-images.githubusercontent.com/5131566/164038073-3cdbe34d-0768-441b-aa8c-7106ef6808b4.JPG)

In the example above, the second part of the filenames provides a clue to future users which files should be run and in what order. The second part of the file includes four alpha numeric values that represent:
- data science workflow task number (0-6)
- letter step within task (a,b,c..)
- v = version
- version number (1,2,3,4...)

 The data science steps include:
- 0 = Research Log or Project Admin
- 1 = Obtain Data
- 2 = Clean Data
- 3 = Explore Data
- 4 = Model Data
- 5 = Interpret Data
- 6 = Publish Data

## Filename Part 3 – Describe the Contents

In this example the project mnemonic is followed by the descriptive text that highlights the file contents or function. 
For example, a file that archives the form used in a field study for a food retail survey, could include the text &quot;Food Retail Form&quot;.
To avoid issues sometimes caused by included spaces in filenames each word is separated by an underscore &quot;\_&quot; or a mix of upper case and lower-case letters.

HRRC\_FoodRetailForm\_2018-01-26

The goal of descriptive name is to reduce a future user's need to click on the file and open it. Hopefully the contents are described enough to help identify what is inside the file.


## Filename Part 4 - Version Control

The example above includes the third part of the filename, the date. 
The date in the format year, month, date (YYYY-MM-DD) follows an international standard (ISO 8601). 
Typing the date in this format means that files will appear in chronological order in file directory. 
Also, by including the date of the file, a future user of the file will be able to easily confirm the version. 
If the date does not provide enough information to identify the version a zero padded version number might be appropriate. 
For example, adding v03 would allow for up-to 99 different versions of a file to be tracked.


![Final.doc PhD Comics](https://raw.githubusercontent.com/npr99/URSC645/main/.github/images/phdcomics_version_control_motivation_comics.png)

## Filename Part 5 – File Type Extension

After the filename, each file includes a file type extension (.xlsx, .csv, .pdf etc.). 
The file type extension provides a way to differentiate files that may have the same name. 
For example:

- HRRC_FoodRetailForm_2018-01-26.docx
- HRRC_FoodRetailForm_2018-01-26.pdf

The two files have the same name but one file is a Word Document and the second file is a PDF. 
The two files have the same contents but provide future users with a file format that can be edited (the Word Document) and 
a file format that preserves the original formatting (the PDF).

**How to turn on file extensions on a Windows computer**
![image](https://user-images.githubusercontent.com/5131566/150422462-fc33e914-9720-41fe-9fa2-c39eaaa30a7c.png)

# Use of Special Characters and Filename Length

Names best tolerated by the widest variety of systems use a combination of letters (A-Z, a-z), numbers (0-9), underscores (\_), and hyphens (-). 
The filename plan presented above uses an underscore &quot;\_&quot; to separate the parts of the naming plan and dashes within the date format YYYY-MM-DD.

Filenames and paths longer than 255 characters may not be readable by some operating systems, such as LINUX (260 for Windows).
Therefore, filenames (including the path) must be less than 255 characters. Additionally, since the filenames are designed to be viewed on a screen with limited width, 
filenames longer than 80 characters will be cutoff, requiring the user to scroll to see the full name. 
Therefore, it is recommended that file names not exceed 80 characters.

# Tell a story

![PhD Comics #1323 Filenames tell a story](https://raw.githubusercontent.com/npr99/URSC645/main/.github/images/phdcomics_filenamestory_1323.jpg)

Let your file names tell the story of the project workflow. As one reads the file names in order (sort by name) the names should give a hint as to how the data has been obtained, cleaned, explored and modeled.
 
# Summary

A good naming plan needs to be easy to understand and should be consistent. 
The filename plan presented is designed to reinforce the project goals, 
project management, and to help future users easily navigate files shared publicly.

![The Mona_Lisa_finalrealupdateFINALL6](https://raw.githubusercontent.com/npr99/URSC645/main/.github/images/NathanPyle_MonaLisaFileName.jpg)

# References

Cadwell, Joel. (2016). A Data Science Solution to the Question "What is Data Science?". Retrieved from [https://www.r-bloggers.com/2016/01/a-data-science-solution-to-the-question-what-is-data-science/](https://www.r-bloggers.com/2016/01/a-data-science-solution-to-the-question-what-is-data-science/)

Cham, Jorge. (2012). Final.doc https://phdcomics.com/comics/archive.php?comicid=1531

Cornell University Research Data Management Service Group. (n.d.). _File Management._ Retrieved from [https://data.research.cornell.edu/content/file-management](https://data.research.cornell.edu/content/file-management)

Hodge, A. (2015). _File Naming Best Practices_. Stanford Data Management Services. Retrieved from [https://library.stanford.edu/research/data-management-services/data-best-practices/best-practices-file-naming](https://library.stanford.edu/research/data-management-services/data-best-practices/best-practices-file-naming)

ISO. (n.d.). _Popular Standards: ISO 8601 DATE AND TIME FORMAT_. [https://www.iso.org/iso-8601-date-and-time-format.html](https://www.iso.org/iso-8601-date-and-time-format.html)

Long, J. S. (2016, August). _Reproducible Results and the Workflow of Data Analysis_. Indiana University Workshop in Methods. [http://hdl.handle.net/2022/20969](http://hdl.handle.net/2022/20969)

NIST Weights and Measures. (2016). _Electronic File Organization Tips_. Retrieved from. [https://www.nist.gov/system/files/documents/pml/wmd/labmetrology/ElectronicFileOrganizationTips-2016-03.pdf](https://www.nist.gov/system/files/documents/pml/wmd/labmetrology/ElectronicFileOrganizationTips-2016-03.pdf)

University of Illinois Research Data Service. (2017). _Organize Your Data_. Retrieved from [https://www.library.illinois.edu/rds/organize/](https://www.library.illinois.edu/rds/organize/)

Wikipedia. (2019). ISO 8601. [https://en.wikipedia.org/wiki/ISO\_8601](https://en.wikipedia.org/wiki/ISO_8601)

XKCD (n.d.) Documents. https://xkcd.com/1459/