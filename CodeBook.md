---
title: "Getting/Cleaning Data Course Project Codebook"
author: "Coursera KKParker"
date: "August 21, 2015"
output: html_document
---

This is a code book that does the following:  

1. describes the variables  
2. describes the data  
3. describes any transformations/work performed/final units used to clean up the data
* The details on the variables is information summarized from the features_info.txt file

# Data Description
This data is collected from the accelerometers from the Samsung Galaxy S smartphone

# Variable Descriptions 
Note that Staff comments on the message board said to ignore Inertial Signals folders so no processing was designed for that data

The features (variable measurements) selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 
These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

'f' to indicate frequency domain signals)
't' indicates time domain signals

tBodyAcc-XYZ  
tGravityAcc-XYZ  
tBodyAccJerk-XYZ  

tBodyGyro-XYZ  
tBodyGyroJerk-XYZ  

tBodyAccMag  
tGravityAccMag  
tBodyAccJerkMag  
tBodyGyroMag  
tBodyGyroJerkMag  

fBodyAcc-XYZ  
fBodyAccJerk-XYZ  
fBodyGyro-XYZ  
fBodyAccMag  
fBodyAccJerkMag  
fBodyGyroMag  
fBodyGyroJerkMag  




The set of variables that were estimated from these signals are (but only mean() and std() were included in the tidy dataset: 

mean(): Mean value
std(): Standard deviation
mad(): Median absolute deviation 
max(): Largest value in array
min(): Smallest value in array
sma(): Signal magnitude area
energy(): Energy measure. Sum of the squares divided by the number of values. 
iqr(): Interquartile range 
entropy(): Signal entropy
arCoeff(): Autorregresion coefficients with Burg order equal to 4
correlation(): correlation coefficient between two signals
maxInds(): index of the frequency component with largest magnitude
meanFreq(): Weighted average of the frequency components to obtain a mean frequency
skewness(): skewness of the frequency domain signal 
kurtosis(): kurtosis of the frequency domain signal 
bandsEnergy(): Energy of a frequency interval within the 64 bins of the FFT of each window.
angle(): Angle between to vectors.

Additional vectors obtained by averaging the signals in a signal window sample. These are used on the angle() variable:

gravityMean
tBodyAccMean
tBodyAccJerkMean
tBodyGyroMean
tBodyGyroJerkMean

The complete list of variables of each feature vector is available in 'features.txt'




# Cleaning the Data Work Performed
Included only -std() and -mean()
Changed these variable names
#I examined the variables and found these symbols that were confusing:
#"t" means "time"
#"f" means frequency
#"Acc" indicates accelerometer
#"Mag" indicates magnitude
#Therefore I am going to change these column name changes
#Change "t" to "Time"
#Change "f" to "Frequency"
#Change "Acc" to "Accelerometer"
#Change "Mag" to "Magnitude"
Not knowing why Body, Body was in the dataset, I left those

In the tidy data, the mean was calculated so those were the units in the final dataset

 