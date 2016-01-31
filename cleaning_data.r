# This script will perform the following steps on the UCI HAR Dataset downloaded from 
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
# 1. Merge the training and the test sets to create one data set.
# 2. Extract only the measurements on the mean and standard deviation for each measurement. 
# 3. Use descriptive activity names to name the activities in the data set
# 4. Appropriately label the data set with descriptive activity names. 
# 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

setwd('./UCI HAR dataset')
library(reshape)
library(reshape2)
library(plyr)

#pull in data
features     = read.table('./features.txt',header=FALSE); #imports features.txt
activityType = read.table('./activity_labels.txt',header=FALSE); #imports activity_labels.txt
subjectTrain = read.table('./train/subject_train.txt',header=FALSE); #imports subject_train.txt
xTrain       = read.table('./train/x_train.txt',header=FALSE); #imports x_train.txt
yTrain       = read.table('./train/y_train.txt',header=FALSE); #imports y_train.txt

#name the header columns
colnames(activityType)  = c('activityId','activityType');
colnames(subjectTrain)  = "subjectId";
colnames(xTrain)        = features[,2]; 
colnames(yTrain)        = "activityId";

#make a training dataset by merging yTrain, subjectTrain, and xTrain
#intersect(names(yTrain), names(subjectTrain))
#intersect(names(yTrain), names(xTrain))
trainingData = cbind(yTrain,subjectTrain,xTrain); #only tacks the three data frames together

#follow the same procedure for the Test dataset
# Read in the test data
subjectTest = read.table('./test/subject_test.txt',header=FALSE); #imports subject_test.txt
xTest       = read.table('./test/x_test.txt',header=FALSE); #imports x_test.txt
yTest       = read.table('./test/y_test.txt',header=FALSE); #imports y_test.txt

# Assign column names to the test data imported above
colnames(subjectTest) = "subjectId";
colnames(xTest)       = features[,2]; 
colnames(yTest)       = "activityId";

# Create the final test set by merging the xTest, yTest and subjectTest data
testData = cbind(yTest,subjectTest,xTest);


### Combine Train and Test datasets
#planning
dim(trainingData)
dim(testData)
#each have 563 variables. so, tack on testData to bottom of trainingData. Instructions did not say to preserve a column to ID training and test
finalData = rbind(trainingData,testData);
names(finalData)

# Extract only the data on mean and standard deviation and activity and subject
wanted <- grep("mean|std|subject|activity", names(finalData))
wanted
wantedCols <- finalData[wanted]

#### name the activities in the data set
q3 <- join(wantedCols, activityType, by = "activityId", match = "first")
head(q3)

# Cleaning up the variable names
dim(q3)
names(q3)
names(q3) <- gsub('mean', 'Mean', names(q3))
names(q3) <- gsub('std', 'Std', names(q3))
names(q3) <- gsub('[-()]', '', names(q3))
names(q3) <- gsub("^(t)","time",names(q3))
names(q3) <- gsub("^(f)","freq",names(q3))

#q5 - average of each variable for each activity and each subject.
#organize by subject (30 total) and activity (6total) 
#so, we'll end up with 180 rows for 79 variables/columns? No.
# we end up with subject factor, activity factor, variable name, and mean

str(q3)
q3$activityId <- factor(q3$activityId, levels = activityType[,1], labels = activityType[,2])
q3$subjectId <- as.factor(q3$subjectId)
q3.melted <- melt(q3, id = c("subjectId", "activityId"))
q3.mean <- dcast(q3.melted, subjectId + activityId ~ variable, mean)
head(q3.mean, 20)
dim(q3.mean)


write.table(q3.mean, file = "tidyData.txt")

