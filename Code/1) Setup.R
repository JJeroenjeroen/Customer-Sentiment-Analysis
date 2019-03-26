#####################################################
# Date:      25-03-2019                             #
# Author:    Jeroen Meij                            #
# File:      Customer Sentiment Analysis            #
# Version:   1.0                                    #    
#####################################################
rm(list = ls())
set.seed(124)

#libraries
library(readr)
library(plotly)
library(caret)
library(dplyr)
library(DMwR)

#set working directory
setwd("C:/Users/Jeroen/Desktop/Ubiqum/Big Data/Excel files")

#add dataframe for iphone modelling/predictions
iphone_matrix <- read.csv("iphone_smallmatrix_labeled_8d.csv")

nzv <- nearZeroVar(iphone_matrix) 
#iphone_matrix <- iphone_matrix[,-nzv]

#split the matrix in a df for the y variable and for the x variables
iphone_sentiment <- iphone_matrix[ncol(iphone_matrix)]
iphone_xvars <- iphone_matrix[-ncol(iphone_matrix)]


#bind rows back together
iphone_matrix <- bind_cols(iphone_xvars, iphone_sentiment)
iphone_matrix <- iphone_matrix[complete.cases(iphone_matrix), ]

#create dummy variable for a negative sentiment
iphone_matrix$negative <- as.numeric(iphone_matrix$iphonesentiment == 0)

#create dummy variable for a positive sentiment
iphone_matrix$positive <- as.numeric(iphone_matrix$iphonesentiment == 5)

#make a positive/negative sentiment factor variable 
iphone_matrix$positive[iphone_matrix$positive == 1] <- 2 
iphone_matrix$sentiment <- (iphone_matrix$negative + iphone_matrix$positive)

#remove rows where sentiment was 2 or 3
iphone_matrix <- iphone_matrix[!(iphone_matrix$sentiment == 0 ),]

#make sentiment a factor
iphone_matrix$sentiment <- as.factor(iphone_matrix$sentiment)
prop.table(table(iphone_matrix$sentiment))

#remove old variables
iphone_matrix$iphonesentiment <- NULL
iphone_matrix$negative <- NULL
iphone_matrix$positive <- NULL

#iphone_matrix <- iphone_matrix[c("iphone", "htcphone", "samsunggalaxy", "sentiment")]
