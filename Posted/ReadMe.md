# Welcome the Posted folder

This folder contains archived files needed for replicating work that has been shared.

Shared work may include files needed to replicate:
- Assignments
- Work shared for a team meeting
- Work shared at a conference
- Tables or figures in a journal article. 

Basically any work that one project member wants to share outside of their work folder should be placed in the posted folder. 

# Check out a file and run it
The files in the Posted folder for URSC 645 are designed to be "check out". Within your cloned GitHub repository create your own Work Folder (at the same level as the Posted Folder). The repository is set to [ignore](..\.gitignore) any folder that starts with the `Work` or `work`. 

# ***WARNING - Archive ONLY*** 

Files within the posted folder are for archiving only. You should only copy from your Work folder to paste into the Posted folder or copy files from the Posted folder to be pasted in your Work folder. 

# ***DO NOT RUN FROM OR WRITE TO*** 
Do not run any files within the Posted folder. Copy and paste the files from the Posted folder to your Work folder. Make sure that you have not accidentally removed a file from the posted folder. 

Do not read from or write to the Posted folder. In other words, say you have a script in your Work folder, do not read a file from the Posted folder or write a file to the Posted folder within the script. To check this make sure that the Posted folder is never included in any relative paths within your scripts.

# _USE RELATIVE PATHS_ 
Scripts within the Posted Folder ***MUST*** use relative paths. When one project member copies a script file in the posted folder and pastes the file in their work folder, the script should run without having to modify any folder paths.

Example Relative Path:
```
..\SourceData\lehd_ces_census_gov\LODES\dc\dc_xwalk.csv
```
The above path refers to a file that is one directory above the current directory and then within the SourceData folder.

For more information on how to use relative paths see: https://www.kaggle.com/code/rtatman/reproducibility-tips-absolute-vs-relative-paths