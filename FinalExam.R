###PREDICTION AND PERFORMANCE LASSO WITH AUC AND ROC CURVE

library(caret)
library(tidyverse)
options(scipen=999)

#Step 1:EDA
exam_data <- read.csv(file = "exam_data.csv", header=T)

library(skimr)
summaryStats <- skim(exam_data)
summaryStats

table(exam_data$response)

#Step 2:Partition and preprocessing

exam_data <- exam_data %>% mutate_at(c("response"), as.factor) 


#b. rename response 
exam_data$response<-fct_recode(exam_data$response, yes = "1", no= "0")

#c. re-level response
exam_data$response<- relevel(exam_data$response, ref = "default")

#d. make sure levels are correct
levels(exam_data$response)


#e. concert categorical variables in predictor variables to dummy variables
exam_predictors_dummy <- model.matrix(response~ ., data = exam_data)

#f. Get rid of intercept and make new data frame
exam_predictors_dummy<- data.frame(exam_predictors_dummy[,-1]) 



library(caret)

set.seed(99) #set random seed
index <- createDataPartition(exam_data$response, p = .7,list = FALSE)
exam_train <-exam_data[index,]
exam_test <- exam_data[-index,]

#Step 2: Train Lasso logistic regression model

library(e1071)
library(glmnet)
library(Matrix)
library(ROCR)

set.seed(8)#set the seed again since within the train method the validation set is randomly selected
exam_model <- train(response ~ .,
                      data = exam_train,
                      method = "glmnet",
                      standardize=T,
                      tuneGrid = expand.grid(alpha=1,
                                             lambda = seq(0.0001,0.2,length=5)),
                      trControl =trainControl(method = "cv",
                                              number = 5,
                                              classProbs=TRUE,
                                              summaryFunction = twoClassSummary),
                      metric="ROC")
coef(exam_model$finalModel, exam_model$bestTune$lambda)
exam_model$bestTune$lambda


#Step 3: Predicted probability of default on test set
exam_probability<-predict(exam_model, exam_test, type="prob")
exam_probability$response

#Step 4: Get AUC and ROC curve for LASSO Model

#Get the ROC
library(ROCR)
exam_lasso <- prediction(exam_probability$response, 
                         exam_test$response,
                         label.ordering =c("yes","no"))

exam_lasso <- performance(exam_lasso, "tpr", "fpr")
plot(exam_lasso, colorize=TRUE)

#Get the AUC
auc_exam<-unlist(slot(performance(exam_lasso, "auc"), "y.values"))
auc_exam