# getting_and_cleaning_data
Jeff Leek coursera class

This is the final project for the Getting and Cleaning Data Coursera class. The R script, run_analysis.R, does the following:

1. First, download data from http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
2. Load the activity and feature files without column names
3. Give column names
3. Load training files and create a full training dataset in one data frame
4. Load test files and create a full test dataset in one data frame
4. Merge training and test objects
5. Extract only the data needed for the assignment
6. Clean the variable names
7. Create a tidy dataset that only has the mean value of each variable for each subject and activity
7. Write the file tidyData.txt
