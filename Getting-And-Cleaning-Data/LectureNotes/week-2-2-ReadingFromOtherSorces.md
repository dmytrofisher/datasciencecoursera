Week 2-2
========

## Reading from other sources
Jeffrey Leek,
Assistant Professor of Biostatistics
Johns Hopkins Bloomberg School of Public Health

### Interacting more directly with files
- **file** - open a connection to a text file
- **url** - open a connection to a url
- **gzfile** - open a connection to a .gz file
- **bzfile** - open a connection to a .bz2 file
- `?connections` for more information
- Remember to close connections

### foreign package
- Loads data from Minitab, S, SAS, SPSS, Stata,Systat
- Basic functions `read.foo`
  - read.arff (Weka)
  - read.dta (Stata)
  - read.mtp (Minitab)
  - read.octave (Octave)
  - read.spss (SPSS)
  - read.xport (SAS)
- See the help page for more details http://cran.r-project.org/web/packages/foreign/foreign.pdf

### Examples of other database packages
- RPostresSQL provides a DBI-compliant database connection from R. 
  - Tutorial: https://code.google.com/p/rpostgresql/
  - help file: http://cran.r-project.org/web/packages/RPostgreSQL/RPostgreSQL.pdf
- RODBC provides interfaces to multiple databases including PostgreQL, MySQL, Microsoft Access and SQLite. 
  - Tutorial: http://cran.r-project.org/web/packages/RODBC/vignettes/RODBC.pdf
  - help file: http://cran.r-project.org/web/packages/RODBC/RODBC.pdf

### Reading images
- jpeg - http://cran.r-project.org/web/packages/jpeg/index.html
- readbitmap - http://cran.r-project.org/web/packages/readbitmap/index.html
- png - http://cran.r-project.org/web/packages/png/index.html
- EBImage (Bioconductor) - http://www.bioconductor.org/packages/2.13/bioc/html/EBImage.html

### Reading GIS data
- rdgal - http://cran.r-project.org/web/packages/rgdal/index.html
- rgeos - http://cran.r-project.org/web/packages/rgeos/index.html
- raster - http://cran.r-project.org/web/packages/raster/index.html

### Reading music data
- tuneR - http://cran.r-project.org/web/packages/tuneR/
- seewave - http://rug.mnhn.fr/seewave/