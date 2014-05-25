## function to create temporary file, write zip file to it then read in 
## datasets and unlink temp file

Get.Process.Data <- function() {
	
	## since using windows, have to change https to http for download.file to work
	temp <- tempfile()
	download.file("http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",temp)
	
	## column names for train and train data
	headings <- read.table(unz(temp, "UCI HAR Dataset/features.txt"), col.names = c("ID", "ColNames"))

	## activity names
	activities <- read.table(unz(temp, "UCI HAR Dataset/activity_labels.txt"), col.names=c("Activity", "ActivityDesc"))

	## test dataset
	test <- read.table(unz(temp, "UCI HAR Dataset/test/X_test.txt"))

	## test subjects
	test.subjects <- read.table(unz(temp, "UCI HAR Dataset/test/subject_test.txt"), col.names=c("Subject"))

	## test activities
	test.activities <- read.table(unz(temp, "UCI HAR Dataset/test/y_test.txt"), col.names=c("Activity"))

	## train dataset
	train <- read.table(unz(temp, "UCI HAR Dataset/train/X_train.txt"))

	## train subjects
	train.subjects <- read.table(unz(temp, "UCI HAR Dataset/train/subject_train.txt"), col.names=c("Subject"))

	## train activities
	train.activities <- read.table(unz(temp, "UCI HAR Dataset/train/y_train.txt"), col.names=c("Activity"))

	## unlink temporary file
	unlink(temp)

	## finished getting data
	## Start processing tidy set

	## Correct heading names and add to new column called GoodNames using stringr package
	## replace all "-", "(", "," with "." and remove "()" and ")" that occur at end of name	
	library(stringr)
	headings$GoodNames <- str_replace_all(headings$ColNames, "-", ".")
	headings$GoodNames <- str_replace_all(headings$GoodNames, ",", ".")
	headings$GoodNames <- str_replace_all(headings$GoodNames, "\\(\\)", "") 
	headings$GoodNames <- str_replace_all(headings$GoodNames, "\\(", ".")
	headings$GoodNames <- str_replace_all(headings$GoodNames, ")", "")

	## add column names to test and train sets
	colnames(test)  <- headings$GoodNames
	colnames(train) <- headings$GoodNames

	## add subjects and activities to test and train set
	test$Subject  <- test.subjects$Subject
	test$Activity <- test.activities$Activity

	train$Subject  <- train.subjects$Subject
	train$Activity <- train.activities$Activity

	## combine test and train sets
	combined <- rbind(test, train)

	## append activity names to combined data frame for data frame with transformations completed
	completed <- merge(combined, activities, by.x="Activity", by.y="Activity", all.x=T)
}

## function to get subset of data including only mean & standard deviation values then write subset to file
## using mean & standard deviation from estimated variables orginally labeled mean(), std()
## also including means that were calculated on the angle() variable as instructions didn't explicitly
## exclude these means from the request as it's easier to remove later than add later

MeanStd <- function() {

	## get data and process data
	completed <- Get.Process.Data()

	## create a vector of all variables with "mean" or "std" in the name
	mean.std.Columns <- grep("*mean*|*std*", colnames(completed), ignore.case=T, value=T)

	## add in "ActivityDesc" and "Subject" columns to list of column names
	mean.std.Columns <- append(mean.std.Columns, c("ActivityDesc", "Subject"))

	## create subset of only columns selected in above step
	mean.std <- completed[, mean.std.Columns]

	## write subset to file

	write.table(mean.std, "project2_mean_std.txt", row.names=F)

}	


## function to get the average of each variable for each activity and each subject
## first it calls the Get.Process.Data() function to get and process the data into
## a tidy dataset then uses the reshape2 library to melt and dcast the data to get means

Averages <- function() {
	## get data and process data
	completed <- Get.Process.Data()

	## melt completed data frame by ActivityDesc and Subject
	completed.melt <- melt(completed, id=c("ActivityDesc", "Subject"))

	## compute the mean of each column grouped by ActivityDesc & Subject by using dcast
	completed.means <- dcast(completed.melt, ActivityDesc + Subject ~ variable, mean)

	## write the data frame containing the means to a file in working directory
	write.table(completed.means, "project2_means_by_activity_subject.txt", row.names=F)

}

