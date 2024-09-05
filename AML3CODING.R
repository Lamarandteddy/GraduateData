### APPLIED MACHINE LEARNING (MSBA 645)
### ASSIGNMENT 3 CODING
### JONATHAN THOMPSON

###########################################################################
# PROBLEM 1: I AM USING A 1984 REPUBLICAN CONGRESSIONAL VOTING RECORDS
# ASSIGNED FROM THE REPUBLICAN POLITICAL CONSULTING COMPANY THAT HIRED ME.
# THE LASSO MULTIVARIATE SUPERVISED LOGISTIC REGRESSION METHOD MODEL IS SIGNIFICANT
# FOR ANALYZING ALL 16 PREDICTORS (INDEPENDENT VARIABLES) AND PREDICTED
# PROBABILITY OF 1984 CONGRESSIONAL REPUBLICAN VOTING. WE CAN COMPARE THIS
# TO A HYPOTHETICAL DATA SET FROM 2023 THAT CAN BE USED TO FLIP VOTES FROM
# DEMOCRAT TO REPUBLICAN IN THE UPCOMING 2024 ELECTION.
###########################################################################


# Installing necessary packages if needed

# install.packages("tidyverse")
# install.packages("skimr")
# install.packages("caret")
# install.packages("e1071")
# install.packages("glmnet")
# install.packages("Matrix")
# install.packages("ROCR")


# Load necessary libraries
library(dplyr)
library(tidyr)
library(tidyverse)
library(skimr)
library(caret)

# Load data set
voting_data <- read.csv("house-votes-84(in).csv")

# Generate table for viewing frequency of both Class types
table(voting_data$Class)

# Partition data and pre-processing

#a. Change response and categorical variables to factor
voting_data <- voting_data %>% mutate_at(c("Class"), as.factor) 

#b. Rename response 
voting_data$Class<-fct_recode(voting_data$Class, Class = "republican",notClass = "democrat")

#c. Re-level response
voting_data$Class<- relevel(voting_data$Class, ref = "Class")

#d. Make sure levels are correct
levels(voting_data$Class)

#e. Devise categorical variables into predictor variables to dummy variables
voting_predictors_dummy <- model.matrix(Class~ ., data = voting_data)

#f. Get rid of intercept and make new data frame
voting_predictors_dummy<- data.frame(voting_predictors_dummy[,-1]) 

#g. Combine response with predictor variables
voting_data <-cbind(Class=voting_data$Class, voting_predictors_dummy )


set.seed(99) #Set random seed
index <- createDataPartition(voting_data$Class, p = .8,list = FALSE) #Create partition
voting_train <-voting_data[index,] #Link training set to regular dataset
voting_test <- voting_data[-index,] #Link testing set to regular dataset

# Train Lasso logistic regression model and library imports

library(e1071)
library(glmnet)
library(Matrix)

set.seed(10)#set the seed again since within the train method the validation set is randomly selected
voting_model <- train(Class ~ .,
                      data = voting_train,
                      method = "glmnet",
                      standardize=T,
                      tuneGrid = expand.grid(alpha=1,
                                             lambda = seq(0.0001,1,length=20)),
                      trControl =trainControl(method = "cv",
                                              number = 5,
                                              classProbs=T,
                                              summaryFunction = twoClassSummary),
                      metric="ROC")
coef(voting_model$finalModel, voting_model$bestTune$lambda)
voting_model$bestTune$lambda #Lambda best tune


# Predict probability of Class on test set
predicted_probability<-predict(voting_model, voting_test, type="prob")
predicted_probability$Class

#Get the ROC for LASSO Model with ROCR library import
library(ROCR)
voting_pred <- prediction(predicted_probability$Class, 
                          voting_test$Class,
                          label.ordering =c("notClass","Class") )

voting_perf <- performance(voting_pred, "tpr", "fpr") #True/false positive rate if applicable
plot(voting_perf, colorize=TRUE) #Plot ROC curve

