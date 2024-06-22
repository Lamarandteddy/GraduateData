library(caret)
library(tidyverse)

data <- read.csv("insurance_data(1).csv")

#Step 1
#remove zero variance predictors
remove_cols <- nearZeroVar(data[,-86], names = TRUE)

data <-data %>% select(-one_of(remove_cols))

data<-data %>% mutate_at(c(1,5), as.factor)

#create dummy variables expect for the response
dummies_model <- dummyVars(response~ ., data = data)
#if the response is a factor may get a warning that you can ignore


#provide only predictors that are now converted to dummy variables
predictors_dummy<- data.frame(predict(dummies_model, newdata = data)) 

#recombine predictors including dummy variables with response
data <- cbind(response=data$response, predictors_dummy) 

#convert response to factor
data$response <- as.factor(data$response)

#Rename the response from 0, 1 
data$response <- fct_recode(data$response,
                            buy="1",
                            notbuy= "0")
data$response <- relevel(data$response,
                         ref="buy")

library(caret)

set.seed(99) #set random seed
index <- createDataPartition(data$response, p = .8,list = FALSE)
data_train <-data[index,]
data_test<- data[-index,]

#Step 2
install.packages("doParallel")
library(doParallel)

#total number of cores on your computer
num_cores<-detectCores(logical=FALSE)
num_cores

#start parallel processing
cl <- makePSOCKcluster(num_cores-2)
registerDoParallel(cl)
library(randomForest)
set.seed(12)
start_time <- Sys.time()
model_gbm <- train(response ~.,
                   data = data_train,
                   method="xgbTree",
                   tuneGrid = expand.grid(
                     nrounds = c(50,200),
                     eta = c(0.025, 0.05),
                     max_depth = c(2, 3),
                     gamma = 0,
                     colsample_bytree = 1,
                     min_child_weight = 1,
                     subsample = 1),
                   trControl = trainControl(method = "cv",
                                            number=5,
                                            classProbs=TRUE,
                                            summaryFunction = twoClassSummary),
                   metric = "ROC")
end_time <- Sys.time()
print(end_time - start_time)

#stop parallel processing
stopCluster(cl)
registerDoSEQ()


model_gbm

plot(varImp(model_gbm))

varImp(model_gbm)$importance

#install.packages("SHAPforxgboost")
library(SHAPforxgboost)

Xdata<-as.matrix(select(data_train,-response)) # change data to matrix for plots

# Calculate SHAP values
shap <- shap.prep(model_gbm$finalModel, X_train = Xdata)

# SHAP importance plot for top 15 variables
shap.plot.summary.wrap1(model_gbm$finalModel, X = Xdata, top_n = 10)

#example partial dependence plot between total_car and perc_lowereducation
p <- shap.plot.dependence(
  shap, 
  x = "total_car", 
  color_feature = "perc_lowereducation", 
  smooth = FALSE, 
  jitter_width = 0.01, 
  alpha = 0.4
) +
  ggtitle("total_car")
print(p)

# Use 4 most important predictor variables. For the top 4 predictor variables (on the x-axis), the color is the strongest interacting variable.

# top4<-shap.importance(shap, names_only = TRUE)[1:5]

# for (x in top4) {
#   p <- shap.plot.dependence(
#     shap, 
#     x = x, 
#     color_feature = "auto", 
#     smooth = FALSE, 
#     jitter_width = 0.01, 
#     alpha = 0.4
#     ) +
#   ggtitle(x)
#   print(p)
# }

#First, get the predicted probabilities of the test data.
predicted_probabilities <- predict(model_gbm, data_test,type="prob")

library(ROCR)
pred_tree<- prediction(predicted_probabilities$buy,
                       data_test$response,
                       label.ordering = c("notbuy","buy"))
perf_tree<-performance(pred_tree,"tpr","fpr")
plot(perf_tree,colorize = T)

auc_tree<-unlist(slot(performance(pred_tree, "auc"), "y.values"))
auc_tree
