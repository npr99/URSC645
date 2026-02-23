# URSC 645 Filename Plan

URSC645 = Project mnemonic. All files start with the same mnemonic.

URSC645 = Urban and Regional Science Course 645 - Urban and Regional Analytics 

Example Filename: `URSC645_1cv1_ReadingData_2025-02-06.ipynb`

```
File Name Structure
                   s     #
                    \   /     description         extension
                     - -     /                    /
                PRJ_tsv#_xxxxxxxxxxxx_yyyy-mm-dd.ext
                   -  -                -   -  -
                  /  /                 |   |  |
                 t  v                  y   m  d


         name    length          contents
         -----------------------------------------------------------
         PRJ       3-5        Project Mnemonic (fixed string)
         _         1          padding underscore
         t         1          data science workflow task number (0-6)
         s         1          letter step within task (a,b,c..)
         v         1          v = version
         #         1          version number (1,2,3,4...)
         _         1          padding underscore
         x         5-10*      description of step
         _         1          padding underscore
         y         4          year (2017,2018,2019,2020...)
         -         1          padding dash
         m         2          month (01,02...12)
         -         1          padding dash
         d         2          date (01,02,...31)
         .         1          decimal
         ext       3          file type extension
         -----------------------------------------------------------

The data science steps include:

0 = Research Log or Project Admin
1 = Obtain Data
2 = Clean Data
3 = Explore Data
4 = Model Data
5 = Interpret Data
6 = Publish Data
```

# Readings Folder Filename Plan
The readings folder contains literature relevant to this project.
Each file is named similar to an APA citation. Goal is to have a readings folder that contains easily referenced files that mirror a reference section in a journal article. Note: Many readings can not be shared publicly, therefore an annotated bibliography is helpful to provide a summary of key readings.

First Author Last Name [et al] YEAR Short Summary

## Examples:
Long 2009 Workflow Guide
Munafo et al 2017 Manifesto Reproducible Science
Freese 2007 Replication Standards for Social Science