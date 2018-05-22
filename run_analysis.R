## 1. Merges the training and the test sets to create one data set.

# Read train data
train = read.table('./train/subject_train.txt',header=FALSE)
trainX = read.table('./train/x_train.txt',header=FALSE)
trainY = read.table('./train/y_train.txt',header=FALSE)
# Read test data  
test = read.table('./test/subject_test.txt',header=FALSE)
testX = read.table('./test/x_test.txt',header=FALSE)
testY = read.table('./test/y_test.txt',header=FALSE)
#merge both data
xMerge <- rbind(trainX, testX)
yMerge <- rbind(trainY, testY)
mergeData <- rbind(train, test)

## 2.Extracts only the measurements on the mean and standard deviation for each measurement.
xMerge_mean_std <- xMerge[, grep("-(mean|std)\\(\\)", read.table("features.txt")[, 2])]
names(xMerge_mean_std) <- read.table("features.txt")[grep("-(mean|std)\\(\\)", read.table("features.txt")[, 2]), 2] 
dim(xMerge_mean_std)
View(xMerge_mean_std)

## 3.Uses descriptive activity names to name the activities in the data set
yMerge[,1] <- read.table("activity_labels.txt")[yMerge[,1],2]
names(yMerge) <- "Activity"
View(yMerge)

## 4.Appropriately labels the data set with descriptive variable names.
names(mergeData) <- "Subject"
summary(mergeData)

#Merge dataset into one
fullMerge <- cbind(xMerge_mean_std,yMerge,mergeData)

#cleaning up name
names(fullMerge) <- make.names(names(fullMerge))
names(fullMerge) <- gsub('tBody',"tBody_",names(fullMerge))
names(fullMerge) <- gsub('tGravity',"tGravity_",names(fullMerge))
names(fullMerge) <- gsub('fBody',"fBody_",names(fullMerge))

## 5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable 
##   for each activity and each subject.

tidyData <- aggregate(. ~Subject + Activity,fullMerge)
tidyData <- tidyData[order(tidyData$Subject,tidyData$Activity),]
write.table(tidyData, file = "tidyData.txt",row.names = FALSE)




