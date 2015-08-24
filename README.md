---
title: "Getting/Cleaning Data Course Project README"
author: "Coursera KKParker"
date: "August 21, 2015"
output: html_document
---
This README.md file does the following: 

1. Explains the README.md and CodeBook.md scripts   
2. Explains how the script run_analysis.R works  

# The README.md and CodeBook.md scripts
### Viewing these files
If you don't know how to view a .md file, one way to see the .md file in R Studio is described. 

1. Open the file in R Studio.  
2. In the markdown menu at the top of the editor with the file, where it says Preview HTML (or Word), you can choose 'View in Pane' to see the content without creating a separate html or Word file.  
3. Then you can select Preview HTML to see the output in the Viewer (where Help is located)

# README.md markdown script
This file explains how the script run_analysis.R works.  

# CodeBook.md markdown script
This is a code book that does the following:  

1. describes the variables  
2. describes the data  
3. describes any transformations/work performed to clean up the data

# Explanation of how the script run_analysis.R works
###Before running the script
1. You will use the <b>reshape2</b> and <b>plyr</b> packages in this script so make sure you have installed those packages.  
2. You should have the run_analysis.R script along with the folder, UCI HAR Dataset in your working directory.  A line is included that you can run to change your working directory if needed. The code assumes that the folder structure is as originally structured with the test and train folders containing the files: subject_test.txt, X_test.txt, y_text.txt and subject_train.txt, X_train.txt, y_train.txt in their respective folders.  It also assumes that features.txt is in the in the UCI HAR Dataset folder.    
3. Detailed comments are included in the run_analysis.R script to help document the steps that are following in processing the data.

###Steps of the script
####Merges the training and the test sets to create one data set.
1. Note that Staff comments on the message board said to ignore Inertial Signals folders so no processing was designed for that data
2. An option is included to set the working directory.
3. The Subject Data Files (subject_train.txt and subject_test.txt) are read in.  Each row identifies the subject (30 total) who performed the activity for each window sample. Its range is from 1 to 30 subjects. These files are combined into one long dataset.  The default "V1" column name is changed to the more meaningful 'Subject'
3. The Label Data Files for the activities (y_train.txt and y_test.txt) are read in. Each row lists the activty performed. These files are combined into one long dataset.  The default "V1" column name is changed to the more meaningful 'ID'. I included a table command to check that there were 6 activities in this file which matches the key: 1:WALKING 2:WALKING_UPSTAIRS 3:WALKING_DOWNSTAIRS 4:SITTING 5:STANDING 6:LAYING. 
4. The Data Features Datafiles (X_train.txt and X_test.txt) are read in. Each row has 561 features (variables) that are measured. These files are combined into one long dataset.   
5. I used the features.txt file to pull in the column names which were "V1" : "V561" by default. These files are combined into one long dataset.
6. I now created one dataset with the Subject data, the Label data and the Data Features data.

####Extracts only the measurements on the mean and standard deviation for each measurement. 
1. I interpreted this to be the measurement variables that end with -mean() or -std() as the ones that would be the calculated means and standard deviations so I'll keep those. I hope to end up with 33 mean and 33 std variables.
2. I first pulled off the Subject and ID columns because I will still need these in our Tidy dataset.
3. I next pulled off the columns with -mean(). I discovered that it also included -meanFreq() variables so I had to exclude those as well (I realized this because my first subset had 46 variables instead of the required 33!)
4. Then I found the columns with -std().
5. Finally, I combined these 3 sets of variables into one dataset with the ID & Subject, the -mean(), and the -std() ending variable measurements for 2 + (33 * 2)  = 68 total variables!


####Uses descriptive activity names to name the activities in the data set
I will use our key for the 6 activities:  
KEY: 1:WALKING 2:WALKING_UPSTAIRS 3:WALKING_DOWNSTAIRS 4:SITTING 5:STANDING 6:LAYING

1. I create a new column, Activity, with these labels.  I start with the base of assigning everything to the value "Laying."  
2. Next I use the ID column to subset the data and change from the default Laying to the approrpriate activity.  
3. Finally, I use the table command to check to make sure this worked so ID 1 is Walking, etc.

####Appropriately labels the data set with descriptive variable names. 
I decided to make the following transformations to the variable names to make them more readable:
# Rename a column in R
#colnames(data)[colnames(data)=="old_name"] <- "new_name"

####From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
The goal is to create a Tidy dataset where:  
Each variable you measure should be in one column,  
Each different observation of that variable should be in a different row.

1. I store all the variable measumre names that have been created. So I first pull of all the names and then restrict it to just the first 2 and skip the final one because 1 is ID, 2 is Subject, and 69 is Activity.
2. I will use these to perform a melt reorganizing the data into one long list of Subject, Activity, and the measure.
3. To make it tidy I need each variable to be it's own column so I will summarize by getting the average(mean) of each of the measures so that each Subject/Activity combination is one value (the mean) and the measures are each columns.
4. Finally, I output the Tidy dataframe to a .txt file and use the default space delimeter so this could be easily read back into R or a package like Excel. 