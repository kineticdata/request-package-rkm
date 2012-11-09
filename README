RKM Package
===========

Description
-----------
This purpose of this package is to provide a portal that allows users to search
the Remedy Knowledge Management database for different types of articles.  It
contains one root jsp (rkm.jsp) which has a search feature and displays the
results in a table.  For each of the results the user can view the article by
clicking on a row, another ajax call is made to retrieve the specifics of that
article.

Installation
------------
Installation of this package is similar to any other package with an additional
step.  The query performed in this package requires the AR 7.6 API jar files,
these can be found in the vendor directory of this package.  These jar files
need to be placed somewhere where they will be loaded by the web server upon
starting (shared/lib for example).

Once the jar files are in place, installation requires you to simple paste the
rkm directory into the packages directory of your bundle and configure the
config/config.jspf.  There are three configuration values which configure which
remedy server to search for knowledge management articles.  Finally a service
item needs to be created that points to the packages/rkm/rkm.jsp.