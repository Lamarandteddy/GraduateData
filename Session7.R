###RANDOM FORESTS

library(caret)

#load breast bc data
bc_data <- read.csv("bc_data(1).csv", header=T)

#skim data with summary included
library(skimr)
skim(bc_data)


#recode response to factor
bc_data$Outcome<-as.factor(bc_data$Outcome)
bc_data$Outcome<-relevel(bc_data$Outcome,
                         ref="Yes")
levels(bc_data$Outcome) #check to see if levels are informative if not need to recode (optional)***

#create training and testing
set.seed(99)
index <- createDataPartition(bc_data$Outcome, p = .8,list = FALSE)
bc_train <- bc_data[index,]
bc_test <- bc_data[-index,]

library(randomForest)
set.seed(8)
model_rf <- train(Outcome ~ .,
                  data = bc_train,
                  method = "rf",
                  tuneGrid= expand.grid(mtry = c(1, 3,6,9)),
                  trControl =trainControl(method = "cv", 
                                          number = 5, 
                                          #Estimate class probabilities
                                          classProbs = TRUE,
                                          ## Evaluate performance using the following function
                                          summaryFunction = twoClassSummary),
                  metric="ROC")

model_rf

plot(model_rf)

plot(varImp(model_rf))

bc_prob<- predict(model_rf, bc_test, type="prob")

library(ROCR)

#In label.ordering the negative class is first then the positive class
pred = prediction(bc_prob$Yes, bc_test$Outcome,label.ordering =c("No","Yes")) 
perf = performance(pred, "tpr", "fpr")

#Plot curve
plot(perf, colorize=TRUE)

#Curve AUC
unlist(slot(performance(pred, "auc"), "y.values"))
