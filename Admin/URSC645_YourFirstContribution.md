# Steps for making your first contribution
---

## Goal: 
- Make an edit to a Jupyter Notebook (Google Colab) using Visual Studio Code
- Connect GitHub and Visual Studio Code
- Commit and Push edit to GitHub repository
- Create Pull Request to main Branch of repository
- See your edits added to the main repository

## Steps:
* Log in to your GitHub Account
    1. On GitHub.com, navigate to the course repository
        * https://github.com/npr99/URSC645
    2. In the top-right corner of the page, click `Fork`.
        * Forking the course repository creates a snapshot of all of the course files on your GitHub account.
    3. On GitHub.com, navigate to your fork of the course repository.

* Open GitHub for Desktop
    1. Select Clone Repository
    2. Select a folder where the repository files will be saved
        * Create a folder on your local machine
        * With Google Drive for Desktop Installed create this directory
            * `G:\My Drive\MyCourses\URSC645\github_com\`
            * Notice that the folder name includes information on the course number and `github_com` - which is a good reminder of the data source.
    3. GitHub Desktop should copy all of the repository files to your local machine in the folder that you designated. 

* Double check that your repository is synced:
    1. <a href="https://docs.github.com/en/desktop/contributing-and-collaborating-using-github-desktop/keeping-your-local-repository-in-sync-with-github/syncing-your-branch" target="_blank">More details on Syncing your Branch in GitHub desktop</a>
    2. In GitHub Desktop, use the `Current Branch` drop-down, and select the local branch you want to update.
    3. To check for commits on the remote branch, click `Fetch origin`
    4. To pull any commits from the remote branch, click `Pull origin`
    
* From GitHub Desktop select `Open Visual Studio Code`
* Visual Studio Code should launch and connect to your GitHub repository

* In Visual Studio Code
    1. Select the file that you want to contribute to
    2. Edit the file - for example add your name to the author list of a notebook
    3. Save the file (`ctrl+s` is a good short cut key to remember)
    4. Notice that in Visual Studio Code the `Source Control` tab will indicate your change
    5. In `Source Control` click the + button next to `Changes` to stage changes.
    6. Once changes are staged, add a short message that describes your change. You can only enter 50 characters per line. But you can type multiple lines.
    7. Click the check mark to `Commit` changes to your repository
    8. Click `Sync Changes` - this uploads the changes from your local machine to your GitHub repository

* In your GitHub Account
    1. On GitHub.com, navigate to your fork of the course repository.
    2. Click `Contribute` and `Open pull request`
    3. Submit a new pull request 
    
The owner of the course repository will then need to merge the new pull request into the course repository.
