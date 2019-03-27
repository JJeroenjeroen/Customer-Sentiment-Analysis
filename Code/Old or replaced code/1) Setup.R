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

#select the vars that actually say something about the iphone
iphone_matrix <- iphone_matrix %>% filter(iphone > 0)
iphone_matrix <- iphone_matrix %>% select(iphonecampos, iphonecamneg, iphonecamunc, 
                                          iphonedispos, iphonedisneg, iphonedisunc, 
                                          iphoneperpos, iphoneperneg, iphoneperunc,
                                          iosperpos, iosperneg, iosperunc, iphonesentiment)




#split the matrix in a df for the y variable and for the x variables
iphone_sentiment <- iphone_matrix[ncol(iphone_matrix)]
iphone_xvars <- iphone_matrix[-ncol(iphone_matrix)]

#remove all zero variance rows
iphone_sentiment <- iphone_sentiment[-which(apply(iphone_xvars,1,var) == 0),]
iphone_xvars <- iphone_xvars[-which(apply(iphone_xvars,1,var) == 0),]

#normalize the rows
iphone_xvars <- scale(t(iphone_xvars))
iphone_xvars <- as.data.frame(t(iphone_xvars))


#bind rows back together
iphone_matrix <- iphone_xvars
iphone_matrix$iphonesentiment <- iphone_sentiment


#replace the 6 factoris into 3
iphone_matrix$iphonesentiment <-  recode(iphone_matrix$iphonesentiment,
                                         "0" =  1, "1" = 1,
                                         "2" = 2, "3" = 2,
                                         "4" = 3, "5" = 3)
#make tha factor an actual factor
iphone_matrix$iphonesentiment <- as.factor(iphone_matrix$iphonesentiment)