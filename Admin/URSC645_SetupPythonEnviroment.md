## Setup your First Python Enviroment
---

### Windows 64-bit (should be similar for MacOS)

1. Download the latest Anaconda3 installer from Anaconda page.

- https://www.anaconda.com/distribution/

2. Run the installer setup
- Depending on the installation you might be asked to choose from different setups.

- Run the installer setup locally; select Just Me choice to avoid the need for administrator privileges.

- Leave the default folder path. For your information, the default path is

```
C:\Users\<username>\..\anaconda3
```

- Do not add Anaconda to the PATH. 
- Do, however, register Anaconda as the default Python environment.

3. Open up an Anaconda prompt from the Windows Start menu. The `base` environment is being activated and the prompt changes to: `(base) C:\Users\<user>`

4. Add conda-forge channel - [conda-forge is a good source for python packages, which works better than the default conda channel](https://conda-forge.org/docs/user/introduction.html#:~:text=Conda%2Dforge%20is%20a%20community,by%20our%20conda%2Dforge%20organization.)
```
conda config --add channels conda-forge
```

5. Create the python environment (for this example we choose URSC645) and activate it

```
conda create -n URSC645 python=3.7
```

6. In Anaconda Prompt - Activate the new enviroment and install required packages. Use the following command line prompts in sequence to activate and install the required packages.

```
conda activate URSC645
conda install pandas
conda install geopandas
conda install jupyter
conda install contextily
conda install descartes
```
Note: This process can take a long time and depends on a solid internet connection.

7. How to check your enviroment? Use the commmand `conda list` in Anaconda Prompt to see what packages and the versions are installed in an enviroment.
- The steps above created an enviroment with 225 python packages (the 5 required and the packages that they require)
- The primary packages that were installed on 2022-02-13 included the following versions, builds, and channels
```
# Name                    Version                   Build  Channel
contextily                1.2.0              pyhd8ed1ab_0    conda-forge
descartes                 1.1.0                      py_4    conda-forge
geopandas                 0.10.2             pyhd8ed1ab_1    conda-forge
jupyter                   1.0.0            py37h03978a9_7    conda-forge
pandas                    1.3.5            py37h6214cd6_0
python                    3.7.12          h7840368_100_cpython    conda-forge
```
- If your enviroment does not have these versions of the primary packages the code may or may not replicate. 
- Try to replicate the code provided by this course, if it does not replicate the issue might be with the enviroment.

8. In Visual Studio Code this new enviroment will be provided as an option for running your Jupyter Notebooks and Python Code.
