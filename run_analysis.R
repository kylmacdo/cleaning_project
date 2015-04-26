#
# Class project for getting and cleaning data
#


library(dplyr)
library(tidyr)

# Read in "test" data
test.subject <- read.table("./UCI HAR Dataset/test/subject_test.txt")
test.data <- read.table("./UCI HAR Dataset/test/X_test.txt")
test.activity <- read.table("./UCI HAR Dataset/test/y_test.txt")

# Put data into a data frame
test<-data.frame(matrix(ncol=563,nrow=2947))
test[,1]<-test.subject
test[,2]<-test.activity
test[,3:563]<-test.data

# Deleted unused objects for "test" data
rm(test.subject,test.data,test.activity)

# Name the activities for the test data set
test[,2]<-as.factor(test[,2])
levels(test[,2])<-c("WALKING","WALKING_UPSTAIRS","WALKING_DOWNSTAIRS","SITTING","STANDING","LAYING")

# Read in "train" data
train.subject <- read.table("./UCI HAR Dataset/train/subject_train.txt")
train.data <- read.table("./UCI HAR Dataset/train/X_train.txt")
train.activity <- read.table("./UCI HAR Dataset/train/y_train.txt")

# Put "train" data into a data frame
train<-data.frame(matrix(ncol=563,nrow=7352))
train[,1]<-train.subject
train[,2]<-train.activity
train[,3:563]<-train.data

# Delete unused objects for "train" data
rm(train.subject,train.data,train.activity)

# Name the activites for the train data set
train[,2]<-as.factor(train[,2])
levels(train[,2])<-c("WALKING","WALKING_UPSTAIRS","WALKING_DOWNSTAIRS","SITTING","STANDING","LAYING")

# Read in the variable/column names for all of the data
data.names<- read.table("./UCI HAR Dataset/features.txt",stringsAsFactors=FALSE)

# Name the columns based on the variables from the features.txt file.
colnames(test)<-c("subject","activity",data.names[,2])
colnames(train)<-c("subject","activity",data.names[,2])

# Delete the unsed feature names object
rm(data.names)

# Convert the data frames to tbl_df for plyr processing
train<-tbl_df(train)
test<-tbl_df(test)

# Select only the mean, std, activity and subject columns for both data frames prior to merging.
train<-train[,grepl("mean",colnames(train))|
               grepl("std",colnames(train))|
               grepl("activity",colnames(train))|
               grepl("subject",colnames(train))]

test<-test[,grepl("mean",colnames(test))|
             grepl("std",colnames(test))|
             grepl("activity",colnames(test))|
             grepl("subject",colnames(test))]

# Merge both data frames together
# This is the result for step 4
merged.data<-merge(test,train,all=TRUE)
merged.data<-tbl_df(merged.data)
merged.data<-group_by(merged.data,subject,activity)

# Create the tidy data set for step 5 by summarizing according to the groups
merged.summary<-summarise_each(merged.data,funs(mean))

# Write the data to file.
write.table(merged.summary,file="merged.summary.txt",row.names=FALSE)
