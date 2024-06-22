# Assignment 2 group work R coding.
# Names in group: Jonathan Thompson, Faysal Bulbul, Daniel Adiele

library(ggplot2)
library(tidyverse)
library(skimr)
library(caret)
library(car)
library(VIM)
library(psych)
library(GGally)
library(Metrics)
library(igraph)
library(ggmosaic)

Insurance=read.csv("insurance_data(1).csv")
sapply(Insurance, class)
skim(Insurance)
Insurance<-Insurance %>% mutate_at(c(1:2, 4:85),as.factor)

# Single bar plot of the distribution of insurance purchase response type
ggplot(Insurance, aes(x = factor(response))) +
  geom_bar(fill = "purple") +
  labs(title = "Distribution of Insurance Purchases",
       x = "Policy Purchase (0: No, 1: Yes)",
       y = "Count")

# Box plot between categorical variable of percentage of annual income and policy purchase response type
boxplot(Insurance$perc_avgincome ~Insurance$response, ylab="Percentage of annual income by key", 
        xlab="Policy Purchase (0: No, 1: Yes)")

# Stacked bar plot with two categorical variables which are # of car policies by key and policy purchase
ggplot(Insurance, aes(x = factor(response), fill = num_car)) +
  geom_bar(position = "stack") +
  labs(title = "# keys of car policies by insurance purchase",
       x = "Policy Purchase (0: No, 1: Yes)",
       fill = "num_car key #")

# Mosaic plot showing relation between categorical variable of customer main type 
# and response variable of policy purchase
mosaicplot(table(Insurance$customer_main, cut(Insurance$response, breaks = 2)),
           main = "Customer main type and how it relates to policy purchase",
           color = TRUE,
           xlab = "Customer main type by key",
           ylab = "Policy Purchase (White: No, Dark: Yes)")


# Density plot for response variable and age categorical variable
ggplot(Insurance, aes(x = response)) +
  geom_density(aes(color = age))


# Violin plot for response variable and total fire categorical variable
ggplot(Insurance, aes(x = total_fire, y = response, fill = total_fire)) +
  geom_violin() +
  labs(title = "Total fire contributions by key and how it relates to policy purchases",
       x = "# of contribution fire policies by key",
       y = "Policy Purchase (0.00: No, 1.00: Yes)")
