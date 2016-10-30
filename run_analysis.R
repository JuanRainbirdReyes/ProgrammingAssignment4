#Install necessary packages
#install.packages("data.table")
#install.packages("dplyr")

#Load librarys
library(data.table)
library(dplyr)

path <- getwd()

url <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20DataSet.zip'
f <- 'DataSet.zip'
#Check if the file dont exists then download
if(!file.exists(f)) {
  download.file(url,f)
}
d <- 'UCI HAR DataSet'
#Check if the directory dont exists then unzip DataSet
if(!file.exists(d)) {
  unzip(f)
}

#Read activities from train and test
dataActTrain <- data.table(read.table(file.path(path, d, 'train','Y_train.txt')))
dataActTest <- data.table(read.table(file.path(path,d,'test','Y_test.txt')))
dataAct <- rbind(dataActTrain,dataActTest)
names(dataAct) <- c('Activity')
remove(dataActTrain,dataActTest)

#Read subjects from train and test
dataSubjTrain <- data.table(read.table(file.path(path, d, 'train', 'subject_train.txt')))
dataSubjTest <- data.table(read.table(file.path(path, d, 'test', 'subject_test.txt')))
dataSubj <- rbind(dataSubjTrain, dataSubjTest)
names(dataSubj) <- c('Subject')
remove(dataSubjTrain,dataSubjTest)

#Merge activities and subjects
dataSubj <- cbind(dataSubj, dataAct)

#Read the data from Train and Test
dataTrain <- data.table(read.table(file.path(path,d,'train','X_train.txt')))
dataTest <- data.table(read.table(file.path(path,d,'test','X_test.txt')))
data <- rbind(dataTrain,dataTest)
remove(dataTrain,dataTest)

#Merge all and set key to subject/activity 
data <- cbind(dataSubj,data)
setkey(data,Subject,Activity)

remove(dataSubj)
remove(dataAct)

#Read feature names, filter only std and mean
dataFeatures <- data.table(read.table(file.path(path,d,'features.txt'))) 
names(dataFeatures) <- c('ftNum','ftName')
dataFeatures <- dataFeatures[grepl("mean\\(\\)|std\\(\\)",ftName)]
dataFeatures$ftCode <- paste('V', dataFeatures$ftNum, sep = "")

#Select only the filtered features
data <- data[,c(key(data), dataFeatures$ftCode),with=F]

#Rename variables
setnames(data, old=dataFeatures$ftCode, new=as.character(dataFeatures$ftName))

#Read activity names
dataActNames <- data.table(read.table(file.path(path, d, 'activity_labels.txt')))
names(dataActNames) <- c('Activity','ActivityName')
data <- merge(data,dataActNames,by='Activity')
remove(dataActNames)
#Add ActivityName as a key
setkey(data,ActivityName)

#Merge in ftName
TidyData <- data %>% group_by(ActivityName, Subject) %>% summarise_each(funs(mean))

TidyData$Activity <- NULL

#Seperate featName column
names(TidyData) <- gsub('^t', 'time', names(TidyData))
names(TidyData) <- gsub('^f', 'frequency', names(TidyData))
names(TidyData) <- gsub('Acc', 'Accelerometer', names(TidyData))
names(TidyData) <- gsub('Gyro','Gyroscope', names(TidyData))
names(TidyData) <- gsub('mean[(][)]','Mean',names(TidyData))
names(TidyData) <- gsub('std[(][)]','Std',names(TidyData))
names(TidyData) <- gsub('-','',names(TidyData))


write.table(TidyData, file.path(path, 'TidyData.txt'), row.names=FALSE)
