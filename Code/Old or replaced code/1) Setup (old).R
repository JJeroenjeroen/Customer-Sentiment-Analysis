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


iphone_matrix <- iphone_matrix %>% filter(iphone > 0)
iphone_matrix <- iphone_matrix %>% select(iphonecampos, iphonecamneg, iphonecamunc, 
                                          iphonedispos, iphonedisneg, iphonedisunc, 
                                          iphoneperpos, iphoneperneg, iphoneperunc,
                                          iosperpos, iosperneg, iosperunc, iphonesentiment)

iphone_matrix <- iphone_matrix[-which(apply(iphone_matrix,1,var) == 0),]


#preprocess all vars
#camera vars
iphone_matrix$iphonecampos <- (iphone_matrix$iphonecampos/
                                 (iphone_matrix$iphonecampos + 
                                    iphone_matrix$iphonecamneg +
                                    iphone_matrix$iphonecamunc))

iphone_matrix$iphonecamneg <- (iphone_matrix$iphonecamneg/
                                 (iphone_matrix$iphonecampos + 
                                    iphone_matrix$iphonecamneg +
                                    iphone_matrix$iphonecamunc))

iphone_matrix$iphonecamunc <- (iphone_matrix$iphonecamunc/
                                  (iphone_matrix$iphonecampos + 
                                     iphone_matrix$iphonecamneg +
                                     iphone_matrix$iphonecamunc))

#iphone performance 
iphone_matrix$iphoneperpos <- (iphone_matrix$iphoneperpos/
                                 (iphone_matrix$iphoneperpos + 
                                    iphone_matrix$iphoneperneg +
                                    iphone_matrix$iphoneperunc))

iphone_matrix$iphoneperneg <- (iphone_matrix$iphoneperneg/
                                 (iphone_matrix$iphoneperpos + 
                                    iphone_matrix$iphoneperneg +
                                    iphone_matrix$iphoneperunc))

iphone_matrix$iphoneperunc <- (iphone_matrix$iphoneperunc/
                                 (iphone_matrix$iphoneperpos + 
                                    iphone_matrix$iphoneperneg +
                                    iphone_matrix$iphoneperunc))


#iphone display
iphone_matrix$iphonedispos <- (iphone_matrix$iphonedispos/
                                 (iphone_matrix$iphonedispos + 
                                    iphone_matrix$iphonedisneg +
                                    iphone_matrix$iphonedisunc))

iphone_matrix$iphonedisneg <- (iphone_matrix$iphonedisneg/
                                 (iphone_matrix$iphonedispos + 
                                    iphone_matrix$iphonedisneg +
                                    iphone_matrix$iphonedisunc))

iphone_matrix$iphonedisunc <- (iphone_matrix$iphonedisunc/
                                 (iphone_matrix$iphonedispos + 
                                    iphone_matrix$iphonedisneg +
                                    iphone_matrix$iphonedisunc))


#ios performance
iphone_matrix$iosperpos <- (iphone_matrix$iosperpos/
                                 (iphone_matrix$iosperpos + 
                                    iphone_matrix$iosperneg +
                                    iphone_matrix$iosperunc))

iphone_matrix$iosperneg <- (iphone_matrix$iosperneg/
                                 (iphone_matrix$iosperpos + 
                                    iphone_matrix$iosperneg +
                                    iphone_matrix$iosperunc))

iphone_matrix$iosperunc <- (iphone_matrix$iosperunc/
                                 (iphone_matrix$iosperpos + 
                                    iphone_matrix$iosperneg +
                                    iphone_matrix$iosperunc))



iphone_matrix$iphonesentiment <-  recode(iphone_matrix$iphonesentiment,
                                         "0" =  1, "1" = 1,
                                         "2" = 2, "3" = 2,
                                         "4" = 3, "5" = 3)
