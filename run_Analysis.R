#Course Project
#You should create one R script called run_analysis.R that does the following. 

#1. Merges the training and the test sets to create one data set.
#2. Extracts only the measurements on the mean and standard deviation for each measurement. 
#3. Uses descriptive activity names to name the activities in the data set
#4. Appropriately labels the data set with descriptive variable names. 

#From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

runAnalysis<-function(){
      
      
      #First step is to download the zip file containing the lectures.
      setwd("C:\\Users\\Ocarin\\Desktop\\MOOCS\\GettingandCleaningData\\Course Project")
      getwd()
      
      fileUrl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
      
      download.file(fileUrl,"accelerometers.zip")
      
      #Second step (which is not shown in here is to decompress the zip file and to rename the resultant folder to "data" without the quotes)
      #for easier reading of the file
      
      #Third step is to obtain the factors' names. This makes it simpler to name the columns
      #We achieve this by reading the activity_labels.txt and features.txt text files
      actData<-read.table(".\\data\\activity_labels.txt")
      featData<-read.table(".\\data\\features.txt")
      
      #Finally obtaining the activities and features in character vectors
      actData$V2<-as.character(actData$V2)
      featData$V2<-as.character(featData$V2)
      
      #Third step is to read the files that contain the lectures from the subject (subject_text.txt)
      #the lectures taken from the samsung device (X_test.txt) and finally from the activities
      #the subject perform for every lecture (y_text.txt)
      subjectTestData<-read.table(".\\data\\test\\subject_test.txt", sep=" ", header=FALSE)
      xTestData<-read.table(".\\data\\test\\X_test.txt", header=FALSE)
      yTestData<-read.table(".\\data\\test\\y_test.txt", sep=" ", header=FALSE)
      
      #Create the Column Subject_Test to know if the subject is from the test or train set
      subjectTest<-data.frame(Subject_Test=replicate(2947,"Test"))
      train<-data.frame(Subject_Test=replicate(7352,"Train"))
      
      #Bind the columns so we can have the subject Id first, then the activity the subject performed in a neat character way
      #The a column saying if the subject is from the test o train set and finally the rest of the data, meaning the lectures
      cleanTestData<-cbind(subjectTestData,actData$V2[as.numeric(yTestData$V1)],subjectTest,xTestData)
      
      #Rename the first bind columns to have descriptive names
      colnames(cleanTestData)[1]<-"Subject"
      colnames(cleanTestData)[2]<-"Activity"
      
      #Read the data from the train set
      subjectTraData<-read.table(".\\data\\train\\subject_train.txt", sep=" ", header=FALSE)
      xTraData<-read.table(".\\data\\train\\X_train.txt", header=FALSE)
      yTraData<-read.table(".\\data\\train\\y_train.txt", sep=" ", header=FALSE)
      cleanTraData<-cbind(subjectTraData,actData$V2[as.numeric(yTraData$V1)],train,xTraData)
      colnames(cleanTraData)[1]<-"Subject"
      colnames(cleanTraData)[2]<-"Activity"
      
      ################# This instruction FullFills Requirement 1 #######
      #1. Merges the training and the test sets to create one data set.
      cleanData<-rbind(cleanTestData,cleanTraData)
      
      
      ################ This instruction fullfills requirement 3 ########
      #3. Uses descriptive activity names to name the activities in the data set
      colnames(cleanData)[4:564]<-features
      names(cleanData)
      
      ############## This instruction fullfulls requirement 2 ########
      #2. Extracts only the measurements on the mean and standard deviation for each measurement. 
      goodColumns<-c(which(grepl("mean()", names(cleanData))),which(grepl("std()", names(cleanData))))
      tidyData<-cleanData[,c(1:4,goodColumns)]
      names(cleanData[,c(1:4,goodColumns)])
      head(tidyData)
      tail(tidyData)
      
}