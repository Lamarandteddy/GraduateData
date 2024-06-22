###PREDICTION AND PERFORMANCE LASSO WITH AUC AND ROC CURVE

library(caret)
library(tidyverse)
options(scipen=999)

#Step 1:EDA
Credit_data <- read.csv(file = "Credit_Default.csv", header=T)

library(skimr)
summaryStats <- skim(Credit_data)
summaryStats

table(Credit_data$default)
boxplot(Credit_data$LIMIT_BAL~Credit_data$default)
boxplot(Credit_data$AGE~Credit_data$default)

#Step 2:Partition and preprocessing

#a. change response and categorical variables to factor
Credit_data <- Credit_data %>% mutate_at(c("default","EDUCATION","MARRIAGE"), as.factor) 


#b. rename response 
Credit_data$default<-fct_recode(Credit_data$default, default = "1",notdefault = "0")

#c. re-level response
Credit_data$default<- relevel(Credit_data$default, ref = "default")

#d. make sure levels are correct
levels(Credit_data$default)


#e. concert categorical variables in predictor variables to dummy variables
Credit_predictors_dummy <- model.matrix(default~ ., data = Credit_data)

#f. Get rid of intercept and make new data frame
Credit_predictors_dummy<- data.frame(Credit_predictors_dummy[,-1]) 

#g. combine response with predictor variables
Credit_data <-cbind(default=Credit_data$default, Credit_predictors_dummy )

library(caret)

set.seed(99) #set random seed
index <- createDataPartition(Credit_data$default, p = .8,list = FALSE)
Credit_train <-Credit_data[index,]
Credit_test <- Credit_data[-index,]

#Step 2: Train Lasso logistic regression model

library(e1071)
library(glmnet)
library(Matrix)

set.seed(10)#set the seed again since within the train method the validation set is randomly selected
Credit_model <- train(default ~ .,
                      data = Credit_train,
                      method = "glmnet",
                      standardize=T,
                      tuneGrid = expand.grid(alpha=1,
                                             lambda = seq(0.0001,1,length=20)),
                      trControl =trainControl(method = "cv",
                                             number = 5,
                                             classProbs=T,
                                              summaryFunction = twoClassSummary),
                      metric="ROC")
coef(Credit_model$finalModel, Credit_model$bestTune$lambda)
Credit_model$bestTune$lambda


#Step 3: Predicted probability of default on test set
predicted_probability<-predict(Credit_model, Credit_test, type="prob")
predicted_probability$default

#Step 4: Get AUC and ROC curve for LASSO Model

#Get the ROC
library(ROCR)
pred_lasso <- prediction(predicted_probability$default, 
                         Credit_test$default,
                         label.ordering =c("notdefault","default") )

perf_lasso <- performance(pred_lasso, "tpr", "fpr")
plot(perf_lasso, colorize=TRUE)

#Get the AUC
auc_lasso<-unlist(slot(performance(pred_lasso, "auc"), "y.values"))
auc_lasso



