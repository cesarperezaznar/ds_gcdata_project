X_Training = read.csv("UCI HAR Dataset/train/X_train.txt", sep="", header=FALSE)
X_Training[,562] = read.csv("UCI HAR Dataset/train/Y_train.txt", sep="", header=FALSE)
X_Training[,563] = read.csv("UCI HAR Dataset/train/subject_train.txt", sep="", header=FALSE)

X_Testing = read.csv("UCI HAR Dataset/test/X_test.txt", sep="", header=FALSE)
X_Testing[,562] = read.csv("UCI HAR Dataset/test/Y_test.txt", sep="", header=FALSE)
X_Testing[,563] = read.csv("UCI HAR Dataset/test/subject_test.txt", sep="", header=FALSE)

A_Labels = read.csv("UCI HAR Dataset/activity_labels.txt", sep="", header=FALSE)

Feat = read.csv("UCI HAR Dataset/features.txt", sep="", header=FALSE)
Feat[,2] = gsub('-mean', 'Mean', Feat[,2])
Feat[,2] = gsub('-std', 'Std', Feat[,2])
Feat[,2] = gsub('[-()]', '', Feat[,2])

DataMerge = rbind(X_Training, X_Testing)

MeanStd <- grep(".*Mean.*|.*Std.*", Feat[,2])
Feat <- Feat[MeanStd,]
# Adding subject and activity columns)
MeanStd <- c(MeanStd , 562, 563)
DataMerge <- DataMerge[,MeanStd]
colnames(DataMerge) <- c(Feat$V2, "Activity", "Subject")
colnames(DataMerge) <- tolower(colnames(DataMerge))

current = 1
for (itemAL in A_Labels$V2) {
  DataMerge$activity <- gsub(current, itemAL , DataMerge$activity)
  current <- current + 1
}

DataMerge$activity <- as.factor(DataMerge$activity)
DataMerge$subject <- as.factor(DataMerge$subject)

tidyfile = aggregate(DataMerge, by=list(activity = DataMerge$activity, subject=DataMerge$subject), mean)
#Subject and activity out
tidy[,90] = NULL 
tidy[,89] = NULL
write.table(tidy, "tidy.txt", sep="\t")
