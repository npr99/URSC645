## Setup your First Python Enviroment
---

### Windows 64-bit

1. Download the latest Miniconda3 installer for Windows from the Miniconda web page or Anaconda3 installer from Anaconda page.

- https://docs.conda.io/en/latest/miniconda.html

- https://www.anaconda.com/distribution/

2. Run the installer setup
- Depending on the installation you might be asked to choose from different setups.

- Run the installer setup locally; select Just Me choice to avoid the need for administrator privileges.

- Leave the default folder path. For your information, the default path is

```
C:\Users\<username>\..\miniconda3 (anaconda3)
```

- Do not add Anaconda to the PATH. 
- Do, however, register Anaconda as the default Python environment.

3. Open up an Anaconda prompt from the Windows Start menu. The `base` environment is being activated and the prompt changes to: `(base) C:\Users\<user>`

4. Create the python environment (for this example we choose URSC645) and activate it

```
conda create -n URSC645 python=3.7
```
5. In Visual Studio Code this new enviroment will be provided as an option for running your Jupyter Notebooks or Python Code.