#Get the AUC for LASSO Model
voting_auc<-unlist(slot(performance(voting_pred, "auc"), "y.values"))
voting_auc

###########################################################################
# PROBLEM 2: FOR THE PRIMARY PURPOSE, THERE ARE SPECIFIC OLDER VOTERS THAT
# WE ARE TRYING TO TARGET BASED ON ANALYZING THE 1984 CONGRESSIONAL
# DATA SET AS A WHOLE.
# THIS CODE AND DATA ATTAINED FROM THIS UNSUPERVISED SOM MODEL WILL ALSO 
# BE USED TO COMPARE TO CURRENT YOUNG VOTERS IN 2024 AS WELL AS OLDER
# VOTERS WHO ALSO VOTED IN 1984. WE WANT TO USE THIS DATA TO HOPEFULLY
# IMPROVE CAMPAIGN EFFORTS IN ORDER TO FLIP VOTING FROM DEMOCRAT
# TO REPUBLICAN IN SWING STATES.
###########################################################################

# Install necessary packages if needed

# install.packages("kohonen")
# install.packages("tidyverse")
# install.packages("stringr")
# install.packages("ggforce")

# Import necessary libraries

library (kohonen)
library(tidyverse) 
library(stringr)
library(ggforce)

# Importing data set
som_model<- read.csv("house-votes-84 NN.csv")

# Creating sample of data set
som_sample <- sample(1:nrow(som_model),100)

# Creating model from data set
som_model <- som_model[som_sample,]

glimpse(som_model)

# Linking and scaling IV predictors from data set
som_voting <- som_model %>%
  select(handicappedinfants:exportadministrationactsouthafrica) %>%
  scale() %>%
  som(grid = somgrid(10, 10, "hexagonal","gaussian"), rlen = 800)

glimpse(som_voting)

# Creating grid for plots
som_grid <- som_voting[[4]]$pts %>%
  as_tibble %>% 
  mutate(id=row_number())

som_grid

# Creating pts for plots using tibble construction
som_pts <- tibble(id = som_voting[[2]],
                  dist = som_voting[[3]],
                  type = som_model$Class)

som_pts <- som_pts %>% left_join(som_grid,by="id")

# Mapping & coloring plot
plot(som_voting, type="mapping", pch=20,
     col = c("#00B0B5","#F8766D")[as.integer(som_voting$Class)],
     shape = "round")

# Creating beginning components of circle layer plot
som_plot <- som_grid %>% 
  ggplot(aes(x0=x,y0=y))+
  geom_circle(aes(r=0.5))+
  theme(panel.background = element_blank(),
        axis.ticks = element_blank(),
        panel.grid = element_blank(),
        axis.text = element_blank(),
        axis.title = element_blank(),
        legend.position = "bottom")

# Plotting beginning components of circle layer plot
som_plot

# Plotting full "circle layer" Jitter Plot
som_plot+geom_jitter(data=som_pts,aes(x,y,col=type),alpha=0.5)+
  scale_color_manual(values=c("#00B0B5","#F8766D"),name="Class")



# Assessing fraction of each Class type per grid node
fraction_pts <- som_pts %>% 
  group_by(id,x,y) %>% 
  count(type) %>% 
  ungroup() %>%
  dplyr::filter(!is.na(type))

# Plotting full "circle layer" Jitter Plot but for fractions
som_plot + 
  geom_arc_bar(data=fraction_pts,
               aes(x0 = x, y0 = y, r0 = 0, r = 0.5, amount = n, 
                   fill = type),
               stat = 'pie')+
  scale_fill_manual(values = c("#00B0B5","#F8766D"), 
                    name = "Class")




