Week 1-3
========

## Reading Exel files
Jeffrey Leek,
Assistant Professor of Biostatistics
Johns Hopkins Bloomberg School of Public Health

### Excel files
Still probably the most widely used format for sharing data

http://office.microsoft.com/en-us/excel/

### Example - Baltimore camera data

![Baltimore camera data](images/image_w121.png)

https://data.baltimorecity.gov/Transportation/Baltimore-Fixed-Speed-Cameras/dz54-2aru

Download the file to load

```r
if(!file.exists("data")){
    dir.create("data")
}
fileUrl <- "https://data.baltimorecity.gov/api/views/dz54-2aru/rows.xlsx?accessType=DOWNLOAD"
download.file(fileUrl,destfile="./data/cameras.xlsx",method="curl")
dateDownloaded <- date()
```

`read.xlsx()`, `read.xlsx2()` from **xlsx** package

```r
library(xlsx)
cameraData <- read.xlsx("./data/cameras.xlsx",sheetIndex=1,header=TRUE)
head(cameraData)
##                         address direction      street  crossStreet               intersection
## 1       S CATON AVE & BENSON AVE       N/B   Caton Ave   Benson Ave     Caton Ave & Benson Ave
## 2       S CATON AVE & BENSON AVE       S/B   Caton Ave   Benson Ave     Caton Ave & Benson Ave
## 3 WILKENS AVE & PINE HEIGHTS AVE       E/B Wilkens Ave Pine Heights Wilkens Ave & Pine Heights
## 4        THE ALAMEDA & E 33RD ST       S/B The Alameda      33rd St     The Alameda  & 33rd St
## 5        E 33RD ST & THE ALAMEDA       E/B      E 33rd  The Alameda      E 33rd  & The Alameda
## 6
## 1 (39.2693779962, -76.6688185297)
## 2 (39.2693157898, -76.6689698176)
## 3  (39.2720252302, -76.676960806)
## 4 (39.3285013141, -76.5953545714)
## 5 (39.3283410623, -76.5953594625)
## 6 (39.3068045671, -76.5593167803)
```

### Reading specific rows and columns
```r
colIndex <- 2:3
rowIndex <- 1:4
cameraDataSubset <- read.xlsx("./data/cameras.xlsx"
    , sheetIndex = 1
    , colIndex=colIndex,rowIndex=rowIndex)
cameraDataSubset
##   direction      street
## 1       N/B   Caton Ave
## 2       S/B   Caton Ave
## 3       E/B Wilkens Ave
```

### Further notes

- The `write.xlsx` function will write out an Excel file with similar arguments.
- `read.xlsx2` is much faster than `read.xlsx` but for reading subsets of rows may be slightly unstable.
- The [XLConnect] package has more options for writing and manipulating Excel files
- The [XLConnect vignette] is a good place to start for that package
- In general it is advised to store your data in either a database or in comma separated files (.csv) or tab separated files (.tab/.txt) as they are easier to distribute.

## Reading XML

### XML
- Extensible markup language
- Frequently used to store structured data
- Particularly widely used in internet applications
- Extracting XML is the basis for most web scraping
- Components
  - Markup - labels that give the text structure
  - Content - the actual text of the document

http://en.wikipedia.org/wiki/XML

Example: http://www.w3schools.com/xml/simple.xml

### Tags, elements and attributes
- Tags correspond to general labels
  - Start tags `<section>`
  - End tags `</section>`
  - Empty tags `<line-break />`
- Elements are specific examples of tags
  - `<Greeting> Hello, world </Greeting>`
- Attributes are components of the label
  - `<img src="jeff.jpg" alt="instructor"/>`
  - `<step number="3"> Connect A to B. </step>`

### Read the file into R
```r
library(XML)
fileUrl <- "http://www.w3schools.com/xml/simple.xml"
doc <- xmlTreeParse(fileUrl,useInternal=TRUE)
rootNode <- xmlRoot(doc)
xmlName(rootNode)
## [1] "breakfast_menu"
names(rootNode)
##   food   food   food   food   food 
## "food" "food" "food" "food" "food" 
```

### Directly access parts of the XML document
```r
rootNode[[1]]
## <food>
##   <name>Belgian Waffles</name>
##   <price>$5.95</price>
##   <description>Two of our famous Belgian Waffles with plenty of real maple syrup</description>
##   <calories>650</calories>
## </food> 
rootNode[[1]][[1]]
## <name>Belgian Waffles</name> 
```

### Programatically extract parts of the file
```r
xmlSApply(rootNode,xmlValue)
```
### XPath
- /node Top level node
- //node Node at any level
- node[@attr-name] Node with an attribute name
- node[@attr-name='bob'] Node with attribute name attr-name='bob'

Information from: http://www.stat.berkeley.edu/~statcur/Workshop2/Presentations/XML.pdf

### Get the items on the menu and prices
```r
xpathSApply(rootNode,"//name",xmlValue)
## [1] "Belgian Waffles"    "Strawberry Belgian Waffles"  "Berry-Berry Belgian Waffles"
## [4] "French Toast"       "Homestyle Breakfast"        
xpathSApply(rootNode,"//price",xmlValue)
## [1] "$5.95" "$7.95" "$8.95" "$4.50" "$6.95"
```

### Another example

http://espn.go.com/nfl/team/_/name/bal/baltimore-ravens

