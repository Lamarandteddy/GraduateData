###CLASSIFICATION TREES

#Step 0: Importing libraries, EDA & summary

library(caret)
library(tidyverse)

churn_data <- read.csv(file = "cust_churn_dataset.csv", header=T)

library(skimr)
summaryStats <- skim(churn_data)
summaryStats

churn_data <- churn_data %>%
  mutate_at(c(1,3:10),as.factor)

#Step 1: Partition our Data
#create dummy variables expect for the response
dummies_model <- dummyVars(Churn~ ., data = churn_data)
#if the response is a factor may get a warning that you can ignore


#provide only predictors that are now converted to dummy variables
churn_predictors_dummy<- data.frame(predict(dummies_model, newdata = churn_data)) 

#recombine predictors including dummy variables with response
churn_data <- cbind(Churn=churn_data$Churn, churn_predictors_dummy)

#Convert response to factor
churn_data$Churn <-as.factor(churn_data$Churn)

#Also, good practice is to rename response from 0 1
#to not churn,, churn to reduce misunderstandings
churn_data$Churn <-fct_recode (churn_data$Churn,
                               churn="1",
                              notchurn="0")
churn_data$Churn <-relevel(churn_data$Churn,
                           ref="churn")

set.seed(99) #set random seed
index <- createDataPartition(churn_data$Churn, p = .8,list = FALSE)
churn_train <-churn_data[index,]
churn_test <- churn_data[-index,]

#Step 2: Train or Fit Model
library(rpart)

set.seed(12)
churn_model <- train(Churn ~ .,
                     data = churn_train,
                     method = "rpart",
                     tuneGrid = expand.grid(cp=seq(0.0001,0.2,length=5)),
                     trControl =trainControl(method = "cv",
                                             number = 5,
                                             classProbs=TRUE,
                                             summaryFunction=twoClassSummary),
                     metric="ROC")
                 
churn_model

plot(churn_model)

library(rpart.plot)
rpart.plot(churn_model$finalModel, type=5)

#Step 3: Get Predictions using Testing Set Data
predprob_churn<-predict(churn_model, churn_test, type="prob")

#Step 4: Evaluate Model Performance
library(ROCR)
pred_tree <- prediction(predprob_churn$churn,#Predicted probalility of category name of positive class
                         churn_test$Churn,#test set response variable
                         label.ordering = c("notchurn","churn"))

perf_tree <- performance(pred_lasso, "tpr", "fpr")

plot(perf_lasso, colorize=TRUE)

auc_tree<-unlist(slot(performance(pred_tree,"auc"), "y.values"))
auc_tree


##########HOUSING REGRESSION##########

library(caret)

Boston_data <- read.csv(file = "housing.csv", header=T)

library(skimr)
summaryStats <- skim(Boston_data)
summaryStats

set.seed(99) #set random seed
index <- createDataPartition(Boston_data$medv, p = .8,list = FALSE)
Boston_train <-Boston_data[index,]
Boston_test <- Boston_data[-index,]

#Step 2: Train or Fit Model
library(rpart)

set.seed(10) #set random seed for k-fold cross validation
housing_model <- train(medv ~ .,
                       data = Boston_train,
                       method = "rpart",
                       trControl =trainControl(method = "cv",number = 5),
                       tuneGrid = expand.grid(cp=seq(0.01,0.2,0.01))) 
housing_model

plot(housing_model)

library(rpart.plot)
rpart.plot(housing_model$finalModel, type=5)

#Step 3: Get Predictions using Testing Set Data
medv_pred_tree<-predict(housing_model , Boston_test)

#Step 4: Evaluate Model Performance
mean((medv_pred_tree- Boston_test$medv)^2)


