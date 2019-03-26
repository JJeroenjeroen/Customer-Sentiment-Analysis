#####################################################
# Date:      25-03-2019                             #
# Author:    Jeroen Meij                            #
# File:      Customer Sentiment Analysis            #
# Version:   1.0                                    #    
#####################################################
setwd("C:/Users/Jeroen/Desktop/Ubiqum/Big Data/Code")
source(file = "1) Setup.R")

set.seed(123)


#make a data partition
#how big should the data partition be?
no_rows_partition <- 1500

#create the data partition of the full trainingset  
train_partition <- createDataPartition(y = iphone_matrix[,"sentiment"],
                                       p = (no_rows_partition/nrow(iphone_matrix)),
                                       list = FALSE)

#create trainset
iphone_train <- iphone_matrix[train_partition,]
iphone_train <- downSample(iphone_train[(c(1:ncol(iphone_train)-1))], 
                           iphone_train$sentiment, list = FALSE, yname = "sentiment")



#create testset
iphone_test <- iphone_matrix[-train_partition,]


#set coss validation parameters
control_method <-"repeatedcv"
control_folds <- 10
control_repeats <- 1
control_search <- "grid"

fitControl <- trainControl(method = control_method,
                           number = control_folds,
                           repeats = control_repeats,
                           search = control_search)

#set training parameters
train_method <- "knn"
train_metric <- "Accuracy"
train_tuneLength <- 10


#train Random Forest Regression model 
set.seed(123)
knnFit <- train(sentiment ~ .,
                 data = iphone_train,
                 method = train_method,
                 metric = train_metric,
                 tuneLength = train_tuneLength,
                 trControl = fitControl)



#See the most important predictors
varImp(knnFit)
predictions <- predict(knnFit, newdata = iphone_test)
postResample(predictions, iphone_test$sentiment)
confusionMatrix(predictions, iphone_test$sentiment)
