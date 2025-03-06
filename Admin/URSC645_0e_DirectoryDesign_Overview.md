# Directory Design

![Data Dumpster or Data Directory](https://raw.githubusercontent.com/npr99/URSC645/main/.github/images/AdobeExpress_DataDumpsterorDirectory2025-01-10.png)

In the context of a computer, the terms "directory" and "folder" refer to a container used to organize and store files and other directories within a digital storage system. A well-designed directory structure helps one avoid the "data dumpster" scenario where files are difficult to locate. Good directory design promotes reproducibility, and avoids confusion about which files are used within the workflow. The proposed design will help reduce the complexity of data management and make it easier to find, share and reuse a project's research.

![Directory Design Views for URSC 645](https://raw.githubusercontent.com/npr99/URSC645/main/.github/images/URSC645_DirectoryDesignOverview_2025-01-14.jpg)

## Directory or Folder Descriptions
---

***General note on directory names***  Avoid using spaces in the folder names. To remove spaces try use camel case (SourceData) and/or underscores "_" (Source_Data) to separate words. Also, directory names should not contain periods "." in them. Python code will have issues with using "." in directory names.


**Admin**      = Administration Folder = Folder has files and guides to introduce project. Folder may contain proposals, budgets, hiring documents, etc. Using the word Admin also helps to have this folder at the top of the list of folders.

**SourceData** = Folder contains data that many project members may want to use. 
The goal is to not have multiple copies of the same files. 
Use the SourceData folder to preserve the original data and metadata. Within the SourceData folder include folders for each data source. The folder names should represent the provenance of the data. For example, data from the US Census Bureaus data.census.gov could be in a folder named "data_census_gov". 

**Work[]** = Work folders will be found inside a project or task folder. Work folder names include the initials of the person that works within the folder. For example, Nathanael's work folders are named WorkNPR (work folder for Nathanael P. Rosenheim). Work folders contain any work logs, files, documents, or generated data related to the specific project or task. The Work Log within the work folder relates to the specific project or task. For larger projects individual project members may have multiple work folders as they work on multiple parts of a larger project. For example, in URSC 645 Dr. Rosenheim will create a work folder within each student's project folder. 

**Posted** = Archived files needed for replicating work that has been shared. Shared work may include files needed to replicate an assignment, work shared for a team meeting, work shared at a conference or tables or figures in a journal article. Basically any work that one project member wants to share outside of their work folder should be placed in the posted folder. ***WARNING*** Files within the posted folder are for archiving only. You should only copy from your Work folder to paste into the Posted folder or copy files from the Posted folder to be pasted in your Work folder. Within your scripts ***DO NOT*** read files from the posted folder or save files to the posted folder. 

### Optional Folders

**Readings** = [_Optional_] Folder contains readings and annotated bibliographies related to the project. 

**Projects** = [_Optional_] Folder contains sub-projects for the main project - usually specific to an individual person or team. Having project folders within project folders allows for a project to scale up. The directory design for each sub-project should match the larger project. For example, URSC 645 is the main project and each student will have their own sub-project within the Projects folder. Within the student's project there will be the same directory design (e.g. Admin, SourceData, Work, Readings, etc.).

**Tasks** = [_Optional_] Folder contains tasks - usually a specific activity that anyone on project may need to accomplish. For example, setting up the python environment or completing a specific training. Tasks are related to the main project or could be within a sub-project. These tasks could be consider "onboarding" tasks that new project members need to complete.

**Archive** = [_Optional_] As a folder gets cluttered it is good to clean up with an archive folder. The folder can contain old versions of scripts or out-of-date files that are not needed for replication. Archive folders are a great way to clean up a Work Folder or the Posted Folder. It is good to keep old versions of files in case you need to go back to them.

---
# _USE RELATIVE PATHS_ 
The directory design is intended to be used with relative paths.
For more information on how to use relative paths see: https://www.kaggle.com/code/rtatman/reproducibility-tips-absolute-vs-relative-paths

If you apply this directory design a file that is Posted from one Work Folder will run in another Work Folder. Similarly, a file that runs in one project folder will run in another project folder that uses the same directory design. 

---
## Other Directory Design Options
A goal of good directory design is to make it easy to find files and to make it easy to replicate work. 
Ideally the directories sort themselves into a logical order based on the directory names. 
If you need a directory to be at the top of the list of directories you can use a number to start the directory name.
For example, "00_Admin" will be at the top of the list of directories. 
To help ensure that your have enough numbers, use two digits for the numbers (01, 02, 03...).

---
## References
Chuang, E., Diamond Pollock, H., Wykstra, S. (2015). Reproducible Research: Best Practices for Data and Code Management. _Innovations for Poverty Action_. https://poverty-action.org/sites/default/files/publications/IPA-Best-Practices-for-Data-and-Code-Management-Nov-2015.pdf

Long, S. (2009). The Workflow of Data Analysis Using Stata. Stata Press. https://www.stata.com/bookstore/workflow-data-analysis-stata/