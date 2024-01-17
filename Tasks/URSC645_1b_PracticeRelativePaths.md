# Relative Paths

## Overview
Relative paths are an essential part of a reproducible workflow.

Relative paths allow a script file to run on any computer, as long as any input data is in the same relative location to the script file.

## Step 1 - know your current working directory
The first step is to know your current working directory.
When a file is open in VS Code, the current working directory is the folder that contains the file.
In most programs the current working directory is the folder that contains the program. However, this is not always the case. A good practice is to always know your current working directory.

## Read File Examples
The following example shows how to use relative paths to read in a file.

```{python}
# Read in a file located in the same folder
df = pd.read_csv('data.csv')

# Read in a file located in a subfolder
df = pd.read_csv('subfolder/data.csv')

# Read in a file located in a parent folder
df = pd.read_csv('../data.csv')

# Read in a file located in a grandparent folder
df = pd.read_csv('../../data.csv')

# Read in a file located in a great-grandparent folder
df = pd.read_csv('../../../data.csv')

# Read in a file located in a subfolder inside the parent folder
df = pd.read_csv('../subfolder/data.csv')

```

## Write File Examples
The following example shows how to use relative paths to write out a file.

```{python}
# Write out a file to the same folder
df.to_csv('data.csv')

# Write out a file to a subfolder
df.to_csv('subfolder/data.csv')

# Write out a file to a parent folder
df.to_csv('../data.csv')

# Write out a file to a grandparent folder
df.to_csv('../../data.csv')

# Write out a file to a great-grandparent folder
df.to_csv('../../../data.csv')

# Write out a file to a subfolder inside the parent folder
df.to_csv('../subfolder/data.csv')

```


