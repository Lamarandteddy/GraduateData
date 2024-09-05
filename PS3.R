# Problem Set #3 group work:

# Names in group: Jonathan Thompson, Alex Graf, Nicolas House, Faysal Bulbul, Daniel Adiele, John Kleine-Kracht

# Problem 1: Categorizing Temperature
# 1.1 Write a Function:

#Initialize function with if statement single argument
temp_categorizer <- function(x){
  if(x >= 90){
    return("Hot")
  }
  if(x >= 60 & x < 90){
    return("Warm")
  }
  if(x > 32 & x < 60){
    return("Cold")
  }
  if(x <= 32){
    return("Freezing")
  }
}



# 1.2 Test Your Function:

#Implement test cases

temp_categorizer(90)
temp_categorizer(60)
temp_categorizer(55)
temp_categorizer(10)


# Problem 2: Analyzing Word Lengths
# 2.1 Create a Loop:

sentence <- c("Learning", "loops", "in", "R", "is", "not", "that", "bad") # Listed function & loop sentence

# Finds range of lengths
min_length <- min(nchar(sentence))
max_length <- max(nchar(sentence))

# For loop iteration
for (length in min_length:max_length) {
  # Finds the words with the current length
  matching_words <- sentence[nchar(sentence) == length]
  
  # Display messages for each length
  if (length == 1) {
    cat("At length 1, the loop should state: \"The word '", matching_words, "' has 1 letter.\"\n", sep = "")
  } else {
    cat("At length", length, ", the loop should state: \"The word '", paste(matching_words, collapse = "', '"), "' has", length, "letters.\"\n", sep = "")
  }
}

# Reflection Questions:

# How did you approach the design of your custom function for categorizing temperatures? 
# I first started with the highest temperatures and made sure everything above 90 was declared "hot" then went to "warm" "cool then "cold".

# In what scenarios might the loop you've created be applied beyond the given example? 
# You could use specific scenarios such as data cleaning where you filter out words that are too small or large as well as social media analysis where you study trends in comments based on a certain length

# Can you identify specialized functions in R that might have helped you in Problem 2, based on what you've learned this week? 
# The lapply function since a vector could be portrayed as a list and applied that function to each element.
  
