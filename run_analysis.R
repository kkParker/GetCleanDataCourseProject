#Getting and Cleaning Data Course Project
#This uses a wearable computing database for a Samsung Galaxy S smartphone
#and creates a Tidy dataset

#Details on the variables can be found in the CodeBook.md file
#Details about what happens in this script can be found in the README.md file

#Collect, clean, and create a tidy dataset
#Create one R script called run_analysis.R that does the following steps
#1.	Merges the training and the test sets to create one data set.
#Staff noted to ignore Inertial Signals folders so no processing was designed for that data

####################IF RUNNING ON YOUR OWN COMPUTER, YOU MIGHT NEED TO EDIT/RUN THIS LINE###############################
#setwd("C:/Users/????/OneDrive/Copies/Coursera/Data Science Specialization/Getting and Cleaning Data/Second Time Aug 2015/Course Project/")

#Subject Data Files (subject_train.txt and subject_test.txt)
#Each row identifies the subject (30 total) who performed the 
#activity for each window sample. Its range is from 1 to 30. 
#Read in Train Data #7352 obs
dfSubTrain <- read.table("./UCI HAR Dataset/train/subject_train.txt",sep="")
str(dfSubTrain) #"V1" column is created
#Read in Test Data #2947 obs
dfSubTest <- read.table("./UCI HAR Dataset/test/subject_test.txt",sep="")
str(dfSubTest) # "V1" column is created

#Combine Train and Test Datafiles into one Subject DataFrame
Subject <- rbind(dfSubTrain,dfSubTest) #all 10,299 obs
colnames(Subject) <-c('Subject') #change default 'V1' to meaningful 'Subject'


#Label Data Files for the activities (y_train.txt and y_test.txt)
#KEY: 1:WALKING 2:WALKING_UPSTAIRS 3:WALKING_DOWNSTAIRS 4:SITTING 5:STANDING 6:LAYING
#Read in Train Data #7352 obs
dfYTrain <- read.table("./UCI HAR Dataset/train/y_train.txt",sep="")
head(dfYTrain,n=15) #"V1" column is created
#Read in Test Data #2947 obs
dfYTest <- read.table("./UCI HAR Dataset/test/y_test.txt",sep="")
str(dfYTest) # "V1" column is created

#Combine Train and Test Datafiles into one Activity Label DataFrame
Label <- rbind(dfYTrain,dfYTest) #all 10,299 obs
colnames(Label) <-c('ID') #change default V1 to meaningful 'ID'

#check that have 1 to 6 Activities
table(Label) #values 1 to 6
#   1    2    3    4    5    6 
#1722 1544 1406 1777 1906 1944  


#Data Features Datafiles (X_train.txt and X_test.txt)
#Read in Train Data #7352 obs
dfXTrain <- read.table("./UCI HAR Dataset/train/X_train.txt",sep="")
str(dfXTrain) #"V1" : "V561"
#Read in Test Data #2947 obs
dfXTest <- read.table("./UCI HAR Dataset/test/X_test.txt",sep="")
str(dfXTest) # "V1": "V561"

#Combine Train and Test DAtafiles into one Features DataFrame
Data <- rbind(dfXTrain,dfXTest) #all 10,299 obs

#Get Feature (variable) Labels from features.txt datafile
features <- read.table("./UCI HAR Dataset/features.txt",sep=" ")
str(features) #'V1' column is id, 'V2' column is the feature names
colnames(Data)<-features$V2 #change the default "V1": "V561" to be the feature names (i.e.,tBodyAcc-mean()-X  )

#Combine all columns into one dataset (from Subject, Label, Data)
dfAll <- cbind(Subject,Label,Data)
head(dfAll[,1:20]) #verify that this worked


#2.Extracts only the measurements on the mean and standard deviation for each measurement. 
#So I need to subset so that I only have mean/stdev columns
#I'm using the interpreation that variables that end with -mean() -std()
#are calculated means and standard deviations so I'll keep those
#So we know there are 33 main variables measured.
#So I should have 66 total variables (1 each for a mean and standard deviation)

#First, let's get the Subject and ID columns, we know we need to keep these
dfIDs <- dfAll[,c('Subject','ID')] 

#Next, find all the columns with -mean()
dfmeanAll<-dfAll[ , grepl( "-mean()" , names( dfAll ) ) ] #includes -meanFreq()
#This also includes some with -meanFreq() - I realized this because dfmeanAll had 46 variables!!
#So we remove those extra columns
dfmean <- dfmeanAll[, -grep("-meanFreq()" , names( dfmeanAll ) )] #remove -meanFreq() so now 33 variables

#Next, we'll get the columns with -std()
dfstd<-dfAll[ , grepl( "-std()" , names( dfAll ) ) ] #33 variables

