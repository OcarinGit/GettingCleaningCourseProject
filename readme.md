#This repository contains the script R file and data that solves the course project for Getting and Cleaning Data
## The R scrip is composed of the following steps even with the downloading of data files included

1. First step is to download the zip file containing the lectures.
2.Second step (which is not shown in here is to decompress the zip file and to rename the resultant folder to "data" without the quotes) for easier reading of the file
      
3. Third step is to obtain the factors' names. This makes it simpler to name the columns. We achieve this by reading the activity_labels.txt and features.txt text files

4. Read the files from test subjects and prepare the columns so subject activity and subject type (test or train) and finally the lectures from every subject are bind into a single table

5. Do the same with the train subject

6. Bind the rows of both data frames

7. Give good presentation to the data.


####Code Book

      ###Activities and features
      actData$V2
      featData$V2
      
      ###Read the files that contain the lectures from the subject (subject_text.txt) the lectures taken from the samsung device (X_test.txt) and finally from the activities the subject perform for every lecture (y_text.txt)
      subjectTestData
      xTestData
      yTestData
      
      ####Column Subject_Test to know if the subject is from the test or train set
      subjectTest
      train
      
      ###Bind the columns so we can have the subject Id first, then the activity the subject performed in a neat character way The a column saying if the subject is from the test o train set and finally the rest of the data, meaning the lectures
      cleanTestData
      
       
      ###Read the data from the train set
      subjectTraData
      xTraData
      yTraData

	###Bind the columns so we can have the subject Id first, then the activity the subject performed in a neat character way The a column saying if the subject is from the test o train set and finally the rest of the data, 
      cleanTraData

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
      