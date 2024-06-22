###EDR Part 1 & 2
###LASSO LINEAR REGRESSION

data(iris)
iris

#install.packages("skimr")
library(skimr)
#install.packages("tidyverse")
library(tidyverse)


head(iris)
tail(iris)

summaryStats <- skim(iris)
summaryStats

summary(iris)

skim(iris, Sepal.Length, Petal.Length)


table(iris$Species)

aggregate(.~Species, iris, mean) 

aggregate(.~Species, iris, sd)

aggregate(Petal.Width~Species, iris, sd)

###EDR EXERCISES 
library(ggplot2)
library(GGally)

customer<- read.csv("CustomerData.csv")

skim(customer)

aggregate(HHIncome~MaritalStatus, data = customer, mean)

ggplot(customer, aes(x=LoanDefault)) +
  geom_bar()

mypivot= table(customer$LoanDefault, customer$JobCategory)
mypivot

customer$LoanDefault<-as.factor(customer$LoanDefault)
customer$JobCategory<-as.factor(customer$JobCategory)
plot(customer$LoanDefault~customer$JobCategory)

mypivot[2,]/table(customer$JobCategory)

chocolates<- read.csv("ChocoDesigns.csv")
ggpairs(chocolates, columns = c(3:5), aes(color = Browser)) 

hist(chocolates$Amount.Spent,prob=T, main="Histogram and Density of Amount Spent", xlab="Amount Spent")
lines(density(chocolates$Amount.Spent), lwd=2) #lwd means line width

# Add a vertical line that indicates the average of Sepal Length
abline(v=mean(chocolates$Amount.Spent), lty=2, lwd=1.5) #lty means line type

boxplot(chocolates$Amount.Spent~chocolates$Browser)





#######################################################
# LASSO LINEAR REGRESSION

#install.packages("caret") #this may take a while
library(caret)
library(tidyverse)
options(scipen=999)#Turn off scientific notation as global setting

flight_data <- read.csv(file = "flight_delays.csv", header=T)

#change categorical to factor
flight_data <- flight_data %>% mutate_at(1, as.factor) 

#Partition data
flight_predictors_dummy <- model.matrix(Arr_Delay~ ., data = flight_data )#create dummy variables expect for the response

flight_predictors_dummy<- data.frame(flight_predictors_dummy[,-1]) #get rid of intercept and make data frame

flight_data <- cbind(Arr_Delay=flight_data$Arr_Delay, flight_predictors_dummy)

set.seed(99) #set random seed
index <- createDataPartition(flight_data$Arr_Delay, p = .8,list = FALSE)
flight_train <-flight_data[index,]
flight_test <- flight_data[-index,]

# install and load packages for LASSO
#install.packages("e1071")
library(e1071)
#install.packages("glmnet")
library(glmnet)
#install.packages("Matrix")
library(Matrix)


set.seed(10) #set the seed again since within the train method the validation set is randomly selected

lasso_model <- train(response ~ .,
                     data = flight_train,
                     method = "glmnet",
                     standardize=TRUE,#standardize coefficients
                     tuneGrid=expand.grid(alpha=1,
                                          lambda=seq(0.001, 0.2, by = 0.1)),#add in grid of lambda values
                     trControl =trainControl(method = "cv",number=5, classProbs = TRUE, 
                                             summaryFunction = twoClassSummary))#5-fold cross validation

# Print LASSO model
lasso_model

 #Best lambda and coefficients
lasso_model$bestTune$lambda
coef(lasso_model$finalModel, lasso_model$bestTune$lambda)

# Get Predictions using Testing Set Data
lasso_pred<-predict(lasso_model, flight_test)

# Evaluate Model Performance & MSE

MSE<-mean((lasso_pred- flight_test$Arr_Delay)^2)
MSE
