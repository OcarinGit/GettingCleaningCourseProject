courseProject<-function(){
      #setwd("C:\\Users\\Ocarin\\Desktop\\MOOCS\\GettingandCleaningData\\Course Project2")
      #getwd()
      
      #You should create one R script called run_analysis.R that does the following. 
      
      #1-Merges the training and the test sets to create one data set.
      #2-Extracts only the measurements on the mean and standard deviation for each measurement. 
      #3-Uses descriptive activity names to name the activities in the data set
      #4-Appropriately labels the data set with descriptive variable names. 
      
      #5-From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
      
      if(!file.exists("data"))
      {
            dir.create("data")
      }
      
      library(dplyr)
      library(tidyr)
      
      fileUrl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
      download.file(fileUrl,"fuciData.zip")
      dateDownloaded<-date()
      print(dateDownloaded)
      unzip("fuciData.zip")
      
      #Obtain the factors' names. This makes it simpler to name the columns
      #We achieve this by reading the activity_labels.txt and features.txt text files
      
      actData<-read.table(".\\UCI HAR Dataset\\activity_labels.txt", sep=" ", header=FALSE, stringsAsFactors = FALSE)
      featData<-read.table(".\\UCI HAR Dataset\\features.txt", sep=" ", header=FALSE, stringsAsFactors = FALSE)
      
      #Read the files that contain the lectures from the subject (subject_text.txt)
      #the lectures taken from the samsung device (X_test.txt) and finally from the activities
      #the subject perform for every lecture (y_text.txt)
      subjectTestData<-read.table(".\\UCI HAR Dataset\\test\\subject_test.txt", sep=" ", header=FALSE, stringsAsFactors = FALSE)
      xTestData<-read.table(".\\UCI HAR Dataset\\test\\X_test.txt", header=FALSE, stringsAsFactors = FALSE)
      yTestData<-read.table(".\\UCI HAR Dataset\\test\\y_test.txt", sep=" ", header=FALSE, stringsAsFactors = FALSE)

      #Read the data from the train set
      subjectTraData<-read.table(".\\UCI HAR Dataset\\train\\subject_train.txt", sep=" ", header=FALSE)
      xTraData<-read.table(".\\UCI HAR Dataset\\train\\X_train.txt", header=FALSE)
      yTraData<-read.table(".\\UCI HAR Dataset\\train\\y_train.txt", sep=" ", header=FALSE)
      
      #Create the Column Subject_Test to know if the subject is from the test or train set
      subjectTest<-data.frame(Subject_Test=replicate(2947,"Test"))
      train<-data.frame(Subject_Test=replicate(7352,"Train"))
      
      ################ This instructions fullfills requirement 3 ########
      #3. Uses descriptive activity names to name the activities in the test data set.
      #This will be completed once the row bind finishes.
      
      #Bind the columns so we can have the subject Id first, then the activity the subject performed in a neat character way
      #The a column saying if the subject is from the test o train set and finally the rest of the data, meaning the lectures
      cleanTestData<-cbind(subjectTestData,actData$V2[as.numeric(yTestData$V1)],subjectTest,xTestData)
      cleanTraData<-cbind(subjectTraData,actData$V2[as.numeric(yTraData$V1)],train,xTraData)

      #Rename the first binded columns to have descriptive names
      colnames(cleanTraData)[1]<-"Subject"
      colnames(cleanTraData)[2]<-"Activity"
      
      colnames(cleanTestData)[1]<-"Subject"
      colnames(cleanTestData)[2]<-"Activity"
      
      
      ################# This instruction FullFills Requirement 1 #######
      #1. Merges the training and the test sets to create one data set.
      cleanData<-rbind(cleanTestData,cleanTraData)
      
      
      
      ################ This instruction fullfills requirement 4 ########
      #4. Appropietly labels the data set with descriptive variable names.
      colnames(cleanData)[4:564]<-featData$V2
      names(cleanData)
      
      ############## This instruction fullfills requirement 2 ########
      #2. Extracts only the measurements on the mean and standard deviation for each measurement. 
      goodColumns<-c(which(grepl("mean()", names(cleanData))),which(grepl("std()", names(cleanData))))
      cleanData<-cleanData[,c(1:4,goodColumns)]
      #tidyData2 <- select(cleanData, contains("Subject"), contains("Activity"), contains("mean()"), contains("std()"))
      cleanData$Activity<-as.character(cleanData$Activity)
      cleanData$Subject<-as.character(cleanData$Subject)
      cleanData$Subject_Test<-as.character(cleanData$Subject_Test)
      #names(cleanData[,c(1:4,goodColumns)])
      head(cleanData)
      tail(cleanData)
      summary(cleanData)
      names(cleanData)
      str(cleanData)
      
      ## Correct duplicate indicators in the name
      colnames(cleanData) <- gsub("tBodyBody","tBody",colnames(cleanData))
      colnames(cleanData) <- gsub("fBodyBody","fBody",colnames(cleanData))
      
      ## Rename the tBody with Time Body and tGravity with Time Gravity
      colnames(cleanData) <- gsub("tBody","TimeBody",colnames(cleanData))
      colnames(cleanData) <- gsub("fBody","FrequencyBody",colnames(cleanData))
      colnames(cleanData) <- gsub("tGravity","TimeGravity",colnames(cleanData))
      colnames(cleanData) <- gsub("fGravity","FrequencyGravity",colnames(cleanData))
      
      ## Rename Accelerometer and Gyroscope
      colnames(cleanData) <- gsub("Acc","Accelerometer",colnames(cleanData))
      colnames(cleanData) <- gsub("Gyro","Gyroscope",colnames(cleanData))
      
      ## Rename Magnitude
      colnames(cleanData) <- gsub("Mag","Magnitude",colnames(cleanData))
      
      ## Rename the estimated values
      colnames(cleanData) <- gsub("-mean","Mean",colnames(cleanData))
      colnames(cleanData) <- gsub("-std","StandardDeviation",colnames(cleanData))
      colnames(cleanData) <- gsub("-X","AxisX",colnames(cleanData))
      colnames(cleanData) <- gsub("-Y","AxisY",colnames(cleanData))
      colnames(cleanData) <- gsub("-Z","AxisZ",colnames(cleanData))
      colnames(cleanData) <- gsub("()","",colnames(cleanData),fixed=T)
      
      
      ############## This instruction fullfills requeriment 5 ######
      #5. From the data set in step 4, creates a second, independet tidy data set with the average
      #of each variable  for ech activity and each subject
      tidyMelt <- melt(cleanData,id=c("Activity","Subject","Subject_Test"),variables=c(cleanData[,4:83]))
      #tidyMelt <- melt(tidyData,id=c("Activity","Subject"),variables=c(tidyData[,3:68]))
      tidySummary <- dcast(tidyMelt, Activity + Subject + Subject_Test ~ variable, mean)
      write.table(tidySummary,file=".\\MeanActivitySubject3.txt", row.names = FALSE)
      
}