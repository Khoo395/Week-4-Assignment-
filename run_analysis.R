##Step 1 

## Setting Working directory & load required libraries
setwd("C:/Users/User/Documents/ProgrammingAssignment2/UCI HAR Dataset")
library(dplyr)
library(textclean)

## Read Train and Test File
path_train <- ("train/X_train.txt")
path_test <- ("test/X_test.txt")
train<- read.table(path_train)
test<- read.table(path_test)

## Binding the data sets by rows
data <- rbind(train,test)


##Step3


## Reading in the Activity Classification Data & Binding them together
path_train_Act <- ("train/y_train.txt")
path_test_Act <- ("test/y_test.txt")
train_act<- readLines(path_train_Act)
test_act<- readLines(path_test_Act)

Activity_class <- c(train_act,test_act)
## Reading in the Label_Activity pair table 
Activity_pair <- read.table("activity_labels.txt")


## Substituting Activity with Activity Class
## I'm using the mapvalues fucntion from plyr but since it interferes with
## dplyr, I detach it immediately after I've used it 
library(plyr)
Activity <- mapvalues(Activity_class, from = as.character(Activity_pair$V1), to = as.character(Activity_pair$V2))
detach("package:plyr", unload=TRUE)


## Add the column "Activity" into the dataset
data <- mutate(data, "Activity" = Activity)




##Step 4

##Read in Variable Names and puting in into data
Var_Names <- read.table("features.txt")
Var_Names <- as.character(Var_Names[,2])
names(data) <- c(Var_Names, "Activity")


##Step 2

##Extract measurements on mean and std 
mean_vars <- grep( "[Mm]ean" ,names(data))
std_vars <- grep( "std" ,names(data))
mean_std_table <- data[,c(mean_vars,std_vars)]


##Step 5

## Read in Individual Label and combine with data
Individual_train <- read.table("train/subject_train.txt")
Individual_test <- read.table("test/subject_test.txt")
Combined <- c(Individual_train[,1], Individual_test[,1])
Combined <- as.factor(Combined)
data[,563] <- Combined
data <- rename(data, "Subject" = "V563")

## Group the variables by Subject and Activity
data2 <- data %>% 
  group_by(Activity, Subject) %>%
  summarise_all(mean)

## Exporting tidied data and summarized data
write.table(data, "Cleaned_data.txt")

