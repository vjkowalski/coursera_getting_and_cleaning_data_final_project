##########################################################################################################

# Coursera 
# Getting and Cleaning _data Course Project
# Vincent Kowalski
# 

# Purpose:
# -------

# Merges the training and the test sets to create one data set.
# Extracts only the measurements on the mean and standard deviation for each measurement.
# Uses descriptive activity names to name the activities in the data set
# Appropriately labels the  data set with descriptive variable names.
# From the  data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

##########################################################################################################


# Clear the workspace
rm(list=ls())

# 1) Merge the training data and the test data.

#set working directory to the location of the UCI HAR Dataset  
setwd('/Users/vincentkowalski/Downloads/UCI HAR Dataset/');

# Read in the data
features     = read.table('./features.txt',header=FALSE); #imports features.txt
activityType = read.table('./activity_labels.txt',header=FALSE); #imports activity_labels.txt
subjectTrain = read.table('./train/subject_train.txt',header=FALSE); #imports subject_train.txt
xTrain       = read.table('./train/x_train.txt',header=FALSE); #imports x_train.txt
yTrain       = read.table('./train/y_train.txt',header=FALSE); #imports y_train.txt

# Assigin column names to the data 
colnames(activityType)  = c('activityId','activityType');
colnames(subjectTrain)  = "subjectId";
colnames(xTrain)        = features[,2]; 
colnames(yTrain)        = "activityId";

# construct the training set by merging yTrain, subjectTrain, and xTrain
trainingData = cbind(yTrain,subjectTrain,xTrain);

# Read in the test data
subjectTest = read.table('./test/subject_test.txt',header=FALSE); #imports subject_test.txt
xTest       = read.table('./test/x_test.txt',header=FALSE); #imports x_test.txt
yTest       = read.table('./test/y_test.txt',header=FALSE); #imports y_test.txt

# Assign column names
colnames(subjectTest) = "subjectId";
colnames(xTest)       = features[,2]; 
colnames(yTest)       = "activityId";


# Construct the final test set by merging the xTest, yTest and subjectTest data
testData = cbind(yTest,subjectTest,xTest);


# Combine training and test data to create a final data set
final_data = rbind(trainingData,testData);

# Construct a vector for the column names from the final_data, which will be used
# to select the desired mean() & stddev() columns
colNames  = colnames(final_data); 

# 2) Extract only the measurements on the mean and standard deviation for each measurement. 

# Construct a logicalVector that contains TRUE values for the ID, mean() & stddev() columns and FALSE for others
logicalVector = (grepl("activity..",colNames) | grepl("subject..",colNames) | grepl("-mean..",colNames) & !grepl("-meanFreq..",colNames) & !grepl("mean..-",colNames) | grepl("-std..",colNames) & !grepl("-std()..-",colNames));

# Subset final_data table based on the logicalVector to keep only desired columns
final_data = final_data[logicalVector==TRUE];

# 3) Use descriptive activity names to name the activities in the data set

# Merge the final_data set with the acitivityType table to include descriptive activity names
final_data = merge(final_data,activityType,by='activityId',all.x=TRUE);

# Updating the colNames vector to include the new column names after merge
colNames  = colnames(final_data); 

# 4) Appropriately label the data set with descriptive activity names. 

# Cleaning up the variable names
for (i in 1:length(colNames)) 
{
  colNames[i] = gsub("\\()","",colNames[i])
  colNames[i] = gsub("-std$","StdDev",colNames[i])
  colNames[i] = gsub("-mean","Mean",colNames[i])
  colNames[i] = gsub("^(t)","time",colNames[i])
  colNames[i] = gsub("^(f)","freq",colNames[i])
  colNames[i] = gsub("([Gg]ravity)","Gravity",colNames[i])
  colNames[i] = gsub("([Bb]ody[Bb]ody|[Bb]ody)","Body",colNames[i])
  colNames[i] = gsub("[Gg]yro","Gyro",colNames[i])
  colNames[i] = gsub("AccMag","AccMagnitude",colNames[i])
  colNames[i] = gsub("([Bb]odyaccjerkmag)","BodyAccJerkMagnitude",colNames[i])
  colNames[i] = gsub("JerkMag","JerkMagnitude",colNames[i])
  colNames[i] = gsub("GyroMag","GyroMagnitude",colNames[i])
};

# Reassign the new descriptive column names to the final_data set
colnames(final_data) = colNames;

# 5) Construct a second, independent tidy_data set with the average of each variable for each activity and each subject. 

# Construct a new table, final_dataNoActivityType without the activityType column
final_dataNoActivityType  = final_data[,names(final_data) != 'activityType'];

# Summarizing the final_dataNoActivityType table to include just the mean of each variable for each activity and each subject
tidy_data    = aggregate(final_dataNoActivityType[,names(final_dataNoActivityType) != c('activityId','subjectId')],by=list(activityId=final_dataNoActivityType$activityId,subjectId = final_dataNoActivityType$subjectId),mean);

# Merging the tidy_data with activityType to include descriptive acitvity names
tidy_data    = merge(tidy_data,activityType,by='activityId',all.x=TRUE);

# Save and View the tidy_data set 
write.table(tidy_data, './tidy_data.txt',row.names=TRUE,sep='\t');
View(tidy_data)