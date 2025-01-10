## Directory and Folder Name Structure

![Data Dumpster or Data Directory](https://raw.githubusercontent.com/npr99/URSC645/main/.github/images/AdobeExpress_Data Dumpster or Directory 2025-01-10.png)

**Admin**      = Administration Folder = Folder has files and guides to introduce project. Folder may contain proposals, budgets, hiring documents, etc. Using the word Admin also helps to have this folder at the top of the list of folders.

**SourceData** = Folder contains data that many project members may want to use. 
The goal is to not have multiple copies of the same files. 
Also to preserve the original data and metadata. Within the SourceData folder include folders for each data source. The folder names should represent the provenance of the data. For example, data from the US Census Bureaus data.census.gov could be in a folder named "data_census_gov". 

**Projects** = [_Optional_] Folder contains subprojects for the main project - usually specific to an individual person or team. Having project folders within project folders allows for a project to scale up.

**Tasks** = [_Optional_] Folder contains tasks - usually a specific activity that anyone on project may need to accomplish. For example, setting up the python environment or completing a specific training. Tasks are related to the main project or could be within a subproject. These tasks could be consider "onboarding" tasks that new project members need to complete.

**Work[]** = Work folders will be found inside a project or task folder. Work folder names include the initials of the person. For example, Nathanael's work folders are named WorkNPR (work folder for Nathanael P. Rosenheim). Work folders contain any files, documents, generated data... related to the specific project or task. Work folders should also include a WorkLog file specific to the project or task. 

**Posted** = Archived files needed for replicating work that has been shared - 
- journal article
- conference paper
- poster
- data archive
- work shared internally for the team
In replication scripts DO NOT SAVE to or READ from the Posted folder. The Posted folder is for archiving only. You should only copy from your Work folder to paste into the Posted folder or copy files from the Posted folder to be pasted in your Work folder.
        
**Readings** = [_Optional_] Folder contains readings related to the project.

***Note on directory names*** Directory names should not contain spaces. Use Camel Case and/or underscores "_" to separate words. Directory names could have "." in them, but more advanced python code may have issues with using "." in directory names.

**Archive** = [_Optional_] As a folder gets cluttered it is good to clean up with an archive folder. The folder can contain old versions of scripts or out-of-date files that are not needed for replication. Archive folders are a great way to clean up a Work Folder or the Posted Folder. It is good to keep old versions of files in case you need to go back to them.

---
# USE RELATIVE PATHS 
The directory design is intended to be used with relative paths.
For more information on how to use relative paths see: https://www.kaggle.com/code/rtatman/reproducibility-tips-absolute-vs-relative-paths

If you apply this directory design a file that is Posted from one Work Folder will run in another Work Folder. 

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