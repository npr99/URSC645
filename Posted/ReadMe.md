Posted 		- Archived files needed for replicating work that has been shared - 
		--- journal article
		--- conference paper
		--- poster
		--- data archive

Files in Posted folder should not be altered, deleted, or modified.

Folder Name Structure
                               description
                               /
                PRJ.SPRJ.PI.xxxxxxx_yyyy-mm-dd
                                     -   -  -
                                     |   |  |
                                     y   m  d


            name    length          contents
            -----------------------------------------------------------
            PRJ         3-5         Project Mnemonic (fixed string)
            .            1          padding dot
           SPRJ         3-5         Sub-Project Mnemonic (fixed string)
            .            1          padding dot
            PI          varies      Principal Investigator last name, first initial
            .            1          padding dot
            x           5-10*       description of who folder contents are shared with
            _            1          padding underscore
            y            4          year (2017,2018,2019,2020...)
            -            1          padding dash
            m            2          month (01,02...12)
            -            1          padding dash
            d            2          date (01,02,...31)
            -----------------------------------------------------------
            * Description - examples 
			Students = shared with students
			ICPSR	 = published on ICPSR
			JAPA	 = publication in Journal of American Planning Association