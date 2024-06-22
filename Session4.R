###SUBSET SELECTION FOR LASSO AS WELL AS LOGISTIC REGRESSION USING LASSO

library(caret)
library(tidyverse)
library(skimr)
library(MASS)

options(scipen=999)

flight_data <- read.csv(file = "flight_delays.csv", header=T)
skim(flight_data)

flight_data <- flight_data %>% mutate_at(1, as.factor)

#Partition data
flight_predictors_dummy <- model.matrix(Arr_Delay ~ ., data = flight_data)
table(flight_data$Carrier)

flight_predictors_dummy<- data.frame(flight_predictors_dummy[,-1])
flight_data <- cbind(Arr_Delay=flight_data$Arr_Delay, flight_predictors_dummy)

#Creating training and testing sets

set.seed(99)
index <-createDataPartition(flight_data$Arr_Delay, p=.7, list=FALSE)

flight_train <- flight_data[index,]
flight_test <-flight_data[-index,]

#Train model


set.seed(10)

subset_model <- train(Arr_Delay ~ .,
                      data = flight_train,
                      method = "glmStepAIC",
                      direction="backward",
                      trControl =trainControl(method = "none"))

coef(subset_model$finalModel)

#Generate predictions from testing data

delay_pred<-predict(subset_model, flight_test)
  
#Evaluate performance on testing set
  
test_MSE <-  mean ((delay_pred - flight_test$Arr_Delay)^2)

#LASSO*************************************

library(e1071)
library(glmnet)
library(Matrix)

#Train model

set.seed(10)

lasso_model <- train(Arr_Delay ~ .,
                     data = flight_train,
                     method = "glmnet",
                     standardize=TRUE,
                     tuneGrid=expand.grid(alpha=1,
                                          lambda=seq(0, 3, by = 0.1)),
                     trControl =trainControl(method = "cv",number=5))

lasso_model

coef(lasso_model$finalModel,lasso_model$bestTune$lambda)

lasso_model$bestTune$lambda

#Get predictions on testing set


delay_pred <-predict(lasso_model, flight_test)

lasso_MSE <-  mean ((delay_pred - flight_test$Arr_Delay)^2)