#Finally, we create one dataset with the ID & Subject, and only -mean() and -std() ending variable measurements
dfmeanstd <- cbind(dfIDs,dfmean,dfstd) #68 variables (ID, Subject, 33 mean and 33 std - Yeah!!)


#3.	Uses descriptive activity names to name the activities in the data set
#We use our key for the 6 activities:
#KEY: 1:WALKING 2:WALKING_UPSTAIRS 3:WALKING_DOWNSTAIRS 4:SITTING 5:STANDING 6:LAYING
#Let's create a new column with these activity labels called 'Activity'
#First define the base as 'Laying' (it's the value for ID = 6)
dfmeanstd$Activity <- 'Laying' #define base
#Then we rename each other ID with the correct activity name
dfmeanstd$Activity[dfmeanstd$ID==1] <- 'Walking'
dfmeanstd$Activity[dfmeanstd$ID==2] <- 'WalkingUpStairs'
dfmeanstd$Activity[dfmeanstd$ID==3] <- 'WalkingDownStairs'
dfmeanstd$Activity[dfmeanstd$ID==4] <- 'Sitting'
dfmeanstd$Activity[dfmeanstd$ID==5] <- 'Standing'
#Now we have 69 variables with the addition of Activity
#check to make sure this worked so ID 1 is Walking, etc.
table(dfmeanstd$Activity, dfmeanstd$ID)

#4.Appropriately labels the data set with descriptive variable names. 
#I decided to change these terms in the variables to make more readable:
#Change "t" to "Time"
#Change "f" to "Frequency"
#Change "Acc" to "Accelerometer"
#Change "Mag" to "Magnitude"

