# coursera_getting_and_cleaning_data_final_project
The Final Project for the Coursera course: Getting and Cleaning Data
There are 3 files included (in addition to this README.md file):
1) CodeBook.MD - provides documentation of the data source and the logic to process it
2) run_analysis.R - the R source code that processes the source data into the tidy data set
3) tidy_data.txt - the output tidy data set

The run_analysis.R code works as follows:

1) Merge the training data and the test data.
2) Extract only the measurements on the mean and standard deviation for each measurement. 
3) Use descriptive activity names to name the activities in the data set
4) Appropriately label the data set with descriptive activity names. 
5) Construct a second, independent tidy_data set with the average of each variable for each activity and each subject. 
Finally - Save and View the tidy data set.
