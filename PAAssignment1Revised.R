library(tidyverse)
library(skimr)
library(caret)
library(ggplot2)
library(car)
library(VIM)
library(psych)
library(GGally)
library(Metrics)
library(igraph)




#PART 1: EDA FOR CASE COMPETITION*****

#Response Variable and plot

Insurance=read.csv("insurance_data(1).csv")

table(Insurance$response)
ggplot(Insurance, aes(x=response)) + geom_bar()

#Finding predictor variables and observations
skim(Insurance)

#change from numeric to factor if categorical
sapply(Insurance, class)
Insurance<-Insurance %>% mutate_at(c(1:2, 4:85),as.factor)

#Finding missing values, null values, outliers, or inconsistencies**********

boxplot(Insurance$customer_sub)
boxplot(Insurance)
boxplot(Insurance[,1:86])
any(is.na(Insurance))

#My plots and describing them

#1 Regular boxplot of my dataset
boxplot(Insurance)

#2 Regular Histogram of average household size and frequency (hhsize is continuous)
hist(Insurance$hhsize, main = "Histogram of household size", xlab = "Number of people in household", ylab = "Frequency")

#3 Regular barplot showing total life policies purchased and frequency (total_life is categorical)

barplot(table(Insurance$total_life), 
        main = "Barplot of total life policies purchased by  frequency",
        xlab = "Key # associated with life policies",
        ylab = "Frequency",
        col = "skyblue", border = "black")

#4 Two-way Table of Response and Random Categorical Predictor percentage of customer subtype is catholic

table_result <- table(Insurance$response, Insurance$perc_catholic)
print(table_result)

#5 Two-way Table of Response and Random Categorical Predictor percentage of  average income
table_result <- table(Insurance$response, Insurance$perc_avgincome)
print(table_result)



#PART 2: CONSULTING AGREEMENT*****

#Finding predictor variables and observations

#Reading data file

Boston_data=read.csv("housing(1).csv")

#Partitioning the Boston housing data

set.seed(99)
index <-createDataPartition(Boston_data$medv, p=.8, list=FALSE)

Boston_train <-Boston_data[index, ]
Boston_testing <-Boston_data[-index, ]

#Train/Fit model
housing_model <- train(medv ~.,
                       data= Boston_train,
                       method="lm")

summary(housing_model)

predictions_model<-predict(housing_model, Boston_testing)

summary(predictions_model)

skim(Boston_data)

#change from numeric to factor if categorical
Boston_data<-Boston_data %>% mutate_at(c(1:2, 4:12),as.factor)

#Provide a table of summary statistics for numerical variables
summary(Boston_data)

#Finding predictor variables and observations
skim(Boston_data)

#Identify missing values, outliers, or inconsistencies

#Missing values
aggr(Boston_data, numbers = TRUE, sortVars = TRUE)

#Outliers
boxplot(Boston_data$medv~Boston_data$indus)

#Inconsistencies
cor(Boston_data$medv, Boston_data$indus)

#Providing histograms for both continuous variables

ggplot(Boston_data, aes(x = medv)) +
  geom_histogram(binwidth = 5, fill = "skyblue", color = "black", alpha = 0.7) +
  labs(title = "Median House Value by Frequency",
       x = "Median House Value",
       y = "Frequency") +
  theme_minimal()

ggplot(Boston_data, aes(x = indus)) +
  geom_histogram(binwidth = 5, fill = "salmon", color = "black", alpha = 0.7) +
  labs(title = "The Proportion of Acres dedicated to retail in the city by frequency",
       x = "Proportion of Acres",
       y = "Frequency") +
  theme_minimal()

#Building box plot for 1 variable by the categories in the chas variable(two examples)

ggplot(Boston_data, aes(x = as.factor(chas), y = rm, fill = as.factor(chas))) +
  geom_boxplot() +
  labs(title = paste("Boxplot of", "Average number of rooms", "by Charles River"),
       x = "Chas",
       y = "Average Number of Rooms") +
  theme_minimal()

ggplot(Boston_data, aes(x = as.factor(chas), y = tax, fill = as.factor(chas))) +
  geom_boxplot() +
  labs(title = paste("Boxplot of", "Property tax", "by Charles River"),
       x = "Chas",
       y = "Full-value property-tax rate per $10,000 ") +
  theme_minimal()

#Providing a scatterplot matrix depicting the correlation between the independent variables and the dependent variable. 


# Specify your dependent and independent variable names
dependent_var <- "medv"
independent_vars <- c("crim", "zn", "indus","chas", "nox", "rm", 
                      "age", "dis", "rad", "tax", "ptratio", "lstat")

# Create a scatterplot matrix with Pearson correlation coefficients
ggpairs(
  data = Boston_data,
  columns = c(dependent_var, independent_vars),
  upper = list(continuous = wrap("cor", method = "spearman", size=2)),  
  lower = list(continuous = wrap("points", mapping = aes(color = "red"))),
  axisLabels = "show",
  cardinality_threshold = NULL
  
) +
  theme(legend.position = "bottom")


#Calculating Mean Squared Error(MSE)

ASE<- mean((predictions_model - Boston_testing$medv)^2)
cat("Average Squared Error (ASE) for the test set:", ASE, "\n")


