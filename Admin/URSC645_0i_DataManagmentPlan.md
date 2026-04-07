# Data Management Plan (DMP)

## 1. Project Overview

Research is a fundamental part of science that involves a significant investment of time, systematic application of methods, and careful consideration. 
"Science demands reproducibility" (Long 2009, p. 2); therefore, reproducible research is a fundamental part of science. 
However, most research is not reproducible because many of the research methods are not clearly documented, and tools or software are not always available.
Additionally, within the social sciences, there is a general sense while research should be reproducible, the requirements are left to individual researchers.
To overcome the gap between the demand for reproducible research and the lack of skills to build reproducibility into projects, researchers need to invest time to develop data science skills. Data science skills can help build a strong workflow to support urban and regional analytic research that is systematic, generalizable, and replicable. 
Researchers who invest time to develop skills for reproducible research will be able to accomplish better science in less time.

## Research Question:

_How do reproducible workflow skills affect the quality and efficiency of science?_

---

## 2. Types of Data and Materials

This project will produce the following materials:

- Markdown Files for course details
- Source data in structured format (e.g., tabular or geospatial datasets)
- Source data metadata (data dictionaries, ReadMe files on how to obtain data)
- Analysis code and scripts (Jupyter Notebooks, python, STATA, R files)
- Documentation files
- Derived outputs such as figures, tables, or summary datasets

Data may be collected from publicly available sources or generated through analysis. Code and documentation are treated as core research data products.

---

## 3. File Formats and Organization

Project files will use commonly accepted, openly documented formats to support long-term accessibility. Typical formats may include plain-text data files (.csv), human-readable code files (.py, .ipynb), text files (.txt or .pdf) and standard image formats (.png, .jpeg).

Files will be organized into a clear directory structure (see directory design file in Admin folder) that separates source data, replication files, and clean data files. File and folder names will be descriptive and consistent to reduce ambiguity (See filename plan in Admin folder).

---

## 4. Documentation and Metadata

Project documentation will be provided to support understanding and reuse of the data. This will include:

- A top-level README file describing the project scope, data sources, and workflow
- Descriptive comments within code files or notebooks
- Basic variable descriptions or data dictionaries for clean data files

Documentation is intended to support both external users and the original author at a later date.

---

## 5. Storage, Backup, and Version Control

Data and code will be stored in GitHub (https://github.com/npr99/URSC645/) as stable digital environment during the project. Backup and versioning practices will be used to reduce the risk of data loss and to track changes to files over time. GitHub commits and Issues will be used to document work on the project.

Version control will be used for code and documentation to maintain a transparent history of revisions. Storage or sharing locations that are not suitable for sensitive or restricted data will be avoided.

---

## 6. Sharing, Access, and Long-Term Stewardship

During each semester, access to data and code may be restricted to students enrolled in the course through the Texas A&M University approved shared drive (Google Drive). After completion, students may elect to share materials publicly or selectively depending on data sensitivity and licensing constraints.

When shared, data and code will be accompanied by documentation describing appropriate use. Any limits on reuse or redistribution will be clearly stated. Long-term stewardship will prioritize clarity, documentation, and responsible reuse over permanent availability.

---

## Statement on Ethical and Institutional Considerations

This project does not involve protected human subjects data or personally identifiable information. If data restrictions or ethical constraints apply, they will be explicitly acknowledged and respected.

## Use of AI statement
This outline was made with the assistance of Microsoft Copilot. References from the DMP Task file were used to guide AI in writing a generic DMP.