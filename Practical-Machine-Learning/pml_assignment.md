---
title: "Practical Machine Learning Assignment"
date: "Sunday, December 21, 2014"
output: html_document
---

### Data

Using devices such as *Jawbone Up*, *Nike FuelBand*, and *Fitbit* it is now possible to collect a large amount of data about personal activity relatively inexpensively. These type of devices are part of the quantified self movement - a group of enthusiasts who take measurements about themselves regularly to improve their health, to find patterns in their behavior. 

The training data:
https://d396qusza40orc.cloudfront.net/predmachlearn/pml-training.csv

The test data:
https://d396qusza40orc.cloudfront.net/predmachlearn/pml-testing.csv

More information is available from the website here: 
http://groupware.les.inf.puc-rio.br/har 
(see the section on the Weight Lifting Exercise Dataset). 

### Task
In this project, your goal will be to use data from accelerometers on the belt, forearm, arm, and dumbell of 6 participants. They were asked to perform barbell lifts correctly and incorrectly in 5 different ways. It is necessary no predict the manner in which they did the excersise. This is the "classe" variable in training set.

### Solution

#### Obtaining the data


```r
uri.training <- "https://d396qusza40orc.cloudfront.net/predmachlearn/pml-training.csv"
uri.testing  <- "https://d396qusza40orc.cloudfront.net/predmachlearn/pml-testing.csv"

#if (!file.exists("data")) { 
#    dir.create("data") 
#    setInternet2(use = TRUE)
#    download.file(uri.training, ".\\data\\pml-testing.csv")
#    download.file(uri.testing, ".\\data\\pml-testing.csv")
#}

pml.test <-  read.csv(".\\data\\pml-testing.csv")
pml.train <- read.csv(".\\data\\pml-training.csv")
```

#### Preprocessing the data

Unfortunately, there are no nice data cookbook, which describes all varibles in the data set. So, try to explore the data without it. First of all, we have to drop variables like participant's name and time. Obviously, that name have no any impact on activity type and using the time, on my opinion, may make model invalid if it will be used sometimes in future. Also there are a lot of NA variables. We can assume that all columns, which end with "_ x", "_ y", "_ z" are columns with a raw data from sensors i.e. exactly what we need for our model.


```r
num <- c(grep("_x$", names(pml.train))
        ,grep("_y$", names(pml.train))
        ,grep("_z$", names(pml.train)))

df <- pml.train[,num]
# Don't forget about "classe" variable
df$class <- pml.train$classe
cix <- length(num) + 1
```

#### Splitting the data for cross validation


```r
library(caret)
inTrain <- createDataPartition(y = df$class, p =.7, list = FALSE)
training <- df[inTrain,]
validating <- df[-inTrain,]
```

#### Applying the algorithm

Several algorithms machine learning were tested. The best preformance among them shows "Random forest" algorithm.


```r
library(randomForest)
fit <- randomForest(class ~ ., data = training, ntree = 100)
```

Validating the training data on "validating" subset.

```r
pred <- predict(fit, newdata = validating[,-cix], type = "class")
cm <- confusionMatrix(pred, validating$class)
cm$overall
```

```
##       Accuracy          Kappa  AccuracyLower  AccuracyUpper   AccuracyNull 
##      0.9869159      0.9834479      0.9836739      0.9896608      0.2844520 
## AccuracyPValue  McnemarPValue 
##      0.0000000            NaN
```

```r
##Confusion matrix
cm$table
```

```
##           Reference
## Prediction    A    B    C    D    E
##          A 1665   12    0    1    0
##          B    3 1122   12    0    1
##          C    2    5 1014   30    2
##          D    4    0    0  930    2
##          E    0    0    0    3 1077
```

So, model shows very high accuracy - 98.7% and seems no overfitted.
Now we can apply algo on the test data:


```r
p <- predict(fit, newdata = pml.test[,num], type = "class")
p
```

```
##  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 
##  B  A  B  A  A  E  D  B  A  A  B  C  B  A  E  E  A  B  B  B 
## Levels: A B C D E
```

#### Generating answers
Writing predicted activitis from test dataset into separate files for auto-checking.

```r
if (!file.exists("predictions")) { dir.create("predictions") }

pml_write_files = function(x){
  n = length(x)
  for(i in 1:n){
    filename = paste0(".\\predictions\\problem_id_",i,".txt")
    write.table(x[i],file=filename,quote=FALSE,row.names=FALSE,col.names=FALSE)
  }
}

p <- as.character(p)
pml_write_files(p)
```


