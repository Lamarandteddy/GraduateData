####QUESTION 5

library(caret)
library("tidyverse")

data <- read.csv("insurance_data(1) (2).csv")

data<-data %>% mutate_at(c(1,4:5,65:85), as.factor) 

#convert response to factor
data$response <- as.factor(data$response)
  
  #Rename the response from 0, 1 
  data$response <- fct_recode(data$response,
                              buy="1",
                              notbuy= "0")
  
data$response <- relevel(data$response,
                         ref="buy")

levels(data$response)

set.seed(99) #set random seed
index <- createDataPartition(data$response, p = .8,list = FALSE)
data_train <-data[index,]
data_test<- data[-index,]

library(rpart)
set.seed(12)
model_tree <- train(response ~.,
                    data = data_train,
                    method="rpart",
                    tuneGrid = expand.grid(cp=seq(0.001, 0.2, length=5)),
                    trControl = trainControl(
                                             method = "cv",
                                             number=5,
                                             classProbs=T,
                                             summaryFunction = twoClassSummary),
                                              metric = "ROC")
model_tree
plot(model_tree)

library(rpart.plot)
rpart.plot(model_tree$finalModel,
           type=5)

predicted_probabilities <- predict(model_tree, data_test, type = "prob")
library(ROCR)
pred_tree<- prediction(predicted_probabilities$buy,
                       data_test$response,
                       label.ordering = c("notbuy","buy"))

perf_tree<-performance(pred_tree,"tpr","fpr")
plot(perf_tree,colorize = T)

auc_tree<-unlist(slot(performance(pred_tree, "auc"), "y.values"))
auc_tree
     

