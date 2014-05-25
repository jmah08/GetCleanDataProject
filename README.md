Getting And Cleaning Data: Course Project Read Me 
========================================================

The run_analysis.R script contains three functions relating to getting, processing and making calculations on data collected from the accelerometers from the Samsung Galaxy S smartphone.

## Summary
The purpose of this script is to completed the following tasks:
* Load the data from separate files
* Combine two primary datasets: test and train
* Load column headings and clean up names to be compliant with R programming best practices
* Append activities and individual participant (subject) identifier to combined file
* Update activities to reflect description instead of activity id
* Select a subset of combined dataset containing only columns that represent mean and standard deviation calculations
* Create a separate data frame containing the mean of each column grouped by the subject and their activity

### Selection of Mean and Standard Deviation Columns
All columns that contained "mean" or "std" in their names were selected. The instructions did not provided details to which particular measures of mean and standard deviation were required. So, for the sake of completeness, all were selected as it is better to be able to remove data if not needed than to not have it available.

## Data Source
The data was obtained from the below link. 

[http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)

The link to the zip file containing the actual data elements is below. For further details regarding the source and processing of the ouriginal data, please see the README file located in the zip file with the data.

[https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)

## Libraries Needed
To use this script, you need the following packages installed from the CRAN:
* stringr
* reshape2

## Using the script
To use the script, simply use the source() function to reference the script, then use one of the functions below.

## Functions

### Get.Process.Data()
This function performs the following tasks and returns a dataframe of the tidy data set of combined test and train data frames:

* Links to the remote zip file
* Saves it to a temporary file
* Extracts the necessary files to data frames 
* Fixes the column names
* Adds them to the test and train data frames
* Appends the subject and activity data to heir respective test or train data frame
* Combines the test and train data frames
* Merges the activity descriptions to the combined data frame
* Returns the combined dataframe

**You do not have to run this function before running the others. Only run this separately if you want to return the combined tidy data frame. The other functions will call this function.**


### MeanStd()
This function performs the following tasks:
* Calls Get.Process.Data()
* Create a vector of all variables with "mean" or "std" in the name
* Adds "ActivityDesc" and "Subject" columns to vector of column names
* Creates subset of combined tidy data frame containing Subject, Activity and mean and standard deviation columns.
* Writes the data frame to mean_std.txt in the working directory with headers



### Averages()
This function performs the following tasks:
* Calls Get.Process.Data()
* Melts combined tidy data frame by ActivityDesc and Subject
* Creates a data frame containing the mean of each column grouped by ActivityDesc & Subject by using dcast
* Writes the data frame to means_by_activity_subject.txt in the working directory with headers



