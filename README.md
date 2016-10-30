#Programming Assignment 4 - Getting and Cleaning Data Course Project

##### DataSource

[The original DataSource](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)


##### run_analysis.R

1. The script downloads and unzips the data described on the DataSource.
2. It merges the training and the test sets to create one data set.
3. It filters only the measurements on the mean and standard deviation for each measurement.
4. It merges in the activity names for the activities in the data set.
5. It create labeled columns to describe each variable from the data set.
6. It create a file `TidyData.txt` that calculates the average of each variable for each activity and each subject.


##### Submitted Data

* The submitted data set is tidy: `TidyData.txt`


##### Code Book

* A code book that modifies and updates the available codebooks with the data to indicate all the variables and summaries calculated, along with units, and any other relevant information: `CodeBook.md`

