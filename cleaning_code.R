library(plyr)
library(dplyr)
library(reshape2)

## Download the data folder and unzip it:

fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

if (!file.exists("getdata_projectfiles_UCI HAR Dataset.zip")){
        download.file(fileURL,"getdata_projectfiles_UCI HAR Dataset.zip")
}  
if (!file.exists("UCI HAR Dataset")) { 
        unzip("getdata_projectfiles_UCI HAR Dataset.zip") 
}

## Load the necessary files

#activity labels
activity_labels = read.table("UCI HAR Dataset/activity_labels.txt")

#features
features = read.table("UCI HAR Dataset/features.txt")

#train data set
train_subjects = read.table("UCI HAR Dataset/train/subject_train.txt")
train_data_all = read.table("UCI HAR Dataset/train/X_train.txt")
train_activities = read.table("UCI HAR Dataset/train/Y_train.txt")

#test data set
test_subjects = read.table("UCI HAR Dataset/test/subject_test.txt")
test_data_all = read.table("UCI HAR Dataset/test/X_test.txt")
test_activities = read.table("UCI HAR Dataset/test/Y_test.txt")

## Filter the columns of both data sets to only include features involving 
## the mean or standard deviation 

include_features = grep("(.*[Mm][Ee][Aa][Nn].*)|(.*[Ss][Tt][Dd].*)", features[,2])
train_data = train_data_all[include_features]
test_data = test_data_all[include_features]

## Merge both data sets into a single one

merged_subjects = rbind(train_subjects,test_subjects)
merged_data = rbind(train_data,test_data)
merged_activities = rbind(train_activities,test_activities)

merged_total = cbind(merged_subjects, merged_activities, merged_data)

## Rename the columns

feature_names = features[,2][include_features]
feature_names = gsub('[()-]', '', feature_names)
feature_names = gsub('m', 'M', feature_names)
feature_names = gsub('s', 'S', feature_names)
NewNames = append("Subject",append("Activity",feature_names))
colnames(merged_total) = NewNames

## Change the factor variables and sort by subject number

merged_total$Activity = factor(merged_total$Activity, levels=activity_labels[,1], labels=activity_labels[,2])
sorted_total = merged_total %>% arrange(Subject)

## Save the clean data set as a .txt file

write.table(sorted_total,  file = "clean_data.txt", quote = FALSE, row.names = TRUE, col.names = TRUE)

## Create a different dataframe with the mean of each feature for each 
## activity and each subject

MeltData = melt(sorted_total, id = append("Subject", "Activity"))
avg_data = dcast(MeltData, Subject + Activity ~ variable, mean)

## Save the clean data set as a .txt file

write.table(avg_data,  file = "clean_data_mean.txt", quote = FALSE, row.names = TRUE, col.names = TRUE)