###########################################################################
# PROBLEM 3A: USING THE ENTIRE 1984 CONGRESSIONAL VOTING DATA SET, I COMPARE 
# BOTH REPUBLICAN & DEMOCRAT VOTING DATA BY TRAINING A SINGLE NODE
# NEURAL NETWORK. THE PURPOSE OF THIS IS IS TO PREDICT VOTING PATTERNS
# FROM THE 1984 CONGRESS TO A HYPOTHETICAL DATA SET FROM 2023 THAT CAN BE 
# LATER IN ORDER TO FLIP VOTERS IN THE UPCOMING 2024 ELECTION.
###########################################################################

# Installing necessary packages if needed

# install.packages("neuralnet")
# install.packages("nnet")
# install.packages("caret")


# Load required libraries

library(neuralnet)
library(nnet)
library(caret)

# Load your data set
congress_data <- read.csv("house-votes-84 Revised(in).csv")

# Neural network model creation
congress_nn = neuralnet(Class ~., congress_data, hidden = 1,
                        threshold = 0.01, stepmax = 1e+05,
                        rep = 1, startweights = NULL,
                        learningrate.limit = NULL,
                        learningrate.factor =
                          list(minus = 0.5, plus = 1.2),
                        learningrate=NULL, lifesign = "none",
                        lifesign.step = 1000, algorithm = "rprop+",
                        err.fct = "sse", act.fct = "logistic",
                        linear.output = TRUE, exclude = NULL,
                        constant.weights = NULL, likelihood = FALSE)

# Plotting Neural network
plot(congress_nn)

###########################################################################
# PROBLEM 3B: USING THE ENTIRE 1984 CONGRESSIONAL VOTING DATA SET, I COMPARE 
# BOTH REPUBLICAN & DEMOCRAT VOTING DATA BY TRAINING A MULTI-CLASS
# NEURAL NETWORK. THE PURPOSE OF THIS IS IS TO ALSO PREDICT VOTING PATTERNS
# FROM THE 1984 CONGRESS TO A HYPOTHETICAL DATA SET FROM 2023 THAT CAN BE 
# LATER IN ORDER TO FLIP VOTERS IN THE UPCOMING 2024 ELECTION.
###########################################################################

# Load your data set
congress_data <- read.csv("house-votes-84 NN.csv")

# Treating dependent variable as factor
congress_data$Class <- factor(congress_data$Class)

# Add a "fake" class to allow for all factors
levels(congress_data$Class) <- c(levels(congress_data$Class),"fake")

# Output levels
levels(congress_data$Class)

# Re-level to make the fake class the factor
congress_data$Class <- relevel(congress_data$Class,ref = "fake")

# Create dummy variables and remove the intercept
congress_data_multinom <- model.matrix(~Class + handicappedinfants + waterprojectcostsharing + adoptionofthebudgetresolution + physicianfeefreeze + 
                                         elsalvadoraid + religiousgroupsinschools + antisatellitetestban + aidtonicaraguancontras + 
                                         mxmissile + immigration + synfuelscorporationcutback + educationspending + 
                                         superfundrighttosue + crime + dutyfreeexports + 
                                         exportadministrationactsouthafrica, data=congress_data)[,-1]

# Adding column names for both affiliations in Class variable
colnames(congress_data_multinom)[1:2] <- c("republican","democrat")

# Multi-class neural network model creation
nn_multi <- neuralnet(republican+democrat~
                        handicappedinfants + waterprojectcostsharing + adoptionofthebudgetresolution + physicianfeefreeze + 
                        elsalvadoraid + religiousgroupsinschools + antisatellitetestban + aidtonicaraguancontras + 
                        mxmissile + immigration + synfuelscorporationcutback + educationspending + 
                        superfundrighttosue + crime + dutyfreeexports + 
                        exportadministrationactsouthafrica,
                      data=congress_data_multinom,hidden=5,lifesign = "minimal",
                      stepmax = 1e+05,rep=10)



congress_res <- compute(nn_multi, congress_data_multinom[,-c(1:2)])

# Installing 'necessary "useful" packages if needed
# install.packages("useful")

# Load useful library
library(useful)

# Plotting multi-class neural network model 
plot(nn_multi, data=congress_res)




