============
Installation
============

Prerequesites
=============

* Linux
* `DuckDB <www.duckdb.org>`_
* `gnu make <https://www.gnu.org/software/make/>`_
* `pandoc <>`_ (Optionally, if you want to convert ``md`` files to another format).


Installation
============

1. Clone the repository
2. Place original data files in ``data/``
   - This program expects a single CSV file named  ``InfrasThemeDetails_complete.csv``.
     The CSV file should have the following columns *in the given order*:
     * Reference
     * Round
     * Organisation
     * Theme
     * Details

.. note::

   At an earlier stage in the development of this program, the HRC programs did not have IDs assigned to them
   and therefore the data were provided in two batches, one file named ``InfrasThemesDetails.csv`` and one file named
   ``HRCThemes.csv``. 

   The file mentioned above (``InfrasThemesDetails_complete.csv``) was then composed by the Makefile rule ``InfrasThemeDetails_complete.csv``

   If only one file is available (describing the theme descriptions of all awards), then use ``InfrasThemeDetails_complete.csv`` only 
   and that rule will not trigger.
     

