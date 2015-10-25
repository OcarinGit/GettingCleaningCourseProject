#This repository contains the script R file and data that solves the course project for Getting and Cleaning Data
## The R scrip is composed of the following steps even with the downloading of data files included

1. First step is to download the zip file containing the lectures.
2.Second step (which is not shown in here is to decompress the zip file and to rename the resultant folder to "data" without the quotes) for easier reading of the file
      
3. Third step is to obtain the factors' names. This makes it simpler to name the columns. We achieve this by reading the activity_labels.txt and features.txt text files

4. Read the files from test subjects and prepare the columns so subject activity and subject type (test or train) and finally the lectures from every subject are bind into a single table

5. Do the same with the train subject

6. Bind the rows of both data frames

7. Give good presentation to the data.

Roughly those were the task performed. All the lines inside the code have comments giving detail about every action performed. And the CodeBook.md provides a good source of detailed informations as well.