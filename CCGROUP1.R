# Project Presentation coding for CC
# Names in group: Jonathan Thompson, Daniel Adiele, Faysal Bulbul

# Library imports
library(caret)
library(tidyverse)

# Reading the data file
data <- read.csv("insurance_data(1).csv")

# Step 1
# Remove zero variance predictors
remove_cols <- nearZeroVar(data[,-86], names = TRUE)

data <-data %>% select(-one_of(remove_cols))

data<-data %>% mutate_at(c(1,5), as.factor)

# Create dummy variables expect for the response
dummies_model <- dummyVars(response~ ., data = data)

# Provide only predictors that are now converted to dummy variables
predictors_dummy<- data.frame(predict(dummies_model, newdata = data)) 

# Recombine predictors including dummy variables with response
data <- cbind(response=data$response, predictors_dummy) 

# Convert response to factor
data$response <- as.factor(data$response)

# Rename the response from 0, 1 
data$response <- fct_recode(data$response,
                            buy="1",
                            notbuy= "0")
data$response <- relevel(data$response,
                         ref="buy")
# Library import
library(caret)

# Seed setting, creating the data partition, and indexing train and test set models
set.seed(99) #set random seed
index <- createDataPartition(data$response, p = .8,list = FALSE)
data_train <-data[index,]
data_test<- data[-index,]

# Step 2
# Install.packages("doParallel") if applicable

# Library import
library(doParallel)

# Total number of cores on your computer
num_cores<-detectCores(logical=FALSE)
num_cores

# Start parallel processing
cl <- makePSOCKcluster(num_cores-0)
registerDoParallel(cl)

# Library import
library(randomForest)

# Setting seed, analyzing computer processing time for overload purposes, and setting GNM model
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

# Stop parallel processing
stopCluster(cl)
registerDoSEQ()

# Printing GBM model/plotting and variance importance
model_gbm

plot(varImp(model_gbm))

varImp(model_gbm)$importance

# install.packages("SHAPforxgboost") if applicable
# Library import
library(SHAPforxgboost)

# Creating matrix
Xdata<-as.matrix(select(data_train,-response)) # change data to matrix for plots

# Calculate SHAP values
shap <- shap.prep(model_gbm$finalModel, X_train = Xdata)

# SHAP importance plot for top 10 variables
shap.plot.summary.wrap1(model_gbm$finalModel, X = Xdata, top_n = 10)

# Examples of partial dependence plots and output
plotinsurance1 <- shap.plot.dependence(
  shap, 
  x = "total_fire", 
  color_feature = "total_car", 
  smooth = FALSE, 
  jitter_width = 0.01, 
  alpha = 0.4
) +
  ggtitle("total_fire")

plotinsurance2 <- shap.plot.dependence(
  shap, 
  x = "total_car", 
  color_feature = "perc_purchasingpowerclass", 
  smooth = FALSE, 
  jitter_width = 0.01, 
  alpha = 0.4
) +
  ggtitle("total_car")

plotinsurance3 <- shap.plot.dependence(
  shap, 
  x = "total_car", 
  color_feature = "perc_lowereducation", 
  smooth = FALSE, 
  jitter_width = 0.01, 
  alpha = 0.4
) +
  ggtitle("total_car")

plotinsurance4 <- shap.plot.dependence(
  shap, 
  x = "total_fire", 
  color_feature = "perc_farmer", 
  smooth = FALSE, 
  jitter_width = 0.01, 
  alpha = 0.4
) +
  ggtitle("total_fire")


plotinsurance1
plotinsurance2
plotinsurance3
plotinsurance4


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

# First, get the predicted probabilities of the test data.
predicted_probabilities <- predict(model_gbm, data_test,type="prob")

# Library import
library(ROCR)

# Tree prediction and plotting
pred_tree<- prediction(predicted_probabilities$buy,
                       data_test$response,
                       label.ordering = c("notbuy","buy"))
perf_tree<-performance(pred_tree,"tpr","fpr")
plot(perf_tree,colorize = T)

# AUC Output
auc_tree<-unlist(slot(performance(pred_tree, "auc"), "y.values"))
auc_tree


####################################
#STOP HERE UNLESS PROCEEDING TO EXTRA ADDITIONAL FUN PLOTS***
####################################










#Jitter Plot in relation to showcase of insurance policies bought by Total Car & Total Fire Keys

#filtered_data1 <- subset(data, response == 1)
#JitterPlot1 = qplot(total_car, total_fire, colour=response, data=filtered_data, geom=c("boxplot", "jitter"), 
#                   main="Jitter chart of response type by total fire and total car policy keys",
#                    xlab="Total car policy by key", ylab="Total fire policy by key")
#JitterPlot1 



#Facet Plot showcasing percentage of farmer by key within relation to percentage of lower education key and response type

#FacetPlot1 = ggplot(data, aes(x=response, y=perc_lowereducation)) + geom_boxplot() + facet_grid(~perc_farmer) 
#FacetPlot1















