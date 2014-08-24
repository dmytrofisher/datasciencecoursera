## Script parses and prettifies UCI HAR Dataset, which can be found on
uci.har.dataset.url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
## or may be automatically load using 'loadData' function

runAnalysis <- function () {
        ## Read common descriptive tables 
	activityLabels <- read.table("UCI HAR Dataset\\activity_labels.txt"
                , header = FALSE)
	featureNames <- read.table("UCI HAR Dataset\\features.txt"
                , header = FALSE)$V2

	## Read test data
	testData <- read.table("UCI HAR Dataset\\test\\X_test.txt"
                , sep = "", header = FALSE)
	testSubj <- read.table("UCI HAR Dataset\\test\\subject_test.txt"
                , sep = "", header = FALSE)
	testActivityId <- read.table("UCI HAR Dataset\\test\\y_test.txt"
                , sep = "", header = FALSE)

	## Read train data
	trainData <- read.table("UCI HAR Dataset\\train\\X_train.txt"
                , sep = "", header = FALSE)	
	trainSubj <- read.table("UCI HAR Dataset\\train\\subject_train.txt"
                , sep = "", header = FALSE)
	trainActivityId <- read.table("UCI HAR Dataset\\train\\y_train.txt"
                , sep = "", header = FALSE)

	## Add subject Id and descriptive activity names to test data
	names(testData) <- featureNames
	testData <- cbind(testActivityId, testData)
	testData <- cbind(subject = testSubj[,1], testData)
	testData <- merge(activityLabels, testData, sort = FALSE)

	## Add subject Id and descriptive activiity names to train data
	names(trainData) <- featureNames
	trainData <- cbind(trainActivityId, trainData)
	trainData <- cbind(subject = trainSubj[,1], trainData)
	trainData <- merge(activityLabels, trainData, sort = FALSE)

	## Merge the training and the test set
	allData <- rbind(testData, trainData)

	## Remove unnecessary activity Id, add descriptive column names
	allData$V1 = NULL
	names(allData)[1] <- "activity"
	allData <- allData[order(allData$subject),]
	allData <- allData[c(2,1,3:ncol(allData))]

	## Extracts only the measurements on the mean 
	## and standard deviation for each measurement
	allData <- allData[,grep("subject|activity|(M|m)ean|std", names(allData))]

	## Appropriately labels the data set with descriptive variable names. 
	nms <- names(allData)
	nms <- gsub("\\(\\)", "", nms)
	nms <- gsub("Acc", ".Acceleration", nms)
	nms <- gsub("Gyro", ".Gyroscope", nms)
	nms <- gsub("Jerk", ".Jerk", nms)
	nms <- gsub("Mag", ".Magnitude", nms)
	nms <- gsub("-", ".", nms)
	nms <- gsub("BodyBody", "Body.Body", nms)
	names(allData) <- nms
	
	## Write tidy data set
	write.table(allData, file = "tidy.txt"
		, sep = " "
		, quote = F
		, col.names = T
		, row.names = F)

	## Creates a second, independent tidy data set 
	## with the average of each variable for each activity and each subject.
	avgdData <- aggregate(. ~ subject + activity, data = allData, FUN = mean)
	avgdData <- avgdData[order(avgdData$subject),]
	write.table(avgdData, file = "tidy_avereged.txt"
		, sep = " "
		, quote = F
		, col.names = T
		, row.names = F)

	message("Done!")
}

loadData <- function (then.run = FALSE){
        download.file(uci.har.dataset.url, "uci-har-dataset.zip")
        unzip("uci-har-dataset.zip")   
        if(then.run){
                runAnalysis()
        }
}