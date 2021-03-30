##Nikki McCloud
## Coursera- Getting & Cleaning Data
## Final Project

library(dplyr)

## Reading Data from Test
path1 <- "./UCI HAR Dataset/test"
ff1 <- unlist(lapply(path1, "/", list.files(path1), FUN = paste0))
sub1 <- read.table(ff1[2])
X1 <- read.table(ff1[3])
Y1 <- read.table(ff1[4])

## Reading Data from Train
path2 <- "./UCI HAR Dataset/train"
ff2 <- unlist(lapply(path2, "/", list.files(path2), FUN = paste0))
sub2 <- read.table(ff2[2])
X2 <- read.table(ff2[3]) 
Y2 <- read.table(ff2[4])

## Binding Data
subtot <- rbind(sub1, sub2)
Xtot <- rbind(X1, X2)
Ytot <- rbind(Y1, Y2)

## Assign Names
names(Ytot) <- "activity"
names(subtot) <- "subject"

vars <- read.table("./UCI HAR Dataset/features.txt")
colnames(Xtot) <- vars$V2

## Merged Data Set
datamerged <- cbind(subtot, Ytot, Xtot)

#Identify and filter relevant data
mean_std_index <- grep("mean\\(|std\\(", vars$V2)
mean_std_vars <- vars[mean_std_index,]
relev_vars <- c("subject","activity",mean_std_vars$V2)
relev_data <- datamerged[,relev_vars]

## Renaming Variables & Columns
act_lab <- read.table("./UCI HAR Dataset/activity_labels.txt")
relev_data$activity <- act_lab[relev_data$activity, 2]
colnames(relev_data)[-(1:2)] <- paste0("avg.", names(relev_data)[-(1:2)])

## Dataset with Averages
tidy_data <- relev_data %>%
  arrange(subject, activity) %>%
  group_by(subject, activity) %>%
  summarise(across(everything(), list(mean)))

tidy_data

##Write Tidy Data Text File
write.table(tidy_data, "TidyData.txt", row.name=FALSE)
