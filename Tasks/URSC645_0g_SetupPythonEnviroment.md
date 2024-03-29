# Setup your First Python Environment
---

## Windows 64-bit (should be similar for MacOS)

### Install Miniconda
Since python is open source, you have to manage the environments yourself. **Miniconda** is a tool to help you do that. It is a free minimal installer for conda. It includes conda, Python, the packages they depend on.

1. Download the latest Miniconda3 installer conda page. Miniconda is a lighter version of Anaconda.

- https://docs.conda.io/en/latest/miniconda.html
- Most likely select the most recent [64-bit version](https://docs.conda.io/en/latest/miniconda.html) for your Operating System 

2. Run the installer setup
- Depending on the installation you might be asked to choose from different setups.

- Run the installer setup locally; select **Just Me** choice to avoid the need for administrator privileges.

- Leave the default folder path. For your information, the default path is

```
C:\Users\<username>\AppData\Local\miniconda3
```

- Do not add Miniconda3 to the PATH. 
- Do, however, register Miniconda3 as the default Python environment.
- Select `Clear the package cache upong completion`

### Create the URSC 645 Python environment
1. Open up an Anaconda prompt from the Windows Start menu. The `base` environment is being activated and the prompt changes to: `(base) C:\Users\<user>`

2. Add conda-forge channel - [conda-forge is a good source for python packages, which works better than the default conda channel](https://conda-forge.org/docs/user/introduction.html#:~:text=Conda%2Dforge%20is%20a%20community,by%20our%20conda%2Dforge%20organization.)
```
conda config --add channels conda-forge
```

3. Create the python environment (for this example we choose URSC645) and activate it

```
conda create -n URSC645 python=3.10
```

> note: the python version should match the miniconda python version. The most recent version is 3.10. Using different versions of python can cause issues.

4. In Anaconda Prompt - Activate the new environment and install required packages. Use the following command line prompts in sequence to activate and install the required packages. Copy and paste each command line and paste it into the Anaconda Prompt. Press enter to execute the command.

```
conda activate URSC645
conda install pandas
conda install geopandas
conda install jupyter
conda install contextily
conda install descartes
conda install openpyxl
conda install dask
```
Note: This process can take a long time and depends on a solid internet connection.

5. How to check your environment? Use the command `conda list` in Anaconda Prompt to see what packages and the versions are installed in an environment.
- The steps above created an environment with 279 python packages (the 7 required and the packages that they require)
- The primary packages that were installed on 2023-02-08 included the following versions, builds, and channels
```
# Name                    Version
contextily                1.3.0
descartes                 1.1.0
geopandas                 0.12.2
jupyter                   1.0.0
openpyxl                  3.1.0
pandas                    1.3.5
python                    3.10.9
```
- If your environment does not have these versions of the primary packages the code may or may not replicate. 
- Try to replicate the code provided by this course, if it does not replicate the issue might be with the environment.

### Check that new environment is available in VS Code
1. In Visual Studio Code this new environment will be provided as an option for running your Jupyter Notebooks and Python Code.
2. Open a Jupyter Notebook in VS Code
3. Try to run a cell in the notebook.
4. VS Code should prompt you to select a Python environment. Select the URSC645 environment.
5. Run the cell again. It should run without errors.

---
### Known installation issues
- OpenSSL error

### How to uninstall Anaconda and Miniconda
If you have issues with your Anaconda or Miniconda installation, you can uninstall it and reinstall it.

Look for the uninstaller located in the folder:

```
C:\Users\<username>\AppData\Local\Anaconda3
C:\Users\<username>\AppData\Local\miniconda3
C:\Users\<username>\Anaconda3
C:\Users\<username>\miniconda3
```
> note: the folder name will be different depending on the version of Anaconda or Miniconda you installed.

> note: The AppData folder may be hidden. Type the path in the address bar of Windows Explorer to access the folder.

### How to remove a conda environment
Sometimes you might need to remove a conda environment. This can be done using the following command line prompt:

```
conda env remove -n <env_name>
```
For URSC 645, the command would be:

```
conda env remove -n URSC645
```