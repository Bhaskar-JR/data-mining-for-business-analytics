# 
# Title:    Chapter 2 - Overview of the Data Mining Process
# Purpose:  (KD) Code for Chapter 2 of "Data Mining for Business Analytics"
# Author:   Billy Caughey
# Date:     2020.07.01 - Initial Build
# 

##### Set Working Directory #####
setwd("/Users/wcaughey/Documents/GitHub/data-mining-for-business-analytics")

##### Section 2.4: Preliminary Steps #####

housing_df <- read.csv("WestRoxbury.csv")
dim(housing_df) # dimensions 
head(housing_df) # first n (default is 6) rows
View(housing_df) # Look at the entire data set

housing_df[1:10, 1] # show first ten rows of the first column
housing_df[1:10, ] # show first ten rows of every column
housing_df[5, 1:10] # show the fifth row of the first ten columns
housing_df[, 1] # Show everything in the first column
housing_df$TOTAL.VALUE # Another way of showing everything in the first column is by calling it by name
housing_df$TOTAL.VALUE[1:10] # Show the first ten values in the field TOTAL.VALUE
length(housing_df$TOTAL.VALUE) # number of observations in the field TOTAL.VALUE 
mean(housing_df$TOTAL.VALUE) # finding the mean of the field TOTAL.VALUE 
summary(housing_df) # Produces summary of each field

# Random Sample
s <- sample(row.names(housing_df), 5) # select 5 records at random
print(housing_df[s,]) # Print the 5 records

# Oversampling
s1 <- sample(row.names(housing_df), 5, prob = ifelse(housing_df$ROOMS > 10, 0.9, 0.01))
print(housing_df[s1,])

# Creating Dummy Variables 
xtotal <- model.matrix(~ 0 + BEDROOMS + REMODEL, data = housing_df)
xtotal <- data.frame(xtotal) # remember, before this step, xtotal = matrix 
t(t(names(xtotal))) # Check the names of xtotal
head(xtotal)