##
## Purpose: 
##  Merge training and test sets of Human Activity Recognition data and
##  produce a summary output consisting of means of all measurements 
##  by each subject and activity.
##  More details of the project is located here: 
##  https://class.coursera.org/getdata-015/human_grading/view/courses/973502/assessments/3/submissions
##
## Parameters:
##  N/A
##
## Example of usage:
##  Run this script which will produce the output in your working director
##
## Author: 
##  20150620 - Julie Koesmarno (http://www.mssqlgirl.com)
##


# Merges the training and the test sets to create one data set.

## install.packages("dplyr") # uncomment this if dplyr has not been installed
## Use dplyr 
library(dplyr)

## Set working directory
setwd("C:\\Users\\Julie\\SkyDrive\\Coursera\\Getting and Cleaning Data\\Assignment1\\UCI HAR Dataset\\")

## Read all the features of the HCA datasets. 
## These features will be column names of the final dataset.
features_file_path <- "features.txt"
features <- read.csv(file = features_file_path, 
                     header = FALSE,
                     sep = " ")

## Read all activities in HCA, i.e. labels of measurements.
activities <- read.csv(file = "activity_labels.txt", 
                       sep = " ",
                       header = FALSE)


## Read the activity instances tracked on the test.
y_test_file_path <- "test\\y_test.txt"
y_test <- read.csv(file = y_test_file_path, 
                   header = FALSE,
                   sep = " ")

## Read the subject instances tracked on the test.
subject_test_file_path <- "test\\subject_test.txt"
subject_test <- read.csv(file = subject_test_file_path, 
                         header = FALSE,
                         sep = " ")

## Read the measured values of all the tests.
x_test_file_path <- "test\\X_test.txt"
x_test <- read.table(file = x_test_file_path, 
                     header = FALSE,
                     col.names = features$V2)


## Read the activity instances tracked on the trained data.
y_train_file_path <- "train\\y_train.txt"
y_train <- read.csv(file = y_train_file_path, 
                    header = FALSE,
                    sep = " ")

## Read the subject instances tracked on the train data.
subject_train_file_path <- "train\\subject_train.txt"
subject_train <- read.csv(file = subject_train_file_path, 
                          header = FALSE,
                          sep = " ")

## Read the measured values of all the trained data.
x_train_file_path <- "train\\X_train.txt"
x_train <- read.table(file = x_train_file_path, 
                      header = FALSE,
                      col.names = features$V2)

## combine the train data, by combining the column of subject and activity 
## instances to the measured values for both train and test datasets.
## Then union the two modified datasets.
master_df <- rbind(cbind(rename(subject_train, subject_id = V1), 
                         rename(y_train, activity = V1), 
                         select(x_train, contains("mean"), contains("std"))),
                   cbind(rename(subject_test, subject_id = V1), 
                         rename(y_test, activity = V1), 
                         select(x_test, contains("mean"), contains("std"))))


## Only keep the measurments that have mean and standard deviation values.
final_df <- 
  master_df %>% 
  inner_join(activities, by = c("activity" = "V1")) %>%
  mutate(activity = V2) %>%
  select(-V2) 

## Get the average measurement values by subject and activity and write it 
## to an output file.
summary <- 
  final_df %>%
  group_by(subject_id, activity) %>%
  summarise_each(funs(mean)) %>%
  write.table(file = "summary_output.txt", append = FALSE, row.name = FALSE)

