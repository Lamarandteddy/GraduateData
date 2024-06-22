###XGBM GRADIENT BOOSTING TREES

library (caret)
library (tidyverse)

#step 0 EDG

data<-read.csv("insurance_data(1) (2).csv")

#step 1 patrition data

remove_cols <-nearZeroVar(data[-86], names=T)
data<-data %>% select(-one_of(remove_cols))

#convert to factor

data<-data %>% mutate_at(c(1,5), as.factor)

dummies_model <- dummyVars(response~., data = data)

predictors_dummy <-data.frame(predict(dummies_model, newdata=data))

data <-cbind(response=data$response, predictors_dummy)


########set,index and createdatapartition and renaming responses from 0,1

set.seed(99)
index <- createDataPartition(data$response, p = .8,list = FALSE)
data_train <- data[index,]
data_test <- data[-index,]

#Step 2 train xgboost model

#install.packages ("doParallel")
#install.packages ("xgboost")

library (doParallel)
library (xgboost)
library (randomForest)

num_cores <-detectCores(logical = FALSE)

num_cores

#start parallel processing

cl <- makePSOCKcluster(num_cores-1)
registerDoParallel(cl)

start_time <-Sys.time()

set.seed (12)

model_gbm <-train(response~.,
                  data = data_train,
                  method = "xgbTree",
                  tuneGrid = expand.grid(nrounds=c(50,200),
                                                   eta= c(0.025, 0.05),
                                         max_depth = c(2,3),
                                         gamma = 0,
                                         colsample_bytree = 1,
                                         min_child_weight = 1,
                                         subsample = 1),
                  trControl = trainControl (method= "cv",
                                            number = 5,
                                            classProbs=TRUE,
                                            summaryFunction = twoClassSummary),
                  metric = "ROC")
                  
end_time <-Sys.time()
print(end_time-start_time)

stopCluster(cl)
registerDOSEQ()

