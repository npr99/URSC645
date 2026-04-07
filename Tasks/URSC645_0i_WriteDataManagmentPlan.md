
# Why Data Management Plans Matter
When you write a Data Management Plan (DMP), you are not fulfilling a bureaucratic requirement—you are making an explicit commitment to future-you, your collaborators, and the broader research community.
Over a long research career, the biggest data failures are rarely methodological. They are practical:

- Files that no longer open
- Analysis scripts that no one understands (including the original author)
- Data that cannot be shared because no one knows what the variables mean
- Results that cannot be reproduced after a student graduates

A DMP is a short document that forces you to pause before a project starts and ask: How will my data survive beyond the moment I need it?

Think of your DMP as:

- A roadmap for how data move through your project
- A contract between collaborators
- A memory aid for yourself six months—or six years—from now

For URSC 645, the ReadMe file becomes you DMP. Your DMP is intentionally lightweight. That is fine. A good DMP scales—from class projects to NSF grants—because the underlying logic is the same.

##  What a Data Management Plan Is (and Is Not)
A DMP is:

- A concise description of how data are created, organized, documented, stored, shared, and preserved
- A living document that can be updated as practices evolve

A DMP is not:

- A data dictionary (though it points to one)
- A legal document (though it acknowledges policies and constraints)
- A promise to share everything immediately and publicly


## The Basic Sections of a Simple DMP
Your DMP will be short—typically 1 page—but it should clearly address the following six areas.
### 1. Project Overview

The first part of your ReadMe file already covers this section.

Briefly describe:

- The purpose of the project
- The research question or objective
- The general type of analysis you are doing

You are setting context for the data—not selling the project.

### 2. Types of Data and Materials
Describe what you will produce or collect:

- Data types (e.g., tabular data, geospatial files, text)
- Code and scripts (Python, notebooks, configuration files)
- Derived products (tables, figures, maps)

Key principle: _code is data_. Treat it with the same care.

You do not need exact file sizes—approximate scope is enough.

### 3. File Formats and Organization
Explain:
- File formats you will use
- How files are organized into folders (point to Admin/DirectoryDesign)
- Any naming conventions you will follow (point to Admin/FileNamePlan)

_Strong preference_: open, non-proprietary formats that will remain readable over time (e.g., `.csv` instead of `.xlsx`, `.txt` or `pdf` instead of `.docx`).

This section is about reducing ambiguity. A consistent structure matters more than a perfect one.

### 4. Storage, Backup, and Version Control
Explain:

- Where data and code will be stored during the project
- How files will be backed up to reduce the risk of loss
- How changes to files will be tracked over time (version control)

This section should make it clear how your data are protected against accidental loss and how prior versions can be recovered or audited. 

Different tools or platforms may be used for different parts of the workflow, and those choices should be stated explicitly.

Be clear about any limits or exclusions (e.g., sensitive data, restricted files, or materials stored outside the main working environment).


For URSC 645, I recommend you use GitHub:

- Include you GitHub account as the primary working repository

Be explicit about what does not belong on GitHub (e.g., sensitive data, personally identifiable information, large raw files that require alternative storage).

### 5. Sharing, Access, and Long-Term Stewardship
Explain:
- Who can access the data during the project
- Whether the repository will be public or private
- Any limits on reuse or redistribution (even if there are none)

_Remember_: sharing can be delayed, partial, or conditional. A DMP does not require immediate openness—it requires clarity and intent.

## A Final Perspective
Most failed data management is not caused by bad intentions—it is caused by postponed decisions.
A simple DMP pulls those decisions forward.

A good Data Management Plan is an act of respect—for your collaborators, your community, and your future self.

In professional research, that mindset matters as much as any method or model.

### References

Austin, J. (2021). Privacy Requirements and Use of Health Data. CONVERGE Extreme Events Research Check Sheets Series. DesignSafe-CI. 
https://doi.org/10.17603/ds2-0bn5-dv59.

Adams, R., Esteva, M., & Peek, L. (2020). Guidance for Data Management Plans. CONVERGE Extreme Events Research Check Sheets Series. 
DesigSafe-CI. https://doi.org/10.17603/ds2-ycz2-xc47

Briney, K. (2020). *Data management for researchers: Organize, maintain and share your data for research success* (2nd ed.). Pelagic Publishing. https://doi.org/10.2307/jj.28833749

California Digital Library. (n.d.). *DMPTool*.  
https://dmptool.org/

Inter-university Consortium for Political and Social Research. (n.d.). *Sample Data Management Plan for Depositing Data with ICPSR*.  
https://www.icpsr.umich.edu/sites/icpsr/manage-data/dmps-grants/sample-dmp

Karvovskaya, L., Yeomans, J., & Rodenburg, E. (2025). The Data Horror Escape Room game as a successful tool for RDM education and engagement. LIBER Quarterly: The Journal of the Association of European Research Libraries, 35(1), 1-29. https://doi.org/10.53377/lq.16089 Online Game: https://sites.google.com/vu.nl/datahorror/home

Michener, W. K. (2015). Ten simple rules for creating a good data management plan. *PLOS Computational Biology, 11*(10), e1004525. https://doi.org/10.1371/journal.pcbi.1004525

National Science Foundation. (n.d.). *Dissemination and sharing of research results*. https://www.nsf.gov/bfa/dias/policy/dmp.jsp

Texas A&M University Libraries. (n.d.). *Research Data Management*. https://library.tamu.edu/services/scholarly_communication/data-management.php

Texas A&M University. (n.d.). *SAP 15.99.03: Ownership, retention, and disposition of research data*.  https://rules-saps.tamu.edu/PDFs/15.99.03.M1.03.pdf

## Use of AI statement
This outline was made with the assistance of Microsoft Copilot. References from the DMP Task file were used to guide AI in writing a generic DMP.




