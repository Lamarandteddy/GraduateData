#FILE READ, ADDING DUMMY PREDICTORS, CREATING PARTITION WITH TRAINING/TESTING SETS

library(caret)
library(tidyverse)
options(scipen=999)

Carseat_data <- read.csv(file = "CarseatsQuiz.csv", header=T)
Carseat_data <- Carseat_data %>% mutate_at(c("ShelveLoc","Urban","US"), as.factor)

Carseat_predictors_dummy <- model.matrix(Sales ~ ., data = Carseat_data)
Carseat_predictors_dummy<- data.frame(Carseat_predictors_dummy[,-1])
Carseat_data <- cbind(Sales=Carseat_data$Sales, Carseat_predictors_dummy)

set.seed(87)
index <-createDataPartition(Carseat_data$Sales, p=.8, list=FALSE)
Carseat_train <- Carseat_data[index,]
Carseat_test <-Carseat_data[-index,]

#LASSO**************

library(e1071)
library(glmnet)
library(Matrix)

set.seed(7)

Carseat_lasso <- train(Sales ~ .,
                       data = Carseat_train,
                       method = "glmnet",
                       standardize=TRUE,
                       tuneGrid=expand.grid(alpha=1,
                                            lambda=seq(0.1, 2, by = 0.1)),
                       trControl =trainControl(method = "cv",number=5))
Carseat_lasso


coef(Carseat_lasso$finalModel,Carseat_lasso$bestTune$lambda)

Carseat_lasso$bestTune$lambda

Carseat_lasso_pred <-predict(Carseat_lasso, Carseat_test)

Carseat_lasso_MSE <-  mean ((Carseat_lasso_pred - Carseat_test$Sales)^2)
Carseat_lasso_MSE

#Advertising Advertising ShelveLocGood ShelveLocMedium