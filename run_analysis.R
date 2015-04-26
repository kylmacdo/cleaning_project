
library(dplyr)
library(tidyr)

test.subject <- read.table("./UCI HAR Dataset/test/subject_test.txt")
test.data <- read.table("./UCI HAR Dataset/test/X_test.txt")
test.activity <- read.table("./UCI HAR Dataset/test/y_test.txt")

test<-data.frame(matrix(ncol=563,nrow=2947))
test[,1]<-test.subject
test[,2]<-test.activity
test[,3:563]<-test.data

rm(test.subject,test.data,test.activity)

test[,2]<-as.factor(test[,2])
levels(test[,2])<-c("WALKING","WALKING_UPSTAIRS","WALKING_DOWNSTAIRS","SITTING","STANDING","LAYING")

train.subject <- read.table("./UCI HAR Dataset/train/subject_train.txt")
train.data <- read.table("./UCI HAR Dataset/train/X_train.txt")
train.activity <- read.table("./UCI HAR Dataset/train/y_train.txt")

train<-data.frame(matrix(ncol=563,nrow=7352))
train[,1]<-train.subject
train[,2]<-train.activity
train[,3:563]<-train.data

rm(train.subject,train.data,train.activity)

train[,2]<-as.factor(train[,2])
levels(train[,2])<-c("WALKING","WALKING_UPSTAIRS","WALKING_DOWNSTAIRS","SITTING","STANDING","LAYING")

data.names<- read.table("./UCI HAR Dataset/features.txt",stringsAsFactors=FALSE)

colnames(test)<-c("subject","activity",data.names[,2])
colnames(train)<-c("subject","activity",data.names[,2])

rm(data.names)

train<-tbl_df(train)
test<-tbl_df(test)

train<-train[,grepl("mean",colnames(train))|
               grepl("std",colnames(train))|
               grepl("activity",colnames(train))|
               grepl("subject",colnames(train))]

test<-test[,grepl("mean",colnames(test))|
             grepl("std",colnames(test))|
             grepl("activity",colnames(test))|
             grepl("subject",colnames(test))]

merged.data<-merge(test,train,all=TRUE)
merged.data<-tbl_df(merged.data)
merged.data<-group_by(merged.data,subject,activity)

merged.summary<-summarise_each(merged.data,funs(mean))
write.table(merged.summary,file="merged.summary.txt",row.names=FALSE)
