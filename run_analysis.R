####1 Merges the training and the test sets to create one data set.
#Download data
if(!file.exists("./dataProject")){dir.create("./dataProject")}
fileUrl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
name_f<-"./dataProject/dataset.zip"
download.file(fileUrl,destfile = name_f,method = "curl")
unzip(zipfile = name_f, exdir = "./dataF")

##merge data from test and train

x_test<-read.table(paste(sep = "","./dataF","/UCI HAR Dataset/test/X_test.txt"))
y_test<-read.table(paste(sep = "","./dataF","/UCI HAR Dataset/test/y_test.txt"))
s_test<-read.table(paste(sep = "","./dataF","/UCI HAR Dataset/test/subject_test.txt"))

x_train<-read.table(paste(sep = "","./dataF","/UCI HAR Dataset/train/X_train.txt"))
y_train<-read.table(paste(sep = "","./dataF","/UCI HAR Dataset/train/y_train.txt"))
s_train<-read.table(paste(sep = "","./dataF","/UCI HAR Dataset/train/subject_train.txt"))

#merge with rbind
x_bind<-rbind(x_test,x_train)
y_bind<-rbind(y_test,y_train)
s_bind<-rbind(s_test,s_train)


##2 Extracts only the measurements on the mean and standard deviation for each measurement.
#read features
features<-read.table(paste(sep = "","./dataF","/UCI HAR Dataset/features.txt"))
msc<-features[grep("-([Ss]td|[Mm]ean)\\(\\)",features$V2),]
names(x_bind)<-features$V2
mean_std_col<-x_bind[,msc$V1]

##3 Uses descriptive activity names to name the activities in the data set
#Appropriately labels the data set with descriptive variable names.
#named y_bind
names(y_bind)<-"Activity"
#read 
ac_labels<-read.table(paste(sep = "","./dataF","/UCI HAR Dataset/activity_labels.txt"))
y_bind[,1]<-ac_labels[y_bind[,1],2]
names(s_bind)<-"Subject"
alldata<-cbind(mean_std_col,y_bind,s_bind)
names(alldata)<-gsub("\\(\\)","",names(alldata))
names(alldata)<-gsub('Acc',"_Acceleration",names(alldata))
names(alldata)<-gsub('GyroJerk',"_AngularAcceleration",names(alldata))
names(alldata)<-gsub('Mag',"_Magnitude",names(alldata))
names(alldata)<-gsub('Gyro',"_AngularSpeed",names(alldata))


##5 From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
d2<-aggregate(.~Subject + Activity,alldata,mean)
d2<-d2[order(d2$Subject,d2$Activity),]
write.table(d2, "./dataF/tidy_dataset.txt", row.names = FALSE, quote = FALSE)
