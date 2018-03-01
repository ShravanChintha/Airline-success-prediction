#Airline Project

# Milestones 1 & 2

#1. Data Acquisition and Conversion

#a. Programmatically download the project data file:

library(RJSONIO)
library(RCurl)

URL      <- "http://ist.gmu.edu/~hpurohit/courses/ait582-proj-data-spring16.json"
destfile <- "Data.json"
download.file(URL, destfile)

#b. It is a json format file, and in a semi-structured data format.
#Convert it into a Comma-separated (CSV) or Tab-separated (TSV) file for 
#easier data manipulation and interpretation.

Data1="Data.json"
Data1=fromJSON(Data1)
Data1=do.call(rbind,Data1)
write.csv(Data1, "Airline_data.csv")

#c.	Output Fields:

View(Data1)

#2. Metadata Extraction and Imputation

#a.	Which metadata types do you observe in the given 
#data field of DESCRIPTION and which implicit (semantic) metadata can be derived?

Data1=Data1[-1,]
Data1=data.frame(Data1)
Data1$DESCRIPTION=as.character(Data1$DESCRIPTION)

#b.	Can you extract such metadata and append them as 
#additional fields for each of the data record?

Data1$Name = sapply(strsplit(as.character(Data1$DESCRIPTION), split = ";"), "[", 1)
Data1$LastName = sapply(strsplit(as.character(Data1$Name), split = ","), "[", 1)
Data1$FirstName = sapply(strsplit(as.character(Data1$Name), split = ","), "[", 2)
Data1 = Data1[-7]
Data1$FirstName
Data1$LastName

Data1$Gender = grepl(pattern = "Mr.", x = Data1$DESCRIPTION,fixed = T)
Data1$Gender= sapply(Data1["Gender"],function(x) ifelse(Data1$Gender == TRUE,"Male","Female"))
Data1$Gender

Data1$Age = sapply(strsplit(as.character(Data1$DESCRIPTION), split = ";"), "[", 2)
Data1$Age = as.integer(Data1$Age)
Data1$Age

#c.	How can you impute the missing data values? 
#Impute with one of your choice of imputing method.

Data1$Age[is.na(Data1$Age)] = 0
Data1$Age = sapply(Data1["Age"],function(x) ifelse(Data1$Age == 0,mean(as.integer(Data1$Age)),Data1$Age))
Data1$Age = floor(Data1$Age)
Data1=Data1[,-2]
write.csv(Data1,"Airline_data.csv",row.names = FALSE)