colnames(dfmeanstd)[colnames(dfmeanstd)=="tBodyAcc-mean()-X"] <- "TimeBodyAccelerometer-mean()-X"
colnames(dfmeanstd)[colnames(dfmeanstd)=="tBodyAcc-mean()-Y"] <- "TimeBodyAccelerometer-mean()-Y"
colnames(dfmeanstd)[colnames(dfmeanstd)=="tBodyAcc-mean()-Y"] <- "TimeBodyAccelerometer-mean()-Z"
colnames(dfmeanstd)[colnames(dfmeanstd)=="tGravityAcc-mean()-X"] <- "TimeGravityAccelerometer-mean()-X"
colnames(dfmeanstd)[colnames(dfmeanstd)=="tGravityAcc-mean()-Y"] <- "TimeGravityAccelerometer-mean()-Y"
colnames(dfmeanstd)[colnames(dfmeanstd)=="tGravityAcc-mean()-Z"] <- "TimeGravityAccelerometer-mean()-Z"
colnames(dfmeanstd)[colnames(dfmeanstd)=="tBodyAccJerk-mean()-X"] <- "TimeBodyAccelerometerJerk-mean()-X"
colnames(dfmeanstd)[colnames(dfmeanstd)=="tBodyAccJerk-mean()-Y"] <- "TimeBodyAccelerometerJerk-mean()-Y"
colnames(dfmeanstd)[colnames(dfmeanstd)=="tBodyAccJerk-mean()-Z"] <- "TimeBodyAccelerometerJerk-mean()-Z"
colnames(dfmeanstd)[colnames(dfmeanstd)=="tBodyGyro-mean()-X"] <- "TimeBodyGyro-mean()-X"
colnames(dfmeanstd)[colnames(dfmeanstd)=="tBodyGyro-mean()-Y"] <- "TimeBodyGyro-mean()-Y"
colnames(dfmeanstd)[colnames(dfmeanstd)=="tBodyGyro-mean()-Z"] <- "TimeBodyGyro-mean()-Z"
colnames(dfmeanstd)[colnames(dfmeanstd)=="tBodyGyroJerk-mean()-X"] <- "TimeBodyGyroJerk-mean()-X"
colnames(dfmeanstd)[colnames(dfmeanstd)=="tBodyGyroJerk-mean()-Y"] <- "TimeBodyGyroJerk-mean()-Y"
colnames(dfmeanstd)[colnames(dfmeanstd)=="tBodyGyroJerk-mean()-Z"] <- "TimeBodyGyroJerk-mean()-Z"
colnames(dfmeanstd)[colnames(dfmeanstd)=="tBodyAccMag-mean()-X"] <- "TimeBodyAccelerometerMagnitude-mean()-X"
colnames(dfmeanstd)[colnames(dfmeanstd)=="tBodyAccMag-mean()-Y"] <- "TimeBodyAccelerometerMagnitude-mean()-Y"
colnames(dfmeanstd)[colnames(dfmeanstd)=="tBodyAccMag-mean()-Z"] <- "TimeBodyAccelerometerMagnitude-mean()-Z"
colnames(dfmeanstd)[colnames(dfmeanstd)=="tBodyGyroMag-mean()"] <- "TimeBodyGyroMagnitude-mean()"
colnames(dfmeanstd)[colnames(dfmeanstd)=="tBodyGyroJerkMag-mean()"] <- "TimeBodyGyroJerkMagnitude-mean()"
colnames(dfmeanstd)[colnames(dfmeanstd)=="fBodyAcc-mean()-X"] <- "FrequencyBodyAccelerometer-mean()-X"
colnames(dfmeanstd)[colnames(dfmeanstd)=="fBodyAcc-mean()-Y"] <- "FrequencyBodyAccelerometer-mean()-Y"
colnames(dfmeanstd)[colnames(dfmeanstd)=="fBodyAcc-mean()-Z"] <- "FrequencyBodyAccelerometer-mean()-Z"
colnames(dfmeanstd)[colnames(dfmeanstd)=="fBodyAccJerk-mean()-X"] <- "FrequencyBodyAccelerometerJerk-mean()-X"
colnames(dfmeanstd)[colnames(dfmeanstd)=="fBodyAccJerk-mean()-Y"] <- "FrequencyBodyAccelerometerJerk-mean()-Y"
colnames(dfmeanstd)[colnames(dfmeanstd)=="fBodyAccJerk-mean()-Z"] <- "FrequencyBodyAccelerometerJerk-mean()-Z"
colnames(dfmeanstd)[colnames(dfmeanstd)=="fBodyGyro-mean()-X"] <- "FrequencyBodyGyro-mean()-X"
colnames(dfmeanstd)[colnames(dfmeanstd)=="fBodyGyro-mean()-Y"] <- "FrequencyBodyGyro-mean()-Y"
colnames(dfmeanstd)[colnames(dfmeanstd)=="fBodyGyro-mean()-Z"] <- "FrequencyBodyGyro-mean()-Z"
colnames(dfmeanstd)[colnames(dfmeanstd)=="fBodyAccMag-mean()"] <- "FrequencyBodyAccelerometerMagnitude-mean()"
colnames(dfmeanstd)[colnames(dfmeanstd)=="fBodyBodyAccJerkMag-mean()"] <- "FrequencyBodyBodyAccelerometerJerkMagnitude-mean()"
colnames(dfmeanstd)[colnames(dfmeanstd)=="fBodyBodyGyroMag-mean()"] <- "FrequencyBodyBodyGyroMagnitude-mean()"
colnames(dfmeanstd)[colnames(dfmeanstd)=="fBodyBodyGyroJerkMag-mean()"] <- "FrequencyBodyBodyGyroJerkMagnitude-mean()"
colnames(dfmeanstd)[colnames(dfmeanstd)=="tBodyAcc-std()-X"] <- "TimeBodyAccelerometer-std()-X"
colnames(dfmeanstd)[colnames(dfmeanstd)=="tBodyAcc-std()-Y"] <- "TimeBodyAccelerometer-std()-Y"
colnames(dfmeanstd)[colnames(dfmeanstd)=="tBodyAcc-std()-Z"] <- "TimeBodyAccelerometer-std()-Z"
colnames(dfmeanstd)[colnames(dfmeanstd)=="tGravityAcc-std()-X"] <- "TimeGravityAccelerometer-std()-X"
colnames(dfmeanstd)[colnames(dfmeanstd)=="tGravityAcc-std()-Y"] <- "TimeGravityAccelerometer-std()-Y"
colnames(dfmeanstd)[colnames(dfmeanstd)=="tGravityAcc-std()-Z"] <- "TimeGravityAccelerometer-std()-Z"
colnames(dfmeanstd)[colnames(dfmeanstd)=="tBodyAccJerk-std()-X"] <- "TimeBodyAccelerometerJerk-std()-X"
colnames(dfmeanstd)[colnames(dfmeanstd)=="tBodyAccJerk-std()-Y"] <- "TimeBodyAccelerometerJerk-std()-Y"
colnames(dfmeanstd)[colnames(dfmeanstd)=="tBodyAccJerk-std()-Z"] <- "TimeBodyAccelerometerJerk-std()-Z"
colnames(dfmeanstd)[colnames(dfmeanstd)=="tBodyGyroJerk-std()-X"] <- "TimeBodyGyroJerk-std()-X"
colnames(dfmeanstd)[colnames(dfmeanstd)=="tBodyGyroJerk-std()-Y"] <- "TimeBodyGyroJerk-std()-Y"
colnames(dfmeanstd)[colnames(dfmeanstd)=="tBodyGyroJerk-std()-Z"] <- "TimeBodyGyroJerk-std()-Z"
colnames(dfmeanstd)[colnames(dfmeanstd)=="tBodyGyro-std()-X"] <- "TimeBodyGyro-std()-X"
colnames(dfmeanstd)[colnames(dfmeanstd)=="tBodyGyro-std()-Y"] <- "TimeBodyGyro-std()-Y"
colnames(dfmeanstd)[colnames(dfmeanstd)=="tBodyGyro-std()-Z"] <- "TimeBodyGyro-std()-Z"
colnames(dfmeanstd)[colnames(dfmeanstd)=="tBodyAccMag-std()"] <- "TimeBodyAccelerometerMagnitude-std()"
colnames(dfmeanstd)[colnames(dfmeanstd)=="tGravityAccMag-std()"] <- "TimeGravityAccelerometerMagnitude-std()"
colnames(dfmeanstd)[colnames(dfmeanstd)=="tBodyAccJerkMag-std()"] <- "TimeBodyAccelerometerJerkMagnitude()"
colnames(dfmeanstd)[colnames(dfmeanstd)=="tBodyGyroMag-std()"] <- "TimeBodyGyroMagnitude()-std()"
colnames(dfmeanstd)[colnames(dfmeanstd)=="tBodyGyroJerkMag-std()"] <- "TimeBodyGyroJerkMagnitude-std()"
colnames(dfmeanstd)[colnames(dfmeanstd)=="fBodyAcc-std()-X"] <- "FrequencyBodyAccelerometer-std()-X"
colnames(dfmeanstd)[colnames(dfmeanstd)=="fBodyAcc-std()-Y"] <- "FrequencyBodyAccelerometer-std()-Y"
colnames(dfmeanstd)[colnames(dfmeanstd)=="fBodyAcc-std()-Z"] <- "FrequencyBodyAccelerometer-std()-Z"
colnames(dfmeanstd)[colnames(dfmeanstd)=="fBodyAccJerk-std()-X"] <- "FrequencyBodyAccelerometerJerk-std()-X"
colnames(dfmeanstd)[colnames(dfmeanstd)=="fBodyAccJerk-std()-Y"] <- "FrequencyBodyAccelerometerJerk-std()-Y"
colnames(dfmeanstd)[colnames(dfmeanstd)=="fBodyAccJerk-std()-Z"] <- "FrequencyBodyAccelerometerJerk-std()-Z"
colnames(dfmeanstd)[colnames(dfmeanstd)=="fBodyGyroMag-std()"] <- "FrequencyBodyGyroMagnitude()-std()"
colnames(dfmeanstd)[colnames(dfmeanstd)=="fBodyGyro-std()-X"] <- "FrequencyBodyGyro-std()-X"
colnames(dfmeanstd)[colnames(dfmeanstd)=="fBodyGyro-std()-Y"] <- "FrequencyBodyGyro-std()-Y"
colnames(dfmeanstd)[colnames(dfmeanstd)=="fBodyGyro-std()-Z"] <- "FrequencyBodyGyro-std()-Z"
colnames(dfmeanstd)[colnames(dfmeanstd)=="fBodyAccMAg-std()"] <- "FrequencyBodyAccelerometerMagnitude-std()"
colnames(dfmeanstd)[colnames(dfmeanstd)=="fBodyAccJerkMag-std()"] <- "FrequencyBodyAccelerometerJerkMagnitude-std()"
colnames(dfmeanstd)[colnames(dfmeanstd)=="fBodyBodyGyroMag-std()"] <- "FrequencyBodyBodyGyroMagnitude-std()"
colnames(dfmeanstd)[colnames(dfmeanstd)=="fBodyBodyGyroJerkMag-std()"] <- "FrequencyBodyBodyGyroJerkMagnitude-std()"