```r
fileUrl <- "http://espn.go.com/nfl/team/_/name/bal/baltimore-ravens"
doc <- htmlTreeParse(fileUrl,useInternal=TRUE)
scores <- xpathSApply(doc,"//li[@class='score']",xmlValue)
teams <- xpathSApply(doc,"//li[@class='team-name']",xmlValue)
scores
## [1] "49-27"    "14-6"     "30-9"     "23-20"    "26-23"    "19-17"    "19-16"    "24-18"   
## [9] "20-17 OT" "23-20 OT" "19-3"     "22-20"    "29-26"    "18-16"    "41-7"     "34-17"   
teams
##  [1] "Denver"      "Cleveland"   "Houston"     "Buffalo"     "Miami"       "Green Bay"  
##  [7] "Pittsburgh"  "Cleveland"   "Cincinnati"  "Chicago"     "New York"    "Pittsburgh" 
## [13] "Minnesota"   "Detroit"     "New England" "Cincinnati"
```

### Notes and further resources
- Official XML tutorials [short], [long]
- [An outstanding guide to the XML package]

## Reading JSON

### JSON
- Javascript Object Notation
- Lightweight data storage
- Common format for data from application programming interfaces (APIs)
- Similar structure to XML but different syntax/format
- Data stored as
  - Numbers (double)
  - Strings (double quoted)
  - Boolean (true or false)
  - Array (ordered, comma separated enclosed in square brackets [])
  - Object (unorderd, comma separated collection of key:value pairs in curley brackets {})

http://en.wikipedia.org/wiki/JSON

### Reading data from JSON {jsonlite package}
```r
library(jsonlite)
jsonData <- fromJSON("https://api.github.com/users/jtleek/repos")
names(jsonData)
##  [1] "id"                "name"              "full_name"         "owner"            
##  [5] "private"           "html_url"          "description"       "fork"             
##  [9] "url"               "forks_url"         "keys_url"          "collaborators_url"
## [13] "teams_url"         "hooks_url"         "issue_events_url"  "events_url"       
## [17] "assignees_url"     "branches_url"      "tags_url"          "blobs_url"        
## [21] "git_tags_url"      "git_refs_url"      "trees_url"         "statuses_url"     
## [25] "languages_url"     "stargazers_url"    "contributors_url"  "subscribers_url"  
## [29] "subscription_url"  "commits_url"       "git_commits_url"   "comments_url"     
## [33] "issue_comment_url" "contents_url"      "compare_url"       "merges_url"       
## [37] "archive_url"       "downloads_url"     "issues_url"        "pulls_url"        
## [41] "milestones_url"    "notifications_url" "labels_url"        "releases_url"     
## [45] "created_at"        "updated_at"        "pushed_at"         "git_url"          
## [49] "ssh_url"           "clone_url"         "svn_url"           "homepage"         
## [53] "size"              "stargazers_count"  "watchers_count"    "language"         
## [57] "has_issues"        "has_downloads"     "has_wiki"          "forks_count"  
```

### Nested objects in JSON
```r
names(jsonData$owner)
##  [1] "login"               "id"                  "avatar_url"          "gravatar_id"        
##  [5] "url"                 "html_url"            "followers_url"       "following_url"      
##  [9] "gists_url"           "starred_url"         "subscriptions_url"   "organizations_url"  
## [13] "repos_url"           "events_url"          "received_events_url" "type"               
## [17] "site_admin"         
jsonData$owner$login
##  [1] "jtleek" "jtleek" "jtleek" "jtleek" "jtleek" "jtleek" "jtleek" "jtleek" "jtleek" "jtleek"
## [11] "jtleek" "jtleek" "jtleek" "jtleek" "jtleek" "jtleek" "jtleek" "jtleek" "jtleek" "jtleek"
## [21] "jtleek" "jtleek" "jtleek" "jtleek" "jtleek" "jtleek" "jtleek"
```

### Writing data frames to JSON
```r
myjson <- toJSON(iris, pretty=TRUE)
cat(myjson)
## [
##     {
##         "Sepal.Length" : 5.1,
##         "Sepal.Width" : 3.5,
##         "Petal.Length" : 1.4,
##         "Petal.Width" : 0.2,
##         "Species" : "setosa"
##     },
##     {
##         "Sepal.Length" : 4.9,
##         "Sepal.Width" : 3,
##         "Petal.Length" : 1.4,
##         "Petal.Width" : 0.2,
##         "Species" : "setosa"
##     },...
```

### Convert back to JSON
```r
iris2 <- fromJSON(myjson)
head(iris2)
##   Sepal.Length Sepal.Width Petal.Length Petal.Width Species
## 1          5.1         3.5          1.4         0.2  setosa
## 2          4.9         3.0          1.4         0.2  setosa
## 3          4.7         3.2          1.3         0.2  setosa
## 4          4.6         3.1          1.5         0.2  setosa
## 5          5.0         3.6          1.4         0.2  setosa
## 6          5.4         3.9          1.7         0.4  setosa
```

http://www.r-bloggers.com/new-package-jsonlite-a-smarter-json-encoderdecoder/

### Further resources
- http://www.json.org/
- A good tutorial on jsonlite - http://www.r-bloggers.com/new-package-jsonlite-a-smarter-json-encoderdecoder/
- [jsonlite vignette]


[XLConnect]:http://cran.r-project.org/web/packages/XLConnect/index.html
[XLConnect vignette]:http://cran.r-project.org/web/packages/XLConnect/vignettes/XLConnect.pdf
[short]:http://www.omegahat.org/RSXML/shortIntro.pdf
[long]:http://www.omegahat.org/RSXML/Tour.pdf
[An outstanding guide to the XML package]:http://www.stat.berkeley.edu/~statcur/Workshop2/Presentations/XML.pdf
[jsonlite vignette]:http://cran.r-project.org/web/packages/jsonlite/vignettes/json-mapping.pdf




