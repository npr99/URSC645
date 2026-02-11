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
conda create -n URSC645 python=3.12
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
conda install fiona
conda install seaborn
```
Note: This process can take a long time and depends on a solid internet connection.

5. How to check your environment? Use the command `conda list` in Anaconda Prompt to see what packages and the versions are installed in an environment.
- The steps above created an environment with 300 python packages (the 9 required and the packages that they require)
- The primary packages that were installed on 2026-01-29 included the following versions, builds, and channels
```
Name                      Version            Build           Channel
contextily                       1.7.0                  pyhd8ed1ab_0           conda-forge
dask                             2026.1.1               pyhcf101f3_0           conda-forge
descartes                        1.1.0                  pyhd8ed1ab_5           conda-forge
fiona                            1.10.1                 py312h3f2e00f_6        conda-forge
geopandas                        1.1.2                  pyhd8ed1ab_0           conda-forge
jupyter                          1.1.1                  pyhd8ed1ab_1           conda-forge
openpyxl                         3.1.5                  py312h83acffa_3        conda-forge
pandas                           3.0.0                  py312h95189c4_0        conda-forge
python                           3.12.12                h0159041_2_cpython     conda-forge
seaborn                          0.13.2                 hd8ed1ab_3             conda-forge

```
- If your environment does not have these versions of the primary packages the code may or may not replicate. 
- Try to replicate the code provided by this course, if it does not replicate the issue might be with the environment.

## Install Visual Studio Code
"Learning to code is intimidating, so set yourself up for success with a tool built for you. 
Visual Studio Code is a free coding editor that helps you start coding quickly. 
Use it to code in any programming language, without switching editors."

https://code.visualstudio.com/?wt.mc_id=DX_841432

To run python in Visual Studio code requires installing Python. If you have followed the steps for create the URSC 645 Python environment, then you have python installed.

### Installed and now need to install extensions:
[How to manage extensions](https://code.visualstudio.com/docs/editor/extension-marketplace)
- Python Extension
- Jupyter Extension
- GitHub Copilot (now free)
- Code Spell Checker
- vscode-pdf

### Check that new environment is available in VS Code
1. In Visual Studio Code this new environment will be provided as an option for running your Jupyter Notebooks and Python Code.
2. Open a Jupyter Notebook in VS Code
3. Try to run a cell in the notebook.
4. VS Code should prompt you to select a Python environment. Select the URSC645 environment.
5. Run the cell again. It should run without errors.

---
### Known installation issues
- OpenSSL error

Error installing openpyxl on MacOS
```
pip install --user openpyxl
```

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

> note: The folder may not be deleted after the uninstall. You may have to delete the folder before reinstalling.

### How to uninstall VS Code
[Uninstall Visual Studio Code](https://code.visualstudio.com/docs/setup/uninstall)

Restarted computer for good measure

Also delete the folder:
C:\Users\<username>\.vscode

The .vscode folder includes all of the VS Code settings and extensions.

### How to remove a conda environment
Sometimes you might need to remove a conda environment. This can be done using the following command line prompt:

```
conda env remove -n <env_name>
```
For URSC 645, the command would be:

```
conda env remove -n URSC645
```

### How to remove a conda channel
If you accidentally misspell a channel name, you can remove it using the following command line prompt:

```
conda config --show channels
conda config --remove channels <channel_name>
``` 