#5.	From the data set in step 4, creates a second, independent tidy data set with the
#average of each variable for each activity and each subject.
#Tidy: Each variable you measure should be in one column,
#Each different observation of that variable should be in a different row
#First we store all the variable names
namesMeltDf <-names(dfmeanstd)
#Next will pull off just the feature names (skip 1 ID, 2 Subject, and 69 Activity)
#We'll use these to perform the melt
varnamesMeltDf<-namesMeltDf[3:68]

#We need the reshape2 package for the melt function and dcast function
library(reshape2) 
MeltDf <- melt(dfmeanstd, id=c("Subject","Activity"),measure.var=varnamesMeltDf)
#we now have a really long list with variables Subject, Activity, variable, value
head(MeltDf, n=60)
#To make it tidy we need each variable to be it's own column so we will summarize
#by getting the average(mean) of each of the measures
#Note 'variable' is now all our 66 variables
TidyMeansDf <- dcast(MeltDf, Subject + Activity  ~ variable, mean)
#view first 2 subjects for the 6 activities - looks good.
head(TidyMeansDf,n=12) 

#upload your data set as a txt file created with write.table() using row.name=FALSE
#I used default sep to create a space-delimited file
write.table(TidyMeansDf, file = "tidy.txt", row.name=FALSE)
