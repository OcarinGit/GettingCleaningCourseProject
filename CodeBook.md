####Code Book

      ###I obtain the Activities and features with these variables
      actData<-read.table(".\\data\\activity_labels.txt")
      featData<-read.table(".\\data\\features.txt")

      ##After I read the values from the text files I transform the factor variables to character variables, this is for make it easier to work with them
      actData$V2<-as.character(actData$V2)
      featData$V2<-as.character(featData$V2)
      
      ###Read the files that contain the lectures from the subject (subject_text.txt) the lectures taken from the samsung device (X_test.txt) and finally from the activities the subject perform for every lecture (y_text.txt)
      subjectTestData<-read.table(".\\data\\test\\subject_test.txt", sep=" ", header=FALSE)
      xTestData<-read.table(".\\data\\test\\X_test.txt", header=FALSE)
      yTestData<-read.table(".\\data\\test\\y_test.txt", sep=" ", header=FALSE)
      
      ###Create the Column Subject_Test to know if the subject is from the test or train set
      ###This is being done to avoid the lose of information once the rows from the test and train set are being bind
      subjectTest<-data.frame(Subject_Test=replicate(2947,"Test"))
      train<-data.frame(Subject_Test=replicate(7352,"Train"))

      ###Bind the columns so we can have the subject Id first, then the activity the subject performed in a neat character way The a column saying if the subject is from the test o train set and finally the rest of the data, meaning the lectures
      ## This instruction fullfills requirement 3
      ##3. Uses descriptive activity names to name the activities in the test data set. This will be completed once the row bind finishes.
      cleanTestData<-cbind(subjectTestData,actData$V2[as.numeric(yTestData$V1)],subjectTest,xTestData)
      
      ###Rename the first bind columns to have descriptive names
      colnames(cleanTestData)[1]<-"Subject"
      colnames(cleanTestData)[2]<-"Activity"
       
      ###Perform the same actions that were performed for the test data set now on the train set. Which can be summarize as follows:
      ###Read the data from the train set, bind the columns and finally assign descriptive names to the added columns
      subjectTraData<-read.table(".\\data\\train\\subject_train.txt", sep=" ", header=FALSE)
      xTraData<-read.table(".\\data\\train\\X_train.txt", header=FALSE)
      yTraData<-read.table(".\\data\\train\\y_train.txt", sep=" ", header=FALSE)
      
      ## This instruction fullfills requirement 3
      ##3. Uses descriptive activity names to name the activities in the test data set.
      ##This will be completed once the row bind finishes.
      cleanTraData<-cbind(subjectTraData,actData$V2[as.numeric(yTraData$V1)],train,xTraData)
      colnames(cleanTraData)[1]<-"Subject"
      colnames(cleanTraData)[2]<-"Activity"
      
      ## This instruction FullFills Requirement 1 and 3
      ##1. Merges the training and the test sets to create one data set. With the merging also the activity names bind
      cleanData<-rbind(cleanTestData,cleanTraData)
      
      ## This instruction fullfills requirement 3
      ##3. Uses descriptive activity names to name the activities in the data set. I took the character vector that contains the features names and change the column names with the colnames function
      colnames(cleanData)[4:564]<-featData$V2
      names(cleanData)
      
      ## This instruction fullfulls requirement 2
      ##2. Extracts only the measurements on the mean and standard deviation for each measurement. I extract only the functions' names from the columns that have mean() and std() inside the column name and assigned them to a logical vector. Finally, I extract only the columns that have those names in them.
      goodColumns<-c(which(grepl("mean()", names(cleanData))),which(grepl("std()", names(cleanData))))
      tidyData<-cleanData[,c(1:4,goodColumns)]

      ## This instruction fullfills requeriment 5
      #5. From the data set in step 4, creates a second, independet tidy data set with the average
      #of each variable  for ech activity and each subject
      actSplit<-split(tidyData, tidyData[,c("Subject","Activity")])
      summAct<-sapply(actSplit, function(x) colMeans(x[,4:83]))
      write.table(summAct,file="MeanActivitySubject.txt", row.names = FALSE)
