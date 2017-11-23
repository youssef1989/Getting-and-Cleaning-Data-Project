library(plyr)
library(data.table)
setwd("E:\\Documents\\Getting and Cleaning Data\\Unit 4\\Project\\UCI HAR Dataset")


xTrain = read.table('./train/x_train.txt',header=FALSE)
yTrain = read.table('./train/y_train.txt',header=FALSE)
subjectTrain = read.table('./train/subject_train.txt',header=FALSE)

xTest = read.table('./test/x_test.txt',header=FALSE)
yTest = read.table('./test/y_test.txt',header=FALSE)
subjectTest = read.table('./test/subject_test.txt',header=FALSE)


xDataSet <- rbind(xTrain, xTest)
yDataSet <- rbind(yTrain, yTest)
subjectDataSet <- rbind(subjectTrain, subjectTest)

xDataSet_mean_std <- xDataSet[, grep("-(mean|std)\\(\\)", read.table(
  "features.txt")[, 2])]
names(xDataSet_mean_std)<-grep("-(mean|std)\\(\\)", read.table("features.txt")[, 2]
                               ,value=TRUE)
yDataSet[, 1] <- read.table("activity_labels.txt")[yDataSet[, 1], 2]
names(subjectDataSet) <- "Subject"
names(yDataSet) <- "Activity"

SingleDataSet<- cbind(xDataSet_mean_std, yDataSet, subjectDataSet)
names(SingleDataSet) <- make.names(names(SingleDataSet))
names(SingleDataSet) <- gsub('Acc',"Acceleration",names(SingleDataSet))
names(SingleDataSet) <- gsub('GyroJerk',"AngularAcceleration",names(SingleDataSet))
names(SingleDataSet) <- gsub('Gyro',"AngularSpeed",names(SingleDataSet))
names(SingleDataSet) <- gsub('Mag',"Magnitude",names(SingleDataSet))
names(SingleDataSet) <- gsub('^t',"TimeDomain.",names(SingleDataSet))
names(SingleDataSet) <- gsub('^f',"FrequencyDomain.",names(SingleDataSet))
names(SingleDataSet) <- gsub('\\.mean',".Mean",names(SingleDataSet))
names(SingleDataSet) <- gsub('\\.std',".StandardDeviation",names(SingleDataSet))
names(SingleDataSet) <- gsub('Freq\\.',"Frequency.",names(SingleDataSet))
names(SingleDataSet) <- gsub('Freq$',"Frequency",names(SingleDataSet))

FinalDataSet<-aggregate(. ~Subject + Activity, SingleDataSet, mean)
FinalDataSet<-FinalDataSet[order(FinalDataSet$Subject,FinalDataSet$Activity),]
write.table(FinalDataSet, file = "tidydataSet.txt",row.name=FALSE)