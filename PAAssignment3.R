# Step 1: Import libraries, skim data, find missing values/outliers and produce tables

library(tidyverse)
options(scipen=999)

Loan_data <- read.csv(file = "loan_default.csv", header=T)

library(skimr)
Loansummary <- skim(Loan_data)
Loansummary

#Finding missing values
missing_values <- sum(is.na(Loan_data))
missing_values

#Find outliers based on minimum, maximum, as well as upper and lower quartiles.
summary(Loan_data)


table(Loan_data$Default)
boxplot(Loan_data$Checking_amount~Loan_data$Default)
boxplot(Loan_data$No_of_credit_acc~Loan_data$Default)

# Step 2:Partition and preprocessing

#a. change response and categorical variables to factor
Loan_data <- Loan_data %>% mutate_at(c("Default","Sex","Marital_status","Emp_status"), as.factor) 

#b. rename response 
Loan_data$Default<-fct_recode(Loan_data$Default, default = "1",notdefault = "0")

#c. re-level response
Loan_data$Default<- relevel(Loan_data$Default, ref = "default")

#d. make sure levels are correct
levels(Loan_data$Default)


#e. concert categorical variables in predictor variables to dummy variables
Loan_predictors_dummy <- model.matrix(Default~ ., data = Loan_data)

#f. Get rid of intercept and make new data frame
Loan_predictors_dummy<- data.frame(Loan_predictors_dummy[,-1]) 

#g. combine response with predictor variables
Loan_data <-cbind(Default=Loan_data$Default, Loan_predictors_dummy)

library(caret)

# Step 3: Using logistic regression to subset selection methods  (Depending on if you want to use # Forward selection 
# or # Backward selection. Skip # Step 3 if you want to Train Lasso logistic regression model).

set.seed(99) #set random seed
index <- createDataPartition(Loan_data$Default, p = .8,list = FALSE)
Loan_train <-Loan_data[index,]
Loan_test <- Loan_data[-index,]

library(e1071)
library(glmnet)
library(Matrix)

# Forward selection (Run this step individually with the previous steps and then skip over # Backward selection
#as well as Step 4. Resume at Step 5).
set.seed(10)#set the seed again since within the train method the validation set is randomly selected
Loan_model <- train(Default ~ .,
                      data = Loan_train,
                      method = "glmStepAIC",
                      direction="forward",
                      trControl =trainControl(method = "none",
                                              classProbs = TRUE,
                                              summaryFunction = twoClassSummary),
                      metric="ROC")

# Backward selection (Run this step individually with the previous steps excluding #Forward selection and then 
#skip over # Step 4. Resume at Step 5).
set.seed(10)#set the seed again since within the train method the validation set is randomly selected
Loan_model <- train(Default ~ .,
                      data = Loan_train,
                      method = "glmStepAIC",
                      direction="backward",
                      trControl =trainControl(method = "none",
                                              classProbs = TRUE,
                                              summaryFunction = twoClassSummary),
                      metric="ROC")



# Step 4: Train Lasso logistic regression model (Run this step individually with the previous steps 
#excluding # Step 3. Proceed to # Step 5).


set.seed(10) #set the seed again since within the train method the validation set is randomly selected
Loan_model <- train(Default ~ .,
                    data = Loan_train,
                    method = "glmnet",
                    standardize=T,
                    tuneGrid = expand.grid(alpha=1,
                                           lambda = seq(0.0001,1,length=20)),
                    trControl =trainControl(method = "cv",
                                            number = 5,
                                            classProbs=T,
                                            summaryFunction = twoClassSummary),
                    metric="ROC")
                    
coef(Loan_model$finalModel, Loan_model$bestTune$lambda)
Loan_model$bestTune$lambda


#Step 5: Predicted probability of default on test set
loan_predicted_probability <- predict(Loan_model, Loan_test, type = "prob")
loan_predicted_probability <- as.data.frame(loan_predicted_probability)


#Step 6: Get AUC and ROC curve for LASSO Model

#Get the ROC
library(ROCR)
loan_pred_lasso <- prediction(loan_predicted_probability[, "default"],
                              as.factor(Loan_test$Default),
                              label.ordering = c("notdefault", "default"))

loan_perf_lasso <- performance(loan_pred_lasso, "tpr", "fpr")
plot(loan_perf_lasso, colorize = TRUE)

#Get the AUC
loan_auc_lasso <- performance(loan_pred_lasso, "auc")@y.values[[1]]
loan_auc_lasso



