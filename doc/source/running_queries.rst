===============
Running Queries
===============

Before one can run semantic search queries on a dataset, this dataset has to be ingested 
to the database and preprocessed.

All actions are taken via Makefile commands which are explained below.

General functionality
=====================

``init_db``
-----------


``> make init_db``

Initialises the database from ``InfrasThemeDetails_complete.csv``.


``explore``
-----------

``> make explore``

Starts a command line interface to the database to run queries and
review the database itself.


``add_embeddings``
------------------

``> make add_embeddings``

Preprocesses the text available in column ``Details``.

Performs sentence tokenisation and then collects sequential sentences
together so that the maximum length does not exceed 160 characters.

Finally it ingests the tokenised dataset back into the database 
relating it with the original table.

``search``
----------

``> make search T=0.39 q="Insert your search term here"``

Performs a search across the tokenised part of the database and returns the results on the terminal.

Parameters
^^^^^^^^^^

* ``T``: Threshold of semantic search (Default is 0.39)
* ``q``: Semantic search query string.


Maternity Topics Subject Specific Searches
==========================================

``subject_specific_search``
---------------------------

``> make subject_specific_search``

Will run all subject specific searches and store their results 
in CSV files. Each CSV filename reflects the topic name.

The files produced from this particular command are as follows:

* ``AccessAndExperience.csv``
* ``SafetyAndQualityInPerinatalAndNeonatalCare.csv``
* ``MaternalAndMentalHealth.csv``
* ``PreconceptionAndInterconceptionHealth.csv``
* ``MaternalAndNeonatalHealthRisksAndDiscovery .csv``

Plain English Summaries (PES)
=============================

``> make pes``

Will extract the relevant PES from the extracted data in Markdown format and convert them to docx too.

